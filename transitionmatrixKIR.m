% loc=load('L:\data\9-April2014\5-Apil21\#2-CH2-m2m2SNAP only-0glut\film34.pks');
%gam=load('L:\data\9-April2014\5-Apil21\#2-CH2-m2m2SNAP only-0glut\selectedFRETavseg34.dat');
%num=gam(:,1);
%for i = 1:100;xc=loc(num(i),1);yc=loc(num(i),3);plot(xc,yc,'.');if gam(i,4)>0;text(xc+1,yc,num2str(gam(i,4)));end;hold on;end

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
cd(path);
[FileName,PathName] = uigetfile('*.dat');
cd(PathName);
step=0.02;
gap = 0:step:1;
temp_end=80;
N_smooth=4;
timeunit=0.1;

sg=max(size(gap));
N_His_f=zeros(1,sg);
N_His_fs=zeros(1,sg);
N_His_F=zeros(1,sg);
N_His_F_gamma=zeros(1,sg);
N_His_fret=zeros(1,sg);

h1=[];h2=[];h3=[];h4=[];h5=[];
N_total_XC=zeros(1,temp_end);
N_total_XC_old=zeros(1,temp_end);
N_total_XC_filter=zeros(1,temp_end);
N_total_XC_smooth=zeros(1,temp_end);
XC_counter=0;
cr=[];u=1;

A=dir
numberfiles=length(A)

A=dir
numberfiles=length(A)

nm=2;
i=1;
cr=[];
dff=[]

while (nm<numberfiles)
        nm=nm+1;
        A(nm).name;
        fname=A(nm).name(1:end-4);
%         disp(fname);
        fid=fopen(A(nm).name,'r');
        dummy = fscanf(fid,'%g %g %g ',[3 inf]);
        fclose(fid);
        dec=size(dummy);
        points = dec(2);
        
       fret=[];time=[];donor=[];acceptor=[];df=[];
        time=dummy(1,:)';
        donor=+dummy(2,:)';       
        acceptor=+dummy(3,:)';
        donorgamma=dummy(3,:)';
           

I_f_don=[];I_b_don=[];I_f_acc=[];I_b_acc=[];C=[];f=[];b=[];
I_f_fret=[];I_b_fret=[];
smooth_donor=[];smooth_acceptor=[];
fret=acceptor./(acceptor+donor);
fret_smooth=smooth(fret,N_smooth);
smooth_donor=smooth(donor,N_smooth);
smooth_acceptor=smooth(acceptor,N_smooth);
        
        length=max(size(donor));
n=[2];%2
M=2;%2
p=15;%15

s=0;

for N=n;
    s=s+1;
    lower_bound=max(M,N+1);

for i = lower_bound:length-N;
    I_f_don(i,s)=(1/N)*sum(donor((i-N):i-1));
    I_b_don(i,s)=(1/N)*sum(donor(i+1:i+N));
    
    I_f_don_gamma(i,s)=(1/N)*sum(donorgamma((i-N):i-1));
    I_b_don_gamma(i,s)=(1/N)*sum(donorgamma(i+1:i+N));
    
    I_f_acc(i,s)=(1/N)*sum(acceptor((i-N):i-1));
    I_b_acc(i,s)=(1/N)*sum(acceptor(i+1:i+N));
    
    I_f_fret(i,s)=(1/N)*sum(fret((i-N):i-1));
    I_b_fret(i,s)=(1/N)*sum(fret(i+1:i+N));
        
end


for i = lower_bound:length-M-N+1;
f(i,s)=0;b(i,s)=0;
fgamma(i,s)=0;bgamma(i,s)=0;
ffret(i,s)=0;bfret(i,s)=0;
    for j=0:M-1;
        j;
        f(i,s)=f(i,s)+((donor(i-j)-I_f_don((i-j),s))^2+(acceptor(i-j)-I_f_acc((i-j),s))^2);
        b(i,s)=b(i,s)+((donor(i+j)-I_b_don((i+j),s))^2+(acceptor(i+j)-I_b_acc((i+j),s))^2); 
        
        fgamma(i,s)=fgamma(i,s)+((donorgamma(i-j)-I_f_don_gamma((i-j),s))^2+(acceptor(i-j)-I_f_acc((i-j),s))^2);
        bgamma(i,s)=bgamma(i,s)+((donorgamma(i+j)-I_b_don_gamma((i+j),s))^2+(acceptor(i+j)-I_b_acc((i+j),s))^2);
        
        ffret(i,s)=ffret(i,s)+((fret(i-j)-I_f_fret((i-j),s))^2);  % filter the raw fret directly.
        bfret(i,s)=bfret(i,s)+((fret(i+j)-I_b_fret((i+j),s))^2);
    end
    f(i,s)=f(i,s)^(-p); b(i,s)=b(i,s)^(-p);
    fgamma(i,s)=fgamma(i,s)^(-p); bgamma(i,s)=bgamma(i,s)^(-p);
    ffret(i,s)=ffret(i,s)^(-p); bfret(i,s)=bfret(i,s)^(-p);

end
end

C=(1./sum(f+b,2));     Cf=(1./sum(ffret+bfret,2));
f=bsxfun(@times,C,f);  ffret=bsxfun(@times,Cf,ffret);
b=bsxfun(@times,C,b);  bfret=bsxfun(@times,Cf,bfret);

Cgamma=(1./sum(fgamma+bgamma,2));     
fgamma=bsxfun(@times,Cgamma,fgamma);  
bgamma=bsxfun(@times,Cgamma,bgamma);  

range=max(size(f));
I_d_filter=0;I_a_filter=0;
I_d_gamma_filter=0;
fret_filter=0;

for k=1:s;
    I_d_filter= I_d_filter + f(1:range,k).* I_f_don(1:range,k) + b(1:range,k).*I_b_don(1:range,k);
    I_a_filter= I_a_filter + f(1:range,k).* I_f_acc(1:range,k) + b(1:range,k).*I_b_acc(1:range,k);
    I_d_gamma_filter= I_d_gamma_filter + fgamma(1:range,k).* I_f_don_gamma(1:range,k) + bgamma(1:range,k).*I_b_don_gamma(1:range,k);
    
    fret_filter= fret_filter + ffret(1:range,k).* I_f_fret(1:range,k) + bfret(1:range,k).*I_b_fret(1:range,k);
end


% f=f'; b=b';
% 
% range=max(size(f));
% I_d_filter=f(1:range).* I_f_don(1:range) + b(1:range).*I_b_don(1:range);
% I_a_filter=f(1:range).* I_f_acc(1:range) + b(1:range).*I_b_acc(1:range);
% 

FRET_filter=I_a_filter./(I_a_filter+I_d_filter);
FRET_filter_gamma=I_a_filter./(I_a_filter+I_d_gamma_filter); 

        lengthfret=max(size(fret));
        for t = 1:lengthfret-2
            if abs(fret(t+2)-fret(t+1))<0.02
            cr(u,1)=fret(t);
            cr(u,2)=fret(t+1);
            u=u+1;
            end
        end

[n_f,x]=hist(fret,gap);          
[n_fs,x]=hist(fret_smooth,gap);  
[n_F,x]=hist(FRET_filter,gap);  
[n_F_gamma,x]=hist(FRET_filter_gamma,gap);  
[n_fret,x]=hist(fret_filter,gap);  
% plot(x,n_F/sum(n_F),'r');hold on


h1=subplot(2,1,1);
% plot(donor,'g');plot(I_d_filter(1:range));hold on;
%plot(acceptor,'r','LineStyle','-');hold on;plot(I_a_filter(1:range),'k')
%plot(fret);hold on;plot(FRET_filter,'r')
cla(h1);cla(h2);cla(h3);cla(h4);    
patchline(time,donor,'edgecolor','g','edgealpha',0.4);hold on;
patchline(time(1:range),I_d_filter(1:range), 'linewidth',1.5,'edgecolor','g');hold on;
patchline(time,acceptor,'edgecolor','r','edgealpha',0.4);hold on;
patchline(time(1:range),I_a_filter(1:range), 'linewidth',1.5,'edgecolor','r');hold on;
patchline(time,150+donor+acceptor,'edgecolor','k','edgealpha',0.4);hold on;
patchline(time(1:range),150+I_a_filter(1:range)+I_d_filter(1:range), 'linewidth',1.5,'edgecolor','k');
title(['File: ' fname '   Molecule:' int2str(nm)]);
ylim([0 20+max(150+I_a_filter(1:range)+I_d_filter(1:range))]);
xlim([min(time) max(time)]);
grid on; zoom on;

h2=subplot(2,1,2);
patchline(time,fret,'edgecolor','c','edgealpha',0.5);hold on;
patchline(time(1:range),FRET_filter(1:range),'linewidth',1.5,'edgecolor','b');hold on;
ylim([-0.02 1.02]);
xlim([min(time) max(time)]);
grid on; zoom on;
linkaxes([h1,h2], 'x');
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%Transition detection%%%%%%%%%%%
option=input('do you want to work on this (s) ', 's');
if option =='s';
    qq=input('what is qq factor ? ', 's');
    while qq=='o';
    disp('Click 2X  to select the range to calculate INITIAL FRET ');
    [xi,yi]=ginput(2);
    xii(1)=round(xi(1)/timeunit);
    xii(2)=round(xi(2)/timeunit);
    initial=mean(fret(xii(1):xii(2)))
    disp('Click 2X  to select the range to calculate FINAL FRET ');
    [xf,yf]=ginput(2);
    xff(1)=round(xf(1)/timeunit);
    xff(2)=round(xf(2)/timeunit);
    final=mean(fret(xff(1):xff(2)))
    
    fid = fopen(['transition.dat'],'a+');
    fprintf(fid, '%4.3f\t  %4.3f\n', initial, final);
    fclose(fid)
    qq=input('what is qq factor ? ', 's')
    end
end
end

nn=120;
ind=find(cr(:,1)>1 | cr(:,1)<0 | cr(:,2)>1 | cr(:,2)<0);
cr(ind,:)=[];
values = hist3([cr(:,1) cr(:,2)],[nn nn]);
imagesc(values)
colorbar
axis equal
axis xy

% hold on; plot(1:nn,1:nn,'k*')
% plot(cr(:,1),cr(:,2),'.')
% hold on; plot(0:0.01:1,0:0.01:1,'k*')

set(gca, 'XTick', 0:nn/5:nn);
set(gca, 'XTickLabel', [ 0:0.2:1 ] );
set(gca, 'YTick', 0:nn/5:nn);
set(gca, 'YTickLabel', [ 0:0.2:1 ] );

xlabel('Inital FRET','FontSize',14) % x-axis label
ylabel('Final FRET','FontSize',14) % y-axis label

