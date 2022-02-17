% Inputs all idealized path data from vbFRET, concatenates the data, and
% processes data for producing TDPs.

clear;
 
% % % Change to input file directory and file name to be analyzed.
[filename,path]=uigetfile('*.dat');
cd(path);
fileData = readtable([path,filename]);
fileData = table2array(fileData);
 pathData = fileData(1:end,[1,6,5]); % for ebFRET
% pathData = fileData(1:end,[1,2]); % For vbFRET
% pathData = fileData(1:end,[1,3]); % for AutoStepfinder
% 
% % Creates structure containing .dat file names
% S=dir('*_PATH.dat');                                            
% 
% % Imports '*_PATH.dat' files and stores them in a cell array
% for k=1:length(S);                                              
% datacell{k}=importdata(S(k).name);
% temp_data=cell2mat(datacell(k)');xx=max(size(temp_data));
% temp_mat=[k*ones(xx,1) temp_data(:,2)];
% data=[data ; temp_mat];
% end

% Converts cell array into a matrix array 
% ('=inverts reading by column to reading by row)

% data=cell2mat(datacell');

% Dwell time analysis scripts
dwellData = getDwell(pathData);                   % Gives transition states and time of occupancy
dwellData_s = purifyDwell(dwellData, 0.1);        % Sets minimal transition threshold
% dwellData_j1 = purifyDwell_J(dwellData_s, 1);    % Optional: Remove single or double frame events with ‘dwellData_J’. Frame is the number of frames you want to delete.
% dwellData_3 = purifyDwell_3(dwellData_j1);       % Optional: Remove the first event of each trace
TDP=plotTDP(dwellData_s, 18);                     % Default bin is 24

% ebfretDwell = getDwell_ebFRET(pathData);
% dwellData_s2 = purifyDwell_ebFRET(ebfretDwell, 0.1);

% note: dwellData must be 3 column

xlim([0 1]);
ylim([0 1]);
set(gca,'XTick',0:0.2:1);
set(gca,'YTick',0:0.2:1);

hold on;

% % Obtain the tick mark locations
xtick = 0:0.1:1;  
% Obtain the limits of the axises
ylim = get(gca,'Ylim');
% Create line data
X = repmat(xtick,2,1);
Y = repmat(ylim',1,size(xtick,2));
% Plot line data
plot(X,Y,'w');

hold on;

% Obtain the tick mark locations
ytick = 0:0.1:1; 
% Obtain the limits of the axises
xlim = get(gca,'Xlim');
% Create line data
X1= repmat(xlim',1,size(ytick,2));
Y1= repmat(ytick,2,1);
% Plot line data
plot(X1,Y1,'w');

xlabel('Initial State')
ylabel('Final State')
set(gca,'fontsize',22)
load('D:\smFret\programs2\downloaded softwares\TDP and Dwelltime code for Michael\dwell time analysis\lifetime\Colormap_softtones_BWL.mat')
colormap(cm2)

% xline(0.22, ':', 'LineWidth',2)
% xline(0.38, ':', 'LineWidth',2)
% xline(0.56, ':', 'LineWidth',2)
% xline(0.78, ':', 'LineWidth',2)
%  
% yline(0.22, ':', 'LineWidth',2)
% yline(0.38, ':', 'LineWidth',2)
% yline(0.56, ':', 'LineWidth',2)
% yline(0.78, ':', 'LineWidth',2)

% saveas(gca,'plot.tif');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% REZA's %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% A=whos; data=[];                                                % After loading in data as individual matrices, 
% for ii=1:numel(A)-2;                                            % Why is it -2 here???
% if length (A(ii).name) > 4 & A(ii).name(end-3:end)=='PATH';     % Selection of files that end in 'PATH' and storing them in the data matrix together, essentially concatenating them
% % data3=[];for ii=1:22;data3=[data3 ;eval(A(ii).name)];end
% data=[data ;eval(A(ii).name)];                                  % Why is data first input of argument???
% end;
% end;
% 
% %Dwell time analysis begins
%
% %dwellData=[];dwellData_s=[];                                   %Finding dwell times and transitions
% dwellData = getDwell(data);
% dwellData_s = purifyDwell(dwellData, 0.1);
% dwellData_j1 = purifyDwell_J(dwellData_s, 1);                   % This is optional: Remove single or double frame events with ‘dwellData_J’. Frame is the number of frame you want to delete.
% dwellData_3 = purifyDwell_3(dwellData_s);                       % This is also optional: Remove the first event of each trace
% plotTDP(dwellData_s, 24);                                       % Default bin is 24
%
% xlim([0 1]);
% ylim([0 1]);