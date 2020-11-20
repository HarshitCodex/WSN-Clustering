
clear;

xm=500;
ym=500;
sink.x=0.5*xm;
sink.y=0.5*ym;
n=200;
p=0.1;
ini_energy = 10000;
proportion = 0.05;
rmax=75;
 
figure(1);

for i=1:1:n
    
    S(i).xd=rand(1,1)*xm;
    XR(i)=S(i).xd;
    S(i).yd=rand(1,1)*ym;
    YR(i)=S(i).yd;
    S(i).E = ini_energy;
    S(i).typ='N';
    plot(S(i).xd,S(i).yd,'+');       
end
S(n+1).xd=sink.x;
S(n+1).yd=sink.y;
plot(S(n+1).xd,S(n+1).yd,'x');
        
figure(1);


cluster=1;

sum_energy = ini_energy * n;
fileID4 = fopen("new_deadgraph.txt",'w+');
fileID5 = fopen("new_sumenergy.txt" , 'w+');

fprintf(fileID5 , "%d %f\n"  , 0 , sum_energy);

for r=0:1:rmax
    dead = 0;
    hold off;
    sum_energy =0 ;
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
    num_assigned = 0;
    fileID = fopen("dataset.txt",'w+');
    for i = 1:1:n
        if(S(i).E >0)
            fprintf(fileID,'%d %f %f %f\n',i , S(i).xd , S(i).yd , S(i).E);
            num_assigned = num_assigned + 1;
        end
    end

    fclose(fileID);

    
    
    commandStr = 'python3 /home/vij/Desktop/misc/projects/networks/WSN-Clustering/LEACH/makehead.py';
    [status, commandOut] = system(commandStr);
    if status==0
     fprintf('clustering done in %d iteration \n' , r + 1);
    end

    fileID2 = fopen('cluster_assigned.txt','r');
    formatSpec = '%d %d\n';
    cluster_assigned = textscan(fileID2,formatSpec);
    fclose(fileID2);
    

    fileID3 = fopen('cluster_heads.txt','r');
    formatSpec = '%d';
    cluster_heads = textscan(fileID3 , formatSpec);
    num_clusters = size(cluster_heads{1});
    fclose(fileID3);
    


    for i=1:1:num_assigned
        S(cluster_assigned{1}(i)).assign = cluster_heads{1}(cluster_assigned{2}(i) + 1);
       
    end



    for j=1:1:num_clusters    
        i = cluster_heads{1}(j) ;
        C(cluster).xd=S(i).xd;
        C(cluster).yd=S(i).yd;
        plot(S(i).xd,S(i).yd,'k*');
        s(i).typ = 'C';
        distance=sqrt( (S(i).xd-(S(n+1).xd) )^2 + (S(i).yd-(S(n+1).yd) )^2 );
        S(i).E = S(i).E - (proportion * distance*distance);
        sum_energy= sum_energy + S(i).E;
        C(cluster).distance=distance;
        C(cluster).id=i;
        cluster=cluster+1;
    end 
    


    for i = 1:1:n 
        if(S(i).typ == 'N')
            j = S(i).assign;
            min_dist = sqrt( (S(i).xd-S(j).xd)^2 + (S(i).yd- S(j).yd)^2);
            S(i).E  =S(i).E -  (proportion * min_dist);
            sum_energy = S(i).E + sum_energy;
        end 
    end


     fprintf(fileID4,'%d %d\n',r + 1, dead);
    fprintf(fileID5 , "%d %f\n" , r +1 , sum_energy);
    


hold on;
end

fclose(fileID4);
fclose(fileID5);

