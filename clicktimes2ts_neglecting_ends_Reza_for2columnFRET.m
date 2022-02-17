%modified by Hajin from clicktimes2ts to neglect the end states (beginning and final states).
%modified by Rahul from clicktimes1p4 (borrowed from Michelle)
% The whole trace is divided into divisions for better analysis.
% Unlike in version 1.5, this one has been modified to calculate three different states. Where you click on the trace
% defines the time as well as the state of the molecule.

% The final output is spit out in a '\time' folder as a column of residence times and the corresponding state (0 for low and 1 for High)
% The first and the last times (in the output) can be ignored as they represent times before first transition and after final transition resp.
% If the total intensity of the molecule varies too much beyond the average value, that time interval is assigned a value of -0.1 01/09/05
% Adjacent averaging introduced for fret trace

% From Clicktimes1pt(cleaned of bugs for single pt transitions), fret cutoffs defined for each trace by clicking on the whole trace
% Manual redefining of states after initial approximation introduced

% Modified on 14March 2005, to look at two state RNA jxns\

%Modified on 2Aug 2005 for SSB data 

%Modified further for RecA Encapsulation, then DNA -annealing/melting-Encapsulation

function clicktimes2ts_ic

pth=input('Directory [default=C:\]  ');
	if isempty(pth)
   	pth='C:\';
	end
cd(pth);

A=dir;
numberfiles=length(A)
intensity_ave=[200];
maxcps=1000;
hdl1=gcf;
inc=1;
i=2;


mkdir('dist');
mkdir('time');

%disp('the number of good molecules was roughly (-2-number of folders in directory):');
skip=input('If you want to skip to trace number X input the number now');
if isempty(skip)
   skip=2;
else
   i=skip;
end

while (i<=numberfiles)
    
   i=i+inc;
   inc=1;
   state=[];
	dwtime=[];

   A(i).name;
  if A(i).name(end-3:end)== '.dat';
  %    if A(i).name(end-3:end)=='.doc';
      
      fname=A(i).name(1:end-4)
      fid=fopen(A(i).name,'r');
      dummy = fscanf(fid,'%g %g ',[2 inf]);
      fclose(fid);
      dec=size(dummy);
      points = dec(2);
      timeunit=1;					%inttime = interval time


      
      time=timeunit*(1:points)';  
      donor=dummy(1,:);         
      acceptor=dummy(2,:);    
      
      raw_fret=acceptor./(acceptor+1.1*donor);
      sort_fret=sort(raw_fret,'descend'); 
      

      
%       high_level=mean(sort_fret(10:30))
%       low_level=mean(sort_fret(end-20:end-10))
      
      
      ttl_count= acceptor+donor+300; % why plus 300?************************    	

      %First figure, first subplot
   maxcps = max(acceptor+donor)+50;
      figure(hdl1);
      
      h12=subplot(4,2,[1,2]);
      plot(time,donor,'g',time, acceptor,'r');
      axis([time(1) time(end) -10 maxcps]);
      grid on;
      zoom on;    
      
      h13=subplot(4,2,[3,4,5,6]);
      plot(time,raw_fret,'b');
      title([ 'Molecule:' int2str(i-2) '  file:' A(i).name]);
      axis([time(1) time(end) mean(sort_fret(end-30:end-10))-0.05 mean(sort_fret(10:30))+0.1]);
      grid on;
      zoom on;
linkaxes([h12,h13], 'x');

      subplot(4,2,7);
      hist(raw_fret,20);
      grid on;
      zoom on;
      
  inq = input('Do you want to work on this trace?  ','s')  
  if isempty(inq)
          disp('Please select LOW cutoff from the trace (2 clicks) ') 
         [Xl,Yl] = ginput(2);
         Xl(1)=round((Xl(1)-time(1))/timeunit);
         Xl(2)=round((Xl(2)-time(1))/timeunit);
         raw_fret(Xl(1):Xl(2));
         low_level=mean(raw_fret(Xl(1):Xl(2)));
         counter = 0;    
    
     disp('Please select HIGH cutoff from the trace (2 clicks) ') 
         [Xh,Yh] = ginput(2);
         Xh(1)=round((Xh(1)-time(1))/timeunit);
         Xh(2)=round((Xh(2)-time(1))/timeunit);
         high_level=mean(raw_fret(Xh(1):Xh(2)));
         counter = 0;    
       
      
        disp('Please select cutoff from the trace')
        [Xb,Yb] = ginput(1);
        low = Yb(1)
        counter = 0;    
         
         
%          disp('Please select cutoff from the trace')
%          [Xb,Yb] = ginput(2);
%          Xb(1)=round(Xb(1)/timeunit);
%          Xb(2)=round(Xb(2)/timeunit);
%          low=mean(donor(Xb(1):Xb(2)))
%          counter = 0;    

ideal_state=[];
idealized=[];
             for p=1:points;                                       
                  if p>=points
                     break;
                  end                  
         			if raw_fret(p)>= low
            			ideal_state(p) = high_level;
            		else ideal_state(p) = low_level;
            
                  end % if

                 end %for p
               
               idealized= ideal_state;
               sz=size(idealized);leng=sz(2);
               
               size(time);
               size(acceptor);
               size(idealized);
               
               hdl1=gcf; 
               figure(hdl1);
               subplot(2,1,2);
               %plot(time,donor,'g',time,acceptor,'r',time, ttl_count,'m',time,int_av_array,'b.');
         figure;
       h1= subplot(2,1,1);
      plot(time,donor,'g',time, acceptor,'r');
      axis([time(1) time(end) -10 maxcps]);
      grid on;
      zoom on; 
      
      
         h2=subplot(2,1,2)
         plot(time(1:leng),raw_fret(1:leng),'r',time(1:leng),idealized,'b.:');
                	title([ 'Molecule:' int2str(i-2) '  file:' A(i).name]);
      axis([time(1) time(end) -0.02 mean(sort_fret(10:30))+0.1]);
      grid on;
      zoom on;
linkaxes([h1,h2], 'x');
           
         happy=input('Enter to accept, "n" to deny and proceed, "b" to deny and go back   ','s');
         
         if isempty(happy)
            happy='y';
         end
         
         if happy== 'b'
            inc=-1;
            first='skip';
         end
         
         if happy== 'y'
            
            state_int=ideal_state(1);
            time_int=time(1);
            dwtime_HighFRET=[];
            dwtime_LowFRET=[];
            state_HighFRET=[];
            state_LowFRET=[];
            
         disp('select a range you want to save ') 
         [Xr,Yr] = ginput(2)          
         Xr(1)=round((Xr(1)-time(1))/timeunit);
         Xr(2)=round((Xr(2)-time(1))/timeunit);   

            
            beginning=1;    % in order to exclude the beginning state dwell time (Hajin)
            for b=Xr(1): Xr(2);
               if state_int~=ideal_state(b)
                  if beginning==0
                    dtime= time(b)- time_int-timeunit;
                    if ideal_state(b)==high_level
                        dwtime_LowFRET= [dwtime_LowFRET; dtime];% Modified on 03/27/07 from HighFRET to lowFRET
                        state_LowFRET= [state_LowFRET; state_int];
               	    else dwtime_HighFRET= [dwtime_HighFRET; dtime]; state_HighFRET= [state_HighFRET; state_int];
                    end
                    time_int=time(b);
                    state_int=ideal_state(b);
                  else
                    time_int=time(b);     % change state without saving the beginning state dwell time (Hajin)
                    state_int=ideal_state(b);
                  end                  
                  beginning=0;
               end 
            end
               
         
            Dwell_times_HighFRET= [dwtime_HighFRET state];
            Dwell_times_LowFRET= [dwtime_LowFRET state];
%             Dist_state= [time(1:leng)' donor(1:leng)' ideal_state(1:leng)'];
            
            fname3_HighFRET=['time\' 'HighFRET' fname '.dat'];
            save(fname3_HighFRET, 'Dwell_times_HighFRET', '-ascii');
            fname3_LowFRET=['time\' 'LowFRET' fname '.dat'];
            save(fname3_LowFRET, 'Dwell_times_LowFRET', '-ascii');
         end
         
        	end

      
  if inq == 'm',
          disp('select a range you want to save ') 
         [Xman,Yan] = ginput(2)          
         Xman(1)=round((Xman(1)-time(1))/timeunit);
         Xman(2)=round((Xman(2)-time(1))/timeunit);    
         Dwell_times_LowFRET= [(Xman(2)-Xman(1))*timeunit state];
%             Dist_state= [time(1:leng)' donor(1:leng)' ideal_state(1:leng)'];
            
            fname3_LowFRET=['time\' 'LowFRET' fname '.dat'];
            save(fname3_LowFRET, 'Dwell_times_LowFRET', '-ascii');  
         end
if inq=='n'
    display('passed')
end
  end
end
  %while
%   
