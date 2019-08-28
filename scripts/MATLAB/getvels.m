function [y] = getvels(f,t,d,e,vd,srd,sld,field,vmin,wmin,alpha)

v=vd+[field(1) 0];

sr=srd+[0 field(2)];
sl=sld+[0 field(2)];

% 
% v=vd;
% 
% sr=srd;
% sl=sld;

thr=atan2(sr(2),sr(1));
thl=atan2(sl(2),sl(1));

% hold on
% plot([0 vd(2)],[0 vd(1)],'k')
% plot([0 -srd(2)],[0  srd(1)],'g')
% plot([0 -sld(2)],[0  sld(1)],'g')
% plot([0 -sr(2)],[0  sr(1)],'b')
% plot([0 -sl(2)],[0  sl(1)],'b')
% plot([0 -field(2)],[0  field(1)],'r')
% hold off
% axis equal
% grid on 
% grid minor
% drawnow


classe=0;




if f==1
   
    
    if d == 1
        vel=max(vmin,alpha(3)*v(1));
        w=min(-wmin, alpha(4)*thr);
        classe=5;
    elseif e == 1
        w=max(wmin, alpha(4)*thl);
        vel=max(vmin,alpha(3)*v(1));
        classe=6;
        
    else
        w=0;
        vel=max(vmin,alpha(1)*v(1));
        classe=1;
    end
    
    
    
elseif f==0 && t==0
    vel=0;
    if d ==1
        classe=3;
        w=min(-wmin, alpha(2)*thr);
    elseif e==1
        classe=4;
        w=max(wmin, alpha(2)*thl);
    else
        classe=7;
        w=0;
    end
    
elseif t==1
    vel=-vmin;
    w=0;
    classe=2;
    
else
    vel=0;
    w=0;
    classe=7;
    
end



y=[vel,w,classe];

end