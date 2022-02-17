%Extraction of dwell times at 4 different FRET values centered around 0.3,
%0.50, 0.70, and 0.85.

% The parameters below were used to determine dwelltime for all 30ms data
% of mGluR2 (WT) glutamate titration and drug tests. Emphasis was placed on
% transitions to/from state 4, which will remain the same for updated
% ranges.

% state1 = find(dwellData_s(:,1) <= 0.38);
% state2 = find(dwellData_s(:,1) > 0.38 & dwellData_s(:,1) <= 0.62);
% state3 = find(dwellData_s(:,1) > 0.62 & dwellData_s(:,1) <= 0.80);
% state4 = find(dwellData_s(:,1) > 0.80);

% The parameters below were used to determine dwelltime for all 100ms data
% of mGluR2 (WT vs PAM (C770A)).
state1 = find(dwellData_s(:,1) <= 0.40);
state2 = find(dwellData_s(:,1) > 0.40 & dwellData_s(:,1) <= 0.61);
state3 = find(dwellData_s(:,1) > 0.61 & dwellData_s(:,1) <= 0.80);
state4 = find(dwellData_s(:,1) > 0.80);

dwelltime_1 = 0.03*dwellData_s(state1,3);
dwelltime_2 = 0.03*dwellData_s(state2,3);
dwelltime_3 = 0.03*dwellData_s(state3,3);
dwelltime_4 = 0.03*dwellData_s(state4,3);

% %Plotting
% edges = linspace(0, 4, 134); % Create 50 bins in intervals of 1
% subplot (2,2,1), histogram(dwelltime_1,'BinEdges',edges);
% xlabel('Time(s)', 'FontSize', 10);
% ylabel('Count', 'FontSize', 10);
% title('State 1', 'FontSize', 14);
% 
% subplot (2,2,2), histogram(dwelltime_2,'BinEdges',edges);
% xlabel('Time(s)', 'FontSize', 10);
% ylabel('Count', 'FontSize', 10);
% title('State 2', 'FontSize', 14);
% 
% subplot (2,2,3), histogram(dwelltime_3,'BinEdges',edges);
% xlabel('Time(s)', 'FontSize', 10);
% ylabel('Count', 'FontSize', 10);
% title('State 3', 'FontSize', 14);
% 
% subplot (2,2,4), histogram(dwelltime_4,'BinEdges',edges);
% xlabel('Time(s)', 'FontSize', 10);
% ylabel('Count', 'FontSize', 10);
% title('State 4', 'FontSize', 14);
% 
% %Save histograms
% saveas(gca,'dwelltimes.tif');

%Export dwell times as CSV files
csvwrite('dwelltime_1.csv',sort(dwelltime_1));
csvwrite('dwelltime_2.csv',sort(dwelltime_2));
csvwrite('dwelltime_3.csv',sort(dwelltime_3));
csvwrite('dwelltime_4.csv',sort(dwelltime_4));