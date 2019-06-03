function varargout= fun_hcp_match_label(varargin)

switch nargin
    case 0
        load .\temp\config.mat
    case 1
        SubjectName=varargin{1};
    case 3
        SubjectName=varargin(1);
        fmriNiftiPath=varargin(2);
        megNiftiPath=varargin(3);
end
addpath('.\external\nifti-analyze-matlab\');
addpath('.\external\cifti-nan-matlab\');
FLAG_DISPLAY=0;
%% READ DATA
% fmriNiftiL=nifti(['.\result\',SubjectName,'.rs.from32k.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.L.nii']);
% fmriNiftiR=nifti(['.\result\',SubjectName,'.rs.from32k.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.R.nii']);
fmriNiftiPath=['.\result\',SubjectName,'.4k.surface.fMRI_REST_LR.nii'];
megNiftiPath=['.\result\',SubjectName,'.4k.source.MEG_REST_LR.nii'];
fmriNifti=load_nii(fmriNiftiPath);
megNifti=load_nii(megNiftiPath);
fmriLabelL=gifti(['.\result\',SubjectName,'.rs.from32k.4k.105923.aparc.32k_fs_LR.L.label.gii']);
fmriLabelR=gifti(['.\result\',SubjectName,'.rs.from32k.4k.105923.aparc.32k_fs_LR.R.label.gii']);
%
% fmriSignal=[squeeze(fmriNiftiL.img);squeeze(fmriNiftiR.img)];
% fmriSignal=[squeeze(double(fmriNiftiL.dat));squeeze(double(fmriNiftiR.dat))];
fmriSignal=squeeze(double(fmriNifti.img));
megSignal=squeeze(double(megNifti.img));
labelAll=[fmriLabelL.cdata;fmriLabelR.cdata];
labelName=fmriLabelL.labels.name;
%% SET MEDIAL WALL
fmriSignal(labelAll==0,:)=0;
megSignal(labelAll==0,:)=0;

fmriNifti.img=reshape(fmriSignal,[size(fmriSignal,1),1,1,size(fmriSignal,2)]);
megNifti.img=reshape(megSignal,[size(megSignal,1),1,1,size(megSignal,2)]);

fmriPathOutput=strrep(fmriNiftiPath,['surface'],['surface.matched']);
save_nii(fmriNifti,fmriPathOutput);
megPathOutput=strrep(megNiftiPath,['source'],['source.matched']);
save_nii(megNifti,megPathOutput);

output(1).path=fmriPathOutput;
output(2).path=megPathOutput;
output(1).type='fmri';
output(2).type='meg';

varargout{1}=output;

%
if FLAG_DISPLAY==1
    fmriTimeSum=sum(fmriSignal,2);
    fmriTimeNan=fmriTimeSum;
    fmriTimeNan(fmriTimeNan~=0)=1;
    
    megTimeSum=sum(megSignal,2);
    megTimeNan=megTimeSum;
    megTimeNan(megTimeNan~=0)=2;
    
    labelNan=labelAll;
    labelNan(labelNan~=0)=3;
    labelNan=labelNan;
    % labelNan=labelNan;
    
    
    % close all
    figure
    plot(fmriTimeNan);hold on;
    plot(megTimeNan);hold on;
    plot(labelNan);
    figure
    plot(double(labelNan)-3*double(fmriTimeNan))
end
%




