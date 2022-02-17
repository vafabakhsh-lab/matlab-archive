%this program is to 
clear;
clf;
close all;
warning('off','all');

leakage=0.09;
temp_end=40;
correction_factor=0;
time_five=zeros(0,0);
acceptor_five=zeros(0,0);
donor_five=zeros(0,0);
FRET_five=zeros(0,0);
raw_fret_His=zeros(0,0);
FRET_five_His=zeros(0,0);
frets_all=[];


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
gap=0:0.02:1;

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
        dummy = fscanf(fid,'%g %g %g  %g ',[4 inf]);
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
            
          %warning off MATLAB:divideByZero      
        raw_fret=acceptor./(acceptor+donor+(leakage.*donor));
        %raw_fret=dummy(2,:);
        ttl_count= acceptor+donor+500;                    %ttl_count = total intensity +500 
        ave_count=(acceptor + donor)/2;	                 %ave_count= average intensity
        
alldata=[donor acceptor];lowlim=min(alldata)-50;highlim=max(alldata)+250;
  
if  length(time)>60

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
%%%%%%%%%%%%%%%%%slider line %%%%%%%%%%%%%%%        
        slider_step=59*timeunit;
        slider_gap= (max(time)-min(time))/slider_step
       hs1=uicontrol('style','slider','Min',min(time),'Max',max(time)-slider_step,'SliderStep',[1 1]./slider_gap,'Value',1,'Position',[200 20 200 20]);
set(hs1,'Callback',@(hObject,eventdata) xlim([get(hObject,'Value') get(hObject,'Value')+slider_step])  )
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
selection= input('click to record the transition? ','s');
while selection=='m'

       zoom on;
     [x1,y1] = ginput(1);
     point=round((x1-time(1))/timeunit)+1;
     starx=time(point);
     stary=raw_fret(point);
     hold on;plot(starx ,stary,'*r')
    answ= input('Proceed? ','s');
        if answ =='n'
            selection= input('click to record the transition? ','s');   
         else 
            frets=raw_fret(1,point-10:point+10);
            frets_all=[frets_all ;frets];
        end
        selection= input('click to record the transition? ','s');
end
hold off;
fname=['transition.dat'];
save(fname,'frets_all','-ascii') ;

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
        
end
        
gp=0:0.02:1;
Z=[];for i=1:21
        n_f=[];
        [n_f,x]=hist(frets_all(:,i),gp);
        Z=[Z;n_f];
end
 contourf(Z',3);
 
 set(gca, 'YTick', 0:10:51);
set(gca, 'YTickLabel', [ 0:0.2:1 ] );

% what i used for final graph is "transition1old" which is th eoriginal
% analysis with 1uM data.
% But transition1=[transition1old;t28] works too.
%
        