function IND = searchIndices(data)
    
    % first index: positive
    [~, id1] = max(data(60:105));
    IND(1) = id1 + 59;

    % second index: negative and must be after first peak
    [~, id2] = min(data(IND(1)+1:IND(1)+40));
    IND(2) = id2 + IND(1);
    
    % peaks are too close together
    if abs(IND(1) - IND(2)) < 4
        [~, id1] = max(data(60:90));
        IND(1) = id1 + 59;
        [~, id2] = min(data(IND(1)+1:IND(1)+25));
        IND(2) = id2 + IND(1);
    end
     % we are way too late
    if IND(1) + IND(2) > 211
         [~, id1] = max(data(60:70));
        IND(1) = id1 + 59;
        [~, id2] = min(data(70:90));
        IND(2) = id2 + 69;
        
    end
    % check every single peak
%     figure;
%     hold on
%     plot(data)
%     plot(IND(1), data(IND(1)), '*')
%     plot(IND(2), data(IND(2)), '*')
%     disp('debug here')
end