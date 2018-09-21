function     [model] = MFD_Train_face_detection...
    (train_number_images,train_image_path, train_data_path, train_vec ,params, postfix)
%% Pictures setting parameters
    
    for i=1:train_number_images
        pic_name='';
        pic_name_name = strcat(pic_name,num2str(i)) ;
        pic_name=strcat(pic_name_name, postfix);
        filenames{i} = pic_name;
    end
%PYRAMID MATCHING
    rebuild_pyramid_all = MFD_Spatial_Pyramid_Matching(filenames, params, train_image_path, train_data_path) ;
%Matlab SVM
    model = svmtrain(rebuild_pyramid_all, train_vec',  'Method', 'SMO') ;
end