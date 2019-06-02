function varargout= fun_hcp_meg_saveas_nifti(varargin)

switch nargin
    case 0
        load .\temp\fun_hcp_meg_inverse_pipeline.mat
    case 1
        load .\temp\config.mat
        megSignal=varargin{1};
    case 2
        SubjectName=varargin{2};
        megSignal=varargin{1};
end
addpath('.\external\nifti-analyze-matlab\');

%% creat nii
% img=[varargin{1}];
img=reshape(Results.ImageGridAmp,[size(Results.ImageGridAmp,1),1,1,size(Results.ImageGridAmp,2)]);
description='Source MEG signal- Create by CCCLAB';
nii = make_nii(img, [], [], [],[]);
%%
save_nii(nii,['.\result\',SubjectName,'.',num2str(round(size(Results.ImageGridAmp,1)/2000)),'k.source.MEG_REST_LR.nii'])
end


