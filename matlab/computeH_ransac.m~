function [ bestH2to1, inliers, Besty] = computeH_ransac( locs1, locs2)
%COMPUTEH_RANSAC A method to compute the best fitting homography given a
%list of matching points.
Threshold = 0.5;
N = 400;
BestH = 0;
BestC = -1;
Besty = -1;
BestD = -1;
for i=1:N
    y = datasample([1:size(locs1)],4,'Replace',false);
    H = computeH_norm(locs1(y,:),locs2(y,:));
    p2 = [locs2, ones(size(locs2,1),1)];
    p1_pred = H*p2';
    p1_pred = p1_pred./p1_pred(3,:);
    p1_pred = p1_pred';
    dists = sqrt((locs1(:,1)-p1_pred(:,1)).^2 + (locs1(:,2)-p1_pred(:,2)).^2);
    dists = dists<Threshold;
    if(sum(dists)>BestC)
        BestC = sum(dists);
        BestH = H;
        Besty = y;
        BestD = dists;
    end
end
inliers=BestD;
bestH2to1=double(BestH);
end

