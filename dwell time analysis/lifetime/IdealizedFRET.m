function IF = IealizedFRET(M)
% extract the first 20 data point of the idealized FRET traces

n = size(M, 1);
k =1;
j =1;
IF =[];
for i = 1:n
    if M(i, 1) == k
        IF (j:j+19, :)= M(i:i+19, :);
        k = k+1;
        j = j+20;
    end 
end
        
    