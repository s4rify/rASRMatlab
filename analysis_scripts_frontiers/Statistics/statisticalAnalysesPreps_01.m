function [] = statisticalAnalysesPreps_01()
    %
    %
    % Developed in Matlab 9.0.0.341360 (R2016a) on PCWIN64
    % at University of Oldenburg.
    % Sarah Blum (sarah.blum@uol.de), 2018-04-13 13:43
    %-------------------------------------------------------------------------
    
    %% blink
    p_blink = '../matFilesForBigPlot_BLINK/';
    channel = [1,2];
    index = [123:126]; % blink is at 125 per definitionem
    [AMP_INSIDE] = amplitudes_blinks(p_blink, channel, index, 'inside');
    SNR_raincloud(AMP_INSIDE, 'Blink Amplitudes inside', '/blinks/sme/big_AMP_inside');
    
    [AMP_OUTSIDE] = amplitudes_blinks(p_blink, channel, index, 'outside');
    SNR_raincloud(AMP_OUTSIDE, 'Blink Amplitudes outside', '/blinks/sme/big_AMP_outside');
   
    % concatenate inside and outside values
    % in blinks, uncorrected is first, then asr, then rasr
    AMP_uncorrected = [AMP_INSIDE{1}, AMP_OUTSIDE{1}];
    AMP_asr = [AMP_INSIDE{2}, AMP_OUTSIDE{2}];
    AMP_rasr = [AMP_INSIDE{3}, AMP_OUTSIDE{3}];
    csvwrite('data/blink_uncorrected.csv',   AMP_uncorrected);
    csvwrite('data/blink_asr.csv',   AMP_asr);
    csvwrite('data/blink_rasr.csv',   AMP_rasr);
    
    %% VEP 
    % SNR
    p_vep = '../matFilesForBigPlot_VEP/';
    channel = [23,24];
    % inside
    [~,SNR_N125_IN, SNR_DIFF_IN] = SNR_VEP(p_vep, channel, 'inside');
    SNR_raincloud(SNR_N125_IN, 'Diff SNR inside', '/VEP/big_VEP_SNR_diff_inside');
    % outside
    [~, SNR_N125_OUT, SNR_DIFF_OUT] = SNR_VEP(p_vep, channel, 'outside');
    SNR_raincloud(SNR_N125_OUT, 'Diff SNR outside', '/VEP/big_VEP_SNR_diff_outside');
    SNR_asr = [SNR_N125_IN{1}, SNR_N125_OUT{1}];
    SNR_uncorr = [SNR_N125_IN{2}, SNR_N125_OUT{2}];
    SNR_rasr = [SNR_N125_IN{3}, SNR_N125_OUT{3}];
    csvwrite('data/vep_snr_uncorrected.csv',  SNR_uncorr);
    csvwrite('data/vep_snr_asr.csv',   SNR_asr);
    csvwrite('data/vep_snr_rasr.csv',   SNR_rasr);
    % AMPLITUDES
    % inside
    [~, AMP_N125_IN, AMP_DIFF_IN] = amplitudes_VEP(p_vep, channel, 'inside');
    SNR_raincloud(AMP_N125_IN, 'Diff Amplitudes inside', '/VEP/big_VEP_AMP_diff_inside');
    % outside
    [~, AMP_N125_OUT, AMP_DIFF_OUT] = amplitudes_VEP(p_vep, channel, 'outside');
    SNR_raincloud(AMP_N125_OUT, 'Diff Amplitudes outside', '/VEP/big_VEP_AMP_diff_outside');
    
    AMP_VEP_asr = [AMP_N125_IN{1}, AMP_N125_OUT{1}];
    AMP_VEP_uncorrected = [AMP_N125_IN{2}, AMP_N125_OUT{2}];
    AMP_VEP_rasr = [AMP_N125_IN{3}, AMP_N125_OUT{3}];
    csvwrite('data/vep_amp_uncorrected.csv',  AMP_VEP_uncorrected);
    csvwrite('data/vep_amp_asr.csv',   AMP_VEP_asr);
    csvwrite('data/vep_amp_rasr.csv',   AMP_VEP_rasr);

end


