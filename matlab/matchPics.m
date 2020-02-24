function [ locs1, locs2] = matchPics( I1, I2, test)
%MATCHPICS Extract features, obtain their descriptors, and match them!

%% Convert images to grayscale, if necessary
gI1 = I1;
gI2 = rgb2gray(I2);

if(~test)
    p1 = detectFASTFeatures(gI1);
    p2 = detectFASTFeatures(gI2);
    
    [desc1, locs1] = computeBrief(gI1, p1.Location);
    [desc2, locs2] = computeBrief(gI2, p2.Location);    
    [indexPairs,matchmetric] = matchFeatures(desc1,desc2,'MatchThreshold',10.0);
else
    p1 = detectSURFFeatures(gI1);
    p2 = detectSURFFeatures(gI2);
    [desc1, locs1] = extractFeatures(gI1, p1.Location, 'Method', 'SURF');
    [desc2, locs2] = extractFeatures(gI2, p2.Location, 'Method', 'SURF');
    % use 0.7 for pictures and 1.2 for video.
    [indexPairs,matchmetric] = matchFeatures(desc1,desc2,'MatchThreshold',1.2);
end
locs1 = locs1(indexPairs(:,1),:);
locs2 = locs2(indexPairs(:,2),:);
if(test)
    locs1 = locs1.Location;
    locs2 = locs2.Location;
else
    fig = figure()
    showMatchedFeatures(I1, I2, locs1, locs2, 'montage')
    saveas(fig, '../results/4_1.png');
end
end

