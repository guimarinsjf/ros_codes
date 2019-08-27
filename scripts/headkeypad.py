#!/usr/bin/env python
import rospy
from sensor_msgs.msg import LaserScan
from geometry_msgs.msg import Twist
import head_class
import numpy as np
import serial


status=4
Lasers = None
anglemin = None
anglemax = None
ranges= None
odometry =[0,0,0]
classe=4;
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
ser = serial.Serial('/dev/rfcomm0', 9600)
rol=0
pit=0

def sleep(t):
    try:
        rospy.sleep(t)
    except:
        pass
 
       
def callback_laser(data): 
    global Lasers
    global ranges
    Lasers=data
    ranges = np.take(Lasers.ranges,range(0,640,9))
    

    
def talker():
         
    ###### SETUPPP #########
    pub_vel = rospy.Publisher('/cmd_vel', Twist, queue_size = 1)
    rospy.init_node('driver', anonymous=False)
    rospy.Subscriber('/scan', LaserScan, callback_laser)  
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
    
    ser.write('b'.encode())
    
    # Rangefinder Angles
    min_angle=Lasers.angle_min
    max_angle=Lasers.angle_max
    increment=9*Lasers.angle_increment
    n_angles=int(round((max_angle-min_angle)/increment)+1)
    angles=min_angle+np.array(range(n_angles))*(max_angle-min_angle)/(n_angles-1)
    
    #Object
    
    
    myshared=head_class.shared(angles, vmin, wmin, dc, dl, vd, srd, sld)   
    

    
    ######## LOOOP  ########
    while not rospy.is_shutdown(): 
        
        ser.write('a'.encode())          
        myshared.get_fields(ranges,lamb1,lamb2)
        S=ser.readline()
        [myshared.rol,myshared.pit]=np.fromstring(S, dtype=float, sep=' ')  
        myshared.get_class()
        myshared.get_vels(alpha)
        twist.linear.x = myshared.v
        twist.angular.z =   myshared.w
        print(twist, myshared.field)
        pub_vel.publish(twist)
        rate.sleep()

if __name__ == '__main__':
    try:
        talker()
    except rospy.ROSInterruptException:
        pass