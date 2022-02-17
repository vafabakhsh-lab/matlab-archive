clear
N_trace=1;
for j = 1:N_trace;
len=[];time=[];datapoint=[];i=[];donor=[];acceptor=[];fname=[];in=[];
len = (45)+5;
time=0:0.03:len;
gamma=zeros(len,1);
datapoint=size(time);datapoint=datapoint(2);
cd('D:\smFret');


for i=1:datapoint;
    r=rand;
    if r>0.9; donor(i)=150+randi([-40,40]);
    else; donor(i) = 170+randi([-40,40]);
    end
end
acceptor= 300-donor+randi([-20,20]);

output=[time' , donor', acceptor'];
in=num2str(j);
fname=['trace' in '.dat'];
save(fname,'output','-ascii') ;
end

 subplot(2,1,1)
 plot(time,acceptor,'r',time,donor,'g')
 subplot(2,1,2)
 fret=acceptor./(donor+acceptor);
 plot(time,fret,'b');