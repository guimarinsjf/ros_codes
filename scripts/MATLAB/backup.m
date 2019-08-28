   function f3 = getfield(obj,B,B2)
            
            obj.field=[0 0 ; 0 0; 0 0];
            nobst1=1;
            nobst2=1;
            nobst3=1;
            
            % Cálculo dos campos
            for k=1:obj.nlaser
                x1=obj.ranges(k)*cos(obj.thetas(k));
                y1=obj.ranges(k)*sin(obj.thetas(k));
                dc=obj.dl+0.55;
                dl=obj.dl2;
                
                
                if k <= obj.nlaser/3
                    % Esquerdo               
                    x2=abs(x1 - dc);
                    y2=y1 + dl ;
                    d2 = (x2^2 + y2^2)^(1/2);
                    th2=atan2(y2,x2);
                    if d2 < obj.R
                        nobst1=nobst1+1;
                        ganho=-B*((obj.R)/(d2))^1;
                        c= (ganho)*[cos(th2) , sin(th2)];
                        obj.field=obj.field+[c ; 0 0; 0 0];
                    end
                end
                
                if k > 2*obj.nlaser/3
                    % Direito               
                    x3=abs(x1 - dc);
                    y3=y1 - dl ;
                    d3 = (x3^2 + y3^2)^(1/2);
                    th3=atan2(y3,x3);
                    if d3 < obj.R
                        d3
                        nobst2=nobst2+1;
                        ganho=-B*((obj.R)/(d3))^1;
                        c= (ganho)*[cos(th3) , sin(th3)];
                        obj.field=obj.field+[0 0; c ; 0 0];
                    end
                end
                
                
                if k <= 2*obj.nlaser/3 && k > obj.nlaser/3
                    % Centro                   
                    x4=x1 - dc;
                    y4=y1;
                    d4 = (x4^2 + y4^2)^(1/2);
                    th4=atan2(y4,x4);
                    if d4 < obj.R
                        d4
                        nobst3=nobst1+3;
                        ganho=-B2*((obj.R)/(d4))^1;
                        c= (ganho)*[cos(th4) , sin(th4)];
                        obj.field=obj.field+[0 0 ; 0 0; c];
                    end
                end
                
            end
            
            
            obj.field=[1/nobst1 0 0; 0 1/nobst2 0; 0 0 1/nobst3]*obj.field;
            
   end
        
   
      function f3 = getfield(obj,B,B2)
            
            obj.field=[0 0 ; 0 0; 0 0];
            nobst1=1;
            nobst2=1;
            nobst3=1;
            
            % Cálculo dos campos
            for k=1:obj.nlaser
                d1=obj.ranges(k);
                th1=obj.thetas(k);
                dc=obj.dl+0.55;
                dl=obj.dl2;
                d1
                
                if k <= obj.nlaser/3
                    % Esquerdo
                    d2 = ((dc - d1*cos(th1))^2 + (dl + d1*sin(th1))^2)^(1/2);
                    th2= atan2(dl + d1*sin(th1),d1*cos(th1) - dc);
                    
                    if d2 < obj.R
                        d2
                        nobst1=nobst1+1;
                        ganho=-B*((obj.R)/(d2))^2;
                        c= (ganho)*[cos(th2) , sin(th2)];
                        obj.field=obj.field+[c ; 0 0; 0 0];
                    end
                end
                
                if k > 2*obj.nlaser/3
                    % Direito
                    d3 = ((dc - d1*cos(th1))^2 + (dl - d1*sin(th1))^2)^(1/2);
                    th3= atan2(d1*sin(th1) - dl, d1*cos(th1) - dc);
                    if d3 < obj.R
                        d3
                        nobst2=nobst2+1;
                        ganho=-B*((obj.R)/(d3))^2;
                        c= (ganho)*[cos(th3) , sin(th3)];
                        obj.field=obj.field+[0 0; c ; 0 0];
                    end
                end
                
                
                if k <= 2*obj.nlaser/3 && k > obj.nlaser/3
                    % Centro
                    d4 = (d1^2*sin(th1)^2 + (dc - d1*cos(th1))^2)^(1/2);
                    th4= atan2(d1*sin(th1) , d1*cos(th1) - dc);
                    if d4 < obj.R
                        d4
                        nobst3=nobst1+3;
                        ganho=-B2*((obj.R)/(d4))^2;
                        c= (ganho)*[cos(th4) , sin(th4)];
                        obj.field=obj.field+[0 0 ; 0 0; c];
                    end
                end
                
            end
            
            
            obj.field=[1/nobst1 0 0; 0 1/nobst2 0; 0 0 1/nobst3]*obj.field;
            
        end