
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
temp_end=100;

sg=max(size(gap));
N_His_f=zeros(1,sg);
N_His_fs=zeros(1,sg);
N_His_F=zeros(1,sg);
N_His_fret=zeros(1,sg);

h1=[];h2=[];h3=[];h4=[];h5=[];
N_total_XC=zeros(1,temp_end);
N_total_XC_filter=zeros(1,temp_end);
N_total_XC_smooth=zeros(1,temp_end);
XC_counter=0;

N_smooth=3;

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
        dummy = fscanf(fid,'%g %g %g ',[3 inf]);
        fclose(fid);
        dec=size(dummy);
        points = dec(2);
        
        time=dummy(1,:)';
        donor=+dummy(2,:)';       
        acceptor=+dummy(3,:)';

I_f_don=[];I_b_don=[];I_f_acc=[];I_b_acc=[];C=[];f=[];b=[];
I_f_fret=[];I_b_fret=[];
smooth_donor=[];smooth_acceptor=[];
fret=acceptor./(acceptor+donor);
fret_smooth=smooth(fret,N_smooth);
smooth_donor=smooth(donor,N_smooth);
smooth_acceptor=smooth(acceptor,N_smooth);
        
        length=max(size(donor));
n=[4];
M=3;
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
    
    I_f_fret(i,s)=(1/N)*sum(fret((i-N):i-1));
    I_b_fret(i,s)=(1/N)*sum(fret(i+1:i+N));
        
end

% I_f_don = I_f_don'; I_b_don = I_b_don';
% I_f_acc = I_f_acc'; I_b_acc = I_b_acc';

for i = lower_bound:length-M-N+1;
f(i,s)=0;b(i,s)=0;
ffret(i,s)=0;bfret(i,s)=0;
    for j=0:M-1;
        j;
        f(i,s)=f(i,s)+((donor(i-j)-I_f_don((i-j),s))^2+(acceptor(i-j)-I_f_acc((i-j),s))^2);
        b(i,s)=b(i,s)+((donor(i+j)-I_b_don((i+j),s))^2+(acceptor(i+j)-I_b_acc((i+j),s))^2); 
        
        ffret(i,s)=ffret(i,s)+((fret(i-j)-I_f_fret((i-j),s))^2);  % filter the raw fret directly.
        bfret(i,s)=bfret(i,s)+((fret(i+j)-I_b_fret((i+j),s))^2);
    end
    f(i,s)=f(i,s)^(-p); b(i,s)=b(i,s)^(-p);
    ffret(i,s)=ffret(i,s)^(-p); bfret(i,s)=bfret(i,s)^(-p);

end
end

C=(1./sum(f+b,2));     Cf=(1./sum(ffret+bfret,2));
f=bsxfun(@times,C,f);  ffret=bsxfun(@times,Cf,ffret);
b=bsxfun(@times,C,b);  bfret=bsxfun(@times,Cf,bfret);

range=max(size(f));
I_d_filter=0;I_a_filter=0;
fret_filter=0;

for k=1:s;
    I_d_filter= I_d_filter + f(1:range,k).* I_f_don(1:range,k) + b(1:range,k).*I_b_don(1:range,k);
    I_a_filter= I_a_filter + f(1:range,k).* I_f_acc(1:range,k) + b(1:range,k).*I_b_acc(1:range,k);
    
    fret_filter= fret_filter + ffret(1:range,k).* I_f_fret(1:range,k) + bfret(1:range,k).*I_b_fret(1:range,k);
end


% f=f'; b=b';
% 
% range=max(size(f));
% I_d_filter=f(1:range).* I_f_don(1:range) + b(1:range).*I_b_don(1:range);
% I_a_filter=f(1:range).* I_f_acc(1:range) + b(1:range).*I_b_acc(1:range);
% 

FRET_filter=I_a_filter./(I_a_filter+I_d_filter);
 

[n_f,x]=hist(fret,gap);          
[n_fs,x]=hist(fret_smooth,gap);  
[n_F,x]=hist(FRET_filter,gap);  
[n_fret,x]=hist(fret_filter,gap);  
% plot(x,n_F/sum(n_F),'r');hold on


h1=subplot(5,2,[1,2,3,4]);
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

h2=subplot(5,2,[5,6,7,8]);
patchline(time,fret,'edgecolor','c','edgealpha',0.5);hold on;
patchline(time(1:range),FRET_filter(1:range),'linewidth',1.5,'edgecolor','b');hold on;
ylim([-0.02 1.02]);
xlim([min(time) max(time)]);
grid on; zoom on;
linkaxes([h1,h2], 'x');

h3=subplot(5,2,9);
plot(gap,n_f/sum(n_f),'*'); hold on;hold on;
h4=subplot(5,2,9);
plot(gap,N_His_F./sum(N_His_F),'r');


option=input('include (enter), skip (s) ', 's');
if option=='s'
    N_His_f=N_His_f;
    N_His_fs=N_His_fs;
    N_His_F=N_His_F;
    N_His_fret=N_His_fret;
else
    N_His_f=N_His_f+n_f./sum(n_f);
    N_His_fs=N_His_fs+n_fs./sum(n_fs);
    N_His_F=N_His_F+n_F./sum(n_F); 
    N_His_fret=N_His_fret+n_fret./sum(n_fret);
%%%%%%%%%%%%%%% CORRELATION  %%%%%%%%%%%%%%%%
Ave_donor=mean(donor);        Ave_donor_filter=nanmean(I_d_filter);
Ave_acceptor=mean(acceptor);  Ave_acceptor_filter=nanmean(I_a_filter);       
std_donor=std(donor);         std_donor_filter=nanstd(I_d_filter);
std_acceptor=std(acceptor);   std_acceptor_filter=nanstd(I_a_filter);
delta_donor=donor-Ave_donor;  delta_donor_filter=I_d_filter-Ave_donor_filter;
delta_acceptor=acceptor-Ave_acceptor; delta_acceptor_filter=I_a_filter-Ave_acceptor_filter;

Ave_smooth_d = mean(smooth_donor); Ave_smooth_a = mean(smooth_acceptor);
std_smooth_d= std(smooth_donor); std_smooth_a= std(smooth_acceptor);
delta_smooth_d=smooth_donor - Ave_smooth_d; delta_smooth_a=smooth_acceptor - Ave_smooth_a;

d_X_a=zeros(1,range+1);
d_X_a_filter=zeros(1,range+1);
d_X_a_smooth=zeros(1,range+1);

delta_donor_filter(isnan(delta_donor_filter))=0;
delta_acceptor_filter(isnan(delta_acceptor_filter))=0;

if range > temp_end;
    for tau=0:range,
    normalize_number=0;
    sum_tau=0;
    sum_tau_filter=0;
    sum_tau_smooth=0;
        for t=1:range-tau,
            sum_tau=sum_tau+(delta_donor(t)*delta_acceptor(t+tau));
            sum_tau_filter=sum_tau_filter +(delta_donor_filter(t)*delta_acceptor_filter(t+tau));
            sum_tau_smooth=sum_tau_smooth +(delta_smooth_d(t)*delta_smooth_a(t+tau));
            normalize_number=normalize_number+1;
         end
    if normalize_number==0
           d_X_a(tau+1)=NaN;
    else        
%            d_X_a(tau+1)=sum_tau_filter/(normalize_number)/std_donor_filter/std_acceptor_filter;;
%            d_X_a_smooth(tau+1)=sum_tau_filter/(normalize_number)/Ave_donor_filter/Ave_acceptor_filter;
%            d_X_a_filter(tau+1)=sum_tau_filter/(normalize_number)/(Ave_donor_filter+Ave_acceptor_filter);
           d_X_a(tau+1)=sum_tau/(normalize_number)/(Ave_donor+Ave_acceptor);
           d_X_a_smooth(tau+1)=sum_tau_smooth/(normalize_number)/(Ave_smooth_a+Ave_smooth_a);
           d_X_a_filter(tau+1)=sum_tau_filter/(normalize_number)/(Ave_donor_filter+Ave_acceptor_filter);
     end
end
N_total_XC=N_total_XC + d_X_a(1:temp_end);
N_total_XC_filter=N_total_XC_filter + d_X_a_filter(1:temp_end);
N_total_XC_smooth=N_total_XC_smooth + d_X_a_smooth(1:temp_end);
XC_counter=XC_counter+1;

h5=subplot(5,2,10);
cla(h5);
plot(d_X_a(1:temp_end),'*b');hold on;
plot(N_total_XC/XC_counter,'r');
ylim([-1 0.2]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
end
%%%%%        TIME             No filter                  smoothed data               filtered data  
output=[timeunit*(0:temp_end-1)' (N_total_XC/XC_counter)' (N_total_XC_smooth/XC_counter)' (N_total_XC_filter/XC_counter)'];
time_fname=['total_XC.dat'];
save(time_fname,'output','-ascii') ;

%%%%% TIME  raw data  smoothed fret  filtered fret   filtered_donor/filtered _acceptor 
output=[x' , N_His_f' N_His_fs' N_His_fret' N_His_F' ];
time_fname=['total_FRET.dat'];
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





