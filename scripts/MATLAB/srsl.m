

% 
% sld=0.55*[1.8508 1.8508];
% srd=0.55*[1.1884 -1.8508];
sld=[2/pi 1];
srd=[2/pi -1];


TH=[];
TH1=[];

CY=[];


for cy=-5:0.1:5
    
sr=srd+[0 cy];
sl=sld+[0 cy];

thr=atan2(sr(2),sr(1));
thl=atan2(sl(2),sl(1));

% if thr < 0.05
%    thr=0.05 
% end
TH=[TH thr];
TH1=[TH1 thl];
CY=[CY cy];


end


% h = figure;
plot(CY,TH,'linewidth',2)
hold on
plot(CY,TH1,'linewidth',2)
plot([-1, -1],[-1.5, 1.5],'--k')
plot([0, 0],[-1.5, 1.5],'--k')
plot([1, 1],[-1.5, 1.5],'--k')
hold off;
grid on
grid minor
xlabel('C_y');
ylabel('\theta_{r,l}(rad)')
legend('\theta_{r}','\theta_{l}')
    



set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h,'filename','-dpdf','-r0')

