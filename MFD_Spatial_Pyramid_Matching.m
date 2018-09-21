function [rebuild_pyramid_all] = MFD_Spatial_Pyramid_Matching(filenames, params, image_path, data_path) 
%% processing histograms

    pyramid_all = BuildPyramid(filenames,image_path,data_path, params);
    
    hist_numbers = (size(pyramid_all, 2)/params.dictionarySize) ;
    rebuild_pyramid_all = 0 ;% initialize output
    for cnt_images=1 : size(pyramid_all, 1)
        word_num = 1 ;
        for cnt_dic=1: params.dictionarySize
            for cnt_hist = 1 : hist_numbers
                number = ((cnt_hist-1)*params.dictionarySize)+cnt_dic ;
                rebuild_pyramid_all(cnt_images, word_num) = pyramid_all(cnt_images, number) ;
                word_num = word_num+1 ;
            end
        end
    end
 end