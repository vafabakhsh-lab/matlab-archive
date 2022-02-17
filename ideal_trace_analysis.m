% This program goes into the folder where selected traces are located and 
% reads the 5 column data. The 5 columns are time, donor, acceptor, fret
% and ideal fret. the 5 column data is created from vbFRET program and
% contains the PATH of ideal traces. 
% This program then plots the path files and you can decide to include it
% in the final transition density plot or no.
% s to include
clear;
clf;
close all;

leakage=0.09;
temp_end=40;
correction_factor=0;

path=input('where are the selected traces?  ');
% cd('D:\SSB SIP\08312010 68T8 SSB-C RecO Mg');
cd(path);
[FileName,PathName] = uigetfile('*.dat');
cd(PathName);

outputname=input('What is the name of outputfile?  ', 's');
A=dir
numberfiles=length(A);
maxcps=1500;
hdl1=gcf;
i=3;
timeunit=1;
h1=[];h2=[];
m=1;

%skip=input('if you want to skip to trace number X input the number now');
%if isempty(skip)
%   skip=2;
%else
%   i=skip;
%end

while (i<numberfiles)
      
    state=[];
    dwtime=[];
    
    A(i).name;
    if A(i).name(end-3:end)=='.dat';
        
        fname=A(i).name(1:end-4);
        disp(fname)
        fid=fopen(A(i).name,'r');
        dummy = fscanf(fid,'%g %g %g %g %g',[5 inf]);
        fclose(fid);
        dec=max(size(dummy));  
        
        time=dummy(1,:)*timeunit;
        donor=dummy(2,:);       
        acceptor=dummy(3,:);
        FRET=dummy(4,:);
        Ideal_FRET=dummy(5,:);
            
          %warning off MATLAB:divideByZero      
        raw_fret=acceptor./(acceptor+donor+(leakage.*donor));
        %raw_fret=dummy(2,:);
        ttl_count= acceptor+donor+500;                    %ttl_count = total intensity +500 
        
alldata=[donor acceptor];lowlim=min(alldata)-50;highlim=max(alldata)+50;
      cla(h1);cla(h2);  
        h1=subplot(3,2,[1,2,3,4]);
        plot(time,donor,'g',time,acceptor,'r' );       
           ylim([lowlim highlim]);
         title(['File:' fname '   Molecule:' int2str(j)]); 
        grid on; zoom on;
        
        h2=subplot(3,2,[5,6]);
 patchline(time,FRET,'edgecolor','b','edgealpha',0.5);hold on;plot(Ideal_FRET,'k')
         ylim([-0.05+min(FRET) 0.05+max(FRET)]);
        grid on; zoom on;
    linkaxes([h1,h2], 'x');  
    
        option=input ('Do you want to include this trace? (include= s) ' , 's');
        if option== 's'
            index_D=[];D_I_FRET=[];
            D_I_FRET=diff(Ideal_FRET);
            index_D=find(D_I_FRET~=0);
            if isempty(index_D)==1;index_D=[1];end
            for k=1:max(size(index_D))
                transition(m,1)=Ideal_FRET(index_D(k));
                transition(m,2)=Ideal_FRET(index_D(k)+1);
                m=m+1;
            end
%            h3=figure;plot(transition(:,1),transition(:,2),'*')
        else
            disp('skipped')
        end
    
       i=i+1; 

    end
end
figure;plot(transition(:,1),transition(:,2),'*');ylim([0 1]);xlim([0 1]);
hold on;plot((0:0.02:1),(0:0.02:1),'-r')

output=[transition(:,1) transition(:,2)];
fname=outputname;save(fname,'output','-ascii');
        
        
        
        
        