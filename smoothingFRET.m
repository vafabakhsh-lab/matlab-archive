% clear
%    dummy=load('D:\analysis\42\sample\1.dat');      
% timeunit=1;
% time=dummy(:,1)*timeunit;
% donor=dummy(:,2);       
% acceptor=dummy(:,3);

clear
donor=ones(200,1)+0.1*rand(200,1);donor (50:52,1)=0.4;
acceptor=2*ones(200,1)+0.1*rand(200,1);

length=max(size(donor));

N=5;
M=5;
p=20;
lower_bound=max(M,N+1);
% f=zeros((length-M-2*N),1);
% b=zeros((length-M-2*N),1);

for i = lower_bound:length-N;
    I_f_don(i)=(1/N)*sum(donor((i-N):i-1));
    I_b_don(i)=(1/N)*sum(donor(i+1:i+N));
    
    I_f_acc(i)=(1/N)*sum(acceptor((i-N):i-1));
    I_b_acc(i)=(1/N)*sum(acceptor(i+1:i+N));
        
end

I_f_don = I_f_don'; I_b_don = I_b_don';
I_f_acc = I_f_acc'; I_b_acc = I_b_acc';

for i = lower_bound:length-M-N+1;
i;
f(i)=0;b(i)=0;

    for j=0:M-1;
        j;
        f(i)=f(i)+((donor(i-j)-I_f_don(i-j))^2+(acceptor(i-j)-I_f_acc(i-j))^2);
        b(i)=b(i)+((donor(i+j)-I_b_don(i+j))^2+(acceptor(i+j)-I_b_acc(i+j))^2);             
    end
    f(i)=f(i)^(-p);b(i)=b(i)^(-p);C=1/(f(i)+b(i));
    f(i)=C*f(i);
    b(i)=C*b(i);
end

f=f'; b=b';

range=max(size(f));
I_d_filter=f(1:range).* I_f_don(1:range) + b(1:range).*I_b_don(1:range);
I_a_filter=f(1:range).* I_f_acc(1:range) + b(1:range).*I_b_acc(1:range);

subplot(2,1,1)
plot(donor,'g');hold on;plot(I_d_filter(1:range));hold on;
plot(acceptor,'r');hold on;plot(I_a_filter(1:range),'k')

FRET_filter=I_a_filter./(I_a_filter+I_d_filter);
fret=acceptor./(acceptor+donor);

subplot(2,1,2)
plot(fret);hold on;plot(FRET_filter,'k');hold on;plot(smooth(fret,5),'r');




% I_filter=





