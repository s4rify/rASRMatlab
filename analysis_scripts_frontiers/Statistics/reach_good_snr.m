function [SNR] = reach_good_snr(p, saveFigs)
%
% reach_good_snr.m
% How many trials do we need to reach a good SNR of the N100?
%
%
% Other m-files required:
%
% Subfunctions:
%
% output: something like
%
% SNR ^
%     |
%     |     ASR       ICA
%     |----/--------/-------- good SNR
%     |   /        /
%     |  /        /
%     o----------------------> trials
%
% Developed in Matlab 9.0.0.341360 (R2016a) on PCWIN64
% at University of Oldenburg.
% Sarah Blum (sarah.blum@uol.de), 2018-05-22 11:25
%-------------------------------------------------------------------------


% 01_raw, 02_ica, 03_oasr, 04_rasr
methods = dir2(p);
signalofinterest = p(end-5:end-1);


%% iterate through the methods
for meth_idx = 1: 4
    flist = dir([p, methods(meth_idx).name, '/', '*.mat']);
    
    for subj_idx = 1: length(flist)
        %% load subject data epoched and sorted by cleaning method
        I = load([p, methods(meth_idx).name, '/', flist(subj_idx).name]);
        
        ntrials = size(I.ALL.data,3);
        ntrials = 100;
        
        %% search best channel and index using all trials
        currentMinN100_ampl = 0;
        bestChannel = 20;
        for channel = [8]
            % average all trials of this subject for the best channel and index computation
            epoch = mean(mean(I.ALL.data(channel, :,:),3),1);
            
            % search for the N100 after the stimulus presentation which is at center of epoch
            [n100_amp, current_index] = min(epoch(20:60));
            current_index = current_index+20;
            
            % save this index, channel and amp if it is better than the one before for the minimum search
            if n100_amp < currentMinN100_ampl
                currentMinN100_ampl = n100_amp;
                bestChannel = channel;
                best_index = current_index;
            end
        end
        
        % compute epoch with best channel again for the plot
        epoch =  mean(mean(I.ALL.data(bestChannel,:,:),3),1);
        
        if saveFigs
            % plot epoch and corresponding topo for the N100
            figure('rend','painters','pos',[100 100 1000 800]);
            supertitle(['N100 SNR with increasing trial number. ', flist(subj_idx).name(1:end-4)]);
            subplot(2,2,1)
            hold on
            plot(epoch)
            plot(best_index, currentMinN100_ampl, '*')
            xlabel('Samples'); ylabel('\muV');
            %legend(['channel: ',num2str(bestChannel)], 'Location', 'SouthWest');
            subplot(2,2,2)
            topoplot(mean(mean(I.ALL.data(:,[best_index:best_index+1],:),3),2),...
                I.ALL.chanlocs,...
                'emarker2', {[bestChannel], 'o', 'w'});      % mark used channel in white
            
            %% after determining the best channel and index, we now increase the number of used trials for the SNR
            %% computation incrementally and plot the results
            subplot(2,2,[3,4])
            hold all
        end
        
        idx = 1;
        %  take steps of ten until we reach the max number of trials for this subject
        for t = 10:10:ntrials
            % for every trial iteration, we sample several times
            for r = 1: ntrials/10;
                
                % sample new trials with each loop
                randomtrials = randsample(ntrials, t);
                
                odd =  mean(mean(I.ALL.data(bestChannel, [best_index: best_index+1] ,randomtrials(1:2:t)),2),3);
                even = mean(mean(I.ALL.data(bestChannel, [best_index: best_index+1] ,randomtrials(2:2:t)),2),3);
                noise = abs(odd - even);
                
                % look for minimum after stimulus onset at epochcenter
                signal = abs(mean(mean(I.ALL.data(bestChannel,[best_index:best_index+1],randomtrials),2),3));
                
                % snr
                snr(idx,r) = 20*log10(signal/noise);
                
            end
            idx = idx +1;
            
        end % end trial loop
        
        SNR{meth_idx}{subj_idx} = snr;
        
        
        if saveFigs
            % plot SNR development with increasing number of trials
            boxplot(snr', 'plotstyle', 'compact', 'Labels',{10:10:ntrials})
            xlabel('Trials used for computation'); ylabel('SNR [dB]');
            %set(gcf, 'Position', get(0, 'Screensize'));
            %print('-depsc', ['Figures/N100/reachGoodSNR/',[num2str(subj_idx),'_',methods(meth_idx).name(end-3:end),'boxplot.eps']]);
            %print('-dpng', ['../Figures/N100/reachGoodSNR/',[num2str(subj_idx),'_',methods(meth_idx).name(end-3:end),'boxplot.png']]);
            %close;
        end
        clear snr
        
    end % end file loop
    
    
end % end method loop