function [] = combineBlocks(p)
%
%
% Developed in Matlab 9.0.0.341360 (R2016a) on PCWIN64
% at University of Oldenburg.
% Sarah Blum (sarah.blum@uol.de), 2018-12-04 16:41
%-------------------------------------------------------------------------
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
INSIDE = ALLEEG;
OUTSIDE = ALLEEG;

flist = dir([p,'*.mat']);
f = 1;
a = 1;
ins = 1;
out = 1;

% load SUBJ structure to divide sets into inside and outside condition
load('sme_data/SUBJ.mat');

while f <= length(flist)
    % load one subject and store its id to make sure we combine blocks from the same subj only
    subj_info = strsplit(flist(f).name(1:end-4), '_');
    subj_id = subj_info{2};
    subj_block = subj_info{3};
    current_subj_id = subj_id;
    
    % as long as we load the same subject, store its blocks
    while current_subj_id == subj_id 
        I = load([p, flist(f).name]);
        if strcmp(SUBJ(str2num(subj_id)).CONDITION{a}, 'inside')
            % combine inside blocks 
            [INSIDE, ~,~] = eeg_store( INSIDE, I.ALL, ins);
            ins = ins+1;
        elseif strcmp(SUBJ(str2num(subj_id)).CONDITION{a}, 'outside')
            % combine outside blocks
            [OUTSIDE, ~,~] = eeg_store( OUTSIDE, I.ALL, out);
            out = out+1;
        else
            warning('this block did not have a valid inside-outside label')
            % ins and out are 4 if everything went according to plan. check them to see which entry in INSIDE
            % or OUTSIDE to remove if one block must be excluded. otherwise, the last entry will be from the
            % last subject and therefore contains wrong values
            if out < 4
                OUTSIDE(3) = [];
            elseif ins < 4
                INSIDE(3) = [];
            end
        end
        % store sets from one subj independently from condition
        [ALLEEG, ~, ~] = eeg_store( ALLEEG, I.ALL, a);
        
        % icrease block counter
        a = a+1;
        % get next subj
        f = f + 1;
        if f > length(flist)
            break
        end
        subj_info = strsplit(flist(f).name(1:end-4), '_');
        subj_id = subj_info{2};
        subj_block = subj_info{3};
    end
    
    % combine all blocks that belong to this subj
    % MERGED = pop_mergeset(ALLEEG, 1:size(ALLEEG,2), false);
    disp('not saving combined conditions!')
    MERGED_INSIDE = pop_mergeset(INSIDE, 1:size(INSIDE,2), false);
    MERGED_OUTSIDE = pop_mergeset(OUTSIDE, 1:size(OUTSIDE,2), false);

    subj_info = strsplit(flist(str2num(subj_id)).name(1:end-4), '_');
    nam = subj_id;
    method = strsplit(p, '/');
    
    %save([p, '/MergedBlocks/', nam, '.mat'], 'MERGED');
    disp('not saving combined conditions!')
    
    save([p, '/MergedBlocks/inside/', nam, '.mat'], 'MERGED_INSIDE');
    save([p, '/MergedBlocks/outside/', nam, '.mat'], 'MERGED_OUTSIDE');
    clear MERGED EEG  MERGED_INSIDE MERGED_OUTSIDE
    a = 1;  
    ins = 1;
    out = 1;
end
end