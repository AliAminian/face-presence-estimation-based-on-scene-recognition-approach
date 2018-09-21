function MFD_face_detection

    clc ; clear all ;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %SetParameter%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    train_number_images     = 387;
    test_number_image       = 256 ;
    postfix = '.pgm' ;
    
    dictionary_size         = 10 ;
    pyramid_level           = 2 ;
    
    delete_train_infos      = 0 ;
    delete_test_infos       = 1 ;
    %Auto Set%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Pyramid matching parameter%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    params.maxImageSize         = 1000;
%     params.gridSpacing          = 1;
%     params.patchSize            = 16;
    params.dictionarySize       = dictionary_size;
%     params.numTextonImages      = 300;
    params.pyramidLevels        = pyramid_level;
%     params.oldSift              = false;
%     canSkip                     =  1;
%     saveSift                    = 1 ;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %SetPathes%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    addpath('.\Sift');
    addpath('.\SpatialPyramidMatching') ;
    
    
    
    train_data_path=        '.\data_train' ;%TMP Data
    test_data_path=         '.\data_test' ;%TMP Data
    train_image_path=       '.\Pics_train\' ;
    test_image_path =        '.\Pics_test\' ;
    xls_filename = '.\Results\Results.xlsx' ;
    
    train_vec = [(ones(1, 240)), (0*ones(1, 147))] ; %MATLAB SVM
    test_vec = [(ones(1, 160)), (0*ones(1, 96))] ;
    
    if(size(train_vec, 2) ~= train_number_images)
        error('Check train_number_images And train_vec size');
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if delete_train_infos
        delete('./data_train/*.mat') ; 
    end
    if delete_test_infos
        delete('./data_test/*.mat') ; 
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Training
    model = MFD_Train_face_detection...
    (train_number_images,train_image_path, train_data_path, train_vec ,params, postfix);

%% Test

    counter = 0;
    for i=1:test_number_image
        pic_name='';
        counter = counter +1 ;
        pic_name_name = strcat(pic_name,num2str(i)) ;
        pic_name=strcat(pic_name_name, postfix);
        impath = strcat(test_image_path,pic_name) ;
        filenames{1} = pic_name;   

        tic ;
        TestSet(counter, :) = MFD_Spatial_Pyramid_Matching(filenames, params, test_image_path, test_data_path) ;
        SVMout(i, 1) = svmclassify(model, TestSet(counter, :));
        SVMout(i, 2) = toc ;
    end

    xlswrite(xls_filename,SVMout,'ATT3') ;
    %SVMout_all = svmclassify(model, TestSet);
    
    SampleScaleShift = bsxfun(@plus,TestSet,model.ScaleData.shift);
    Sample      = bsxfun(@times,SampleScaleShift,model.ScaleData.scaleFactor);
    sv          = model.SupportVectors;
    alphaHat    = model.Alpha;
    bias        = model.Bias;
    kfun        = model.KernelFunction;
    kfunargs    = model.KernelFunctionArgs;
    f = kfun(sv,Sample,kfunargs{:})'*alphaHat(:) + bias;
    Confidence = f*-1;
    
    [X,Y,T,AUC] = perfcurve(test_vec,Confidence,1);
    plot(X,Y,'LineWidth',3,'Color','k');
    xlabel('False positive rate');
    ylabel('True positive rate');
    title('ROC for database #5');
    AUC
    
end
