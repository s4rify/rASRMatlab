function [] = import_and_cleaning()
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This script lies in PhD/ASR_Riemann_Evaluation
    %
    %
    %
    % Developed in Matlab 9.2.0.538062 (R2017a) on GLNXA64.
    % Sarah Blum (sarah.blum@uni-oldenburg.de), 2017-12-12 17:04
    %-------------------------------------------------------------------------
    % This is the protocol that we follow to compare both ASR cleanings against each other.
    %
    %
    % Comparison of performance of the original ASR and Riemann-adapted ASR version
    % (from here on rASR).
    % We want to evaluate the performance of the rASR toolbox by looking at its specificity
    % and its sensitivity.
    % In the first stage of evaluation, we use the clean_rawdata toolbox and all its wrappers in
    % both test scenarios. The only changes that distinguish the oASR from the rASR toolbox
    % are changes in its calibration method and its processing method.
    %
    % Specificity is evaluated by looking at the SNR of motor signals
    % Expectations:
    %   - SNR is better with rASR than with oASR than with ICA in movement
    %
    % Its sensitivity is evaluated by a comparison of artifact cleaning via ICA and both ASR
    % methods.
    % Expectation:
    %   -  less variation in the cleaned signal of artefactual maps (eg eye blinks)
    %       in movement data when using ASR (or JAVA) instead of ICA
    % technical expectation: computing time in Riemann ASR is reduced by ~ 2/3 because we do not
    % compute the covariance matrix that often --> and this is although the computations in
    % Riemann geometry are optimization problems!
    %
    % other files needed:
    % load_xdf.m, eeglab
        
    %% import and pre-process data: filter
    SME_RAW = 'sme_data/raw_single_blocks/';
    SME_FILT = 'sme_data/filtered/';
    flist = dir([SME_RAW, '*.xdf']);
    for s= 1:length(flist)
        EEG = pop_loadxdf([SME_RAW, flist(s).name] , 'streamtype', 'EEG', 'exclude_markerstreams', {});
        EEG = eeg_checkset( EEG );
        EEG = pop_select( EEG,'nochannel',{'GyroX' 'GyroY' 'GyroZ' 'AccX' 'AccY' 'AccZ' 'GPSLatitude' 'GPSLongitude'});
        EEG=pop_chanedit(EEG, 'load',{[pwd,'/smarting-24channels.locs'] 'filetype' 'autodetect'});
        % lp filter
        EEG = pop_eegfiltnew(EEG, [],  40, 166, 0, [], 0); % lp
        % perform hp filtering
        EEG = pop_eegfiltnew(EEG, [], 0.25, 3300, true, [], 0);
        EEG.setname = [flist(s).name, '_filt'];
        EEG = pop_saveset(EEG, [EEG.setname,'.set'], SME_FILT);
    end
    
    %% extract calib data
    PATH = [pwd, '/sme_data/filtered/'];
    flist = dir([PATH, '*.set']);
    for s = 1: length(flist)
        EEG = pop_loadset('filename',[PATH, flist(s).name]);
        % use 6 marker with description 'resteeg' as beginning of 1 minute epoch
        epochrange = [0,60]; % 1 minute
        %index = find(~cellfun(@isempty,regexp({EEG.event.description},'resteeg')));
        marker = '6 rest eeg';
        EEG = pop_epoch(EEG, {marker}, epochrange , 'epochinfo', 'yes');
        % save as extra datasets
        EEG.setname = flist(s).name;
        pop_saveset(EEG,[EEG.setname, '_calib'],'sme_data/calib_data/');
    end
    
    % Riemannian ASR
    PATHIN = 'sme_data/filtered/';
    PATHOUT = 'sme_data/rASR_out/';
       params = {
            'flatline', 1
            'hp' , [0.25 0.95]
            'channel', 0.9
            'noisy', 3 % std dev for removing chnnels
            'burst', 2 % std dev for removing samples
            'c_window', 0.3 % how much dirt can be left in the final output
            ... processing values from here on ...
            'cutoff', 1
            'p_window', 0.3
            'stepsize', 16
            'maxdims', 1
            };
    performOnlineASR('rASRToolbox/', PATHIN, PATHOUT, 'ETIME_rasr_sme',params);
    
    % original ASR
    PATHIN = 'sme_data/filtered/';
    PATHOUT = 'sme_data/ASR_out/';
    params = {
        'flatline', []
        'hp' , [0.25, 0.95]
        'channel', -1
        'noisy',-1
        'burst', -1
        'c_window', []
        ... processing values from here on ...
        'cutoff', 5
        'p_window', 0.5
        'stepsize', 32
        'maxdims', 0.66
        };
    performOnlineASR('oASRToolbox/', PATHIN, PATHOUT, 'ETIME_oasr_sme', params);
    
end
