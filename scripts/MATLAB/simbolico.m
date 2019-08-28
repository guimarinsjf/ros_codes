clear; clc;

syms I th th1 th2 m M d g x x1 x2 F M b


x2=(F-b*x1-m*d*th2*cos(th)+m*d*th1^2*sin(th))/(M+m);

eq1=-I*th2+(-th2*m*d*sin(th)-th1^2*m*d*cos(th)+m*g)*d*sin(th)...
    -(m*x2+m*d*th2*cos(th)-m*d*th1^2*sin(th))*d*cos(th)

eqth2=simplify(solve(eq1,th2));


th2=eqth2;

syms x2


eq2=x2*(m+M)+b*x1-F+m*d*th2*cos(th)-m*d*th1^2*sin(th)
eqx2=simplify(solve(eq2,x2));


syms km ke n r R1 e1 

F2=(km*n/(r*R1))*e1 - (ke*km*n^2/(r^2*R1))*x1

new_eqx2=subs(eqx2,F,F2)

new_eqth2=subs(eqx2,F,F2)

-(- 2*R1*sin(th)*d^3*m^2*r^2*th1^2 + R1*g*sin(2*th)*d^2*m^2*r^2 + 2*ke*km*d^2*m*n^2*th1 - 2*e1*km*d^2*m*n*r + 2*R1*b*x1*d^2*m*r^2 - 2*I*R1*sin(th)*d*m*r^2*th1^2 + 2*I*ke*km*n^2*th1 - 2*I*e1*km*n*r + 2*I*R1*b*x1*r^2)/(2*R1*r^2*(I*m + d^2*m^2 + I*M - d^2*m^2*cos(th)^2 + M*d^2*m))
