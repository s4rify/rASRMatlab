function [nt] = grandAverageBlink2(p, channels, toposcale, yscale, extraInfo, id)
    %
    %
    % Developed in Matlab 9.0.0.341360 (R2016a) on PCWIN64
    % at University of Oldenburg.
    % Sarah Blum (sarah.blum@uol.de), 2018-12-07 16:28
    %-------------------------------------------------------------------------
    flist = dir2([p, '*.mat']);
    % setup of intial parameters
    rows = 2;
    columns = 3;
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    % first combine everything from all subjects
    for i = 1: length(flist)
        disp(['loading ', num2str(i), '..'])
        % add variable with name MERGED to the workspace
        S = load([p,flist(i).name]);
        % since the save call cannot handle named fields, we have to figure out what the inside of our mat
        % file looks like. it will contain combined blocks in any case which we can use the same for all use
        % cases
        names =  fieldnames(S);
        MERGED = getfield(S,names{1});
        MEAN(i,:) = mean(mean(MERGED.data([channels],:,:),1),3);
        MEANTOPO(i,:) = mean(mean(MERGED.data(:,id,:),2),3);
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, MERGED, i);
        nt(i) = size(MERGED.data,3);
    end
    % open figure
    fig = figure( 'pos', [100, 0, 550,1000], 'rend', 'painters');
    method = strsplit(p, '/');
    supertitle(['Grand average BLINK, ', method{2},' ', extraInfo]);
    
    % TOPO
    subplot(rows,columns, [1,2,3]);
    topoplot(mean(MEANTOPO,1), MERGED.chanlocs, 'maplimits', toposcale);
    title([num2str(MERGED.times(id)), ' ms']);
    colorbar;
    
    % TIME COURSE
    subplot(rows,columns,[4,5,6]);
    xax = MERGED.times;
    hold all
    plot(xax,MEAN, 'Color', [211,211,211]/256, 'LineWidth',1);
    ylim(yscale);
    plot(xax, mean(MEAN),'k', 'LineWidth', 4);
    ylim(yscale);
    xlim([xax(1),xax(end)]);
    nsubj = size(ALLEEG,2);
    ntrials = mean(nt);
    title(['Blinks from ', num2str(nsubj),' subjects, mean number of blinks ', num2str(round(ntrials)), ' per subject' ]);
    legend('single subject mean','grand average');
    xlabel('ms');
    ylabel('\muV');
    
    % SAVE FIGURE
    set(fig, 'Color', [1,1,1]);
    saveas(fig,['Figures/blinks/sme/', [method{2}, extraInfo, '_GA'] ,'.fig']);
end