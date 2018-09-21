function MFD_linkage_classify(pic_name, data_path, img)

    [points,descr]=sift_detector(img);
    y = points(1:2,:) ;
    [wid, hgt]= size(img) ;
    features.data = descr;
    features.x = y(1, :) ;
    features.y = y(2, :) ;
    features.wid = wid;
    features.hgt = hgt;
    outFName = fullfile(data_path, sprintf('%s_sift.mat', pic_name));
    sp_make_dir(outFName);
    save(outFName, 'features');
end