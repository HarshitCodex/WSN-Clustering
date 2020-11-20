
clear;

xm=500;
ym=500;
sink.x=0.5*xm;
sink.y=0.5*ym;
n=200;
p=0.1;
proportion = 0.05;
ini_energy = 10000;
rmax=75;
 
figure(1);

for i=1:1:n
    
    S(i).xd=rand(1,1)*xm;
    XR(i)=S(i).xd;
    S(i).yd=rand(1,1)*ym;
    YR(i)=S(i).yd;
    S(i).G=0;
    S(i).E = ini_energy;
    S(i).typ='N';
    plot(S(i).xd,S(i).yd,'+');       
end
S(n+1).xd=sink.x;
S(n+1).yd=sink.y;
plot(S(n+1).xd,S(n+1).yd,'x');
        
figure(1);
 
countCHs=0;




cluster=1;

fileID4 = fopen("old_deadgraph.txt",'w+');
fileID5  = fopen("old_sumenergy.txt" , 'w+');

sum_energy  = ini_energy * n;
fprintf(fileID5 , "%d %f\n" , 0 , sum_energy);

for r=0:1:rmax
    dead = 0;
    sum_energy = 0;
    if(mod(r, round(1/p) )==0)
        for i=1:1:n
            S(i).G=0;
            S(i).cl=0;
        end
    end
    hold off;

    figure(1);

    for i=1:1:n
       if(S(i).E <=0)
            S(i).typ  = 'D';
            S(i).E  =0 ;
            plot(S(i).xd , S(i).yd , 'r^');
            dead = dead + 1;
        end
        if(S(i).E >0)
            S(i).typ = 'N';
            plot(S(i).xd,S(i).yd,'+');
        end
        hold on;
    end
    plot(S(n+1).xd,S(n+1).yd,'x');

    countCHs=0;
    cluster=1;
    for i=1:1:n    
        temp_rand=rand;
        if ( (S(i).G)<=0 && S(i).E >0) 
            
            if(temp_rand<=(p/(1-p*mod(r,round(1/p)))))
                        countCHs=countCHs+1;
                        
                    S(i).typ='C';
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
                     S(i).E = S(i).E - (proportion * distance*distance);

                     sum_energy  = sum_energy + S(i).E;


                    
            end         
        end 
    end

    for i=1:1:n
        if ( S(i).typ=='N' && S(i).E>0 )
            if(cluster-1>=1)
                min_dis=sqrt( (S(i).xd-S(n+1).xd)^2 + (S(i).yd-S(n+1).yd)^2 );
       
                for c=1:1:cluster-1
                    temp=min(min_dis,sqrt( (S(i).xd-C(c).xd)^2 + (S(i).yd-C(c).yd)^2 ) );
                    if ( temp<min_dis )
                            min_dis=temp;
                            min_dis_cluster=c;
                    end
                end
            S(i).E  =S(i).E -  (proportion * min_dis);
           sum_energy = sum_energy + S(i).E;

            end
        end
    end

    
    fprintf(fileID4,'%d %d\n',r + 1, dead);
    fprintf(fileID5 , "%d %f\n" , r +1 , sum_energy);
    fprintf("iteration %d completed\n" , r + 1);
        
    


hold on;
end
fclose(fileID4);




