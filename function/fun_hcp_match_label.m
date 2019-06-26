function varargout= fun_hcp_match_label(varargin)
outputType='mat';
switch nargin
    case 0
        load .\temp\config.mat
        fmriNiftiPath=['.\result\',subjectName,'.4k.surface.fMRI_REST_LR.nii'];
        megNiftiPath=['.\result\',subjectName,'.4k.source.MEG_REST_LR.nii'];
        fmriLabelPath={['.\result\',subjectName,'.rs.from32k.4k.aparc.32k_fs_LR.L.label.gii']...
            ['.\result\',subjectName,'.rs.from32k.4k.aparc.32k_fs_LR.R.label.gii']};
    case 1
        subjectName=varargin{1};
        fmriNiftiPath=['.\result\',subjectName,'.4k.surface.fMRI_REST_LR.nii'];
        megNiftiPath=['.\result\',subjectName,'.4k.source.MEG_REST_LR.nii'];
        fmriLabelPath={['.\result\',subjectName,'.rs.from32k.4k.aparc.32k_fs_LR.L.label.gii']...
            ['.\result\',subjectName,'.rs.from32k.4k.aparc.32k_fs_LR.R.label.gii']};
    case 4
        subjectName=varargin{1};
        fmriNiftiPath=varargin{2};
        megNiftiPath=varargin{3};
        fmriLabelPath=varargin{4};
    case 5
        subjectName=varargin{1};
        fmriNiftiPath=varargin{2};
        megNiftiPath=varargin{3};
        fmriLabelPath=varargin{4};
        outputType=varargin{5};
end
addpath('.\external\nifti-analyze-matlab\');
addpath('.\external\cifti-nan-matlab\');
FLAG_DISPLAY=0;
%% READ DATA
% fmriNiftiL=nifti(['.\result\',subjectName,'.rs.from32k.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.L.nii']);
% fmriNiftiR=nifti(['.\result\',subjectName,'.rs.from32k.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.R.nii']);

%
% fmriSignal=[squeeze(fmriNiftiL.img);squeeze(fmriNiftiR.img)];
% fmriSignal=[squeeze(double(fmriNiftiL.dat));squeeze(double(fmriNiftiR.dat))];
% fmriLabelL=gifti(['.\result\',subjectName,'.rs.from32k.4k.105923.aparc.32k_fs_LR.L.label.gii']);
% fmriLabelR=gifti(['.\result\',subjectName,'.rs.from32k.4k.105923.aparc.32k_fs_LR.R.label.gii']);

fmriNifti=load_nii(fmriNiftiPath);
megNifti=load_nii(megNiftiPath);
fmriLabelL=gifti(fmriLabelPath{1});
fmriLabelR=gifti(fmriLabelPath{2});
fmriSignal=squeeze(double(fmriNifti.img));
megSignal=squeeze(double(megNifti.img));
labelAll=[fmriLabelL.cdata;fmriLabelR.cdata];
labelName=fmriLabelL.labels.name;
%% debug, need remove
[~, hostname] = system('hostname');
hostname=string(strtrim(hostname));
switch hostname
    case 'KBOMATEBOOKXPRO'
        fmriSignal=fmriSignal(:,200:500-1);
        megSignal=megSignal(:,12000:12400-1);
end

%% SET MEDIAL WALL
fmriSignal(labelAll==0,:)=0;
megSignal(labelAll==0,:)=0;

fmriNifti.img=reshape(fmriSignal,[size(fmriSignal,1),1,1,size(fmriSignal,2)]);
megNifti.img=reshape(megSignal,[size(megSignal,1),1,1,size(megSignal,2)]);
switch outputType
    case 'nifti'
        fmriPathOutput=strrep(fmriNiftiPath,['surface'],['surface.matched']);
        save_nii(fmriNifti,fmriPathOutput);
        megPathOutput=strrep(megNiftiPath,['source'],['source.matched']);
        save_nii(megNifti,megPathOutput);
    case 'mat'
        fmriPathOutput=strrep(fmriNiftiPath,['surface'],['surface.matched']);
        fmriPathOutput=strrep(fmriPathOutput,['.nii'],['.mat']);
        megPathOutput=strrep(megNiftiPath,['source'],['source.matched']);
        megPathOutput=strrep(megPathOutput,['.nii'],['.mat']);
        dtseries=fmriSignal;
        save(fmriPathOutput,'dtseries','-v7.3');
        %         bst_save(fmriPathOutput,fmriSignal,'v7.3');
        dtseries=megSignal;
        save(megPathOutput,'dtseries','-v7.3');
        %         bst_save(megPathOutput,,megSignal,'v7.3');
end
fmriLabelPathOutput=strrep(fmriLabelPath{1},['L.label.gii'],['label.mat']);
label.labelL=fmriLabelL.cdata;
label.labelR=fmriLabelR.cdata;
label.attribute=fmriLabelL.labels;
%         save(fmriLabelPathOutput,'labelL','labelR','attribute')
% save(fmriLabelPathOutput,'-struct',label,'-v7.3');
bst_save(fmriLabelPathOutput,label,'v7.3');

%%
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




