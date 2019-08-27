import numpy as np
from numpy import diff

class shared(object):

    def __init__(self , gains ,xs , min_pass , max_pass , angles, 
                 vmin, wmin, dc, dl, vd, srd, sld):
        
        # Narrow Passages Parameters        
        self.gains=gains
        self.xs=xs
        self.min_pass=min_pass
        self.max_pass=max_pass
        self.angles=angles
        self.pose=[0,0,0]
        self.X=np.matrix([[-1],[0],[0]])
        s1=0.03
        s2=0.03
        s3=0.05
        self.R=np.matrix([[s1**2, 0, 0] ,[0, s2**2, 0], [0, 0, s3**2]])
        self.Q=np.matrix([[s1**2/15, 0, 0] ,[0, s2**2/15, 0], [0, 0, s3**2/100]])
        self.P=self.Q
        self.H=np.matrix([[1, 0, 0] ,[0, 1, 0], [0, 0, 1]])
        self.v=0
        self.w=0
        
        
        # Navigation
        self.vmin = vmin
        self.wmin = wmin
        self.dc=dc
        self.dl=dl
        self.vd=vd
        self.srd=srd
        self.sld=sld        
        self.field=np.matrix([0,0])                
    
    
    
    
    ######### Shared Control #########
    
    def get_fields(self,lasers,lamb1,lamb2):
        self.field=np.array([0,0]) 
        dist=100;
        for k in range(len(self.angles)):           
            x=lasers[k]*np.cos(self.angles[k])
            y=lasers[k]*np.sin(self.angles[k])
            
            if x <= self.dc:
                if y < -self.dl:
                    dist=-y-self.dl
                    th=-np.pi/2
                elif y > self.dl:
                    dist=y-self.dl
                    th=np.pi/2
            else:
                if y<-self.dl:
                    dist=np.sqrt(pow(x-self.dc,2)+pow(y+self.dl,2))
                    th=np.arctan2(y+self.dl,x-self.dc)
                elif y>self.dl:
                    dist=np.sqrt(pow(x-self.dc,2)+pow(y-self.dl,2))
                    th=np.arctan2(y-self.dl,x-self.dc)
                else:
                    dist=x-self.dc
                    th=0                     
            if dist < 1.25:
                beta= lamb1*th*th+lamb2     
                self.field=self.field+[(-beta/dist)*np.cos(th),(-beta/dist)*np.sin(th)] 
                    
            
    
    def get_vels(self,classe,modo,alpha):
        v=self.vd+self.field[0]
        sr=self.srd+[0,self.field[1]]
        sl=self.sld+[0,self.field[1]]       
        thr= np.arctan2(sr[1],sr[0])
        thl= np.arctan2(sl[1],sl[0])
        modo = modo+1 
        vels=[0,0]
        

        if classe ==1:
            if modo ==3:
                vels[0]=self.vmin
                vels[1]=0                
            elif modo ==2:
                vels[0]=max(self.vmin,alpha[0]*v)
                vels[1]=0                                       
            elif modo ==1:                 
                vels[0]=max(self.vmin,alpha[1]*v)
                vels[1]=0 
                
        elif classe ==2:
                vels[0]=-self.vmin
                vels[1]=0 
                
        elif classe ==3:
            if modo ==3:
                vels[0]=0
                vels[1]=-self.wmin                 
            elif modo ==2:
                vels[0]=0
                vels[1]=min(-self.wmin , alpha[2]*thr)                 
            elif modo ==1: 
                vels[0]=0
                vels[1]=min(-self.wmin , alpha[3]*thr)                 
                
        elif classe ==4:
            if modo ==3:
                vels[0]=0
                vels[1]=self.wmin                     
            elif modo ==2:
                vels[0]=0
                vels[1]=max(self.wmin , alpha[2]*thl)                   
            elif modo ==1: 
                vels[0]=0
                vels[1]=max(self.wmin , alpha[3]*thl)   
                
        elif classe ==5:
            if modo ==3:
                vels[0]=self.vmin
                vels[1]=-self.wmin                      
            elif modo ==2:
                vels[0]=max(self.vmin,alpha[4]*v)
                vels[1]=min(-self.wmin , alpha[5]*thr)                  
            elif modo ==1:  
                vels[0]=max(self.vmin,alpha[6]*v)
                vels[1]=min(-self.wmin , alpha[7]*thr)    
                
        elif classe ==6:
            if modo ==3:
                vels[0]=self.vmin
                vels[1]=-self.wmin      
            elif modo ==2:
                vels[0]=max(self.vmin,alpha[4]*v)
                vels[1]=max(self.wmin , alpha[5]*thl)                 
            elif modo ==1:
                vels[0]=max(self.vmin,alpha[6]*v)
                vels[1]=max(self.wmin , alpha[7]*thl) 
                
        elif classe ==7:             
                vels[0]=0
                vels[1]=0 
               
        self.v = vels[0]
        self.w = vels[1]        
    

        
    def get_gates(self, lasers):
                   
        derivates=diff(lasers)
        start_gate=np.where(derivates>0.3)[0]
        end_gate=np.where(derivates<-0.3)[0]
        
        lds=lasers[start_gate];
        lde=lasers[end_gate];
              
        X=lasers*np.cos(self.angles)
        Y=lasers*np.sin(self.angles)

        gates=[]
        mingate=10;                
        
        for k in range(len(start_gate)):
            if lds[k] < 2.3:     
                x1=X[start_gate[k]]
                y1=Y[start_gate[k]]
                x2=X[start_gate[k]+1:]
                y2=Y[start_gate[k]+1:]
                d=np.sqrt((x2-x1)**2+(y2-y1)**2)
                dmin=min(d)
                endd=np.where(d==dmin)
                if (dmin > self.min_pass) and (dmin < self.max_pass)  and (endd[0][0]>3) and (dmin < mingate):
                    gates=[x1,y1,x2[endd[0][0]],y2[endd[0][0]]]
                    mingate=dmin
                
        for k in range(len(end_gate)):
            if lde[k] < 2.3 and end_gate[k] > 3:     
                x1=X[end_gate[k]]
                y1=Y[end_gate[k]]
                x2=X[0:end_gate[k]]
                y2=Y[0:end_gate[k]]
                d=np.sqrt((x2-x1)**2+(y2-y1)**2)
                dmin=min(d)
                startt=np.where(d==dmin)
                if (dmin > self.min_pass) and (dmin < self.max_pass) and (startt[0][0] > end_gate[k]-3) and (dmin < mingate):
                    gates=[x1,y1,x2[startt[0][0]],y2[startt[0][0]]]
                    mingate=dmin
        
        self.gates=gates
        
        
    def localization(self):
        if self.gates:
            gates=self.gates          
            x1=gates[0]-0.32
            x2=gates[2]-0.32
            y1=gates[1]
            y2=gates[3]        
            x3=(x1+x2)/2
            y3=(y1+y2)/2        
            
            thg=-np.arctan2(y2-y1,x2-x1)+np.pi/2
            if thg > np.pi:
                thg=thg-2*np.pi
            if thg < -np.pi:
                thg=thg+2*np.pi
            self.pose=[-x3*np.cos(thg)+y3*np.sin(thg) , -x3*np.sin(thg)-y3*np.cos(thg) , thg]
        else:
            pass
             
    def kalman(self,ds,dth):

        F=np.matrix([[1, 0, -ds*np.sin(self.X[2,0]+dth/2)],[0, 1, ds*np.cos(self.X[2,0]+dth/2)],[0,   0,  1]])
        dX=np.matrix([[ds*np.cos(self.X[2,0]+dth/2)],[ ds*np.sin(self.X[2,0]+dth/2)], [dth]])    
        self.X=self.X+dX
        self.P=F * self.P * F.T + self.Q
        
        if self.gates:
            Z=np.matrix([[self.pose[0]],[self.pose[1]],[self.pose[2]]])
            S=self.H*self.P*self.H.T+self.R
            K=self.P*self.H.T*S.I   
            self.X=self.X+K*(Z-self.H*self.X)
            self.P=(self.H-K*self.H.T)*self.P       
            if abs(self.X[2]-Z[2])>0.2:
                self.X[2]=Z[2]
        
    def controler(self):
        k=self.gains
        xr=self.X[0,0]
        yr=self.X[1,0]
        thr=self.X[2,0]
        ths=np.arctan2(-yr,(self.xs-xr))-thr
        a=1/(1+(yr/k[6])**8)
        w1=-k[0]*a*yr*np.cos(thr)
        w2=-k[1]*a*thr
        w3=k[2]*(1-a)*ths  
        v1=k[3]*np.cos(thr)**2+0.05
        v2=k[4]*a*(xr*np.cos(thr))**4
        v3=k[5]*(1-a)*(yr*np.cos(ths/2))**2
        self.w=w1+w2+w3
        self.v=v1+v2+v3        

        
        
        
