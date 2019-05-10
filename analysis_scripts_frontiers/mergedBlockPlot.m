function [] = mergedBlockPlot(pathin, channel_indices, topoidx, searchIndex, ylims, fout, condition)
%
%
%
% Developed in Matlab 9.0.0.341360 (R2016a) on PCWIN64
% at University of Oldenburg.
% Sarah Blum (sarah.blum@uol.de), 2018-12-06 10:01
%-------------------------------------------------------------------------

% initial subplot indices
k = 1;
L = 5;
subj = 1;
method = strsplit(pathin, '/');
% open 2 figs in total
for fig = 1: 2
    s=1;
    fighandle = figure('rend', 'painters', 'pos', [0,0, 900, 1000] );
    supertitle(['Combined Blocks per subj,', method{2} , num2str(fig), condition ]);
    % get names of preprocessed data (ASSUMES SORTED FOLDER CONTENT!!)
    flist = dir([pathin, '*.mat']);
    %  load files from folder and plot
    for i = k: 20 % 20 on one figure
       
        if subj > length(flist)
            break;
        end
        
        I = load([pathin, flist(subj).name]);
        names = fieldnames(I);
        MERGED = getfield(I,names{1});
        CHANNEL = mean(mean(MERGED.data([channel_indices(1), channel_indices(2)],:,:),1),3);
        if searchIndex
            topoidx = searchIndices(CHANNEL);
            % topoidx(1) = index of P100
            % topoidx(2) = index of N125
        end
        
        % topo
        subplot(10, 4, s)
        if size(topoidx) > 1
            topoplot(mean(mean(MERGED.data(:,topoidx(2),:),3),2), MERGED.chanlocs, ...
                'emarker2', {[channel_indices], '.', 'w'}); %, 'maplimits', ylims);
            title(num2str(subj));
        else
            topoplot(mean(mean(MERGED.data(:,topoidx,:),3),2), MERGED.chanlocs, ...
                'emarker2', {[channel_indices], '.', 'w'}); %, 'maplimits', ylims);
            title(num2str(subj));
        end
        
        % insert channel time course below topo
        subplot(10,4,s+4)
        plot(MERGED.times, CHANNEL);
        %ylim(ylims);
        axis tight
        if size(topoidx) > 1
            title([num2str(size(MERGED.data,3)), ', ',num2str(MERGED.times(topoidx(2)))]);
        else
            title([num2str(size(MERGED.data,3)), ', ',num2str(MERGED.times(topoidx))]);
        end
         if mod(s,4) == 0 % one row complete
            % adapt subplot index for next row
            s = s + 5;
        else
            s= s+1;
        end
        subj = subj + 1;
    end
    clear CHANNEL 
    saveas(fighandle,[fout, num2str(fig), '.fig']);
end
% with a new figure, we want to load new datasets
k = k+5;
L = L+5;
end