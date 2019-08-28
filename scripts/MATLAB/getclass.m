function [y] = getclass(f,t,d,e)






if f==1
   
    
    if d == 1
       y=5;
        
    elseif e == 1
       y=6; 
        
    else
        y=1;
        
    end
    
    
    
elseif f==0 && t==0
    if d ==1
        y=3;
    elseif e==1
        y=4;
    else
        y=7;
    end
    
elseif t==1
    y=2;
    
else
    y=7;
    
end



end