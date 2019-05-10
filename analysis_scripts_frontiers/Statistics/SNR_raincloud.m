function [] = SNR_raincloud(SNR, titlestring, figtitle)
    %
    % SNR_raincloud.m--
    %
    % Input arguments:
    %
    % Output arguments:
    %
    % Other m-files required:
    %
    % Example usage:
    %
    %
    % Developed in Matlab 9.0.0.341360 (R2016a) on PCWIN64
    % at University of Oldenburg.
    % Sarah Blum (sarah.blum@uol.de), 2019-01-03 10:50
    %-------------------------------------------------------------------------
    % SNR contains 3 cells, one for every method:
    % SNR{1} = asr, SNR{2} = uncorrected, SNR{3} = rasr
    % Every entry contains 27 values, one SNR value per subject, computed on combined blocks of this subject
    
    darkblue = [0,10,115]/255;
    darkgreen = [0,166,131]/255;
    ornage = [255,192,0]/255; 
    axlims = [-30, 120]; % this looks crazy
    
    % filtered
    f1 = figure('rend', 'painters', 'pos', [100,100,1600,900]);
    supertitle(titlestring);
    subplot(3,3,[1:6])
    bar([SNR{1}; SNR{2}; SNR{3}])
    ylabel('SNR in dB')
    set(gca, 'XTickLabels', {'ASR','uncorrected','Riemann ASR'})
    subplot(3,3,7)
    raincloud_plot('X', SNR{1}', ...
        'box_on',1, 'color', darkblue, 'cloud_edge_col', darkblue);
    set(gca,'YTickLabel',[] ... % this does not hold any information
        );
    xlabel('SNR in dB');
    legend({num2str(mean(SNR{1}))})
    
    % asr
    subplot(3,3,8)
    raincloud_plot('X', SNR{2}', ...
        'box_on',1, 'color', darkgreen, 'cloud_edge_col', darkgreen);
    set(gca,'YTickLabel',[] ... % this does not hold any information
        );
    xlabel('SNR in dB');
    legend({num2str(mean(SNR{2}))})
    
    % rasr
    subplot(3,3,9)
    raincloud_plot('X', SNR{3}', ...
        'box_on',1, 'color', ornage, 'cloud_edge_col', ornage);
    set(gca,'YTickLabel',[] ... % this does not hold any information
        );
    xlabel('SNR in dB');
    legend({num2str(mean(SNR{3}))})
    saveas(f1, ['../Figures',figtitle, '.fig'])
end