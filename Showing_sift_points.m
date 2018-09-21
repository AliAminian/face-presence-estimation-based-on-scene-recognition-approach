function [] = Showing_sift_points()

    addpath('.\Sift');
    %test_image_path     = '.\Pics_train\';
    test_image_path     = 'G:\FaceDetectionUsingSPM\conference and journals\IJARS\Sumbitted to IJARS\Submitted\code\ROC Curve\result\pure SVM(CVL)\Pics_test\';
    class_number        = 10 ;
    
    postfix = '.jpg' ;
    marks = ['.','-.',':','*','x','c*','s','o','d','^'] ;
    
    for i=241:250
        pic_name = '' ;
        pic_name_name = strcat(pic_name,num2str(i)) ;
        pic_name=strcat(pic_name_name, postfix);
        impath = strcat(test_image_path,pic_name) ;
        
        [points,descr]=sift_detector(imread(impath));
        y = points(1:2,:) ;
        Z = linkage(y', 'ward', 'euclidean') ;
        T = cluster(Z,'maxclust',class_number) ;
        
        t_size = size(T, 1) ;
        figure() ;
        imshow(impath);
        hold on
        for j=1:class_number
            for ind=1:t_size
                if T(ind,1) == j
                    plot(y(1, ind),y(2, ind),marks(j));
                end
            end
        end
    end

end