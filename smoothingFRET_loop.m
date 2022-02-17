
clear
%    dummy=load('D:\analysis\mGlu\m3-0Ca\film12\New folder\1.dat');      
% timeunit=1;
% time=dummy(:,1)*timeunit;
% donor=dummy(:,2);       
% acceptor=dummy(:,3);

% clear
% donor=ones(200,1)+0.1*rand(200,1);donor (50:52,1)=0.4;
% acceptor=2*ones(200,1)+0.1*rand(200,1);acceptor (50:52,1)=2.4;

path=input('where are the selected traces?  ');
% cd('D:\SSB SIP\08312010 68T8 SSB-C RecO Mg');
cd(path);
[FileName,PathName] = uigetfile('*.dat');
cd(PathName);

step=0.04;
gap = 0:step:1;
sg=max(size(gap));
N_His_f=zeros(1,sg);
N_His_fs=zeros(1,sg);
N_His_F=zeros(1,sg);
N_smooth=5;
h1=[];h2=[];h3=[];

A=dir
numberfiles=length(A)
timeunit=0.1;
nm=2;

while (nm<numberfiles)
    nm=nm+1;
A(nm).name;
        
        fname=A(nm).name(1:end-4);
        disp(fname)
        fid=fopen(A(nm).name,'r');
        dummy = fscanf(fid,'%g %g %g',[3 inf]);
        fclose(fid);
        dec=size(dummy);
        points = dec(2);
        
        time=dummy(1,:)';
        donor=dummy(2,:)';       
        acceptor=dummy(3,:)';

I_f_don=[];I_b_don=[];I_f_acc=[];I_b_acc=[];C=[];f=[];b=[];

        
        length=max(size(donor));
n=[2 5];
M=4;
p=20;

s=0;

for N=n;
    s=s+1;
    lower_bound=max(M,N+1);

for i = lower_bound:length-N;
    I_f_don(i,s)=(1/N)*sum(donor((i-N):i-1));
    I_b_don(i,s)=(1/N)*sum(donor(i+1:i+N));
    
    I_f_acc(i,s)=(1/N)*sum(acceptor((i-N):i-1));
    I_b_acc(i,s)=(1/N)*sum(acceptor(i+1:i+N));
        
end

% I_f_don = I_f_don'; I_b_don = I_b_don';
% I_f_acc = I_f_acc'; I_b_acc = I_b_acc';

for i = lower_bound:length-M-N+1;
f(i,s)=0;b(i,s)=0;
    for j=0:M-1;
        j;
        f(i,s)=f(i,s)+((donor(i-j)-I_f_don((i-j),s))^2+(acceptor(i-j)-I_f_acc((i-j),s))^2);
        b(i,s)=b(i,s)+((donor(i+j)-I_b_don((i+j),s))^2+(acceptor(i+j)-I_b_acc((i+j),s))^2);             
    end
    f(i,s)=f(i,s)^(-p);b(i,s)=b(i,s)^(-p);

end
end

C=(1./sum(f+b,2));
f=bsxfun(@times,C,f);
b=bsxfun(@times,C,b);

range=max(size(f));
I_d_filter=0;I_a_filter=0;

for k=1:s;
    I_d_filter= I_d_filter + f(1:range,k).* I_f_don(1:range,k) + b(1:range,k).*I_b_don(1:range,k);
    I_a_filter= I_a_filter + f(1:range,k).* I_f_acc(1:range,k) + b(1:range,k).*I_b_acc(1:range,k);
    
end


% f=f'; b=b';
% 
% range=max(size(f));
% I_d_filter=f(1:range).* I_f_don(1:range) + b(1:range).*I_b_don(1:range);
% I_a_filter=f(1:range).* I_f_acc(1:range) + b(1:range).*I_b_acc(1:range);
% 

FRET_filter=I_a_filter./(I_a_filter+I_d_filter);
fret=acceptor./(acceptor+donor);
fret_smooth=smooth(fret,N_smooth); 

[n_f,x]=hist(fret,gap);          
[n_fs,x]=hist(fret_smooth,gap);  
[n_F,x]=hist(FRET_filter,gap);   
% plot(x,n_F/sum(n_F),'r');hold on


h1=subplot(5,2,[1,2,3,4]);
% plot(donor,'g');plot(I_d_filter(1:range));hold on;
%plot(acceptor,'r','LineStyle','-');hold on;plot(I_a_filter(1:range),'k')
%plot(fret);hold on;plot(FRET_filter,'r')
cla(h1);cla(h2);cla(h3); 
patchline(time,donor,'edgecolor','g','edgealpha',0.4);hold on;
patchline(time(1:range),I_d_filter(1:range), 'linewidth',1.5,'edgecolor','g');hold on;
patchline(time,acceptor,'edgecolor','r','edgealpha',0.4);hold on;
patchline(time(1:range),I_a_filter(1:range), 'linewidth',1.5,'edgecolor','r');hold on;
xlim([min(time) max(time)]);
grid on; zoom on;

h2=subplot(5,2,[5,6,7,8]);
patchline(time,fret,'edgecolor','c','edgealpha',0.5);hold on;
patchline(time(1:range),FRET_filter(1:range),'linewidth',1.5,'edgecolor','b');hold on;
ylim([-0.02 1.02]);
xlim([min(time) max(time)]);
grid on; zoom on;
linkaxes([h1,h2], 'x');

h3=subplot(5,2,9);
plot(gap,n_f/sum(n_f),'*'); hold on;plot(gap,n_F/sum(n_F),'r')
subplot(5,2,10)
plot(gap,N_His_F./sum(N_His_F),'*b')


option=input('include (enter), skip (s) ', 's');
if option=='s'
    N_His_f=N_His_f;
    N_His_fs=N_His_fs;
    N_His_F=N_His_F;
else
    N_His_f=N_His_f+n_f./sum(n_f);
    N_His_fs=N_His_fs+n_fs./sum(n_fs);
    N_His_F=N_His_F+n_F./sum(n_F); 
end

end

output=[x' , N_His_f' N_His_fs' N_His_F'];
time_fname=['total_pro_FRET_new.dat'];
save(time_fname,'output','-ascii') ;

% h1=subplot(3,2,[1,2])
% plot(donor,'g');hold on;plot(I_d_filter(1:range));hold on;
% plot(acceptor,'r');hold on;plot(I_a_filter(1:range),'k')

% h2=subplot(3,2,[3,4])
% plot(fret);hold on;plot(FRET_filter,'r')
% 
% linkaxes([h1,h2], 'x');
% 
% 
% [n_f,x]=hist(fret,0:0.04:1);
% subplot(3,2,5)
% plot(x,n_f/sum(n_f),'*'); hold on;
% 
% [n_F,x]=hist(FRET_filter,0:0.04:1)
% % subplot(3,2,6)
% plot(x,n_F/sum(n_F),'r')





