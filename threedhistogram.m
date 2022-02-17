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

path=input('where are the selected traces?  ', 's');
cd(path);
[FileName,PathName] = uigetfile('*.dat');
cd(PathName);

step=0.02;
gap = 0:step:1;
temp_end=130;
N_smooth=4;
timeunit=0.03;

sg=max(size(gap));
N_His_f=zeros(1,sg);
N_His_fs=zeros(1,sg);
N_His_F=zeros(1,sg);
N_His_F_gamma=zeros(1,sg);
N_His_fret=zeros(1,sg);

h1=[];h2=[];h3=[];h4=[];h5=[];
N_total_XC=zeros(1,temp_end);
N_total_XC_filter=zeros(1,temp_end);
N_total_XC_smooth=zeros(1,temp_end);
XC_counter=0;

A=dir('*tr*.dat')
numberfiles=length(A)

nm=2;
i=1;
cr=[];
dff=[]

while (nm<numberfiles)
        nm=nm+1;
        A(nm).name;
        fname=A(nm).name(1:end-4);
        disp(fname)
        fid=fopen(A(nm).name,'r');
        dummy = fscanf(fid,'%g %g %g %g %g %g',[6 inf]);
        fclose(fid);
        dec=size(dummy);
        points = dec(2);
        
       fret=[];time=[];donor=[];acceptor=[];df=[];
        time=dummy(1,:)';
        donor=+dummy(2,:)';       
        acceptor=+dummy(3,:)';
        donorgamma=dummy(4,:)';
        
        fret=acceptor./(acceptor+donor);
        
        lengthfret=max(size(fret));
        for j = 1:lengthfret-1
            cr(i,1)=fret(j);
            cr(i,2)=fret(j+1);
            i=i+1;
        end
        df=diff(fret);
        dff=[dff ;df];
end

% values = hist3([cr(:,1) cr(:,2)],[141 141]);
% imagesc(values)
% colorbar
% axis equal
% axis xy
% hold on; plot(1:100,1:100,'k*')
% plot(cr(:,1),cr(:,2),'.')
% hold on; plot(0:0.01:1,0:0.01:1,'k*')



