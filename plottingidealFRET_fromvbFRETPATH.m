% This program read the output data from vbFRET (blah_PATH) which is 5
% column data (index, donor, accepor, FRET, ideal FRET). You then input
% 4 values for high and low Intensity levels of donor and acceptor signal
% and based on the ideal FRET it plots a trace which you can add new
% transition points.
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
        dummy = fscanf(fid,'%g %g %g %g %g',[5 inf]);
        dummy=dummy';
        fclose(fid);
        dec=size(dummy);
        points = dec(2);
        inttime=dummy(1,2)-dummy(1,1);					%inttime = interval time 

        
time=dummy(:,1)*timeunit;
donor=dummy(:,2);
acceptor=dummy(:,3);
fret=dummy(:,4);
ideal_fret=dummy(:,5);
            
        
alldata=[donor ;acceptor];lowlim=min(alldata)-50;highlim=max(alldata)+250;
        
        h1=subplot(2,2,[1,2]);
        plot(time,donor,'g',time,acceptor,'r' ,time,donor+acceptor+200,'k');       
           ylim([lowlim highlim]);
         title(['File:' fname '   Molecule:' int2str(j)]);
      
        grid on;
        zoom on;
        h2=subplot(2,2,[3,4]);
        plot(time,fret,'b');
         ylim([-0.01 1.01]);
        grid on;
        zoom on;
        linkaxes([h1,h2], 'x');
        
        option= input('what do you want to do? ','s');
        
        if option == 'b'
            i=i-2;
        end
        
selection= input('Do you want to analyze this trace?y for yes ','s');

if selection=='y';
    donor_low=[];donor_high=[];acceptor_low=[];acceptor_high=[];
    ideal_donor=[];ideal_acceptor=[];

    donor_low=input('low state of ideal donor] ');
    donor_high=input('high state of ideal donor] ');
    acceptor_low=input('low state of ideal acceptor] ');
    acceptor_high=input('high state of ideal acceptor] ');    
    
    
    %new%%%%%%%%%%%%%%%%%%%
    FRET_low = acceptor_low/(acceptor_low + donor_high);
    FRET_high = acceptor_high/(acceptor_high + donor_low);
    
    for ii = 1:length(time);
        if abs(ideal_fret(ii)-FRET_high) < abs(ideal_fret(ii)-FRET_low)
            ideal_donor(ii)=donor_low;
            ideal_acceptor(ii)=acceptor_high;
        else
            ideal_donor (ii)=donor_high;
            ideal_acceptor (ii)=acceptor_low;
        end
    end
    ideal_donor=ideal_donor';
    adeal_acceptor=ideal_acceptor';
    %end new%%%%%%%%%%%%%%%%%%
    
    clf;
%    h1= subplot(3,2,[1,2,3,4]);
%     patchline(time,donor,'edgecolor','g','edgealpha',0.5);hold on;
%     patchline(time,ideal_donor, 'linewidth',1.5,'edgecolor','g');hold on;
%     patchline(time,acceptor,'edgecolor','r','edgealpha',0.5);hold on;
%     patchline(time,ideal_acceptor, 'linewidth',1.5,'edgecolor','r');hold on;
%     patchline(time,150+donor+acceptor,'edgecolor','k','edgealpha',0.5);hold on;
%     patchline(time,150+ideal_donor+ideal_acceptor, 'linewidth',1.5,'edgecolor','k');
%     ylim([0 20+max(donor+acceptor)]);
%     xlim([min(time) max(time)]);
%     grid on; zoom on;
%     
%     h2=subplot(3,2,[5,6]);
%     patchline(time,raw_fret,'edgecolor','c','edgealpha',0.8);hold on;
%     patchline(time,ideal_fret,'linewidth',1.5,'edgecolor','b');hold on;
%     ylim([-0.02 1.02]);
%     xlim([min(time) max(time)]);
%     grid on; zoom on;
%     linkaxes([h1,h2], 'x');
     
%new%%%%%
h1= subplot(3,2,[1,2,3,4]);
    patchline(time,donor,'edgecolor','g','edgealpha',0.6);hold on;
    patchline(time,ideal_donor, 'linewidth',1.5,'edgecolor','m');hold on;
   patchline(time,acceptor,'edgecolor','r','edgealpha',0.6);hold on;
    patchline(time,ideal_acceptor, 'linewidth',1.5,'edgecolor','b');hold on;

    ylim([0 20+max(donor+acceptor)]);
    xlim([min(time) max(time)]);
    grid on; zoom on;
    
    
        h2=subplot(3,2,[5,6]);
    patchline(time,fret,'edgecolor','b','edgealpha',0.4);hold on;
    patchline(time,ideal_fret,'linewidth',2,'edgecolor','r');hold on;
    ylim([-0.02 1.02]);
    xlim([min(time) max(time)]);
    grid on; zoom on;
    linkaxes([h1,h2], 'x');
    %new%%%%%
    
    
    hi=[];dhi=[];lo_fret_intervals=[];
    lo=[];dlo=[];hi_fret_intervals=[];
     hi=find(ideal_fret==max(ideal_fret));hi=hi';
     hold on;plot(time(hi),max(ideal_fret),'r*')
     
     extra=input('Do you want to add points? ', 's');
     
     while extra=='y'
         [x1,y1] = ginput(1);
         point=round((x1-time(1)')/timeunit)+1;
         hi=[hi point];
         ideal_fret(point)=max(ideal_fret);
         hold on;plot(time(point),max(ideal_fret),'k*')
         extra=input('Do you want to add points? (y)', 's');
     end
      extra=input('Do you want to add points? ', 's');
     while extra=='s'
         [x2,y2] = ginput(1);
         point=round((x2-time(1)')/timeunit)+1;
         hi(hi==point)=[];
         ideal_fret(point)=min(ideal_fret);
         hold on;plot(time(point),min(ideal_fret),'k*')
         extra=input('Do you want to subtract points? (s) ', 's');
     end
     
     hi=sort(hi); 
     dhi=diff(hi);
     lo_fret_intervals=timeunit*dhi(dhi>1)';
     
     lo=find(ideal_fret~=max(ideal_fret));
     dlo=diff(lo);
     hi_fret_intervals=timeunit*dlo(dlo>1)';
     hold on;plot(time(lo),min(ideal_fret),'m*')
     
     ask=input('do you want to save? ', 's');
     if ask=='y'
        fname_lo_fret_interval=[fname 'lowfret.dat']; 
        save(fname_lo_fret_interval,'lo_fret_intervals','-ascii') ;
        
        fname_hi_fret_interval=[fname 'hifret.dat']; 
        save(fname_hi_fret_interval,'hi_fret_intervals','-ascii') ;
        
%         fid = fopen(['lowfret.dat'],'a+');
%         fprintf(fid,'%4.3f\n', intervals);
%         fclose(fid);
     end
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

        
        
        
        
        