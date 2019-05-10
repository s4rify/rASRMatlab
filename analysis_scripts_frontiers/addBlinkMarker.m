function [] = addBlinkMarker(pathin, pathout, path_blinker);
% Blinker toolbox did detect blinks on filtered, but otherwise uncorrected datsets and saved these indices for
% every subject in path_blinker. In this function, EEGLAB epoch event trigger are added at the indices of
% these detected blinks so that later we can use them like normal experimental triggers.
% We add the number '9' as an event here since it was not used during the paradigm.
% Data sets with these new triggers are saved as mat files in pathout. 
%
% Developed in Matlab 9.0.0.341360 (R2016a) on PCWIN64
% at University of Oldenburg.
% Sarah Blum (sarah.blum@uol.de), 2018-11-29 15:09
%-------------------------------------------------------------------------

[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
P = {pathin};
a = 1;
for p = 1 :  length(P)
    
    % get dataset name
    fnd = dir([P{p}, '*.set']);
    
    for f = 1: length(fnd)
        % load blinker mat file which contains blink indices
        fnb = dir([path_blinker, '*.mat']); % change problems here
        fnb(f).name;
        fnb(f).name;
        
        % load blink info
        S = load([path_blinker, fnb(f).name]); % change problems here
        
        % this is all blink indices for this dataset
        index = [S.blinkFits.maxFrame].';
        % load data
        EEG = pop_loadset('filename',[P{p}, fnd(f).name]);
        
        % turn blinks into events. note that we cannot have different types
        % of events in one EEG structure, so that we have to make
        % sure that the newly inserted marker fits the rest
        for e = 2:length(index-1)
            if ischar(EEG.event(1).type)
                EEG.event(end+1).type = '9';
            else
                EEG.event(end+1).type = 9;
            end
            EEG.event(end).duration = 1;
            EEG.event(end).latency = index(e);
        end
        EEG = eeg_checkset(EEG);
        %EEG = pop_saveset(EEG, [EEG.setname,'.set'], ['sme_data/plus_blink_events/',]);
        
        % this works for all events then
        marker = {'9'};
        EEG = pop_epoch( EEG, marker, [-0.5  0.5]);
        EEG = eeg_checkset(EEG);
        ALL = EEG;
        % save epoched EEG as mat file
        fname = EEG.setname(1:end-11);
        save([pathout, fname, '.mat'], 'ALL');
        
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, a);
        a = a+1;
        clear EEG ALL
    end
%         % combine all ALLEEG contents for later average plots
%         MERGED = pop_mergeset(ALLEEG, 1:size(ALLEEG,2), false);
%         method = strsplit(pathin, '/');
%         nam = method{2}; 
%         save(['matFilesForBigPlot_BLINK/Merged/', nam, '.mat'], 'MERGED');
%         clear MERGED
%         a = 1;
end
