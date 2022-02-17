% cross-correlation calculation from selected traces. Each trace is in a
% single .dat file with 3 columns: time, donor, acceptor. All the trace
% files are in a seperate folder with nothing else in there.
%
% The parameters you have to manually update are  1) the time resolution 
% 2) Range of cross-correlation the range you want to calculate
% the X-correlation.

clear

path=input('where are the selected traces?  ');
cd(path);
[FileName,PathName] = uigetfile('*.dat');
cd(PathName);


timeunit=0.1; % time resolution, default is 100ms
% Over how many data points you want to calculate the X-correlation?
% I usually use 2-3 seconds at least.
temp_end=60; % this is 6 seconds for 100 ms data


h1=[];h2=[];h3=[];h4=[];h5=[];
N_total_XC=zeros(1,temp_end);
N_total_XC_old=zeros(1,temp_end);

XC_counter=0;
cr=[];u=1;

A=dir
numberfiles=length(A)
nm=2;
while (nm<numberfiles-0)
            nm=nm+1;
        A(nm).name;
        fname=A(nm).name(1:end-4);
        disp(fname)
        fid=fopen(A(nm).name,'r');
        dummy = fscanf(fid,'%g %g %g',[3 inf]);
        fclose(fid);
        dec=size(dummy);
        points = dec(2);
        
        time=dummy(1,:)';
        donor=+dummy(2,:)';       
        acceptor=+dummy(3,:)';

%%%%%%%%%%%%%%% CORRELATION  %%%%%%%%%%%%%%%%
Ave_donor=mean(donor);        
Ave_acceptor=mean(acceptor);      
std_donor=std(donor);         
std_acceptor=std(acceptor);   
delta_donor=donor-Ave_donor;  
delta_acceptor=acceptor-Ave_acceptor; 
range=max(size(donor))-5;

d_X_a=zeros(1,range+1);

if range > temp_end;
    for tau=0:range,
    normalize_number=0;
    sum_tau=0;
        for t=1:range-tau,
            sum_tau=sum_tau+(delta_donor(t)*delta_acceptor(t+tau));
            normalize_number=normalize_number+1;
         end
    if normalize_number==0
           d_X_a(tau+1)=NaN;
    else        
            d_X_a_old(tau+1)=sum_tau/(normalize_number)/std_donor/std_acceptor;;
            d_X_a(tau+1)=sum_tau/(normalize_number)/(Ave_donor+Ave_acceptor);

     end
end
N_total_XC=N_total_XC + d_X_a(1:temp_end);
N_total_XC_old=N_total_XC_old + d_X_a_old(1:temp_end);
XC_counter=XC_counter+1;

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
%%%%%        TIME                     new_normalization             old normalization                
output=[timeunit*(0:temp_end-1)' (N_total_XC/XC_counter)' (N_total_XC_old/XC_counter)'];
time_fname=['total_XC.dat'];
save(time_fname,'output','-ascii') ;

% New normalization:  (Ave_donor+Ave_acceptor)
% old normalization: (std_donor*std_acceptor)
% some people also use (Ave_donor*Ave_acceptor) as the normalization factor

