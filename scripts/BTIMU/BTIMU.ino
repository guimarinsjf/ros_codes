#include<Wire.h>
#include <SoftwareSerial.h>

const int MPU=0x68; 
int ax ,ay, az, Tmp,GyX,GyY,GyZ;
float AcX,AcY,AcZ;
float roll, roll_f, inertial_roll;
float pitch, pitch_f, inertial_pitch;
float gx , gy;
int t=0;
int t2=0;
int t0=0;

// Parametros Kalman
float KFangleX = 0;
float KFangleY = 0;
float kalmanY= 0;
float kalmanX= 0;
float x_bias = 0;
float y_bias = 0;
float Q_angle  =  0.003;
float Q_gyro   =  0.03;
float R_angle  =  0.23 * 0.23;
float DT=0.05;
float XP_00 = 0.01, XP_01 = 0, XP_10 = 0, XP_11 = 0.01;
float YP_00 = 0.01, YP_01 = 0, YP_10 = 0, YP_11 =  0.01;


// Define the data transmit/receive pins in Arduino

#define TxD 2

#define RxD 3

SoftwareSerial mySerial(RxD, TxD); // RX, TX for Bluetooth


void request()
{
  Wire.beginTransmission(MPU);
  Wire.write(0x3B);  // starting with register 0x3B (ACCEL_XOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU,14,true);
  
  ax=Wire.read()<<8|Wire.read();  //0x3B (ACCEL_XOUT_H) & 0x3C (ACCEL_XOUT_L)     
  ay=Wire.read()<<8|Wire.read();  //0x3D (ACCEL_YOUT_H) & 0x3E (ACCEL_YOUT_L)
  az=Wire.read()<<8|Wire.read();  //0x3F (ACCEL_ZOUT_H) & 0x40 (ACCEL_ZOUT_L)
  Tmp=Wire.read()<<8|Wire.read();  //0x41 (TEMP_OUT_H) & 0x42 (TEMP_OUT_L)
  GyX=Wire.read()<<8|Wire.read();  //0x43 (GYRO_XOUT_H) & 0x44 (GYRO_XOUT_L)
  GyY=Wire.read()<<8|Wire.read();  //0x45 (GYRO_YOUT_H) & 0x46 (GYRO_YOUT_L)
  GyZ=Wire.read()<<8|Wire.read();  //0x47 (GYRO_ZOUT_H) & 0x48 (GYRO_ZOUT_L) 
  
  AcX = (float)ax;
  AcY = (float)ay;
  AcZ = (float)az;
}

void calibrate()
   {
     float soma_r=0;
     float soma_p=0;
     
     for(int k=0; k<200; k++)
     {
       request();
       get_angles();
       soma_r+=roll;
       soma_p+=pitch;
     }
     inertial_roll=soma_r/200;
     inertial_pitch=soma_p/200;
   }

void get_angles()
{
  float AX = 0.00006147844*AcX + 0.0000004262922*AcY - 0.0000002167082*AcZ - 0.04212447;  
  float AY = 0.0000606373*AcY - 0.000000407563*AcX + 0.0000005529877*AcZ - 0.002551615;
  float AZ = 0.00006056773*AcZ - 0.0000009520133*AcY - 0.0000007607212*AcX + 0.1074834;
  roll =  atan2(AY, AZ);
  pitch =   atan( -AX  / (AY * sin(roll) + AZ * cos(roll)));
}

void setup(){

  mySerial.begin(9600); // For Bluetooth
  
  Wire.begin();
  Wire.beginTransmission(MPU);
  Wire.write(0x6B); 
  Wire.write(0);    
  Wire.endTransmission(true);

   calibrate();
   t0=millis();
   DT=0.02;
}

void loop(){
  
  t = t + millis()-t0;
  t0=millis();


  if (t > 20)
  {
    t=0;
    // Velocides
    
    request();
    gx= 0.000133*(float)GyX;
    gy= 0.000133*(float)GyY;
    get_angles();

    kalmanY = kalmanFilterY(pitch-inertial_pitch, gy);
    kalmanX = kalmanFilterX(roll-inertial_roll, gx);
  }  
  
  if( mySerial.available() > 0 ) { // LOOP...

    char c = mySerial.read(); // Execute the option based on the character recieved
    
    switch ( c ) {
    
    case 'a': // You've entered a
    
    // Do the code you need when 'a' is received.....
    
      mySerial.print(kalmanX);
      mySerial.print(" "); mySerial.println(kalmanY); 
    
    
    break;

    case 'b': // You've entered a
    
      calibrate();
    
    break;
    
    }
  }
}

//Define as funcoes de filtro de kalman

float kalmanFilterX(float accAngleX, float gyroRate)
{
  float  y, S;
  float K_0, K_1;
  KFangleX += DT * (gyroRate - x_bias);
  XP_00 +=  - DT * (XP_10 + XP_01) + XP_11 * DT * DT + Q_angle * Q_angle;
  XP_01 +=  - DT * XP_11;
  XP_10 +=  - DT * XP_11;
  XP_11 +=  + Q_gyro * Q_gyro * DT;
  y = accAngleX - KFangleX;
  S = XP_00 + R_angle;
  K_0 = XP_00 / S;
  K_1 = XP_10 / S;
  KFangleX +=  K_0 * y;
  x_bias  +=  K_1 * y;
  XP_00 -= K_0 * XP_00;
  XP_01 -= K_0 * XP_01;
  XP_10 -= K_1 * XP_00;
  XP_11 -= K_1 * XP_01;
  return KFangleX;
}

float kalmanFilterY(float accAngleY, float gyroRate)
{
  float  y, S;
  float K_0, K_1;
  KFangleY += DT * (gyroRate - y_bias);
  YP_00 +=  - DT * (YP_10 + YP_01) + YP_11 * DT * DT + Q_angle * Q_angle;
  YP_01 +=  - DT * YP_11;
  YP_10 +=  - DT * YP_11;
  YP_11 +=  + Q_gyro * Q_gyro * DT;
  y = accAngleY - KFangleY;
  S = YP_00 + R_angle;
  K_0 = YP_00 / S;
  K_1 = YP_10 / S;
  KFangleY +=  K_0 * y;
  y_bias  +=  K_1 * y;
  YP_00 -= K_0 * YP_00;
  YP_01 -= K_0 * YP_01;
  YP_10 -= K_1 * YP_00;
  YP_11 -= K_1 * YP_01;
  return KFangleY;
}
