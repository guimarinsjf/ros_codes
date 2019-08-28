classdef simula < handle
    properties
        dl
        dl2
        thmin
        thmax
        nlaser
        posereal
        pose
        thetas
        xmin
        xmax
        ymin
        ymax
        L
        ranges
        dmax
        field
        totalfield
        R
        seta
    end
    
    methods
        %Construtur
        function sm = simula(dl, dl2 ,L , thmin , thmax , nlaser , dmax , R)
            sm.ranges=dmax*ones(1,nlaser);
            sm.dl = dl;
            sm.dl2=dl2;
            sm.dmax=dmax;
            sm.thmin=thmin;
            sm.thmax=thmax;
            sm.nlaser=nlaser;
            sm.R=R;
            sm.thetas = thmin:(thmax-thmin)/(nlaser-1):thmax+0.000001;
            sm.L=L;
            % Limites do mapa
            sm.xmin = min([L(:,1) ; L(:,3)]);
            sm.xmax = max([L(:,1) ; L(:,3)]);
            sm.ymin = min([L(:,2) ; L(:,4)]);
            sm.ymax = max([L(:,2) ; L(:,4)]);
        end
        
        function f1 = getlaser(obj,pose)
            obj.posereal=pose;
            obj.pose.x=pose.x-obj.dl*cos(pose.th);
            obj.pose.y=pose.y-obj.dl*sin(pose.th);
            obj.pose.th=pose.th;
            obj.ranges = 500 * ones(size(obj.thetas));
            
            % Loop de calculo
            for k = 1:length(obj.thetas)
                % dist
                dist = obj.ranges(k);
                
                % Obtem o angulo desejado
                thS = obj.thetas(k);
                
                % Forma o raio de laser
                x1 = obj.pose.x;
                y1 = obj.pose.y;
                x2 = x1 + cos(obj.pose.th + thS);
                y2 = y1 + sin(obj.pose.th + thS);
                
                for i = 1:size(obj.L,1)
                    % Forma a reta do ambiente
                    x3 = obj.L(i,1);
                    y3 = obj.L(i,2);
                    x4 = obj.L(i,3);
                    y4 = obj.L(i,4);
                    
                    % Calcula o denominador para saber se as retas sao paralelas
                    den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
                    
                    if ~isequal(den , 0)
                        % Calcula o ponto de interseccao
                        Px = ((x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4))/den;
                        Py = ((x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4))/den;
                        
                        % Calcula o angulo entre o robo e o ponto de interseccao
                        thP = mod(atan2(Py - obj.pose.y , Px -  obj.pose.x) -  obj.pose.th , 2*pi);
                        if thP > pi
                            thP = thP - 2*pi;
                        end
                        
                        epsilon = 0.0001;
                        if abs(thS - thP) < epsilon %abs(mod(thS,360) - mod(thP,360)) < epsilon
                            % Verifica se o ponto de interseccao pertence ao intervalo
                            % do segmento de reta:
                            
                            if ( (min(x3,x4)-0.001 <= Px) && (Px <= max(x3,x4)+0.001) ) && ...
                                    ( (min(y3,y4)-0.001 <= Py) && (Py <= max(y3,y4)+0.001) )
                                
                                % Calcula a distancia entre o robo e o ponto
                                dist = min(dist , sqrt(( obj.pose.x - Px)^2 + ( obj.pose.y - Py)^2));
                            end
                        end
                    end
                end
                obj.ranges(k) = dist + 0.01 * randn;
                if obj.ranges(k) > obj.dmax
                    obj.ranges(k)=obj.dmax;
                end
            end
        end
        
        function f3 = getfield(obj,a1,a2)
            
            obj.field=[0 0; 0 0 ;  0 0; 0 0 ; 0 0];
            nobst1=1;
            nobst2=1;
            nobst3=1;
            nobst4=1;
            nobst5=1;
            
            
            
            
            % Cálculo dos campos
            for k=1:obj.nlaser
                x1=obj.ranges(k)*cos(obj.thetas(k));
                y1=obj.ranges(k)*sin(obj.thetas(k));
                dc=obj.dl+0.5;
                dl=obj.dl2;
                
                
                % lateral direita
                if x1 <= dc && y1 < -dl
                    d = abs(-dl-y1);
                    th=-pi/2;
                    B=a1*th^2+a2;
                    if d < obj.R
                        ganho=-B/d;
                        c= (ganho)*[cos(th) , sin(th)];
                        nobst1=nobst1+1;
                        obj.field=obj.field+[c; 0 0 ;  0 0; 0 0 ; 0 0];
                    end
                end
                
                % frente direita
                if x1 > dc && y1 < -dl
                    x2=x1 - dc;
                    y2=y1 + dl;
                    d = (x2^2 + y2^2)^(1/2);
                    th=atan2(y2,x2);
                    if d < obj.R
                        B=a1*th^2+a2;
                        ganho=-B/d;
                        c= (ganho)*[cos(th) , sin(th)];
                        nobst2=nobst2+1;
                        obj.field=obj.field+[0 0; c ;  0 0; 0 0 ; 0 0];
                    end
                end
                
                %frente central
                if x1 > dc && abs(y1) <= dl
                    d = abs(x1-dc);
                    th=0;
                    if d < obj.R
                        B=a1*th^2+a2;
                        ganho=-B/d;
                        c= (ganho)*[cos(th) , sin(th)];
                        nobst3=nobst3+1;
                        obj.field=obj.field+[0 0; 0 0 ; c ; 0 0 ; 0 0];
                    end
                end
                
                % frente esquerda
                if x1 > dc && y1 > dl
                    x2=x1 - dc;
                    y2=y1 - dl;
                    d = (x2^2 + y2^2)^(1/2);
                    th=atan2(y2,x2);
                    if d < obj.R
                        B=a1*th^2+a2;
                        ganho=-B/d;
                        c= (ganho)*[cos(th) , sin(th)];
                        nobst4=nobst4+1;
                        obj.field=obj.field+[0 0; 0 0 ;  0 0; c ; 0 0];
                    end
                end
                
                % lateral esquerda
                if x1 <= dc && y1 > dl
                    d = abs(dl-y1);
                    th=pi/2;
                    if d < obj.R
                        B=a1*th^2+a2;
                        ganho=-B/d;
                        c= (ganho)*[cos(th) , sin(th)];
                        nobst5=nobst5+1;
                        obj.field=obj.field+[0 0; 0 0 ;  0 0; 0 0 ; c];
                    end
                end
                
                %                 d
                
            end
            %             nobst=nobst1+nobst2+nobst3+nobst4+nobst5;
            nobst=obj.nlaser;
            obj.field=diag([1/nobst 1/nobst 1/nobst 1/nobst 1/nobst])*obj.field;
            
            obj.totalfield=sum(obj.field);
            
        end
        
        
        
        function f2 = plota(obj, plotlaser , plotfield)
            % Plot
            Rot = 0.001*[cos(obj.posereal.th) -sin(obj.posereal.th)
                sin(obj.posereal.th)  cos(obj.posereal.th)];
            
            % Corpo do robo
            prop = 260;
            % Corpo do robo
            base=Rot *[500 500 -400 -400;
                250 -250 -250 250];
            
            lws=Rot *[300 400 400 300;
                290 290 320 320];
            
            rws=Rot *[300 400 400 300;
                -290 -290 -320 -320];
            
            lwb=Rot *[200 200 -400 -400;
                310 350 350 310];
            
            rwb=Rot *[200 200 -400 -400;
                -310 -350 -350 -310];
            
            leg=Rot *[365 0 0 365;
                225 225 -225 -225];
            
            larm= Rot *[ -100 -100 300 300;
                275 200 200 275];
            
            rarm= Rot *[ -100 -100 300 300;
                -275 -200 -200 -275];
            
            
            armor=Rot *[0 0 -200 -400 -400 -200;
                250 -250 -300 -250 250 300];
            
            chair=Rot *[-400 -500 -500 -400;
                -310 -310 310 310];
            
            cam=Rot *[-420 -470 -470 -420;
                -110 -110 110 110];
            
            head=Rot *[-50 -100 -200 -300 -350 -300 -200 -100;
                0 100 150 100 0 -100 -150 -100];
            

            
            
%             subplot(1,2,1)
            plot([obj.L(1,1) obj.L(1,3)] , [obj.L(1,2) obj.L(1,4)] , 'k' , 'linewidth' , 2)
            axis equal; grid on; box on;
            xlabel('x [m]'); ylabel('y [m]'); hold on;
            
            % Paredes
            for i = 2:size(obj.L,1)
                plot([obj.L(i,1) obj.L(i,3)] , [obj.L(i,2) obj.L(i,4)] , 'k' , 'linewidth' , 5)
            end
            
            if plotlaser == 1
                % Lasers
                for k = [1:length(obj.ranges)]
                    Px(k) = obj.pose.x + obj.ranges(k) * cos(obj.pose.th + obj.thetas(k));
                    Py(k) = obj.pose.y + obj.ranges(k) * sin(obj.pose.th + obj.thetas(k));
                    
                    plot(Px(k) , Py(k) , '.b' , 'linewidth' , 3 , 'markersize' , 10)
                    plot([obj.pose.x Px(k)] , [obj.pose.y Py(k)] , 'color' , [171 195 240]/255)
                end
            end
            
            
            fill(obj.posereal.x +base(1,:) ,obj.posereal.y + base(2,:) , [0.7 0.7 0.7])
            fill(obj.posereal.x +lws(1,:) , obj.posereal.y +lws(2,:) , [0.1 0.1 0.1])
            fill(obj.posereal.x +rws(1,:) , obj.posereal.y+rws(2,:) , [0.1 0.1 0.1])
            fill(obj.posereal.x +lwb(1,:) , obj.posereal.y+lwb(2,:) , [0.1 0.1 0.1])
            fill(obj.posereal.x +rwb(1,:) , obj.posereal.y+rwb(2,:) , [0.1 0.1 0.1])
            fill(obj.posereal.x +leg(1,:) , obj.posereal.y+leg(2,:) , [0 0 0.3])
            fill(obj.posereal.x +larm(1,:) , obj.posereal.y+larm(2,:) ,  [0.5 0.25 0])
            fill(obj.posereal.x +rarm(1,:) , obj.posereal.y+rarm(2,:) ,  [0.5 0.25 0])
            fill(obj.posereal.x +armor(1,:) , obj.posereal.y+armor(2,:) , [0 0.6 0])
            fill(obj.posereal.x +chair(1,:) , obj.posereal.y+chair(2,:) , [0.5 0.5 0.5])
            fill(obj.posereal.x +head(1,:) , obj.posereal.y+head(2,:) , [0.5 0.255 0])
            fill(obj.posereal.x +cam(1,:) , obj.posereal.y+cam(2,:) , [0.1 0.1 0.1])
            hold off
            grid minor
            axis([min([obj.L(:,1);obj.L(:,3)]),max([obj.L(:,1);obj.L(:,3)]),min([obj.L(:,2);obj.L(:,4)]),max([obj.L(:,2);obj.L(:,4)])]) 
            drawnow
            
            
            
            %             Rot = 0.001;
            %
            %             % Corpo do robo
            %             prop = 260;
            %             % Corpo do robo
            %             base=Rot *[500 500 -400 -400;
            %                 300 -300 -300 300];
            %
            %             lws=Rot *[300 400 400 300;
            %                 310 310 350 350];
            %
            %             rws=Rot *[300 400 400 300;
            %                 -310 -310 -350 -350];
            %
            %             lwb=Rot *[200 200 -400 -400;
            %                 330 400 400 330];
            %
            %             rwb=Rot *[200 200 -400 -400;
            %                 -330 -400 -400 -330];
            %
            %             leg=Rot *[365 0 0 365;
            %                 225 225 -225 -225];
            %
            %             larm= Rot *[ -100 -100 300 300;
            %                 275 200 200 275];
            %
            %             rarm= Rot *[ -100 -100 300 300;
            %                 -275 -200 -200 -275];
            %
            %
            %             armor=Rot *[0 0 -200 -400 -400 -200;
            %                 250 -250 -300 -250 250 300];
            %
            %             chair=Rot *[-400 -500 -500 -400;
            %                 -310 -310 310 310];
            %
            %             cam=Rot *[-420 -470 -470 -420;
            %                 -110 -110 110 110];
            %
            %             head=Rot *[-50 -100 -200 -300 -350 -300 -200 -100;
            %                 0 100 150 100 0 -100 -150 -100];
            %
            %
            %             seta=Rot *[0 0 100;
            %                 -3 3 0];
            %
            %
            %             subplot(1,2,2)
            %
            if plotfield == 1
                
                
                vecc=1000*Rot*[obj.totalfield(1);  obj.totalfield(2)];
                
                thti=atan2(vecc(2),vecc(1));
                Rot2=[cos(thti) -sin(thti)
                sin(thti)  cos(thti)];
                seta=Rot2*[0 0 0.2;
                -0.06 0.06 0];
                hold on;
                plot([obj.posereal.x obj.posereal.x+vecc(1)],[obj.posereal.y obj.posereal.y+vecc(2)],'k','linewidth',2.1)
                plot([obj.posereal.x obj.posereal.x+vecc(1)],[obj.posereal.y obj.posereal.y+vecc(2)],'r','linewidth',2) 
                fill(obj.posereal.x+vecc(1)+seta(1,:) ,obj.posereal.y+vecc(2)+seta(2,:) , 'r')
                hold off;
               drawnow
                
  
            end
            
            
        end
        
        
        
    end
    
    
end


%         function f3 = getfield(obj,B,ep)
%
%             obj.field=[0 0 ; 0 0];
%             nobst=0;
%
%             % Left field
%             for k=1:obj.nlaser
%                 d1=obj.ranges(k);
%                 th1=obj.thetas(k);
%                 d12=obj.dl;
% %                 d2 = (d1^2*sin(th1)^2 + (d12 - d1*cos(th1))^2)^(1/2);
% %                 th2 = atan2(d1*sin(th1), d1*cos(th1)-d12);
%                 d2=d1-0.5;
%                 th2=th1;
%
%                 if d2 < obj.R
%                     nobst=nobst+1;
%                     ganho=-B*((obj.R)/(d2));
%                     c= (ganho)*[cos(th2) , sin(th2)];
%                     if th1>0
%                         obj.field=obj.field+[0 0; c];
%                     end
%                     if th1<0
%                         obj.field=obj.field+[c; 0 0];
%                     end
%                 end
%             end
%
%
%             obj.field=obj.field/nobst;
%
%         end