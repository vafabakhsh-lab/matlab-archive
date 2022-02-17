% Given the .pks files for 2 channels, calulating the percentage overlap
% For same channel

clear all
close all;
fclose('all');
dataOutput={'Heterodimerization','Pixel_Tolerance','Proteins','TheoreticalMax','NatureMax','MovieNumber','GFP_Colocalization','Cherry_Colocalization','GFP_Particles','Cherry_Particles','Total_Particles','Scrambled','Channel'};
% read data
pth=input('Directory [default=C:\\User\\tir data\\yyyy\\New Folder]  ');
	if isempty(pth)
   	pth='C:\User\tir data\yyyy\New Folder';
	end
cd(pth);
proteins=input('What proteins are being colocalized? '); 
ScrambledStatus=input('Are the movies Scrambled or Unscrambled?: (Answer Scrambled or Unscrambled)   ');
ann=input ('more? ');
while ann==0
   
% read data
fname=input('index # of  file [default=1] '); 
movieNumber = fname;
   
% disp('ankur1');
   
  fname=num2str(fname);
  

d1 = load(['gfpfilm' fname '.pks']);
d2 = load (['cherryfilm' fname '.pks']);

len1 = length (d1);
len2 = length (d2);
str = ['Number of gfp = ' num2str(len1)];disp(str)
str = ['Number of cherry = ' num2str(len2)];disp(str)
   
    overlap0 = 0;
    for i = 1:len1
       for j = 1:len2
          if abs(d1(i, 1) - d2 (j, 1)) <= 0.5
             if abs(d1(i, 3) - d2(j, 3)) <= 0.5
                 overlap0 = overlap0+1;
             end
             
          end
       end
    end
 disp(['overlap0= ' num2str(overlap0)])
      
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

%% Calculating Variables for CSV file %%

cy3coloc0=100*overlap0/len1;
cy5coloc0=100*overlap0/len2;
coloc0 = 100*overlap0/(len2+len1-overlap0);
totalProtein0 = len1+len2-overlap0;
fractionGFP0 = len1/totalProtein0;
fractionCherry0 = len2/totalProtein0;

cy3coloc1=100*overlap1/len1;
cy5coloc1=100*overlap1/len2;
coloc1 = 100*overlap1/(len2+len1-overlap1);
totalProtein1 = len1+len2-overlap1;
fractionGFP1 = len1/totalProtein1;
fractionCherry1 = len2/totalProtein1;


cy3coloc1p5=100*overlap1p5/len1;
cy5coloc1p5=100*overlap1p5/len2;
coloc1p5=100*overlap1p5/(len2+len1-overlap1p5);
totalProtein1p5 = len1+len2-overlap1p5;
fractionGFP1p5 = len1/totalProtein1p5;
fractionCherry1p5 = len2/totalProtein1p5;


cy3coloc2=100*overlap2/len1;
cy5coloc2=100*overlap2/len2;
coloc2 = 100*overlap2/(len2+len1-overlap2);
totalProtein2 = len1+len2-overlap2;
fractionGFP2 = len1/totalProtein2;
fractionCherry2 = len2/totalProtein2;


cy3coloc3=100*overlap3/len1;
cy5coloc3=100*overlap3/len2;
coloc3 = 100*overlap3/(len2+len1-overlap3);
totalProtein3 = len1+len2-overlap3;
fractionGFP3 = len1/totalProtein3;
fractionCherry3 = len2/totalProtein3;


cy3coloc5=100*overlap5/len1;
cy5coloc5=100*overlap5/len2;
coloc5 = 100*overlap5/(len2+len1-overlap5);
totalProtein5 = len1+len2-overlap5;
fractionGFP5 = len1/totalProtein5;
fractionCherry5 = len2/totalProtein5;

coloc10 = 100*overlap10/(len2+len1-overlap10);



%% Caculate theoretical maximum values %%

% the 0.8 in the theoretical max is the assumption that the maturation rate
% for each FP is 0.8 - which may not be the case
% theoreticalMax=100*[(MaturationRateA*FractionA)*(MaturationRateB*FractionB)]
theoreticalMax0=100*[(0.8*fractionGFP0)*(0.8*fractionCherry0)];
theoreticalMax1=100*[(0.8*fractionGFP1)*(0.8*fractionCherry1)];
theoreticalMax1p5=100*[(0.8*fractionGFP1p5)*(0.8*fractionCherry1p5)];
theoreticalMax2=100*[(0.8*fractionGFP2)*(0.8*fractionCherry2)];
theoreticalMax3=100*[(0.8*fractionGFP3)*(0.8*fractionCherry3)];
theoreticalMax5=100*[(0.8*fractionGFP5)*(0.8*fractionCherry5)];
% Maturation rate/fraction taken from Nature Methods paper
natureMax0=100*[(0.65*fractionGFP0)*(0.43*fractionCherry0)];
natureMax1=100*[(0.65*fractionGFP1)*(0.43*fractionCherry1)];
natureMax1p5=100*[(0.65*fractionGFP1p5)*(0.43*fractionCherry1p5)];
natureMax2=100*[(0.65*fractionGFP2)*(0.43*fractionCherry2)];
natureMax3=100*[(0.65*fractionGFP3)*(0.43*fractionCherry3)];
natureMax5=100*[(0.65*fractionGFP5)*(0.43*fractionCherry5)];


%% Chunk for displaying values as I am analyzing data %%
disp(['Cy3 colocalization (@1.5pixel) = ' num2str(cy3coloc1p5) '%'])
disp(['Cy5 colocalization (@1.5pixel) = ' num2str(cy5coloc1p5) '%'])
disp(['General Colocalization (@1.5pixel) = ' num2str(coloc1p5) '%'])
disp(['Theoretical Colocalization Max (@1.5pixel) = ' num2str(theoreticalMax1p5) '%'])
disp(['NatureMethods Theoretical Colocalization Max (@1.5pixel) = ' num2str(natureMax1p5) '%'])

disp(['General Colocalization (@0 pixel) = ' num2str(coloc0) '%']);
disp(['General Colocalization (@1 pixel) = ' num2str(coloc1) '%']);
disp(['General Colocalization (@1.5 pixel) = ' num2str(coloc1p5) '%']);
disp(['General Colocalization (@2 pixel) = ' num2str(coloc2) '%']);
disp(['General Colocalization (@3 pixel) = ' num2str(coloc3) '%']);
disp(['General Colocalization (@5 pixel) = ' num2str(coloc5) '%']);
disp(['General Colocalization (@10 pixel) = ' num2str(coloc10) '%']);

%% Collate data and write csv %%

% Heterodimerization, pixel tolerance, proteins, theoretical max, nature paper max, movie#, gfp coloc %, cherry coloc%, #GFP, # Cherry, total  particles, scrambled status, Channel
tempData = {coloc0, 0, proteins, theoreticalMax0, natureMax0, movieNumber, cy3coloc0, cy5coloc0, len1, len2, totalProtein0, ScrambledStatus, 'Channel1';
    coloc1, 1, proteins, theoreticalMax1, natureMax1, movieNumber, cy3coloc1, cy5coloc1, len1, len2, totalProtein1, ScrambledStatus, 'Channel1';
    coloc1p5, 1.5, proteins, theoreticalMax1p5, natureMax1p5, movieNumber, cy3coloc1p5, cy5coloc1p5, len1, len2, totalProtein1p5, ScrambledStatus, 'Channel1';
    coloc2, 2, proteins, theoreticalMax2, natureMax2, movieNumber, cy3coloc2, cy5coloc2, len1, len2, totalProtein2, ScrambledStatus, 'Channel1';
    coloc3, 3, proteins, theoreticalMax3, natureMax3, movieNumber, cy3coloc2, cy5coloc2, len1, len2, totalProtein3, ScrambledStatus, 'Channel1';
    coloc5, 5, proteins, theoreticalMax5, natureMax5, movieNumber, cy3coloc5, cy5coloc5, len1, len2, totalProtein5, ScrambledStatus, 'Channel1'};

dataOutput = [dataOutput; tempData];

filename = 'FullStatsSummary.csv';
cell2csv(filename,dataOutput)   % This is from a script I found online
                                % It saves a cell as a csv file and is
                                % named cell2csv.m and is in the same
                                % folder as this script (programs2)
                                % --Michael Schamber

end
    

