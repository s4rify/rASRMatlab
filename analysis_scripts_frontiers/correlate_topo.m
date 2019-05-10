function [Cs] = correlate_topo(condition)
%
% Developed in Matlab 9.0.0.341360 (R2016a) on PCWIN64
% at University of Oldenburg.
% Sarah Blum (sarah.blum@uol.de), 2018-05-09 09:55
%-------------------------------------------------------------------------

%% GA things are in the repository

%% SINGLE SUBJECT THINGS
% load single subject
index = [125];
for i = 1: 27 %subjects
   disp(['Handling subject ', num2str(i),'..']);
   tmp = load([pwd, filesep, 'matFilesForBigPlot_BLINK\01_filtered\MergedBlocks\',condition, num2str(i), '.mat']);
   names = fieldnames(tmp);
   MERGED = getfield(tmp, names{1});
   Fs(i,:) = mean(mean(MERGED.data(:, index,:),2),3);
   clear tmp
   
   tmp = load([pwd, filesep, 'matFilesForBigPlot_BLINK\03_oasr\MergedBlocks\',condition, num2str(i), '.mat']);
   names = fieldnames(tmp);
   MERGED = getfield(tmp, names{1});
   As(i,:) = mean(mean(MERGED.data(:, index,:),2),3);
   clear tmp
   
   tmp = load([pwd, filesep, 'matFilesForBigPlot_BLINK\04_rasr\MergedBlocks\',condition, num2str(i), '.mat']);
   names = fieldnames(tmp);
   MERGED = getfield(tmp, names{1});
   Rs(i,:) = mean(mean(MERGED.data(:, index,:),2),3);
   clear tmp
   
   % absolute R values: correlate the single subjects per condition
   F_A = corr(Fs(i,:)', As(i,:)', 'type', 'Pearson'); % filtered ~ asr
   F_R = corr(Fs(i,:)', Rs(i,:)', 'type', 'Pearson'); % filtered ~ riemann
   
   % R squared
   Cs(i,1) = power(F_A ,2); 
   Cs(i,2) = power(F_R ,2); 
   % diff(R^2) for plots
   Cs(i,3) = Cs(i,1) - Cs(i,2);

   % z-transformed correlation values for the t-tests, not for plotting
   % http://lasp.colorado.edu/cism/CISM_DX/code/CISM_DX-0.50/required_packages/octave-forge/extra/NaN/corrcoef.m
   z_f_asr(i) = log((1+F_A) ./ (1-F_A))/2;
   z_f_rasr(i) = log((1+F_R) ./ (1-F_R))/2;

end
% save z-transformed correlation values for statistical analysis
csvwrite(['Statistics/stats/data/ztrans_blink_corr_FILT_ASR_',condition(1:end-1), '.csv'], z_f_asr)
csvwrite(['Statistics/stats/data/ztrans_blink_corr_FILT_rASR_',condition(1:end-1), '.csv'], z_f_rasr)
% 
% % have 3 groups in total, containing 27 values
% f1 = figure('rend', 'painters', 'pos', [100,100,1600,900]);
% subplot(3,3,[1:6])
% bar([Cs(:,1)';  Cs(:,2)'; Cs(:,3)']);
% ylim([-0.5, 1]);
% set(gca, 'XTickLabels', {'uncorrected ~ ASR','uncorrected ~ riemann ASR','Difference of group1 and group2'})
% title(['Correlations of single subject blink maps. Each bar is a subject, ', condition])
% ylabel('Pearson correlation [R^2]')
% 
% subplot(3,3,7)
% darkblue = [0,10,115]/255;
% raincloud_plot('X', Cs(:,1)', ...
%     'box_on',1, 'color', darkblue, 'cloud_edge_col', darkblue);
% xlabel('Pearson correlation [R^2]');
% %set(gca,'YTickLabel',[]);% this does not hold any information
% subplot(3,3,8)
% darkgreen = [0,166,131]/255;
% raincloud_plot('X', Cs(:,2)', ...
%     'box_on',1, 'color', darkgreen, 'cloud_edge_col', darkgreen);
% xlabel('Pearson correlation [R^2]');
% %set(gca,'YTickLabel',[]); % this does not hold any information
% % subplot(3,3,9)
% % ornage = [255,192,0]/255; 
% % raincloud_plot('X', Cs(:,3)', ...
% %     'box_on',1, 'color', ornage, 'cloud_edge_col', ornage);
% % xlabel('Difference of correlation values');
% % set(gca,'YTickLabel',[]);% this does not hold any information
% saveas(f1, ['Figures/blinks/sme/big_corr_',condition(1:end-1), '.fig'])
% % awesome.


end