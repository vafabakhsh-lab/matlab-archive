% clear;
path=input('where are the selected traces?  ');
cd(path);
[FileName,PathName] = uigetfile('*.dat');
cd(PathName);

A=dir
numberfiles=length(A)
nm=3;
i=1;

while (nm<numberfiles)
        nm=nm+1;
%         A(nm).name;
        fname=A(nm).name;
        fid=fopen(fname,'r');
        dummy = fscanf(fid,'%g %g %g %g %g',[5 inf]);
        fclose(fid);
             
        idFRET=dummy(5,:)';
        states=sort(unique(idFRET))
        if max(size(states))==2;
            transition(i,1)=states(1);
            transition(i,2)=states(2);
            i=i+1;
        end
        if max(size(states))==1;
            transition(i,1)=states(1);
            transition(i,2)=states(1);
            i=i+1;
        end
%         if max(size(states))==3;
%             transition(i,1)=states(1);
%             transition(i,2)=states(2);
%             i=i+1;
%             transition(i,1)=states(1);
%             transition(i,2)=states(3);
%             i=i+1;
%             transition(i,2)=states(1);
%             transition(i,3)=states(3);
%             i=i+1;
%         end
end

fclose('all');