function [frames1,descr1]=sift_detector(image)

%I1=imreadbw(file_name1) ;
%imreadbow
I=im2double(image) ;
if(size(I,3) > 1)
  I = rgb2gray( I ) ;
end

I=I-min(I(:)) ;
I=I/max(I(:)) ;

fprintf('Computing frames and descriptors.\n') ;
[frames1,descr1,gss1,dogss1] = sift( I, 'Verbosity', 1 ) ;



