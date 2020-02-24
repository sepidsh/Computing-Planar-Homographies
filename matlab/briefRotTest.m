% Your solution to Q2.1.5 goes here!

%% Read the image and convert to grayscale, if necessary
img = imread('../data/cv_cover.jpg');
%% Compute the features and descriptors
p = detectFASTFeatures(img);
[desc, locs] = computeBrief(img, p.Location);

ps = detectSURFFeatures(img);
[features, valid_points] = extractFeatures(img, ps, 'Method', 'SURF');

c = zeros(37,1);
csurf = zeros(37,1);
fig = figure()
for i = 0:36
    %% Rotate image
    imgr = imrotate(img, 10*i);
    %% Compute features and descriptors
    p2 = detectFASTFeatures(imgr);
    [desc2, locs2] = computeBrief(imgr, p2.Location);
    %% Match features
    [indexPairs,matchmetric] = matchFeatures(desc,desc2,'MatchThreshold',10.0);
    %% Update histogram
    c(i+1)=size(indexPairs,1);
    if(i==1 | i==4 | i==9 | i==12 |i==15| i==20 )
        showMatchedFeatures(img, imgr, locs2(indexPairs(:,2),:), locs(indexPairs(:,1),:), 'montage')
        saveas(fig, strcat('../results/4_2_Brief_',int2str(10*i),'.png'));
    end
    
    ps2 = detectSURFFeatures(imgr);
    [features2, valid_points2] = extractFeatures(imgr, ps2, 'Method', 'SURF');
    [indexPairs,matchmetric] = matchFeatures(features,features2,'MatchThreshold',1.0);
    if(i==1 | i==4 | i==9 | i==12 |i==15| i==20 )
        showMatchedFeatures(img, imgr, valid_points2.Location(indexPairs(:,2),:), valid_points.Location(indexPairs(:,1),:), 'montage')
        saveas(fig, strcat('../results/4_2_Surf_',int2str(10*i),'.png'));
    end
    cs(i+1) = size(indexPairs,1);
end
%% Display histogram
plot(c);
saveas(fig, '../results/4_2_Brief_hist.png');
plot(cs);
saveas(fig, '../results/4_2_Surf_hist.png');