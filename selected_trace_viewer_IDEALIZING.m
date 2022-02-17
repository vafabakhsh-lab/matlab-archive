% This program was used for newtimeanalysis3
% measure distance of each donor and acceptor points to the ideal levels
% given and decide based on proximity the value of ideal donor and
% acceptor.

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
        dummy = fscanf(fid,'%g %g %g  %g',[4 inf]);
        fclose(fid);
        dec=size(dummy);
        points = dec(2);
        inttime=dummy(1,2)-dummy(1,1);					%inttime = interval time 
%         if inttime<1
%             timeunit=1;
%         end
        
        
        time=dummy(1,:);
        donor=dummy(2,:);       
        acceptor=dummy(3,:);
            
        fret=acceptor./(acceptor+donor+(leakage.*donor));
alldata=[donor acceptor];lowlim=min(alldata)-50;highlim=max(alldata)+250;
        
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
        
        range_select= input('do you want to select a rage? ','s')
        if range_select == 'y'
            [xr,yr]=ginput (2);
            range_low=round((xr(1)-time(1)')/timeunit)+1;
            range_hi=round((xr(2)-time(1)')/timeunit)+1;
            time=time(1,range_low+1:range_hi);
            donor=donor(1,range_low+1:range_hi);       
            acceptor=acceptor(1,range_low+1:range_hi);
             fret=[];fret=acceptor./(acceptor+donor+(leakage.*donor));
             
         clf;
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
        end;
        
        histoplot=input('Do you want to hist?  ','s');
        if histoplot== 'y';
           figure;
           hist(fret,gap);
        end
        
        
selection= input('Do you want to analyze this trace?y for yes ','s');

if selection=='y';
    donor_low=[];donor_high=[];acceptor_low=[];acceptor_high=[];
    ideal_donor=[];ideal_acceptor=[];

    donor_low=input('low state of ideal donor] ');
    donor_high=input('high state of ideal donor] ');
    acceptor_low=input('low state of ideal acceptor] ');
    acceptor_high=input('high state of ideal acceptor] '); 
    
    FRET_Reference=[];
    FRET_Reference= input('what is the FRET cutoff?   ');
    
    

    
    for k=1:length(time);
    if abs(donor(k)-donor_low)< abs(donor(k)-donor_high);
        ideal_donor(k)=donor_low;
    else
        ideal_donor(k)=donor_high;
    end
    if abs(acceptor(k)-acceptor_low) < abs(acceptor(k)-acceptor_high);
        ideal_acceptor(k)=acceptor_low;
    else
        ideal_acceptor(k)=acceptor_high;
    end
    end
   ideal_fret=ideal_acceptor./(ideal_donor+ideal_acceptor);
    
    clf;
   h1= subplot(3,2,[1,2,3,4]);
    patchline(time,donor,'edgecolor','g','edgealpha',0.6);hold on;
    patchline(time,ideal_donor, 'linewidth',1.5,'edgecolor','g');hold on;
    patchline(time,acceptor,'edgecolor','r','edgealpha',0.6);hold on;
    patchline(time,ideal_acceptor, 'linewidth',1.5,'edgecolor','r');hold on;
    patchline(time,150+donor+acceptor,'edgecolor','k','edgealpha',0.6);hold on;
    patchline(time,150+ideal_donor+ideal_acceptor, 'linewidth',1.5,'edgecolor','k');
    ylim([0 20+max(donor+acceptor)]);
    xlim([min(time) max(time)]);
    grid on; zoom on;
    
    h2=subplot(3,2,[5,6]);
    patchline(time,fret,'edgecolor','c','edgealpha',0.8);hold on;
    patchline(time,FRET_Reference*ones(1,length(time)),'linestyle','--','edgecolor','r','linewidth',2);hold on;
    patchline(time,ideal_fret,'linewidth',1.5,'edgecolor','b');hold on;
    ylim([-0.02 1.02]);
    xlim([min(time) max(time)]);
    grid on; zoom on;
    linkaxes([h1,h2], 'x');
     
   
    
    hi=[];dhi=[];lo_fret_intervals=[];
    lo=[];dlo=[];hi_fret_intervals=[];
     hi=find(ideal_fret==max(ideal_fret));
     hold on;plot(time(hi),max(ideal_fret),'r*')
     
     extra=input('Do you want to add points? ', 's');
     
     while extra=='y'
         [x1,y1] = ginput(1);
         point=round((x1-time(1)')/timeunit)+1;
         hi=[hi point];
         ideal_fret(point)=max(ideal_fret);
         hold on;plot(time(point),max(ideal_fret),'k*')
         extra=input('Do you want to add points? ', 's');
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
        
        
        
        
        