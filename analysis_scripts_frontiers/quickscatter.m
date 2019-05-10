function [] = quickscatter(IN, OUT)
    %
    % quickscatter.m--
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
    % Sarah Blum (sarah.blum@uol.de), 2019-01-22 14:47
    %-------------------------------------------------------------------------
    
    markersize = 100;
    f = figure( 'pos', [100, 100, 800,800], 'rend', 'painters');
    
    hold on
    scatter(IN(:,1), IN(:,2), markersize, '^') % correlation values
    
    scatter(OUT(:,1), OUT(:,2), markersize, 's')
    plot([0:1],[0:1], ':') % line through origin
    ylim([0,1]);
    xlim([0,1]);
    xlabel('uncorr ~ ASR')
    ylabel('uncorr ~ rASR')
    legend({'inside', ' ', 'outside'})
    set(f, 'XTickMode', 'off')
    axis square
    grid on
    set(gca, 'FontSize', 18)