clear;
clf;
close all;

%%%%% Bin STEP %%% 
step=0.02;
gap1 = 0:step:1;

sg=size(gap1);sg=sg(2);
N_His=zeros(1,sg);
N_His2=zeros(1,sg);

%%%%% N point averaging %%%% 
N_av=5;
N_smooth=5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

leakage=0.0;
temp_end=40;
correction_factor=0;
time_five=zeros(0,0);
acceptor_five=zeros(0,0);
donor_five=zeros(0,0);
FRET_five=zeros(0,0);
raw_fret_His=zeros(0,0);
FRET_five_His=zeros(0,0);
% N_His=zeros(1,51);
N_total_number=0;
N_total_correlation=zeros(1,temp_end);
N_total_correlation_collected=zeros(1,temp_end);
N_total_number_correlation=0;
N_total_number_correlation_collected=0;

path=input('where are the selected traces?  ');
% cd('D:\SSB SIP\08312010 68T8 SSB-C RecO Mg');
cd(path);
[FileName,PathName] = uigetfile('*.dat');
cd(PathName);

A=dir
numberfiles=length(A);
maxcps=1500;
hdl1=gcf;
i=2;
timeunit=1;
frettable=zeros(0,0);

while (i<numberfiles)
    i=i+1;
    state=[];
    dwtime=[];
    
    A(i).name;
    if A(i).name(end-3:end)=='.dat';
        
        fname=A(i).name(1:end-4);
        disp(fname)
        fid=fopen(A(i).name,'r');
        dummy = fscanf(fid,'%g %g %g',[3 inf]);
        fclose(fid);
        dec=size(dummy);
        points = dec(2);
        
        time=dummy(1,:)*timeunit;
        donor=dummy(2,:);       
        acceptor=dummy(3,:);
        
        %warning off MATLAB:divideByZero      
        raw_fret=acceptor./(acceptor+donor+(leakage.*donor));
        ttl_count= acceptor+donor+500;                    %ttl_count = total intensity +500 
        ave_count=(acceptor + donor)/2;	                 %ave_count= average intensity
        
        %Adjacent Averaging
%         ave_fret = raw_fret;
%         for b=3: points-1
%             ave_fret(b)= (raw_fret(b-1)+raw_fret(b)+raw_fret(b+1))/3;
%         end
        
        
    raw_fret_smooth=smooth(raw_fret,N_smooth);    
    range=find(raw_fret_smooth>=0 & raw_fret_smooth<=1);
    raw_fret_smooth_truncated= raw_fret_smooth(range);
    
%     max(size(raw_fret))
%     max(size(raw_fret_smooth_truncated))
    
       
   [n1,xout] =hist(raw_fret_smooth_truncated,gap1);
    N_His=N_His+n1/sum(n1);
  
       
        
        N_total_number=N_total_number+1;
       
        size_trace=size(donor);
        portion_start=1;
        portion_end=size_trace(2);
        portion_length=abs(portion_end-portion_start);
        portion_length_five=fix(portion_length/N_av);
        
        
        n=0;
        for t=1:portion_length_five,
            n=n+1;
            time_five(n)=portion_start+2+(n-1)*N_av;
            acceptor_five(n)=sum(acceptor((portion_start+(n-1)*N_av):(portion_start+(N_av-1)+(n-1)*N_av)));
            donor_five(n)=sum(donor((portion_start+(n-1)*N_av):(portion_start+(N_av-1)+(n-1)*N_av)));
            FRET_five(n)=acceptor_five(n)/(acceptor_five(n)+donor_five(n));
        end
                
        m=0;
        l=0;
        for n=1:portion_length_five,
            m=m+1;
            if (FRET_five(m)<=1 & FRET_five(m)>=0)
                l=l+1;
                FRET_five_His(l)=FRET_five(m);
            end
        end
      
        
    range2=find(FRET_five>=0 & FRET_five<=1);
    FRET_five_His= FRET_five(range2);
    l=max(size(FRET_five_His));
    
       [n,xout] =hist(FRET_five_His,gap1);
%        sum(n/l)
        N_His2=N_His2+n/l;
%         bar(xout,N_His2);
        title(['Total Number of Molecule now is: ' num2str(N_total_number)]);
      
         output=[xout' , N_His' N_His2'];
         time_fname=['total_pro_FRET_new.dat'];
         save(time_fname,'output','-ascii') ;
        
       
        drawnow;
    end
end
subplot(2,1,1)
bar(xout,N_His);

subplot(2,1,2)
bar(xout,N_His2);

