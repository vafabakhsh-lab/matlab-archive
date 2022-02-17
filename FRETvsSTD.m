

path=input('where are the selected traces?  ');
% cd('D:\SSB SIP\08312010 68T8 SSB-C RecO Mg');
cd(path);
[FileName,PathName] = uigetfile('*.dat');
cd(PathName);

A=dir;
numberfiles=length(A);
maxcps=1500;
hdl1=gcf;
i=2;
timeunit=1;
frettable=zeros(0,0);


leakage=0.09;

while (i<numberfiles)
    i=i+1;
 AVFRET=[];
 STDFRET=[];   
    A(i).name;
    if A(i).name(end-3:end)=='.dat';
  PR= isstrprop(A(i).name, 'digit');
  if PR(1)==1
        fname=A(i).name(1:end-4);
        fid=fopen(A(i).name,'r');
        dummy = fscanf(fid,'%g %g %g %g',[4 inf]);
        fclose(fid);
        dec=size(dummy);
        points = dec(2);
        inttime=dummy(1,2)-dummy(1,1);					%inttime = interval time 
        
        
        time=dummy(1,:)*timeunit;
        donor=dummy(2,:);       
        acceptor=dummy(3,:);
            
   
        raw_fret=acceptor./(acceptor+donor+(leakage.*donor));
        
        AVFRET=mean(raw_fret);
        STDFRET=std(raw_fret);
        plot(AVFRET,STDFRET,'*');hold on;
  end
    end
       fid = fopen(['FRETvsSTD.dat'],'a+');
       fprintf(fid, '%4.3f\t  %4.3f\n', AVFRET,STDFRET);
       fclose(fid);
end

    


