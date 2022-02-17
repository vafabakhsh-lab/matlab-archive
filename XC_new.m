%for viewing a bunch of dat files in a folder where the columns go
%Time, FRET, Donor, Acceptor.  The way cat_tir delivers them.

function ChengDatViewer(path)
clear;
clf;
close all;

Fret_one=0;
Fret_multi=0;

step=0.02;
gap1 = 0:step:1;
sg=size(gap1);sg=sg(2);
N_His=zeros(1,sg);
N_av=4;

leakage=0.0;
temp_end=125;
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
        dummy = fscanf(fid,'%g %g %g %g',[4 inf]);
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
            
        
%          time=dummy(1,:)*timeunit;
%         donor=dummy(2,:)./(dummy(2,:)+dummy(3,:));       
%         acceptor=(dummy(3,:)-0.14.*donor)./(dummy(2,:)+dummy(3,:));
        
        %warning off MATLAB:divideByZero      
        raw_fret=acceptor./(acceptor+donor+(leakage.*donor));
        %raw_fret=dummy(2,:);
        ttl_count= acceptor+donor+500;                    %ttl_count = total intensity +500 
        ave_count=(acceptor + donor)/2;	                 %ave_count= average intensity
        
        %Adjacent Averaging
        ave_fret = raw_fret;
        for b=3: points-1
            ave_fret(b)= (raw_fret(b-1)+raw_fret(b)+raw_fret(b+1))/3;
        end
        
        m=0;
        l=0;
        for n=1:points,
            m=m+1;
            if (raw_fret(m)<=1.2 & raw_fret(m)>= -0.2) %increased the range from 0-1
                l=l+1;
                raw_fret_His(l)=raw_fret(m);
            end
        end
        
        original_fret = raw_fret;
        raw_fret= ave_fret;
        ideal_state = raw_fret;
        array=ones(size(raw_fret));
        
        %%%%%%%%%%%%%%%five points smooth%%%%%%%%%%%%%%%%%%%%%%%
        donor_five_smooth=donor;
        acceptor_five_smooth=acceptor;
        m=2;
        for n=3:points-2,
            m=m+1;
            donor_five_smooth(m)=sum(donor(m-2:m+2))/5;
            acceptor_five_smooth(m)=sum(acceptor(m-2:m+2))/5;
        end
        
        raw_fret_five_smooth=acceptor_five_smooth./(acceptor_five_smooth+donor_five_smooth);
        %raw_fret=dummy(2,:);
        ttl_count_five_smooth= acceptor_five_smooth+donor_five_smooth+500;                    %ttl_count = total intensity +500 
        ave_count_five_smooth=(acceptor_five_smooth + donor_five_smooth)/2;
        
        m=0;
        l=0;
        for n=1:points,
            m=m+1;
            if (raw_fret(m)<=1 & raw_fret_five_smooth(m)>=0)
                l=l+1;
                raw_fret_His(l)=raw_fret_five_smooth(m);
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %First figure, first subplot
        figure(hdl1);
        subplot(5,2,1); 
        %plot(time,donor,'g',time,acceptor,'r',time,ave_count,'k:');
        plot(time,donor_five_smooth,'g',time,acceptor_five_smooth,'r');
        title([ 'Molecule:' int2str(i-2) '  file:' A(i).name]);
        %axis([time(1) time(end) -20 maxcps]);
        axis tight;
        temp=axis;
        temp(4)=2*temp(4);
        axis(temp);
        grid on;
        zoom on;
        
        %First figure, second subplot
        subplot(5,2,3);
        plot(time,original_fret,'c:',time,raw_fret_five_smooth,'b');
        axis([time(1) time(end) -0.05 1.1]);
        grid on;
        zoom on;
        
        subplot(5,2,5);
        gap = 0:0.01:1;
        hist(raw_fret_His,gap);
        axis tight;
        temp=axis;
        temp(1)=-0.1;
        temp(2)=1.1;
        axis(temp);
        grid on;
        zoom on;
        raw_fret_His=zeros(0,0);
        
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
        
        
        
        subplot(5,2,2);
        plot(time_five,donor_five,'-g','LineWidth',2);
        hold on;
        plot(time_five,acceptor_five,'-r','LineWidth',2);
        hold off;
        title([ 'Bined five traces for Molecule:' int2str(i-2) '  file:' A(i).name]);
        axis tight;
        temp=axis;
        temp(4)=2*temp(4);
        axis(temp);
        grid on;
        zoom on;
        
        subplot(5,2,4);
        plot(time_five,FRET_five,'-b','LineWidth',2);
        axis([portion_start portion_end -0.05 1.1]);
        grid on;
        zoom on;
        
        m=0;
        l=0;
        for n=1:portion_length_five,
            m=m+1;
            if (FRET_five(m)<=1 & FRET_five(m)>=0)
                l=l+1;
                FRET_five_His(l)=FRET_five(m);
            end
        end
        subplot(5,2,6);
       
        hist(FRET_five_His,gap1);
        axis tight;
        temp=axis;
        temp(1)=-0.1;
        temp(2)=1.1;
        axis(temp);
        grid on;
        zoom on;
        
       [n,xout] =hist(FRET_five_His,gap1);
       sum(n/l)
        N_His=N_His+n/l;
        subplot(5,2,8);
        bar(xout,N_His);
        title(['Total Number of Molecule now is: ' num2str(N_total_number)]);
        axis tight;
        temp=axis;
        temp(1)=-0.1;
        temp(2)=1.1;
        axis(temp);
        grid on;
        zoom on;
      
         output=[xout' , N_His'];
         time_fname=['total_pro_FRET.dat'];
         save(time_fname,'output','-ascii') ;
        
       
        drawnow;
        %%%%%%%%%%%%%%%%%%%%cross correlation part%%%%%%%%%%%%%%%%%
        %donor=donor_five_smooth;
        %acceptor=acceptor_five_smooth;
        Ave_donor=mean(donor(portion_start:portion_end));
        Ave_acceptor=mean(acceptor(portion_start:portion_end));
        std_donor=std(donor(portion_start:portion_end));
        std_acceptor=std(acceptor(portion_start:portion_end));
        delta_donor=donor-Ave_donor;
        delta_acceptor=acceptor-Ave_acceptor;
        Ave_donor_cross_acceptor=zeros(1,portion_end-portion_start+1);
        for tau=0:(portion_end-portion_start),
            normalize_number=0;
            sum_tau=0;
            for t=portion_start:(portion_end-tau),
                sum_tau=sum_tau+(delta_donor(t)*delta_acceptor(t+tau));
                normalize_number=normalize_number+1;
            end
            if normalize_number==0
                Ave_donor_cross_acceptor(tau+1)=NaN;
            else
                Ave_donor_cross_acceptor(tau+1)=sum_tau/(normalize_number)/std_donor/std_acceptor;
            end
        end
        subplot(5,2,7)
        t=0:(portion_end-portion_start);
        plot(t,Ave_donor_cross_acceptor,'-b','LineWidth',2);
        title(['Cross Correlation: ']);
        axis tight;
        temp=axis;
        temp(1)=0;
        temp(2)=fix((portion_end-portion_start)/2);
        axis(temp);
        grid on;
        zoom on;
        drawnow;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %             wait=input('Do you satisfy with this correlation? Hit ''g'' for choose, ''Enter'' for next one: ','s');
        %             if wait=='g'
        %                 N_total_number=N_total_number+1;
        %                 [n,xout] =hist(FRET_five_His,gap);
        %                 N_His=N_His+n/l;
        %                 subplot(4,2,8);
        %                 bar(xout,N_His);
        %                 title(['Total Number of Molecule now is: ' num2str(N_total_number)]);
        %                 axis tight;
        %                 temp=axis;
        %                 temp(1)=-0.1;
        %                 temp(2)=1.1;
        %                 axis(temp);
        %                 grid on;
        %                 zoom on;
        %                 
        %                 output=N_His';
        %                 time_fname='total_correlation.xls';
        %                 save(time_fname,'output','-ascii') ;
        %             end
        
        FRET_five_His=zeros(0,0);
        FRET_five=zeros(0,0);
        time_five=zeros(0,0);
        acceptor_five=zeros(0,0);
        donor_five=zeros(0,0);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%total_correlation%%%%%%%%%%%%%%%%%%%%%
        if (portion_end-portion_start)>temp_end
           if fix((portion_end-portion_start)/3)>=temp_end
                N_total_number_correlation_collected=N_total_number_correlation_collected+1;
                N_total_correlation_collected=N_total_correlation_collected+Ave_donor_cross_acceptor(1:temp_end);  
                subplot(5,2,10)
                t=0:temp_end-1;
                plot(t,N_total_correlation_collected/N_total_number_correlation_collected,'-b','LineWidth',2);
                title(['Total Number of the Collected Correlation traces is: ' num2str(N_total_number_correlation_collected)]);
                axis tight;
                temp=axis;
                temp(1)=0;
                temp(2)=temp_end;
                axis(temp);
                grid on;
                zoom on;
                
                output=(N_total_correlation_collected/N_total_number_correlation_collected)';
                time_fname='total_collected_correlation_5.xls';
%                 save(time_fname,'output','-ascii') ;
            end
            N_total_number_correlation=N_total_number_correlation+1;
            N_total_correlation=N_total_correlation+Ave_donor_cross_acceptor(1:temp_end);
            subplot(5,2,9)
            t=0:temp_end-1;
            plot(t,N_total_correlation/N_total_number_correlation,'-b','LineWidth',2);
            title(['Total Number of the Correlation traces is: ' num2str(N_total_number_correlation)]);
            axis tight;
            temp=axis;
            temp(1)=0;
            temp(2)=temp_end;
            axis(temp);
            grid on;
            zoom on;
            
            output=(N_total_correlation/N_total_number_correlation)';
            time_fname=['total_correlation.dat'];
            save(time_fname,'output','-ascii') ;
        else
            continue;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    frettable2=frettable';
    %save('fretstates.dat', 'frettable2', '-ascii');
end

figure (2);
subplot (3,1,1);
bar(xout,N_His);
title(['Total Number of Molecule is: ' num2str(N_total_number)]);
axis tight;
temp=axis;
temp(1)=-0.1;
temp(2)=1.1;
axis(temp);
grid on;
zoom on;

subplot(3,1,2)
t=0:temp_end-1;
plot(t,N_total_correlation/N_total_number_correlation,'-b','LineWidth',2);
title(['Total Number of the Correlation traces is: ' num2str(N_total_number_correlation)]);
axis tight;
temp=axis;
temp(1)=0;
temp(2)=temp_end;
axis(temp);
grid on;
zoom on;

subplot (3,1,3);
t=0:temp_end-1;
plot(t,N_total_correlation_collected/N_total_number_correlation_collected,'-b','LineWidth',2);
title(['Total Number of the Collected Correlation traces is: ' num2str(N_total_number_correlation_collected)]);
axis tight;
temp=axis;
temp(1)=0;
temp(2)=temp_end;
axis(temp);
grid on;
zoom on;
