
path=input('where are the selected traces?  ', 's');
cd(path);
[FileName,PathName] = uigetfile('*.dat');
cd(PathName);

A=dir('*tr*.dat')
numberfiles=length(A)
nm=3;
FRETdata=[];
Z=[];
deltaFRET=[];
temp_deltaFRET=[];
step=0.05;
gap = -0.2:step:1.2; % bin size, same role as the one in the histogram/smoothing script
                % From 0 to 1 by step size 0.05

while (nm<numberfiles)
        nm=nm+1;
        A(nm).name;
        fname=A(nm).name(1:end-4);
        fid=fopen(A(nm).name,'r');
        dummy = fscanf(fid,'%g %g %g %g %g %g',[6 inf]);
        fclose(fid);
        
        time=dummy(1,:)';
        donor=dummy(2,:)';       
        acceptor=dummy(3,:)';
        
        FRET=acceptor./(1.1*donor+acceptor);
        temp_deltaFRET = diff(FRET);
        if max(size(FRET))> 200;
             FRETdata=[FRETdata ,FRET(1:200) ];
             deltaFRET = [deltaFRET; temp_deltaFRET(1:200)];
        end
%         out=[donor acceptor];
%         save([pathput '\' fname],'out','-ascii') ;
end
FRETdata=FRETdata';
for i=1:100
        n_f=[];
        [n_f,x]=hist(FRETdata(:,i),gap);
        Z=[Z;n_f];
        
end
ind=find (deltaFRET>-0.5 & deltaFRET<0.5);
hisdeltaFRET=deltaFRET(ind);
hist_graph = hist(ind,100);
figure;contourf(Z',8);

fclose('all');