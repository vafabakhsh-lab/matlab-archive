
clear;
lambda1=0.3;      % average time at low
lambda2=10;      % average time at high
N=20;              % number of simulated traces

Tmax=2000;       % maximum time
cd('C:\Woods hole\New folder')

sz=0;in=0;
donor=[];acceptor=[];ALLT1=[];ALLT2=[];

%%%%%%% exponential distribution %%%%%

 T1=round(exprnd(lambda1,10000,1));
 T2=round(exprnd(lambda2,20000,1));
%%% random distribution %%%%
% T1=randi(20,10000,1);
 %T2=randi(500,20000,1);
T3=randi(1800,20000,1);
T4=randi(20,10000,1);

 
d_noise=10;
a_noise=10;

i=1;kk=1;

for j = 1:N
Time=[];donor=[];acceptor=[];
in=0;sz=0;  

while sz<Tmax
%     T1=round(random('Exponential',lambda1))+1;ALLT1=[ALLT1 T1];
%     T1=round(exprnd(lambda1));
    t1=T1(i);
    donor(1+in:in+t1)=150+ (-d_noise) + (2*d_noise) .*rand(t1,1);  %random number between -20 and 20 added. r = a + (b-a).*rand(100,1);
%     T2=round(random('Exponential',lambda2))+1;ALLT2=[ALLT2 T2];
%     T2=round(exprnd(lambda2));
    t2=T2(i+10000);
    donor(in+t1+1:in+t1+t2)=200+ (-d_noise) + (2*d_noise).*rand(t2,1); 
    sz=size (donor);sz=sz(2);
    in=t1+t2+in;
    i=i+1;
end    




err=-a_noise + (2*a_noise).*rand(sz,1);
% acceptor=(15.*ones(size(donor)))+err'; 

acceptor=350.-(donor+err');

ad=[];ad=zeros(1,max(size(donor)));
for k=1:randi(100);
    flicker=randi(5);    
    ad(1,T3(kk):T3(kk)+flicker)=randi(10);
    kk=kk+1;
end

donor=donor+ad;

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
