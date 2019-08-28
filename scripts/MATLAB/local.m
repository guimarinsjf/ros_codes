function [x,y,th] = local(gate)
x1=gate(1);
x2=gate(3);
y1=gate(2);
y2=gate(4);

x3=(x1+x2)/2;
y3=(y1+y2)/2;

a1=-(y2-y1)/(x2-x1);
b1=1;
c1=-a1*x3-y3;


a2=-1/a1;
b2=1;
c2=-a2*x3-y3;


% th1=atan(-a1);
% thG=th1-0.5*pi*c1/abs(c1);

thG=-atan2(y2-y1,x2-x1)+pi/2;

if thG > pi;
    thG=thG-2*pi;
end

if thG < -pi;
    thG=thG+2*pi;
end

    
x=-x3*cos(thG)+y3*sin(thG);
y=-x3*sin(thG)-y3*cos(thG);
th=thG;