%Mapa
L =[ -1.8477,   -4.5110,   -1.8477,   -4.3558
  -1.8477 ,  -4.3558 ,  -3.4583,   -4.3364
 -3.4583  , -4.3364   ,-3.4583  ,  3.4254
 -3.4583  ,  3.4254   ,-2.9538  ,  4.3181
 -2.9538  ,  4.3181   ,-0.6252  ,  4.3181
 -0.6252  ,  4.3181   ,-0.0819  ,  3.4254
 -0.0819  ,  3.4254   ,-0.1013  ,  1.5820
 -0.1013  ,  1.5820   , 0.0540  ,  1.6014
  0.0540 ,   1.6014   , 0.0346  ,  3.3478
  0.0346  ,  3.3478   , 3.4886  ,  3.3672
 3.4886   , 3.3672    ,3.5080   ,-1.6392
 3.5080   ,-1.6392    ,2.5766   ,-1.6198
 2.5766   ,-1.6198    ,2.5766   ,-1.7362
 2.5766   ,-1.7362    ,3.4886   ,-1.7556
 3.4886   ,-1.7556    ,3.5080   ,-4.3558
 3.5080   ,-4.3558    ,0.7137   ,-4.3558
  0.7137  , -4.3558   , 0.7137  , -1.7556
    0.7137,   -1.7556 ,   1.6839,   -1.7556
    1.6839,   -1.7556 ,   1.6839,   -1.6003
    1.6839,   -1.6003 ,   0.7137,   -1.6003
    0.7137,   -1.6003 ,   0.7137,   -0.4361
    0.7137,   -0.4361 ,   0.0540,   -0.3973
    0.0540,   -0.3973 ,   0.0734,    0.6118
    0.0734,    0.6118 ,  -0.0819,    0.6118
   -0.0819,    0.6118 ,  -0.1013,   -0.3973
   -0.1013,   -0.3973 ,  -1.0133,   -0.4167
   -1.0133,   -0.4167 ,  -1.0133,   -0.5525
   -1.0133,   -0.5525 ,   0.5779,   -0.5525
    0.5779,   -0.5525 ,   0.5779,   -4.3364
    0.5779,   -4.3364 ,  -0.9551   ,-4.3364
   -0.9551,   -4.3364 ,  -0.9551  , -4.4916
    4.5946,   -4.5304 ,   4.6140  , -6.5291
    4.6140,   -6.5291 ,  -4.6031  , -6.5097
   -4.6031,   -6.5097 ,  -4.5837 ,  -4.5693];


% Parametros Laser
thmin=-pi/6;
thmax=pi/6;
nlaser=60;

% Pose inicial
pose.x=-2;
pose.y=0;
pose.th=pi/4;

% Classe simulador
a=simula( 0.4, L ,thmin,thmax,nlaser,5);

v=0.1;
w=0.3;

tic
while(1)
dt=toc;
tic
ds=v*dt;
dth=w*dt;
pose.x=pose.x+ds*cos(pose.th+dth/2)
pose.y=pose.y+ds*sin(pose.th+dth/2)
pose.th=pose.th+dth

if pose.th>pi
    pose.th=pose.th-2*pi;
elseif pose.th < -pi
    pose.th=pose.th+2*pi;
end
    

a.getlaser(pose);

a.plota(1)


end
% gates=narrowpassage(a.thetas,a.ranges,3,0.5,0.1,0.01);
% [xr,yr,thr]=local(gates);
