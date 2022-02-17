% Given the .pks files for 2 channels, calulating the percentage overlap
% For same channel

clear all
close all;
fclose('all');

% read data
pth=input('Directory [default=C:\\User\\tir data\\yyyy\\New Folder]  ');
	if isempty(pth)
   	pth='C:\User\tir data\yyyy\New Folder';
	end
cd(pth);
ann=input ('more? ');
while ann==0
    
% read data
fname=input('index # of  file [default=1] '); 

   
% disp('ankur1');
   
  fname=num2str(fname);
  

d1 = load(['film' fname 'cy3.pks']);
d2 = load (['film' fname 'cy5.pks']);

len1 = length (d1);
len2 = length (d2);
str = ['Number of Cy3 = ' num2str(len1)];disp(str)
str = ['Number of Cy5 = ' num2str(len2)];disp(str)
   
    overlap = 0;
    for i = 1:len1
       for j = 1:len2
          if abs(d1(i, 1) - d2 (j, 1)) <= 0.5
             if abs(d1(i, 3) - d2(j, 3)) <= 0.5
                 overlap = overlap+1;
             end
             
          end
       end
    end
 disp(['overlap0= ' num2str(overlap)])
      
    overlap1 = 0;
       for i = 1:len1
       for j = 1:len2
          if abs(d1(i, 1) - d2 (j, 1)) <= 1.0
             if abs(d1(i, 3) - d2(j, 3)) <= 1.0
                 overlap1 = overlap1+1;
             end
          end
       end
    end
disp(['overlap1= ' num2str(overlap1)])
    
    
       overlap1p5 = 0;
       mol = 0;
       for i = 1:len1
         for j = 1:len2
           if abs(d1(i, 1) - d2 (j, 1)) <= 1.5
             if abs(d1(i, 3) - d2(j, 3)) <= 1.5
                 overlap1p5 = overlap1p5+1;
             end
          end
       end
       end
disp(['overlap1.5= ' num2str(overlap1p5)])
    
    
       overlap2 = 0;
       for i = 1:len1
       for j = 1:len2
          if abs(d1(i, 1) - d2 (j, 1)) <= 2.0
             if abs(d1(i, 3) - d2(j, 3)) <= 2.0
                 overlap2 = overlap2+1;
             end
             
          end
       end
    end
disp(['overlap2= ' num2str(overlap2)])
    
       overlap3 = 0;
       for i = 1:len1
       for j = 1:len2
          if abs(d1(i, 1) - d2 (j, 1)) <= 3.0
             if abs(d1(i, 3) - d2(j, 3)) <= 3.0
                 overlap3 = overlap3+1;
             end             
          end
       end
    end
disp(['overlap3= ' num2str(overlap3)])
    
       overlap5 = 0;
       for i = 1:len1
       for j = 1:len2
           if abs(d1(i, 1) - d2 (j, 1)) <= 5.0
                 if abs(d1(i, 3) - d2(j, 3)) <= 5.0
                 overlap5 = overlap5+1;
             end
             
          end
       end
    end    
disp(['overlap5= ' num2str(overlap5)])
    
    
        
       overlap10 = 0;
       for i = 1:len1
       for j = 1:len2
          if abs(d1(i, 1) - d2 (j, 1)) <= 10.0
             if abs(d1(i, 3) - d2(j, 3)) <= 10.0
                 overlap10 = overlap10+1;
             end
             
          end
       end
    end
disp(['overlap10= ' num2str(overlap10)])
    
    
       new_overlap2 = 0;
       mol2 = 0;
       for i = 1:len1
       if d1 (i, 1) > 50 && d1 (i, 1) < 200 && d1 (i, 3) > 150 && d1 (i, 3) < 350
              mol2 = mol2 + 1;
              for j = 1:len2
           if abs(d1(i, 1) - d2 (j, 1)) <= 1.5
             if abs(d1(i, 3) - d2(j, 3)) <= 1.5
                 new_overlap2 = new_overlap2+1;
             end
          end
       end
       end
       end
disp(['new overlap= ' num2str(new_overlap2)])
disp(['mol2= ' num2str(mol2)])

cy3coloc=100*overlap1p5/len1;
cy5coloc=100*overlap1p5/len2;

disp(['Cy3 colocalization (@1.5pixel) = ' num2str(cy3coloc) '%'])
disp(['Cy5 colocalization (@1.5pixel) = ' num2str(cy5coloc) '%'])

end
    
    
