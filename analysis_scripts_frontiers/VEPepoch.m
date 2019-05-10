function [] = VEPepoch(pathin, pathout)
%
% VEPepoch.m--
%
% Developed in Matlab 9.0.0.341360 (R2016a) on PCWIN64
% at University of Oldenburg.
% Sarah Blum (sarah.blum@uol.de), 2018-12-03 14:20
%-------------------------------------------------------------------------

% take data from sme_data/rasr_out and epoch them on marker 2,3
flist = dir([pathin, '*.set']);
epochlength = [-0.2, 0.6]; % in seconds

for i = 1: length(flist)
    fname = flist(i).name(1:end-4);
    
    % load data
    EEG = pop_loadset('filename',[pathin,flist(i).name]);
    
    % epoch on markers that begin with 3
    indices = find(~cellfun(@isempty,regexp({EEG.event.type},'^3 ')));
    %indices = [indices2, indices3];
    EEG = pop_epoch( EEG, {}, epochlength ,'eventindices', indices);
    EEG = pop_rmbase(EEG, [-200, 0]);
    %EEG = pop_jointprob(EEG,1,[1:EEG.nbchan],3,3,0,1,0,[],0);
    EEG = eeg_checkset(EEG);
    
    % save this subject as mat file
    ALL = EEG;
    save([pathout, fname, '.mat'], 'ALL')
       
    clear ALL indices
end