function [SNR] = SNR_gain_with_trials(p, channels, condition)
    %
    % SNR_gain_with_trials.m--
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
    % Sarah Blum (sarah.blum@uol.de), 2019-01-08 16:51
    %-------------------------------------------------------------------------
    
    % How many trials do we need to reach a good SNR of the signal?
    %
    %
    % output: something like
    %
    % SNR ^
    %     |
    %     |     rASR     ASR
    %     |----/--------/-------- good SNR
    %     |   /    ----
    %     |  /  /
    %     o----------------------> trials
    %
    % Developed in Matlab 9.0.0.341360 (R2016a) on PCWIN64
    % at University of Oldenburg.
    % Sarah Blum (sarah.blum@uol.de), 2018-05-22 11:25
    %-------------------------------------------------------------------------
    
    methods = dir2(p);
    for i = 1 : size(methods,1)
        FOLDERS{i} = [methods(i).name, '/MergedBlocks/', condition, filesep];
    end
    %% iterate through the methods
    for meth_idx = 1: 3
        flist = dir([p, FOLDERS{meth_idx}, '*.mat']);
        
        for subj_idx = 1: length(flist)
            %% load subject data, averaged over all blocks epoched and sorted by cleaning method
            I = load([p, FOLDERS{meth_idx}, flist(subj_idx).name]);
            names = fieldnames(I);
            MERGED = getfield(I, names{1});
            disp(['Processing subject ', num2str(subj_idx), '...']);
            ntrials = 70; % not everyone has the same amount size(MERGED.data,3);
            
            % compute epoch over all trials to detect indices of P100 and N125
            epoch =  mean(mean(MERGED.data(channels,:,:),3),1);
            IND = searchIndices(epoch);
    
            % proceed in small steps until max number of trials is reached
            step = 1;
            offset = 0;
            idx = 1;
            for t = 1:step:ntrials
%                  epoch =  mean(mean(MERGED.data(channels,:,1:t),3),1);
%                 IND = searchIndices(epoch);
                erp = squeeze(mean(mean(MERGED.data(channels,:,1:t),1),3));
                signal_p100 = erp(IND(1));
                signal_n125 = erp(IND(2));
                signal_diff = abs(signal_p100 - signal_n125);
                
                SIGNAL(idx) = signal_diff;
                idx = idx+1;
            end % end trial loop
            SNR{meth_idx}{subj_idx} = SIGNAL;
            clear SIGNAL  
        end % all subj for one methods treated        
    end % one method treated
end % end method loop





