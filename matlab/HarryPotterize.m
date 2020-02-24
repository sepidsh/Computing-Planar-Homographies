%Q2.2.4
clear all;
close all;

cv_img = imread('../data/cv_cover.jpg');
desk_img = imread('../data/cv_desk.png');
hp_img = imread('../data/hp_cover.jpg');

%% Extract features and match
%change true to false to see the part 1 answer 
[locs1, locs2] = matchPics(cv_img, desk_img,true);

%% Compute homography using RANSAC
fig = figure()

[H2to1] = computeH(locs1, locs2);
p = [locs2, ones(size(locs2,1),1)];
p_pred = H2to1*p';
p_pred = p_pred./p_pred(3,:);
p_pred = p_pred';
p_pred = p_pred(:,1:2)

showMatchedFeatures(cv_img, desk_img, p_pred, locs2, 'montage')
saveas(fig, '../results/4_3.png');

[H2to1] = computeH_norm(locs1, locs2);
p = [locs2, ones(size(locs2,1),1)];
p_pred = H2to1*p';
p_pred = p_pred./p_pred(3,:);
p_pred = p_pred';
p_pred = p_pred(:,1:2)

showMatchedFeatures(cv_img, desk_img, p_pred, locs2, 'montage')
saveas(fig, '../results/4_4.png');

[bestH2to1, inliers, besty] = computeH_ransac(locs1, locs2);
p = [locs2, ones(size(locs2,1),1)];
p_pred = H2to1*p';
p_pred = p_pred./p_pred(3,:);
p_pred = p_pred';
p_pred = p_pred(:,1:2)

showMatchedFeatures(cv_img, desk_img, locs1(besty, :), locs2(besty, :), 'montage')
saveas(fig, '../results/4_5_points.png');
showMatchedFeatures(cv_img, desk_img, locs1(inliers>0, :), locs2(inliers>0, :), 'montage')
saveas(fig, '../results/4_5_inliers.png');

%% Scale harry potter image to template size
% Why is this is important?
scaled_hp_img = imresize(hp_img, [size(cv_img,1) size(cv_img,2)]);

%% Display warped image.
imshow(warpH(scaled_hp_img, inv(bestH2to1), size(desk_img)));

%% Display composite image
imshow(compositeH(inv(bestH2to1), scaled_hp_img, desk_img));
saveas(fig, '../results/4_6.png');
