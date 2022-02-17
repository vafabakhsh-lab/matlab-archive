
clear;
lambda1=80;      % average time at low
lambda2=80;      % average time at high
lambda3=80;
N=5;              % number of simulated traces

Tmax=4000;       % maximum time
cd('D:\smFret')

sz=0;in=0;
donor=[];acceptor=[];ALLT1=[];ALLT2=[];
%% exponential distribution %%%%
 T1=round(exprnd(lambda1,10000,1));
 T2=round(exprnd(lambda2,20000,1));
%%% random distribution %%%%
% T1=randi(40,10000,1);
% T2=randi(40,20000,1);

d_noise=1;
a_noise=1;

tr1=0.100;
tr2=0.9;

i=1;

for j = 1:N
Time=[];donor=[];acceptor=[];
in=0;sz=0;  

while sz<Tmax
    toss=rand(1);
    if toss < tr1
        t=T1(i);
        donor(1+in:in+t)=50+ (-d_noise) + (2*d_noise) .*rand(t,1);  %random number between -20 and 20 added. r = a + (b-a).*rand(100,1);
    else
        t=T2(i+10000);
        donor(1+in:in+t)=70+ (-d_noise) + (2*d_noise) .*rand(t,1); 
    end
    
    sz=max(size (donor));
    in=t+in;
    i=i+1;
end    

err=-a_noise + (2*a_noise).*rand(sz,1);
acceptor=200.-(donor+err');
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
