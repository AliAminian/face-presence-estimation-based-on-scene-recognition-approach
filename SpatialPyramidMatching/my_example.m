% Example of how to use the BuildPyramid function
% set image_dir and data_dir to your actual directories
image_dir = 'images'; 
data_dir = 'data';
pyramid_all = BuildPyramid(filenames,image_dir,data_dir);
% compute histogram intersection kernel
K = hist_isect(pyramid_all, pyramid_all); 
hist(K(:)) ;
% for faster performance, compile and use hist_isect_c:
% K = hist_isect_c(pyramid_all, pyramid_all);
i = 2 ;