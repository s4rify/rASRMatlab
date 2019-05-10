function [SNR_P100, SNR_N125, SNR_COMBI] = SNR_VEP(p, channels, condition)
    %
    % Developed in Matlab 9.0.0.341360 (R2016a) on PCWIN64
    % at University of Oldenburg.
    % Sarah Blum (sarah.blum@uol.de), 2018-12-12 15:19
    %-------------------------------------------------------------------------
    
    methods = dir2(p);
    for i = 1 : size(methods,1)
        FOLDERS{i} = [methods(i).name, '/MergedBlocks/',condition, filesep];
    end
    
    for m = 1: 3 % asr, filtered, rasr
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
            baseline = 1:40; % 1-40 samples = 200 ms before trigger
            noise =  std(mean(mean(MERGED.data(channels, baseline ,:),1),3));
            % rms noise
            % noise =  rms(mean(mean(I.MERGED.data(channels, baseline ,:),1),3));
            signal_p100 = max(mean(mean(MERGED.data(channels, [IND(1)-offset : IND(1)+offset], :),1),3));
            snr_p100(i) = 10*log10(abs(signal_p100)/noise);
            
            % N125
            signal_n125 = min(mean(mean(MERGED.data(channels, [IND(2)-offset : IND(2)+offset], :),1),3));
            snr_n125(i) = 10*log10(abs(signal_n125)/noise);
            
            % combined SNR for both peaks
            % this must be the sum here because the former negative n125 peak is a positive value here!
            signal_diff = abs(signal_p100 - signal_n125);
            snr_combi(i) = 10*log10(signal_diff/noise);
            
        end
         disp([num2str(m), ' is ', FOLDERS{m}])
        SNR_P100{m} = snr_p100;
        SNR_N125{m} = snr_n125;
        SNR_COMBI{m} = snr_combi;
        
    end % all methods treated
    
end


