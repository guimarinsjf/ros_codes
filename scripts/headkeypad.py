#!/usr/bin/env python
import rospy
from sensor_msgs.msg import LaserScan
from geometry_msgs.msg import Twist
import head_class
import numpy as np
from std_msgs.msg import Float32
from std_msgs.msg import Float32MultiArray
from std_msgs.msg import String


status=4
Lasers = None
anglemin = None
anglemax = None
ranges= None
odometry =[0,0,0]
classe=4;
ralatorio_status=0;
relatorio=[];
gains=[1.996, 0.8416, 0.3623, 0.093, 0.18569, 0.28358, 0.345]
xs=-1.2
min_pass= 0.7
max_pass =  1.0
vmin = 0.07
wmin = 0.01
dc = 1 
dl = 0.40
vd = 1
srd = np.array([0.64,-1])
sld = np.array([0.64, 1])
lamb1=0.012
lamb2=0.004
alpha=[0.5, 0.8, 0.5, 0.6, 0.4, 0.3, 0.7, 0.3] 


def sleep(t):
    try:
        rospy.sleep(t)
    except:
        pass

def callback_imu(data):
    global classe;
    rol=data.data[4];
    pit=data.data[5];
    d7 = np.sqrt((pit - 0.00181)*(743.0*pit + 69.1*rol - 2.08) + (rol - 0.0107)*(69.1*pit + 1277.0*rol - 13.7))
    d3 = np.sqrt((pit + 0.00189)*(642.0*pit - 105.0*rol + 20.9) - 1.0*(rol - 0.188)*(105.0*pit - 1244.0*rol + 234.0))     
    d4 = np.sqrt((pit + 0.00603)*(606.0*pit + 82.5*rol + 17.6) + (rol + 0.168)*(82.5*pit + 810.0*rol + 137.0))
    d1 = np.sqrt((pit - 0.189)*(537.0*pit + 189.0*rol - 101.0) + (rol + 0.00515)*(189.0*pit + 1166.0*rol - 29.9))
    d2 = np.sqrt((pit + 0.165)*(1344.0*pit + 68.7*rol + 221.0) + (rol - 0.00347)*(68.7*pit + 1766.0*rol + 5.25))
    d5 = np.sqrt(- 1.0*(rol - 0.15)*(45.2*pit - 972.0*rol + 139.0) - 1.0*(pit - 0.159)*(45.2*rol - 760.0*pit + 114.0))          
    d6 = np.sqrt((rol + 0.143)*(423.0*rol - 6.76*pit + 61.7) - 1.0*(pit - 0.18)*(6.76*rol - 792.0*pit + 143.0))   
    mahala=[d1,d2,d3,d4,d5,d6,d7]
    classe = np.where(mahala==min(mahala))[0][0]+1
 
       

def callback_center(data):
    global status
    status=data.data

def callback_laser(data): 
    global Lasers
    global ranges
    Lasers=data
    ranges = np.take(Lasers.ranges,range(0,640,9))
    
def callback_odom(msg):
    global odometry
    odometry[0]=msg.pose.pose.position.x;
    odometry[1]=msg.pose.pose.position.y;
    odometry[2] = np.arctan2(2*msg.pose.pose.orientation.w*msg.pose.pose.orientation.z,1-2*msg.pose.pose.orientation.z*msg.pose.pose.orientation.z);  

    
def talker():
         
    ###### SETUPPP #########
    pub_vel = rospy.Publisher('/RosAria/cmd_vel', Twist, queue_size = 1)
    pub_state= rospy.Publisher('driver_feedback', String, queue_size=10)
    rospy.init_node('driver', anonymous=False)
    rospy.Subscriber('/scan', LaserScan, callback_laser)
    rospy.Subscriber('/RosAria/pose',Odometry,callback_odom)   
    rospy.Subscriber('/central',Float32,callback_center)
    rospy.Subscriber('/imu_head',Float32MultiArray,callback_imu)    
    rate = rospy.Rate(15) # 10hz
    
    # Velocity Message    
    twist = Twist()
    twist.linear.x = 0 
    twist.linear.y = 0 
    twist.linear.z = 0
    twist.angular.x = 0 
    twist.angular.y = 0 
    twist.angular.z = 0
    rospy.sleep(2) 
    
    # initial Position
    x0=odometry[0]
    y0=odometry[1]
    th0=odometry[2]
    
    # Rangefinder Angles
    min_angle=Lasers.angle_min
    max_angle=Lasers.angle_max
    increment=9*Lasers.angle_increment
    n_angles=int(round((max_angle-min_angle)/increment)+1)
    angles=min_angle+np.array(range(n_angles))*(max_angle-min_angle)/(n_angles-1)
    
    #Object
    
    
    myshared=Shared_Class.shared(gains, xs, min_pass, max_pass, angles, vmin, wmin, dc, dl, vd, srd, sld)   
    
    global relatorio
    global relatorio_status
    relatorio_status = 0
    
    ######## LOOOP  ########
    while not rospy.is_shutdown(): 
        
        
            
            
        # Narrow Passage             
        if status==3:   
            
            # odometry
            ds=np.sqrt((x0-odometry[0])**2+(y0-odometry[1])**2)
            dth=odometry[2]-th0
            x0=odometry[0]
            y0=odometry[1]
            th0=odometry[2]   
            if dth > np.pi:
                dth=dth-2*np.pi
            if dth < -np.pi:
                dth = dth+2*np.pi 
                  
            myshared.get_gates(ranges) 
            myshared.localization()          
            myshared.kalman(ds,dth) 
            
            if myshared.X[0]<0.55:
                myshared.controler()
                twist.linear.x = myshared.v
                twist.angular.z =  myshared.w
                relatorio=[relatorio,[odometry[0],odometry[1],odometry[2],0]]
                
            else:
                twist.linear.x = 0
                twist.angular.z =  0
                pub_vel.publish(twist)
                pub_state.publish('finished')
        

        # Manual Mode
        if status in (0,1,2):
            myshared.get_fields(ranges,lamb1,lamb2)
            myshared.get_vels(classe,status,alpha)
            twist.linear.x = myshared.v
            twist.angular.z =   myshared.w
            relatorio.append([odometry[0],odometry[1],odometry[2],classe])
            print(classe,myshared.field)
        
        # Parked
        if status in (4,5):
            twist.linear.x = 0
            twist.angular.z = 0
            if relatorio_status ==0:
                np.savetxt('marinstxt.txt',relatorio)
                relatorio_status =1
                    
        pub_vel.publish(twist)
        rate.sleep()

if __name__ == '__main__':
    try:
        talker()
    except rospy.ROSInterruptException:
        pass