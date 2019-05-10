function [] = VEPplot(p)
%
% VEPplot.m--
%
% Input arguments: 
%
% Output arguments: 
%
% Other m-files required:   
%
% Example usage:   
%
%
% Developed in Matlab 9.0.0.341360 (R2016a) on PCWIN64
% at University of Oldenburg.
% Sarah Blum (sarah.blum@uol.de), 2018-12-03 13:21
%-------------------------------------------------------------------------
flist = dir([p, '/', '*.mat']);
method = strsplit(p, '/');
% initial subplot indices
k = 1;
L = 5;
c = 1;
subj = 1;

% open several figs
for fig = 1: ceil(length(flist)/20)
    s=1;
    fighandle = figure('rend', 'painters', 'pos', [0,0, 900, 1000] );
    supertitle(['VEP comparison, epoched on visual markers ', method{2}, num2str(fig) ]);
    
    % get names of preprocessed data (ASSUMES SORTED FOLDER CONTENT!!)
    flist = dir([p, '*.mat']);
    %  load files from folder and plot
    
    for i = k: 20 % 20 on one figure
       
        if subj > length(flist)
            break;
        end
        
        I = load([p, flist(subj).name]);
        % use the last two channels, no matter on which reference
        ch1 = I.ALL.nbchan;
        ch2 = I.ALL.nbchan -1;
        CHANNEL = mean(mean(I.ALL.data([ch1,ch2],:,:),1),3);
        
        % index for topo
        id = 100:110;
        [amp, id] = min(CHANNEL(90:115));
        id = id +90; % account for offset
        
        % topo
        subplot(10, 4, s)
        topoplot(mean(mean(I.ALL.data(:,id:id+3,:),3),2), I.ALL.chanlocs);
        % insert title at column head (first topo) which indicates the method that was used
        title(I.ALL.setname, 'Interpreter' , 'none');
        
        % insert channel time course below topo
        subplot(10,4,s+4)
        plot(CHANNEL);
        axis tight
        title(['trials: ', num2str(size(I.ALL.data,3)), ', index: ',num2str(id)]);
       
         if mod(s,4) == 0 % one row complete
            % adapt subplot index for next row
            s = s + 5;
        else
            s= s+1;
        end
        subj = subj + 1;
    end
    
    clear CHANNEL
end
% with a new figure, we want to load new datasets
k = k+5;
L = L+5;
end

