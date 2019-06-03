function varargout= fun_hcp_meg_saveas_nifti(varargin)

switch nargin
    case 0
        load .\temp\fun_hcp_meg_inverse_pipeline.mat
        megSignal= Results.ImageGridAmp;
    case 1
        load .\temp\config.mat
        megSignal=varargin{1};
    case 2
        SubjectName=varargin{1};        
        megSignal=varargin{2};
end
addpath('.\external\nifti-analyze-matlab\');

%% creat nii
img=reshape(megSignal,[size(megSignal,1),1,1,size(megSignal,2)]);

% img=[varargin{1}];
description='Source MEG signal- Create by CCCLAB';
nii = make_nii(img, [], [], [],description);
%%
pathOutput=['.\result\',SubjectName,'.',num2str(round(size(megSignal,1)/2000)),'k.source.MEG_REST_LR.nii'];
save_nii(nii,pathOutput);
varargout{1}=pathOutput;
end


