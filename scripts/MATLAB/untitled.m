syms d1 th1 dc dl

x1=d1*cos(th1)
y1=d1*sin(th1)
x2=x1-dc
y2=y1-dl
x3=x1-dc
y3=y1+dl
y4=y1
x4=x1-dc

d2=sqrt(x2^2+y2^2)
% th2=atan2(y2/x2)

d3=sqrt(x3^2+y3^2)
% th3=atan2(y3/x3)
d4=sqrt(x4^2+y4^2)
syms a b c d e f g h

A=[a b;c d]; B=[e 0 ; 0 h];