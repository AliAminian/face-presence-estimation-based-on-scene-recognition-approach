function [descriptors]=siftdescriptor_p(I,points)
[M,N,C] = size(I) ;

% Lowe's equivalents choices
S      =  3 ;
omin   = -1 ;
O      = floor(log2(min(M,N)))-omin-3 ; % up to 8x8 images
sigma0 = 1.6*2^(1/S) ;                  % smooth lev. -1 at 1.6
sigman = 0.5 ;
thresh = 0.04 / S / 2 ;
r      = 10 ;
NBP    = 4 ;
NBO    = 8 ;
magnif = 3.0 ;
gss = gaussianss(I,sigman,O,S,omin,-1,S+1,sigma0) ;
for o=1:1
sh = siftdescriptor(...
    gss.octave{o}, ...
    [points' ;ones(1,size(points,1))], ...
    gss.sigma0, ...
    gss.S, ...
    gss.smin, ...
    'Magnif', magnif, ...
    'NumSpatialBins', NBP, ...
    'NumOrientBins', NBO) ;

descriptors = [descriptors, sh] ;
end