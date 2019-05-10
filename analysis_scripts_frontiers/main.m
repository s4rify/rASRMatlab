function [] = main()
    % Developed in Matlab 9.2.0.538062 (R2017a) on GLNXA64.
    % Sarah Blum (sarah.blum@uni-oldenburg.de), 2017-12-12 17:04
    %-------------------------------------------------------------------------
    % This is the protocol that we follow to compare both ASR cleanings against each other and uncorrected
    % data
    %
    %
    % Comparison of performance of the original ASR (from here on oASR) and Riemann-adapted ASR version
    % (from here on rASR).
    % We want to evaluate the performance of the rASR toolbox by looking at its specificity
    % and its sensitivity.
    % In the first stage of evaluation, we use the clean_rawdata toolbox and all its wrappers in
    % both test scenarios. The only changes that distinguish the oASR from the rASR toolbox
    % are changes in its calibration method and its processing method.
    %
    %
    % Specificity is evaluated by looking at the SNR of motor signals
    % Expectations:
    %   - SNR is better with rASR than with oASR
    %
    % rASR sensitivity is evaluated by a comparison of artifact cleaning of eye blinks
    % Expectation:
    %   -  less variation in the cleaned signal of artefactual maps (eg eye blinks)
    %
    % technical expectation: computing time in Riemann ASR is reduced by ~ 2/3 because we do not
    % compute the covariance matrix that often --> and this is although the computations in
    % Riemann geometry are optimization problems!
    
    %%%%%%%%%%%%%%%%%%%
    %% DATA PREPROCESSING THINGS
    %%%%%%%%%%%%%%%%%%%
    % load raw data and run ASR, RASR on them
    import_and_cleaning();
    
    % save eye blink latencies in mat files for later analyses
    % blinker bandpass-filters the data 1-20 hz, so we can give filtered or unfiltered sets here
    outputDir = 'Blinker/sme/';
    detectBlinksInRawData('sme_data/filtered/', outputDir);
    
    % add blink events to sets and save in sme_data/plus_blinker_events/
    path_blinker = 'Blinker/sme/';% contains the detected blink indices
    commonpath_out = 'matFilesForBigPlot_BLINK/';
    commonpath_in = 'sme_data/';
    path_in = {'filtered/', 'ASR_out/', 'rASR_out/'};
    path_out = {'01_filtered', '03_oasr', '04_rasr'};
    for m = 1 :3 % methods
        p_in = [commonpath_in, path_in{m}];
        p_out = [commonpath_out, path_out{m}, filesep ];
        addBlinkMarker(p_in, p_out, path_blinker);
    end
    
    % combine all 4-6 blocks per subject
    % store all blocks together in /Merged/ and the inside and outside blocks additionally in Merged/inside or
    % Merged/outside
    commonpath = 'matFilesForBigPlot_BLINK/';
    methods = {'01_filtered', '03_asr', '04_rasr'};
    for m = 1 :3 % methods
        p = [commonpath, methods{m}, filesep];
        combineBlocks(p);
    end
      
    %%% Computing time
    % plot the duration of processing quickly and not very nicely
    generateTimingMatrices;
    exploreComputingTimeASR;
    
    
    %%%%%%%%%%%%%%%%%%%
    %% PLOT THINGS
    %%%%%%%%%%%%%%%%%%%
    
    %%% Blinks
    channels = [1,2];
    topoindex = 125; % 250 samples in total, blink is at center of epoch: 125, residual VEP is at 159
    searchIndex = false; % we already know where the blink is
    condition = {'outside', 'inside'};
    commonpath = ['matFilesForBigPlot_Blink\'];
    methods = {'01_filtered', '03_oasr', '04_rasr'};
    topolimits = {[-100, 500], [-20,50], [-20,50]}; % for uncorrected, asr and rasr, % [-8,8] for residual VEP
    ylims = {[-50, 400], [-5, 15], [-5, 15]}; 
    namfig = {'filtered_combinedBlocks','ASR_combinedBlocks', 'rASR_combinedBlocks' };
    for m = 1 : 3 % methods
        for c = 1 : 2 % conditions
            p = [commonpath, methods{m},'/MergedBlocks/', condition{c}, filesep ];
            [nblinks]= grandAverageBlink2(p, channels, topolimits{m},topolimits{m}, condition{c}, topoindex);
            %fout = ['Figures/blinks/sme/', namfig{m}];
            %mergedBlockPlot(p, channels, topoindex, searchIndex, ylims, fout, 'outside');
        end
    end
    
    % check how much is left of the blink by correlating the topos
    % this produces bar plots of correlations and raincloud plots of channel values and
    % correlations as well, it also saves the z-transformed correlation values in Statistics/data/
    [IN] = correlate_topo('inside/');
    [OUT] = correlate_topo('outside/');
    csvwrite(['Statistics/data/ztrans_blink_corr_FILT_ASR_', '.csv'], [IN(:,1); OUT(:,1)])
    csvwrite(['Statistics/data/ztrans_blink_corr_FILT_RIEM_', '.csv'], [IN(:,2); OUT(:,2)])
    
    % make a quick scatterplot
    quickscatter(IN, OUT); % beautiful.
  
    %%% VEPs
    commonpath = 'matFilesForBigPlot_VEP/';
    pathin = {'filtered', 'ASR_out', 'rASR_out'};
    pathout = {'filtered', 'asr', 'rasr'};
    for m = 1 :3 % methods
        p_in = [commonpath, pathin{m}, filesep];
        p_out = [commonpath, pathout{m}, filesep];
        VEPepoch(p_in, p_out);
        VEPplot(p_out);
        combineBlocks(p_out);
    end
    
    % grand average VEPs and combined block plots
    channels = [23,24];
    condition = {'inside', 'outside'};
    commonpath = ['matFilesForBigPlot_VEP\'];
    methods = {'filtered', 'asr', 'rasr'};
    limits = [-6,6];
    for m = 1 : 3 % methods
        for c = 1 : 2 % conditions
            p = [commonpath, methods{m},'/MergedBlocks/', condition{c}, filesep ];
            fout = ['Figures/VEP/', methods{m}, '/merged_', condition{c}];
            grandAverageVEP(p, channels, limits, ['_', condition{c}], methods{m});
            mergedBlockPlot(p, [channels], [], true, [], fout, condition{c});
        end
    end

    % peak to peak map to check whether we look at P100-N125 difference instead of single peak
    conditions = {'inside', 'outside'};
    commonpath = ['matFilesForBigPlot_VEP\'];
    methods = {'filtered', 'asr', 'rasr'};
    for m = 1 : 3 % methods
        for c = 1 : 2 % conditions
            p = [commonpath, methods{m},'/MergedBlocks/', conditions{c}, filesep ];
            peakToPeakMapVEP(p, [23,24],[-6,6], conditions{c}, methods{m});
        end
    end
    
    
    %%%%%%%%%%%%%%%%%%%
    %% STATISTIC THINGS
    %%%%%%%%%%%%%%%%%%%
    cd 'Statistics/';
    statisticalAnalysesPreps_01()
end