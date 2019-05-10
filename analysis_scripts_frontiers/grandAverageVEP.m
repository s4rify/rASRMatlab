function [] = grandAverageVEP(p, channels, toposcale,extraInfo, meth)
    %
    % Developed in Matlab 9.0.0.341360 (R2016a) on PCWIN64
    % at University of Oldenburg.
    % Sarah Blum (sarah.blum@uol.de), 2018-12-06 15:40
    %-------------------------------------------------------------------------
    flist = dir2([p]);
    %% define colormap for fancy colors in shaded line plot
    my_map = [...[136, 84, 208]/255; ...  % purple
        [128, 142, 155]/255; ...  % grey
        [56, 103, 214]/255;...    % blue
        [52, 231, 228]/255 ...    % red
        ];
    
    % setup of intial parameters
    rows = 2; % time course and topos
    columns = 2; % how many topos
    m = 1;
    sp = 1;
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
        % search indices
        IND = searchIndices(MEAN(i,:));
        
        % interpolate channel T8 for the topoplots
        MERGED = pop_interp(MERGED, 12, 'spherical');
        MEANTOPO1(i,:) = mean(mean(MERGED.data(:,IND(1),:),2),3);
        MEANTOPO2(i,:) = mean(mean(MERGED.data(:,IND(2),:),2),3);
        %MEANTOPO3(i,:) = mean(mean(MERGED.data(:,IND(3),:),2),3);

        nt(i) = size(MERGED.data,3);
        all_IND(i,:) = [IND].';
    end

    nsubj = 27;
    ntrials = mean(nt);
    fig = figure( 'pos', [100, 0, 550,1000], 'rend', 'painters');
    supertitle(['Grand average VEP, ', meth, ' , mean ntrials per subj: ', num2str(round(ntrials)),', ', extraInfo]);

    % TOPOs
    subplot(rows,columns, [1]);
    topoplot(mean(MEANTOPO1), MERGED.chanlocs, 'maplimits', toposcale, 'emarker2', {[channels], '.', 'w'});
    
    subplot(rows,columns, [2]);
    topoplot(mean(MEANTOPO2), MERGED.chanlocs, 'maplimits', toposcale, 'emarker2', {[channels], '.', 'w'});
    colorbar;
    
    % TIME COURSE
    subplot(rows,columns,[3,4]);
    xax = MERGED.times;

    hold all
    ylim([-35,30]);
    xlim([xax(1),xax(end)]);
    % make grey boxes <3
    c(1,:) = [192,192,192]/256;
    c(2,:) = [200,200,200]/256;
    c(3,:) = [170,170,170]/256;
%     for a = 1:2
%         X = MERGED.times(min(all_IND(:,a))) : MERGED.times(max(all_IND(:,a)));
%         Y = repmat(25, length(X),1)';
%         level = -30;
%         a1 = area(X, Y, level);
%         a1.FaceColor = c(2,:);
%         a1.LineStyle = 'none';
%         a1.FaceAlpha = 0.5;
%     end

    % indicate topo indices with stars instead of area
    plot(xax(all_IND(:,1)),20, '.');
    plot(xax(all_IND(:,2)),-30, '.');
    plot(xax,MEAN, 'Color', [128,128,128]/256, 'LineWidth',1);
    plot(xax, mean(MEAN),'k', 'LineWidth', 4);

    title(['VEP averaged across ', num2str(nsubj),' subjects and ', num2str(ntrials), ' trials']);
    set(fig, 'Color', [1,1,1]);
    saveas(fig,['Figures/VEP/', [meth, '_GA', extraInfo] ,'.fig']);

end
