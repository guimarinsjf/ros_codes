#!/usr/bin/env python

import rospy
from sensor_msgs.msg import LaserScan
from geometry_msgs.msg import Twist
from std_msgs.msg import Float32MultiArray
import head_class
import numpy as np
import serial


Lasers = None
anglemin = None
anglemax = None
ranges= None
classe=7
vmin = 0.05
wmin = 0.01
dc = 1.1 
dl = 0.40
vd = 1
srd = np.array([0.64,-1])
sld = np.array([0.64, 1])
srd = np.array([0.64,-1])
sld = np.array([0.64, 1])
lamb1=0.006
lamb2=0.009
beta=[0.05, 0.05, 0.25, 0.05, 0.05]
alpha=[0.45,0.5, 0.40 , 0.3] 
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
    pub_head = rospy.Publisher('head', Float32MultiArray, queue_size = 1)
    rospy.init_node('driver', anonymous=False)
    rospy.Subscriber('/scan', LaserScan, callback_laser)  
    rate = rospy.Rate(10) # 10hz
    
    control = False

   
    ser = serial.Serial('/dev/rfcomm0', 9600)
    ser.write('b'.encode())

    # Velocity Message    
    twist = Twist()
    twist.linear.x = 0 
    twist.linear.y = 0 
    twist.linear.z = 0
    twist.angular.x = 0 
    twist.angular.y = 0 
    twist.angular.z = 0
    rospy.sleep(2) 
    
    
    
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
        myshared.get_fields(ranges,beta)
        S=ser.readline()
        [myshared.rol,myshared.pit]=np.fromstring(S, dtype=float, sep=' ')  
        myshared.get_class()
        myshared.get_vels(alpha)
        twist.linear.x = 0.6*twist.linear.x+ 0.4*myshared.v
        twist.angular.z = 0.6*twist.angular.z + 0.4*myshared.w
        #print(twist.linear.x,twist.angular.z,myshared.field)
        pub_vel.publish(twist)
	headdata = Float32MultiArray(data=[myshared.rol,myshared.pit,myshared.classe,myshared.field[0],myshared.field[1]])
	pub_head.publish(headdata)
        rate.sleep()

if __name__ == '__main__':
    try:
        talker()
    except rospy.ROSInterruptException:
        pass
