
clear;
lambda1=10;      % average time at low
lambda2=10;      % average time at high
lambda3=10;
N=100;              % number of simulated traces

Tmax=2000;       % maximum time
cd('F:\programs\traces')

sz=0;in=0;
donor=[];acceptor=[];ALLT1=[];ALLT2=[];
%% exponential distribution %%%%
 T1=round(exprnd(lambda1,40000,1));
 T2=round(exprnd(lambda2,40000,1));
 T3=round(exprnd(lambda3,50000,1));
%%% random distribution %%%%
% T1=randi(40,10000,1);
% T2=randi(10,20000,1);

d_noise=1;
a_noise=1;

tr1=0.3333;
tr2=0.6666;

i=1;

for j = 1:N
Time=[];donor=[];acceptor=[];
in=0;sz=0;  

t=T1(i);
donor(1+in:in+t)=100+ (-d_noise) + (2*d_noise) .*rand(t,1);
status=1;

while sz<Tmax
    toss=rand(1);
    i=i+1;
    if status==1;
        if toss < 0.5;
        t=T2(i);
        donor(1+in:in+t)=150+ (-d_noise) + (2*d_noise) .*rand(t,1);  %random number between -20 and 20 added. r = a + (b-a).*rand(100,1);
        temp_status=2;
        else 
        t=T3(i);
        donor(1+in:in+t)=200+ (-d_noise) + (2*d_noise) .*rand(t,1);  %random number between -20 and 20 added. r = a + (b-a).*rand(100,1);
        temp_status=3;
        end
    end

     if status==2;
        if toss < 0.5;
        t=T1(i);
        donor(1+in:in+t)=100+ (-d_noise) + (2*d_noise) .*rand(t,1);  %random number between -20 and 20 added. r = a + (b-a).*rand(100,1);
        temp_status=1;
        else 
        t=T3(i);    
        donor(1+in:in+t)=200+ (-d_noise) + (2*d_noise) .*rand(t,1);  %random number between -20 and 20 added. r = a + (b-a).*rand(100,1);
        temp_status=3;
        end
     end
    
       if status==3;
        if toss < 0.5;
        t=T1(i);
        donor(1+in:in+t)=100+ (-d_noise) + (2*d_noise) .*rand(t,1);  %random number between -20 and 20 added. r = a + (b-a).*rand(100,1);
        temp_status=1;
        else 
        t=T2(i);    
        donor(1+in:in+t)=150+ (-d_noise) + (2*d_noise) .*rand(t,1);  %random number between -20 and 20 added. r = a + (b-a).*rand(100,1);
        temp_status=2;
        end
       end
    status=temp_status;
    sz=max(size (donor));
    in=t+in;
    
end    

err=-a_noise + (2*a_noise).*rand(sz,1);
acceptor=350.-(donor+err');
Time=[1:sz];
FRET=acceptor./(donor+acceptor);

% plotting the traces and FRET
 subplot(2,1,1);
plot(Time,donor,'g',Time,acceptor,'r');

subplot(2,1,2)
plot(Time,FRET,'b')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% saving the traces in 3 column .dat files.
output=[Time' , donor', acceptor'];
k=num2str(j);fname=['trace' k '.dat'];
save(fname,'output','-ascii') ;
%%%%%%%%%%%%%%%%%%%%
end
