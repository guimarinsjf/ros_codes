import serial
import matplotlib.pyplot as plt
import numpy as np
import time

ser = serial.Serial('/dev/rfcomm0', 9600)



data=np.zeros((2,100))

ser.write('b'.encode())

ser.write('a'.encode())



k=0
ser.write('a'.encode())
t=time.time()
for k2 in range(10000):
    
    
    S=ser.readline()
    A=np.fromstring(S, dtype=float, sep=' ')
    ser.write('a'.encode())
    time.sleep(0.013)
    data[0][k]=A[0]
    data[1][k]=A[1]
    k=k+1
    if k>99:
        k=0
    print(time.time()-t)       
    plt.clf()
    plt.plot(data[0])
    plt.plot(data[1])
    plt.plot(0,-pi/2)
    plt.plot(0,pi/2)
    plt.pause(0.01)

        

