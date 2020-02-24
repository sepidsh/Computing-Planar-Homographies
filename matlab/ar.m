% Q3.3.1
clc;clear;
cv_img = imread('../data/cv_cover.jpg');
vid1 = loadVid("../data/ar_source.mov");
vid2 = loadVid("../data/book.mov");
parfor i=1:size(vid1,2)
    i
  
    [locs1, locs2] = matchPics(cv_img, vid2(i).cdata,true);
    [bestH2to1, ~] = computeH_ransac(locs1, locs2);
    
    tmp_img=vid1(i).cdata;
    cropped_img=tmp_img(60:270, 40:400, :);
    scaled_img = imresize(cropped_img, [size(cv_img,1) size(cv_img,2)]);
    vid1(i).cdata = compositeH(inv(bestH2to1), scaled_img, vid2(i).cdata);
end

v = VideoWriter('../results/5.avi','Motion JPEG AVI');
open(v)
for i=1:size(vid1,2)
    writeVideo(v,vid1(i).cdata);
end
close(v)