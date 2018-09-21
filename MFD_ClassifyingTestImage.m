function [Classifying] = MFD_ClassifyingTestImage(model, number_window, class_number, params, BoxPoints)

Sliding_SubImg_Path = '.\Slid_SubImgs_data' ;
Slid_SubImgs = '.\Slid_SubImgs\' ;

canSkip                     =  1;
saveSift                    = 0 ;
subcounter = 0;
for i=1:number_window
    pic_subname='';
    subcounter = subcounter +1 ;
    %subpic_name_name = strcat(pic_subname,num2str(i)) ;
    subpic_name_name = BoxPoints{i}.Name ;
    pic_subname=strcat(subpic_name_name, '.jpg');
    sub_impath = strcat(Slid_SubImgs,pic_subname) ;
    subfilenames{1} = pic_subname;   

    MFD_linkage_classify(subpic_name_name, Sliding_SubImg_Path, imread(sub_impath), class_number) ;
    TestSet(subcounter, :) = MFD_Spatial_Pyramid_Matching(subfilenames, params, Slid_SubImgs, Sliding_SubImg_Path,  canSkip, saveSift) ;
end
%Classifying = svmclassify(model, TestSet);%MATLAB SVM
label = ones(number_window,1);
[~, Classifying] = svmclassify(TestSet,label,model); % SVM Light
end