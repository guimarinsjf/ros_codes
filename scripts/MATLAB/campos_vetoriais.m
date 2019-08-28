% clear ; clc 
% 
% h=figure
% set(gcf,'WindowKeyPressFcn',@testeKeyPress)
% set(gcf,'WindowKeyReleaseFcn',@testeKeyRelease)


% fis=readfis('fis')

% fz = evalfis([0;0;1],fis) ;d

%Mapa
L = [0 0 6 0
    6 0 6 5
    6 5 0 5
    0 5 0 0
    6 1 2 1
    6 1.2 2 1.2
    2 1 2 1.2
    0 2.2 3.5 2.2
    0 2.4 3.5 2.4
    3.5 2.2 3.5 2.4
    4.5 3.5 5 3.5
    5 3.5 4.5 4
    4.5 4 4.5 3.5];


L=[]
r1=0.2;

for k=-20:29
   r2=(r1+1/14);
   th1=2*pi*k/20 ;
   th2=2*pi*(k+1)/20;
   L=[L; [r1*cos(th1) r1*sin(th1) r2*cos(th2) r2*sin(th2)]];
   r1=r2;  
end
L=[L; [-1.251 1.722 -1.50 2]]
L=[L; [-1.50 2 -1.78 1.293 ]]
L=[L; [1.923 2.647 1.9 1.881]]
L=[L; [1.9 1.881 2.589  1.881]]
L=[L; [-2.343 0 -1.8 0]]
L=[L; [-1.8 0 -2.296 -0.7461]]
L=[L; [1.617 0.525 1.95 -0.3]]
L=[L; [1.95 -0.3 1.481 -0.481]]

% L = [0 0 6 0
%     6 0 6 5
%     6 5 5 6
%     5 6 0 6
%     0 6 0 0
%     6 1.2 1.5 1.2
%     0 2.7 4 2.7 
%     5 3 6 3
%     1.2 3.7 2 3.7
%     2 3.7 2 4.8
%     2 4.8 1.2 4.8 
%     1.2 4.8 1.2 3.7];

% Parametros Laser
thmin=-pi/5.8;
thmax=pi/5.8;
nlaser=60;

% Pose inicial
pose.x=-2.95;
pose.y=-1;
pose.th=1*pi/2;


vmax=0.7;
vmin=0.05;
wmax=0.5;
wmin=0.005;
vneg=-0.05;
v=0;
w=0;
    u=[0;0];
    alpha=[0.6,0.5, 0.5 , 0.25];
    
    vd=[1.2 0];
    srd=1*[2/pi -1];
    sld=1*[2/pi 1];
    


% Classe simulador
a=simula(0.51, 0.4, L ,thmin,thmax,nlaser,5,1);


frente=1;
direita=1;
esquerda=0;
tras=0;

    
POSE=[];
XX=[];
YY=[];
TH=[];

VV=[];
WW=[];
XXl=[];
YYl=[];
XXr=[];
YYr=[];
tic
CLA=[];

t=0;
% while(1)
T=[];
for k=1:1200
%     dt=toc;
%     t=t+dt;
%      if newlocal==1
% 
%     [pose.x,pose.y,na] = ginput(1);
%     newlocal=0;
%     
%     end
%     tic
    
    dt=0.05;
    T=[T t];
    ds=v*dt;
    dth=-w*dt;
    dx=ds*cos(pose.th+dth/2);
    dy=ds*sin(pose.th+dth/2);
    pose.x=pose.x+dx;
    pose.y=pose.y+dy;
    pose.th=pose.th+dth;
    


    
    if pose.th>pi
        pose.th=pose.th-2*pi;
    elseif pose.th < -pi
        pose.th=pose.th+2*pi;
    end
    
%     POSE=[POSE,[pose.x;pose.y;pose.th]];
    
    a.getlaser(pose);

    % tic
%     for k=1:1
        a.getfield(0.8,0.32);
%         v=1+sum(a.field(:,1));
%         if v<0.05
%             v=0.05;
%         end
        
%     end
    % toc
%     a.plota(0,0)
%     hold on
%     plot(XX, YY)
%     hold off
%     drawnow
%     title(num2str([v,w]))
    
    
%      hold on
%      
%      Rot = [cos(pose.th) -sin(pose.th)
%                 sin(pose.th)  cos(pose.th)];    
%     vecc=Rot*[a.totalfield(1);  a.totalfield(2)];
%      
%     plot([pose.x pose.x+vecc(1)],[pose.y pose.y+vecc(2)],'g','linewidth',3) 
%     hold off
%     drawnow  
    
%     u=getvels(frente,tras,direita,esquerda,a.field);
%   u= getvels(frente,tras,direita,esquerda,a.field,vmax,vmin,wmax,wmin,vneg)
   u=getvels(frente,tras,direita,esquerda,vd,srd,sld,a.totalfield,vmin,wmin,alpha);
    CLA=[CLA u(3)];
        XX=[XX pose.x];
    YY=[YY pose.y];
    TH=[TH pose.th];
    
    
    Rot = [cos(pose.th) -sin(pose.th)
                sin(pose.th)  cos(pose.th)]; 
    
    rr=Rot*[0 ; -0.35];
    rl=Rot*[0 ; 0.35];
           
            
    XXl=[XXl pose.x+rl(1)];
    YYl=[YYl pose.y+rl(2)];
    XXr=[XXr pose.x+rr(1)];
    YYr=[YYr pose.y+rr(2)];
    
    v=0.5*v+0.5*u(1);
    w=0.5*w-0.5*u(2);
%  title(num2str(u))
    subplot(3,4,[1,2,3,5,6,7,9,10,11])
    a.plota(0,0)
    
    vf=vd+[a.totalfield(1) 0];
    sr=srd+[0 a.totalfield(2)];
    sl=sld+[0 a.totalfield(2)];
    
    subplot(3,4,4)
    plot([0 vd(1)],[0 vd(2)],'k','linewidth',3);
    hold on
    plot([0 srd(1)],[0 srd(2)],'k','linewidth',3);
    plot([0 sld(1)],[0 sld(2)],'k','linewidth',3);
    plot([0 vf(1)],[0 vf(2)],'b','linewidth',3);
    plot([0 sr(1)],[0 sr(2)],'b','linewidth',3);
    plot([0 sl(1)],[0 sl(2)],'b','linewidth',3);
    plot([0 a.totalfield(1)],[0 a.totalfield(2)],'r','linewidth',3);
    axis([-5,5,-5,5])
    hold off
    drawnow
    
        subplot(3,4,8)

    hold off
    drawnow
    
    t=t+dt;

   
end

    
a.plota(1,0)



   hold on  
%     plot(XX,YY,'g') 
    plot(XXl,YYl,'--k')
    plot(XXr,YYr,'--k')
    for k=1:round(0.015*length(XX)):length(XX)
    Rot = [cos(TH(k)) -sin(TH(k))
                sin(TH(k))  cos(TH(k))];    
    seta=Rot *[0 0 0.12;
                -0.035 0.035 0];    
    
    if CLA(k)==1        
    fill(XX(k) +seta(1,:) ,YY(k) + seta(2,:) , 'm')
    end
        if CLA(k)==5        
    fill(XX(k) +seta(1,:) ,YY(k) + seta(2,:) , 'y')
        end
        if CLA(k)==6        
    fill(XX(k) +seta(1,:) ,YY(k) + seta(2,:) , 'c')
        end
            if CLA(k)==3        
    fill(XX(k) +seta(1,:) ,YY(k) + seta(2,:) , 'r')
            end
            if CLA(k)==4        
    fill(XX(k) +seta(1,:) ,YY(k) + seta(2,:) , 'b')
    end
%     plot(XX(k),YY(k),'or')    
%     plot([XX(k) XX(k)+0.1*cos(TH(k))],[YY(k) YY(k)+0.1*sin(TH(k))],'r','linewidth',2)
    end
    hold off
% 
% % plot(POSE(1,:),POSE(2,:))
% % a.plota(1,1)
% % end
% % gates=narrowpassage(a.thetas,a.ranges,3,0.5,0.1,0.01);
% % [xr,yr,thr]=local(gates);

% 
% set(h,'Units','Inches');
% pos = get(h,'Position');
% set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
% print(h,'res_nav3','-dpdf','-r0')