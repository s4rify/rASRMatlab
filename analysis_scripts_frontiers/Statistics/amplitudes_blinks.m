function [AMP] = amplitudes_blinks(p, channels, index, condition)
    %
    % amplitudes_blinks.m--
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
    % Sarah Blum (sarah.blum@uol.de), 2019-01-08 16:43
    %-------------------------------------------------------------------------
    
    methods = dir2(p);
    for i = 1 : size(methods,1) -1 % do not use the GA data
        FOLDERS{i} = [methods(i).name,'/MergedBlocks/', condition, filesep]; % we only want to compute SNRs of subjects, not single blocks
    end
        
    for m = 1: length(FOLDERS)
        flist = dir([p, FOLDERS{m},'*.mat']);
        for i = 1: length(flist)
            % load subject data, with combined blocks, epoched and sorted by cleaning method
            I = load([p, FOLDERS{m}, flist(i).name]);
            names =  fieldnames(I);
            MERGED = getfield(I,names{1});
            disp(['Processing subject ', num2str(i), '..']);
            timerange = index;
            signal = max(mean(mean(MERGED.data(channels, timerange, :),1),3));
            blinksnr(i) = signal;
        end
        AMP{m} = blinksnr;
    end % all methods treated
end