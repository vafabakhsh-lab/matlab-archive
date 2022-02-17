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
  

d1 = load(['gfpfilm' fname '.pks']);
d2 = load (['cherryfilm' fname '.pks']);

len1 = length (d1);
len2 = length (d2);
str = ['Number of gfp = ' num2str(len1)];disp(str)
str = ['Number of cherry = ' num2str(len2)];disp(str)
   
    overlap = 0;
    for i = 1:len1
       for j = 1:len2
          if abs(d1(i, 6) - d2 (j, 6)) <= 0.5
             if abs(d1(i, 8) - d2(j, 8)) <= 0.5
                 overlap = overlap+1;
             end
             
          end
       end
    end
 disp(['overlap0= ' num2str(overlap)])
      
    overlap1 = 0;
       for i = 1:len1
       for j = 1:len2
          if abs(d1(i, 6) - d2 (j, 6)) <= 1.0
             if abs(d1(i, 8) - d2(j, 8)) <= 1.0
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
           if abs(d1(i, 6) - d2 (j, 6)) <= 1.5
             if abs(d1(i, 8) - d2(j, 8)) <= 1.5
                 overlap1p5 = overlap1p5+1;
             end
          end
       end
       end
disp(['overlap1.5= ' num2str(overlap1p5)])
    
    
       overlap2 = 0;
       for i = 1:len1
       for j = 1:len2
          if abs(d1(i, 6) - d2 (j, 6)) <= 2.0
             if abs(d1(i, 8) - d2(j, 8)) <= 2.0
                 overlap2 = overlap2+1;
             end
             
          end
       end
    end
disp(['overlap2= ' num2str(overlap2)])
    
       overlap3 = 0;
       for i = 1:len1
       for j = 1:len2
          if abs(d1(i, 6) - d2 (j, 6)) <= 3.0
             if abs(d1(i, 8) - d2(j, 8)) <= 3.0
                 overlap3 = overlap3+1;
             end             
          end
       end
    end
disp(['overlap3= ' num2str(overlap3)])
    
       overlap5 = 0;
       for i = 1:len1
       for j = 1:len2
           if abs(d1(i, 6) - d2 (j, 6)) <= 5.0
                 if abs(d1(i, 8) - d2(j, 8)) <= 5.0
                 overlap5 = overlap5+1;
             end
             
          end
       end
    end    
disp(['overlap5= ' num2str(overlap5)])
    
    
        
       overlap10 = 0;
       for i = 1:len1
       for j = 1:len2
          if abs(d1(i, 6) - d2 (j, 6)) <= 10.0
             if abs(d1(i, 8) - d2(j, 8)) <= 10.0
                 overlap10 = overlap10+1;
             end
             
          end
       end
    end
disp(['overlap10= ' num2str(overlap10)])
    
    
       new_overlap2 = 0;
       mol2 = 0;
       for i = 1:len1
       if d1 (i, 6) > 50 && d1 (i, 6) < 200 && d1 (i, 8) > 150 && d1 (i, 8) < 350
              mol2 = mol2 + 1;
              for j = 1:len2
           if abs(d1(i, 6) - d2 (j, 6)) <= 1.5
             if abs(d1(i, 8) - d2(j, 8)) <= 1.5
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
generalcoloc=100*overlap1p5/(len2+len1-overlap1p5);
totalProtein = len1+len2-overlap1p5;
fractionGFP = len1/totalProtein;
fractionCherry = len2/totalProtein;

% the 0.8 in the theoretical max is the assumption that the maturation rate
% for each FP is 0.8 - which may not be the case
% theoreticalMax=100*[(MaturationRateA*FractionA)*(MaturationRateB*FractionB)]
theoreticalMax=100*[(0.8*fractionGFP)*(0.8*fractionCherry)];
% Maturation rate/fraction taken from Nature Methods paper
natureMax=100*[(0.65*fractionGFP)*(0.43*fractionCherry)];


disp(['Cy3 colocalization (@1.5pixel) = ' num2str(cy3coloc) '%'])
disp(['Cy5 colocalization (@1.5pixel) = ' num2str(cy5coloc) '%'])
disp(['General Colocalization (@1.5pixel) = ' num2str(generalcoloc) '%'])
disp(['Theoretical Colocalization Max (@1.5pixel) = ' num2str(theoreticalMax) '%'])
disp(['NatureMethods Theoretical Colocalization Max (@1.5pixel) = ' num2str(natureMax) '%'])

end
    
    
