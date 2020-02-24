function [H2to1] = computeH_norm(x1, x2)

%% Compute centroids of the points
centroid1 = mean(x1,1);
centroid2 = mean(x2,1);

%% Shift the origin of the points to the centroid
orgx1 = x1;
orgx2 = x2;
x1 = x1-centroid1;
x2 = x2-centroid2;
%% Normalize the points so that the average distance from the origin is equal to sqrt(2).
s1 = (mean(sqrt(sum(x1.^2,2)))).*sqrt(2);
s2 = (mean(sqrt(sum(x2.^2,2)))).*sqrt(2);
x1 = x1./s1;
x2 = x2./s2;
%% similarity transform 1
T1 = [1/s1 0 -centroid1(1)/s1;
    0 1/s1, -centroid1(2)/s1;
     0 0 1];

%% similarity transform 2
T2 = [1/s2 0 -centroid2(1)/s2;
    0 1/s2, -centroid2(2)/s2;
     0 0 1];

%% Compute Homography
if(any(isnan(x2(:))))
        x2
end
l2 = computeH(x1,x2);
%% Denormalization
H2to1 = inv(T1)*l2*T2;
