% save all timing matrices and do not save cleaned data

%% ASR
% Riemannian ASR
PATHIN = 'sme_data/filtered/';
PATHOUT = 'sme_data/rASR_out/';
params = {
    'flatline', 1
    'hp' , [0.25 0.95]
    'channel', 0.85
    'noisy', 4 % std dev for removing chnnels
    'burst', 3 % std dev for removing samples
    'c_window', 0.3 % how much dirt can be left in the final output
    ... processing values from here on ...
    'cutoff', 1
    'p_window', 0.3
    'stepsize', 16
    'maxdims', 1
    };
% this saves three timing measurements:
% 1) the whole cleaning:                            CALIB
% 2) cleaning of processing data with all steps:    PROC
% 3) the pure processing algorithm alone:           MINIMAL
ASR_time_measurement_only('rASRToolbox/', PATHIN, PATHOUT, 'rASR', params);

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
ASR_time_measurement_only('oASRToolbox/', PATHIN, PATHOUT, 'ASR', params);