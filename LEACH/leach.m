
clear;

xm=500;
ym=500;
sink.x=0.5*xm;
sink.y=0.5*ym;
n=200;
p=0.1;
rmax=250;
 
figure(1);

for i=1:1:n
    
    S(i).xd=rand(1,1)*xm;
    XR(i)=S(i).xd;
    S(i).yd=rand(1,1)*ym;
    YR(i)=S(i).yd;
    S(i).G=0;
    S(i).type='N';
   
    
    plot(S(i).xd,S(i).yd,'+');       
end
S(n+1).xd=sink.x;
S(n+1).yd=sink.y;
plot(S(n+1).xd,S(n+1).yd,'x');
        
figure(1);
 
countCHs=0;


cluster=1;


for r=0:1:rmax
    
    if(mod(r, round(1/p) )==0)
        for i=1:1:n
            S(i).G=0;
            S(i).cl=0;
        end
    end
    hold off;




    figure(1);

    for i=1:1:n
        S(i).type='N';  
        plot(S(i).xd,S(i).yd,'+');
        hold on;
    end
    plot(S(n+1).xd,S(n+1).yd,'x');

    countCHs=0;
    cluster=1;
    for i=1:1:n    
        temp_rand=rand;
        if ( (S(i).G)<=0)
            
            if(temp_rand<=(p/(1-p*mod(r,round(1/p)))))
                        countCHs=countCHs+1;
                        
                    S(i).type='C';
                    S(i).G=round(1/p)-1;
                    C(cluster).xd=S(i).xd;
                    C(cluster).yd=S(i).yd;
                    plot(S(i).xd,S(i).yd,'k*');
                    
                    distance=sqrt( (S(i).xd-(S(n+1).xd) )^2 + (S(i).yd-(S(n+1).yd) )^2 );
                    C(cluster).distance=distance;
                    C(cluster).id=i;
                    X(cluster)=S(i).xd;
                    Y(cluster)=S(i).yd;
                    cluster=cluster+1;
            end         
        end 
    end

   


hold on;

end

