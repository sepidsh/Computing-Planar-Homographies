# Computing-Planar-Homographies
This code is for implementing an AR application step by step using planar homographies.
1. Feature Detection
Before finding the homography between an image pair, we need to find corresponding point pairs between two images. But how do we get these points? One way is to select them manually (using cpselect), which is tedious and inefficient. The CV way is to find interest points in the image pair and automatically match them. In the interest of being able to do cool stuff, we will not reimplement a feature detector or descriptor here, but use built-in MATLAB methods. The purpose of an interest point detector (e.g. Harris, SIFT, SURF, etc.) is to find particular salient points in the images around which we extract feature descriptors (e.g. MOPS, etc.). These descriptors try to summarize the content of the image around the feature points in as succinct yet descriptive manner possible (there is often a trade-off between representational and computational complexity for many computer vision tasks; you can have a very high dimensional feature descriptor that would ensure that you get good matches, but computing it could be prohibitively expensive). Matching, then, is a task of trying to find a descriptor in the list of descriptors obtained after computing them on a new image that best matches the current descriptor. This could be something as simple as the Euclidean distance between the two descriptors, or something more complicated, depending on how the descriptor is composed. For the purpose of this exercise, we shall use the widely used FAST detector in concert with the BRIEF descriptor. 
Now implement the following function:
[locs1, locs2] = matchPics(I1, I2)

where I1 and I2 are the images you want to match. locs1 and locs2 are N × 2 matrices containing the x and y coordinates of the matched point pairs. Use the Matlab built-in function detectFASTFeatures to compute the features, then build descriptors using the provided computeBrief function and finally compare them using the built-in method matchFeatures. Use the function showMatchedFeatures(im1, im2, locs1, locs2, ‘montage’) to visualize your matched points and include the result image in your write-up. An example is shown in Fig. 2.

There is a threshold parameter on matchFeatures() that must be tweaked to see things:
matchFeatures(..., 'MatchThreshold', threshold);
Threshold should be 10.0 at default for binary descriptors and 1.0 otherwise. BRIEF is a binary descriptor, but matlab fails to set 10.0 for some reason (use 1.0 instead). Specify the threshold to be 10.0 for BRIEF descriptor. You may also need to increase MaxRatio parameter.

We provide you with the function:
					
[desc, locs] = computeBrief(img, locs in)
					
which computes the BRIEF descriptor for img. locs in is an N × 2 matrix in which each row represents the location (x, y) of a feature point. Please note that the number of valid output feature points could be less than the number of input feature points. desc is the corresponding matrix of BRIEF descriptors for the interest points.

2. BRIEF and Rotations.
Let’s investigate how BRIEF works with rotations. Write a script briefRotTest.m that:
					
Takes the cv cover.jpg and matches it to itself rotated [Hint: use imrotate] in increments of 10 degrees.
Stores a histogram of the count of matches for each orientation.
Plots the histogram using plot
					
Visualize the feature matching result at three different orientations and include them in your write-up

3. Homography Computation (3 pts)
Write a function computeH that estimates the planar homography from a set of matched point pairs.					
function [H2to1] = computeH(x1, x2)


x1 and x2 are N × 2 matrices containing the coordinates (x, y) of point pairs between the two images. H2to1 should be a 3 × 3 matrix for the best homography from image 2 to image 1 in the least-square sense. You can use eig or svd to get the eigenvectors as described above in this handout

4. Homography Normalization
Normalization improves numerical stability of the solution and you should always normalize your coordinate data. Normalization has two steps:
Translate the mean of the points to the origin.
Scale the points so that the average distance to the origin (or you could also try “the largest distance to the origin” to compare) is sqrt(2). This is a linear transformation and can be written as follows:
					
x’1 = T1 x1
x’2 = T2 x2
							
where x’1 and x’2 are the normalized homogeneous coordinates of x1 and x2. T1 and T2 are 3 × 3 matrices. The homography H from x’2  to  x’1 computed by computeH satisfies:

x’1 = H x’2

By substituting x’1 and x’2  with T1 x1  and T2 x2 , we have

T1 x1=H T2  x2

By following the above procedure, implement the function computeH_norm:

function [H2to1] = computeH_norm(x1, x2).

This function should normalize the coordinates in x1 and x2 and call computeH(x1, x2). 

5.RANSAC.
The RANSAC algorithm can generally fit any model to noisy data. You will implement it for (planar) homographies between images. Remember that 4 point-pairs are required at a minimum to compute a homography.					
Write a function:
					
function [bestH2to1, inliers] = computeH_ransac(locs1, locs2)
					
where bestH2to1 should be the homography H with most inliers found during RANSAC. H will be a homography such that if x2 is a point in locs2 and x1 is a corresponding point in locs1, then x1 ≡ H x2. locs1 and locs2 are N × 2 matrices containing the matched points. inliers is a vector of length N with a 1 at those matches that are part of the consensus set, and 0 elsewhere. Use computeH norm to compute the homography. 


