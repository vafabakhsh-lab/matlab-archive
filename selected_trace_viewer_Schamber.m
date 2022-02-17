clear;
clf;
close all;

leakage=0.09;
temp_end=40;
correction_factor=0;
time_five=zeros(0,0);
acceptor_five=zeros(0,0);
donor_five=zeros(0,0);
FRET_five=zeros(0,0);
raw_fret_His=zeros(0,0);
FRET_five_His=zeros(0,0);


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
timeunit=0.03;
frettable=zeros(0,0);

step=0.02;
gap = 0:step:1;
%skip=input('if you want to skip to trace number X input the number now');
%if isempty(skip)
%   skip=2;
%else
%   i=skip;
%end

while (i<numberfiles)
      i=i+1;
    state=[];
    dwtime=[];
    
    A(i).name;
    if A(i).name(end-3:end)=='.dat';
        
        fname=A(i).name(1:end-4);
        disp(fname)
        fid=fopen(A(i).name,'r');
        dummy = fscanf(fid,'%g %g %g %g  ',[4 inf]);
        fclose(fid);
        dec=size(dummy);
        points = dec(2);
        inttime=dummy(1,2)-dummy(1,1);					%inttime = interval time 
        if inttime<1
            timeunit=1;
        end
        
        
        time=dummy(1,:)*timeunit;
        donor=dummy(2,:);       
        acceptor=dummy(3,:);
            
          %warning off MATLAB:divideByZero      
        raw_fret=acceptor./(acceptor+donor+(leakage.*donor));
        %raw_fret=dummy(2,:);
        ttl_count= acceptor+donor+500;                    %ttl_count = total intensity +500 
        ave_count=(acceptor + donor)/2;	                 %ave_count= average intensity
        
alldata=[donor acceptor];lowlim=min(alldata)-50;highlim=max(alldata)+250;
        
        h1=subplot(2,2,[1,2]);
        plot(time,donor,'g',time,acceptor,'r' ,time,donor+acceptor+200,'k');       
           ylim([lowlim highlim]);
         title(['File:' fname '   Molecule:' int2str(j)]);
      
        grid on;
        zoom on;
        h2=subplot(2,2,[3,4]);
        plot(time,raw_fret,'-b.');
         ylim([-0.01 1.01]);
        grid on;
        zoom on;
        linkaxes([h1,h2], 'x');
        
        option= input('what do you want to do? ','s');
        
        if option == 'b'
            i=i-2;
        end
        
        if option  == 'c'
            transition=[];
           for j = 1: max(size(raw_fret))-2;
               transition(j,1)=raw_fret(j);
               transition(j,2)=raw_fret(j+1);
           end
           plot(transition(:,1),transition(:,2),'.')
        end
        
        if option== 'h';
            figure;
          hist(raw_fret,gap);
          [nhis,x]=hist(raw_fret,gap);
          data=[x' ,nhis'];
          
          filtername=['hist' fname ];
          save([path '\' filtername '.dat'],'data','-ascii') ;
 
        end
        
%         subplot(4,2,[7]);
%         datafret=raw_fret>0.05;
%         hist(raw_fret(datafret),[0:0.01:1]);
%         xlim([-0.02 1.02]);
          more_range=input('Press n to move to next molecule ','s');
%                         if more_range=='n'
%                             j=j-1;
%                         end
    end
end
        
        
        
        
        