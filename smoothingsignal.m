 clear
%    dummy=load('D:\analysis\42\sample\1.dat');      
% timeunit=1;
% time=dummy(:,1)*timeunit;
% donor=dummy(:,2);       
% acceptor=dummy(:,3);
pth=input('Directory: ');
cd(pth);

fname=input('index # of filename [default=1]  ');
	if isempty(fname)
   	fname=1;
	end
fname=num2str(fname);
filename=[fname '.dat']
fid=fopen([fname '.dat'],'r');
dummy = fscanf(fid,'%g %g %g %g %g',[5 inf]); % based on 5 column data. change 5 to the number of your columns
fclose(fid);

% set time and signal from the data file.
time=dummy(1,:);
signal=dummy(4,:)-dummy(5,:);

length=max(size(signal));

% N, M and P are parameters for the filter. 
% I would keep p at 20 and play mostly with N and maybe M.
N=5;
M=3;
p=20;
lower_bound=max(M,N+1);
% f=zeros((length-M-2*N),1);
% b=zeros((length-M-2*N),1);

for i = lower_bound:length-N;
    I_f(i)=(1/N)*sum(signal((i-N):i-1));
    I_b(i)=(1/N)*sum(signal(i+1:i+N));
            
end

I_f = I_f'; I_b = I_b';

for i = lower_bound:length-M-N+1;
f(i)=0;b(i)=0;
    for j=0:M-1;
        f(i)= f(i) + (signal(i-j)-I_f(i-j))^2;
        b(i)= b(i) + (signal(i+j)-I_b(i+j))^2;             
    end
    f(i)= f(i)^(-p); b(i)= b(i)^(-p);
    C=1/(f(i)+b(i));
    f(i)=C*f(i);
    b(i)=C*b(i);
end

f=f'; b=b';

range=max(size(f));
I_filter=f(1:range).* I_f(1:range) + b(1:range).*I_b(1:range);

%%% in MATLAB you cannot change the transparancy of plots. I use patchline
%%% function do do this. You can just use PLOT
patchline(time,signal,'edgecolor','r','edgealpha',0.4);hold on;
patchline(time(1:range),I_filter(1:range),'edgecolor','k','edgealpha',1)
grid on; zoom on;
Adata=[time signal'];
Afiltered=[time(1:range) I_filter(1:range)];
% I_filter=





