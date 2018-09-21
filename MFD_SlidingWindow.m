function [BoxPoints, number_window] = MFD_SlidingWindow(img)

Sliding_SubImg_Path =   '.\Slid_SubImgs\' ;
win_size= [128, 128];

counter = 1;
counter_imagesize = 0;
for s=0.25:0.25:1
  X=win_size(1);
  Y=win_size(2);
  counter_imagesize = counter_imagesize+1;
  Bimg = imresize(img,s);
  [lastRightCol lastRightRow d] = size(Bimg);
  for y = 1:X/4:lastRightCol-Y
      for x = 1:Y/4:lastRightRow-X
          p1 = [x,y];
          p2 = [x+(X-1), y+(Y-1)];
          po = [p1; p2] ;

          crop_px = [po(1,1) po(2,1)];
          crop_py  = [po(1,2) po(2,2)];
          topLeftRow = ceil(min(crop_px));
          topLeftCol = ceil(min(crop_py));
          bottomRightRow = ceil(max(crop_px));
          bottomRightCol = ceil(max(crop_py));

          imnumber_name = strcat(num2str(counter), num2str(counter_imagesize));
          subimpath = strcat(strcat(Sliding_SubImg_Path,imnumber_name), '.jpg') ;
          image = Bimg(topLeftCol:bottomRightCol,topLeftRow:bottomRightRow,:);
          %imwrite(image, subimpath, 'jpg') ;
          BoxPoints{counter}.Name = imnumber_name ;
          BoxPoints{counter}.Coordinate = [x,y,X,Y];
                  
          counter = counter+1;                    
          x = x+2 ;
     end
  end
end
number_window = counter-1;
end