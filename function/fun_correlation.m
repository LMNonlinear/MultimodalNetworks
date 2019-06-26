function varargout=fun_correlation(varargin)

switch nargin
    case 0
        load ./temp/config.mat
        
    case 1
        subjectName=varargin{1};
        
end
%%
labelPath=['.\result\',subjectName,'.rs.from32k.4k.105923.aparc.32k_fs_LR.label.mat'];
labelMat=load(labelPath);
label=labelMat.fmriLabel.label;
%%
megPath=['.\result\',subjectName,'.4k.source.matched.band.envelope.MEG_REST_LR.mat'];
megMat=load(megPath);

