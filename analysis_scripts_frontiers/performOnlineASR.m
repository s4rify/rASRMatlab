function [] = performOnlineASR(toolboxpath, inputdatadir, outsets, nameMat, params)
    %
    % performOnlineASR(toolboxpath, inputdatadir, outsets, nameMat).m--
    %
    % Developed in Matlab 9.0.0.341360 (R2016a) on PCWIN64
    % at University of Oldenburg.
    % Sarah Blum (sarah.blum@uol.de), 2018-11-27 09:08
    %-------------------------------------------------------------------------
    
    % path specs
    raw_dir = inputdatadir;
    fn = dir([raw_dir, '*.set']);
    
    % use matching calibration data for all cleaning!
    calib_dir = 'sme_data/calib_data/';
    fc = dir([calib_dir, '*.set']);
    
    addpath(toolboxpath, '-begin')
    
    for i = 1 : length(fn)
        
        %% load dataset to be cleaned
        EEG = pop_loadset('filename',[raw_dir, fn(i).name]);
        channelEEG = EEG.chanlocs;
        
        %% load calibration set and make sure that it has correct number of channels
        EEG_c = pop_loadset('filename',[calib_dir, fn(i).name]);
        
        %% clean calib data
        flatline = params{1,2};
        hp = params{2,2};
        channel = params{3,2};
        noisy = params{4,2};
        burst = params{5,2};
        window = params{6,2};
        EEG_c = clean_rawdata(EEG_c, flatline, hp, channel, noisy, burst, window);
        EEG_c = pop_interp(EEG_c, EEG.chanlocs, 'spherical');
        
        % ASR
        warning off;
        disp('beginning processing..')
        cutoff = params{7,2};
        window = params{8,2};
        stepsize = params{9,2};
        maxdims = params{10,2};
        EEG = clean_flatlines(EEG, flatline);
        EEG = clean_drifts(EEG,hp);
        % this is no online method
        %EEG = clean_channels(EEG, channel,noisy);
        EEG = pop_interp(EEG, channelEEG, 'spherical');
        % tstart = tic; % when do we want to measure?
        EEG = clean_asr(EEG,cutoff,window,stepsize,maxdims,EEG_c,[],[],[]);
        
        % EEG = pop_saveset(EEG, 'filename', EEG.setname,'filepath', [outsets,filesep,'online',filesep]);
        EEG = pop_saveset(EEG, 'filename', lower(EEG.setname),'filepath', [outsets,filesep]);
        clear outdata process_data calib_data EEG EEG_c state samplemask
    end
    %% timing measurement is now done in ASR_time_measurement_only.m in the same folder
    %% save(['compTimes/', nameMat ,'.mat'], 'ETIME');
    % remove toolbox from path again so that we can add it next time
    rmpath(toolboxpath); disp('removed ASR toolbox from path');
end

