function [X,P] = ekf(dS,dT,Z,X,P,sensor)


F=[1 0 -dS*sin(X(3)+dT/2);
    0 1 dS*cos(X(3)+dT/2);
    0   0   1];

dX=[dS*cos(X(3)+dT/2);
    dS*sin(X(3)+dT/2);
    dT];
X=X+dX;
P=F*P*F'+Q;

% case we have measurements
if sensor == 1
    K=P*H'*inv(H*P*H'+R);
    X=X+K*(Z-H*X);
    P=(eye(3)-K*H)*P;
end
