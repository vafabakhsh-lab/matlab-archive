 clear
data=load('F:\data\1-June2013\June21-FRET\#5-CH3-1uM glutamate\15ms\film2\forvbFRET\aftervbFRET\2 tr106_PATH.dat');
time=data(:,1);donor=data(:,2);acceptor=data(:,3);fret=data(:,4);ideal_fret=data(:,5);

 donor_low=[];donor_high=[];acceptor_low=[];acceptor_high=[];
    ideal_donor=[];ideal_acceptor=[];

    donor_low=input('low state of ideal donor] ');
    donor_high=input('high state of ideal donor] ');
    acceptor_low=input('low state of ideal acceptor] ');
    acceptor_high=input('high state of ideal acceptor] '); 
    
    FRET_low = acceptor_low/(acceptor_low + donor_high);
    FRET_high = acceptor_high/(acceptor_high + donor_low);
    
    for i = 1:length(time);
        if abs(ideal_fret(i)-FRET_high) < abs(ideal_fret(i)-FRET_low)
            ideal_donor(i)=donor_low;
            ideal_acceptor(i)=acceptor_high;
        else
            ideal_donor (i)=donor_high;
            ideal_acceptor (i)=acceptor_low;
        end
    end
    
     h1= subplot(3,2,[1,2,3,4]);
    patchline(time,donor,'edgecolor','g','edgealpha',0.1);hold on;
    patchline(time,ideal_donor, 'linewidth',1.5,'edgecolor','m');hold on;
   patchline(time,acceptor,'edgecolor','r','edgealpha',0.1);hold on;
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
    
    
    
    