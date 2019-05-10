
% computing time has been evaluated for the ASR methods
% each mat file contains 158 entries, which in theory would have been 162 entries:
% 27 subjects, 6 blocks per subject = 27*6 = 162. In practice, we lost some blocks due to technical problems
% during the recording, so that we end up with 158 entries that contain indoors and outdoors in non-described
% order. 

matFileLocation = 'compTimes/';
flist = dir([matFileLocation, '*.mat']);
for i = 1: length(flist)
    % get info of current mat file because we do not know what itself or its field is called
    info = whos('-file',[matFileLocation, flist(i).name]);
    % load the variable, which is now under its (unknown) name in the workspace
    load([matFileLocation, flist(i).name]);
    % get the values from the file without explicitly giving the name
    vals = eval(info.name);
    % we want it as a vector
    times(i,:) = [vals{:}];
end

% times now has 6 entries, 3 for ASR timing measurements and 3 for Riemann ASR measurements
% the information which is which is contained in the flist and can be used in the plots
flist(1).name(1:end-4);

f1=figure('rend', 'painters', 'pos', [100,100,800,800]);
boxplot([times(1,:)', times(2,:)', times(3,:)', times(4,:)'], ...
    'labels', {'ASR total', 'ASR core functions', 'rASR total', 'rASR core functions'});
ylabel('Computation time [s]')
set(gca, 'FontSize', 20)
grid on
axis square 
saveas(f1, ['Figures/compTimes/boxplot.fig'])

darkblue = [0,10,115]/255;
f1 = figure('rend', 'painters', 'pos', [100,100,1600,900]);
for s = 1 : 4
    subplot(2,2,s)
    raincloud_plot('X', times(s,:)', ...
        'box_on',1, 'color', darkblue, 'cloud_edge_col', darkblue);
    title(flist(s).name(1:end-4))
    set(gca, 'YTickLabel', [])
end

% percent change
% 1-(smol/big)
asr_total = times(1,:);
asr_min = times(2,:);
rasr_total = times(3,:);
rasr_min = times(4,:);

mean(asr_total)
mean(rasr_total)
mean(asr_min)
mean(rasr_min)

1 -(rasr_total / asr_total)
1- (rasr_min / asr_min)

saveas(f1, ['Figures/compTimes/allTimes_raincloudOnly.fig'])

% export computation times for R as well 
csvwrite(['Statistics/stats/data/asr_total.csv'], times(1,:))
csvwrite(['Statistics/stats/data/asr_min.csv'], times(2,:))
csvwrite(['Statistics/stats/data/rasr_total.csv'], times(3,:))
csvwrite(['Statistics/stats/data/rasr_min.csv'], times(4,:))

