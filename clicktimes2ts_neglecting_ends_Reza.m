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
      dummy = fscanf(fid,'%g %g %g',[3 inf]);
      fclose(fid);
      dec=size(dummy);
      points = dec(2);
      inttime=0.03;					%inttime = interval time

%% reading variables from a file and calculating a high and low level estimates for FRET
      
      time=dummy(1,:);  
      donor=dummy(2,:);         
      acceptor=dummy(3,:);    
      
      raw_fret=acceptor./(acceptor+1.09*donor);
      sort_fret=sort(raw_fret,'descend'); 
      
      high_level=mean(sort_fret(10:30))
      low_level=mean(sort_fret(end-30:end-10))
           
  
      ttl_count= acceptor+donor+300; %% why plus 300?************************
      	
 
     
      %First figure, first subplot
      maxcps = max(acceptor)+200;
      figure(hdl1);
      subplot(2,1,1);
      plot(time,raw_fret,'b');
      title([ 'Molecule:' int2str(i-2) '  file:' A(i).name]);
      axis([time(1) time(end) -0.02 1.02]);
      grid on;
      zoom on;
      
      %First figure, second subplot

        
         disp('Please select cutoff from the trace')
         [Xb,Yb] = ginput(1);
         low = Yb(1)
         
         
         
         counter = 0;    
         
%          divisions = floor(points/frames)+1;
%          st_point=floor(dummy(1,1)/inttime);
         
%          for j=1:divisions
            
%             start= st_point+(j-1)*frames;
                                             
%                for p= 1+(j-1)*frames : j*frames  
ideal_state=[];
idealized=[];
             for p=1:points;     
						
                  %if ttl_count(p)/int_ave > 2.5 
                  %   ideal_state(p)= -0.1;
                  %   p=p+1;
                  %elseif ttl_count(p)/int_ave < 0.25
                  %   ideal_state(p)= -0.1;
                  %   p=p+1;
						%end
                  %% if the total intensity changes too much, assign a value of -0.1
                                       
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
               
               size(time)
               size(raw_fret)
               size(idealized)

               hdl1=gcf; 
               figure(hdl1);
               subplot(2,1,2);
               %plot(time,donor,'g',time,acceptor,'r',time, ttl_count,'m',time,int_av_array,'b.');
               plot(time(1:leng),raw_fret(1:leng),'r',time(1:leng),idealized,'b.:');

            	title([ 'Molecule:' int2str(i-2) '  file:' A(i).name]);
      axis([time(1) time(end) -0.05 1.05]);
      grid on;
      zoom on;
            
           	 	%First figure, second subplot

                                         
          
                        
            % Manual re-assignment of states (if necessary)
%             manual = input('Would you like to make changes? Press (y)','s');
%             
%             while manual == 'y'
%                disp('Click on the sections you want to change');
%                [Xm,Ym,buttonm]=ginput;
%                num_manual=size(Xm);
%                for h=1:num_manual(1)
%                   center= floor((Xm(h)-dummy(1,1))/0.1)+1;
%                   old_id_state= ideal_state(center);
%                   if Ym(h)>=0.6
%                      Ym(h) = 0.8;
%                   end
%                   if Ym(h)<0.6
%                      Ym(h) = 0.35;
%                   end
%                                      
%                   e= center;
%                   while old_id_state== ideal_state(e)
%                      e=e-1;
%                   end
%                   
%                   e=e+1;
%                   while old_id_state== ideal_state(e)
%                      ideal_state(e) = Ym(h);
%                      e=e+1;
%                   end
%                end %for i=1:num_manual
%                
%                idealized= ideal_state*int_ave + 100;
% 
%                hdl1=gcf; 
%                figure(hdl1);
%                subplot(2,1,1);
%                %plot(time,donor,'g',time,acceptor,'r',time, ttl_count,'m',time,int_av_array,'b.');
%                plot(time,donor,'g',time,acceptor,'r',time,idealized,'b.:');
% 
%             	title([ 'Molecule:' int2str(i-2) '  file:' A(i).name]);
%             	axis([(st_point+(j-1)*frames)*inttime (st_point+4+j*frames)*inttime -20 maxcps]);
%             	grid on;
%             	zoom on;
%             
%            	 	%First figure, second subplot
%             	subplot(2,1,2);
%             	plot(time,original_fret,'c:',time,raw_fret,'bx-', time, ideal_state,'r', time, low_array, 'g.');
%                axis([(st_point+(j-1)*frames)*inttime (st_point+4+j*frames)*inttime 0 1]);
%                text((st_point+(j-1)*frames)*inttime,low, num2str(low));
%             	grid on;
%                zoom on;
%                
%                manual = input('Happy about the changes? Press y to repeat','s');
%                
%                if isempty(manual)
%                   break;
%                end
%                
% 				end %while manual == 'y'
            
          raw_fret;  
            
%          end %for loop for j
         
         %Creating the idealized state plot
         %redisplays unzoomed trace
                        
         %First figure, first subplot
%          figure(hdl1);
%          subplot(2,1,1);
%          plot(time,donor,'g',time,acceptor,'r',time,ttl_count,'m',time,idealized,'b.:');
%          title([ 'Molecule:' int2str(i-2) '  file:' A(i).name]);
%          axis([time(1) time(end) -20 maxcps]);
%          grid on;
%          zoom on;
%          
%          %First figure, second subplot
%          subplot(2,1,2);
%          plot(time,original_fret,'c.',time,raw_fret,'b', time, ideal_state, 'm');
%          axis([time(1) time(end) 0 1]);
%          grid on;
%          zoom on;
           
         happy=input('Enter to accept, "n" to deny and proceed, "b" to deny and go back','s');
         
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
            dwtime_HighFRET= []
            dwtime_LowFRET=[]
            state_HighFRET=[]
            state_LowFRET=[]
            
            beginning=1;    % in order to exclude the beginning state dwell time (Hajin)
            for b=2:points-1
               if state_int~=ideal_state(b)
                  if beginning==0
                    dtime= time(b)- time_int;
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
            Dist_state= [time(1:leng)' donor(1:leng)' ideal_state(1:leng)'];
            
            fname3_HighFRET=['time\' 'HighFRET' fname '.dat'];
            save(fname3_HighFRET, 'Dwell_times_HighFRET', '-ascii');
            fname3_LowFRET=['time\' 'LowFRET' fname '.dat'];
            save(fname3_LowFRET, 'Dwell_times_LowFRET', '-ascii');

            
            fname4=['dist\' fname 'st.dat'];
            save(fname4, 'Dist_state', '-ascii');
            
        	end
      end
%    end %if .dat
  end
  %while
