path=input('where are the selected traces?  ');
cd(path);
[FileName,PathName] = uigetfile('*.dat');
cd(PathName);

pathput=input('where to save output traces?  ');

A=dir
numberfiles=length(A)
nm=3;

while (nm<numberfiles)
        nm=nm+1;
%         A(nm).name;
        fname=A(nm).name(end-9:end-4);
%         disp(fname);
        if fname=='report'
            A(nm).name;
      %             save([pathput '\' A(nm).name '.dat'],'raw_out','-ascii');
            copyfile(A(nm).name,pathput);
        end
end
