function varargout= fun_hcp_fmri_saveas_nifti(varargin)

switch nargin
    case 0
        load .\temp\config.mat
        fmriNiftiL=nifti(['.\result\',subjectName,'.rs.from32k.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.L.nii']);
        fmriNiftiR=nifti(['.\result\',subjectName,'.rs.from32k.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.R.nii']);
        fmriSignal=[squeeze(double(fmriNiftiL.dat));squeeze(double(fmriNiftiR.dat))];
    case 1
        load .\temp\config.mat
        fmriSignal=varargin{1};
    case 2
        fmriSignal=varargin{1};
        subjectName=varargin{2}; 
    case 3
        subjectName=varargin{1};
        fmriNiftiL=nifti(varargin(2));
        fmriNiftiR=nifti(varargin(3));
        fmriSignal=[squeeze(double(fmriNiftiL.dat));squeeze(double(fmriNiftiR.dat))];
end
addpath('.\external\nifti-analyze-matlab\');

%% creat nii
img=reshape(fmriSignal,[size(fmriSignal,1),1,1,size(fmriSignal,2)]);
% img=[varargin{1}];
description='Surface fMRI signal- Create by CCCLAB';
nii = make_nii(img, [], [], [],description);
%%
pathOutput=['.\result\',subjectName,'.',num2str(round(size(fmriSignal,1)/2000)),'k.surface.fMRI_REST_LR.nii'];
save_nii(nii,pathOutput);
varargout{1}=pathOutput;
end


