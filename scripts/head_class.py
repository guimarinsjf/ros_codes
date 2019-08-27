import numpy as np
from numpy import diff

class shared(object):

    def __init__(self , vmin, wmin, dc, dl, vd, srd, sld):
        
        
        
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
    

      

        
        
        
