function [AMP_P100, AMP_N125, AMP_DIFF] = amplitudes_VEP(p, channels, condition)
    %
    % amplitudes_VEP.m--
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
    % Sarah Blum (sarah.blum@uol.de), 2019-01-08 16:00
    %-------------------------------------------------------------------------
    
    methods = dir2(p);
    for i = 1 : size(methods,1)
        FOLDERS{i} = [methods(i).name, '/MergedBlocks/', condition, filesep];
    end
    
    for m = 1: 3 % filtered, ASR, rASR
        flist = dir([p, FOLDERS{m}, '*.mat']);
        
        for i = 1: length(flist)
            % load subject data epoched and sorted by cleaning method
            I = load([p, FOLDERS{m}, flist(i).name]);
            names =  fieldnames(I);
            MERGED = getfield(I, names{1});
            disp(['Processing subject ', num2str(i), '...']);
            
            % this is the mean response of the respective subject, all blocks combined
            MEAN(i,:) = mean(mean(MERGED.data([channels],:,:),1),3);
            
            % search indices: compute SNR for P100 and N125 seperately
            % IND will contain the indices of the three peaks we see in the VEP in chronological order
            IND = searchIndices(MEAN(i,:));
            % P100
            offset = 0;
            signal_p100 = max(mean(mean(MERGED.data(channels, [IND(1)-offset : IND(1)+offset], :),1),3));
            amp_p100(i) = signal_p100;
            
            % N125
            signal_n125 = min(mean(mean(MERGED.data(channels, [IND(2)-offset : IND(2)+offset], :),1),3));
            amp_n125(i) = signal_n125;
            
            % P1-N1
            % the difference, meaning the distance between the points must be the differene here, because one value is 
            % positive, the other is negative
            % assert(signal_p100 > 0);
            % assert(signal_n125 < 0);
            signal_diff = abs(signal_p100 - signal_n125);
            amp_diff(i) = signal_diff;
            
        end
        disp([num2str(m), ' is ', FOLDERS{m}])
        AMP_P100{m} = amp_p100;
        AMP_N125{m} = amp_n125;
        AMP_DIFF{m} = amp_diff;
        
    end % all methods treated
    
end