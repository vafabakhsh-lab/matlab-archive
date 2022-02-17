%Extraction of dwell times


% The following code chunk was used for determining dwelltimes of mCasR 5ms
% data based on the output of dwell_reza_all and using FRET values.

state1 = find(dwellData_s(:,1) <= 0.35);
state2 = find(dwellData_s(:,1) > 0.35 );
% state3 = find(dwellData_s(:,1) > 0.4 );

dwelltime_1 = 0.03*dwellData_s(state1,3);
dwelltime_2 = 0.03*dwellData_s(state2,3);
% dwelltime_3 = 0.005*dwellData_s(state3,3);

% The following chunk was used for dwell time calculation using the state
% number assigned by ebFRET and was included in the pathData output from
% dwell_reza_all.

% state1 = find(dwellData_s2(:,4) == 1);
% state2 = find(dwellData_s2(:,4) == 2);
% 
% dwelltime_1 = 0.03*dwellData_s2(state1,3);
% dwelltime_2 = 0.03*dwellData_s2(state2,3);

% %Plotting
edges = linspace(0, 4, 100); % Create 50 bins in intervals of 1
subplot (2,2,1), histogram(dwelltime_1,'BinEdges',edges);
xlabel('Time(s)', 'FontSize', 10);
ylabel('Count', 'FontSize', 10);
title('State 1', 'FontSize', 14);

subplot (2,2,2), histogram(dwelltime_2,'BinEdges',edges);
xlabel('Time(s)', 'FontSize', 10);
ylabel('Count', 'FontSize', 10);
title('State 2', 'FontSize', 14);

% subplot (2,2,3), histogram(dwelltime_3,'BinEdges',edges);
% xlabel('Time(s)', 'FontSize', 10);
% ylabel('Count', 'FontSize', 10);
% title('State 3', 'FontSize', 14);


% 
% %Save histograms
% saveas(gca,'dwelltimes.tif');

%Export dwell times as CSV files
 csvwrite('dwelltime_1.csv',sort(dwelltime_1));
 csvwrite('dwelltime_2.csv',sort(dwelltime_2));
% csvwrite('dwelltime_3.csv',sort(dwelltime_3));
