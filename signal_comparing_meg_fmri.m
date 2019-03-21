% clear;clc;
close all;
%% FLAG
FLAG_LOAD_DATA=0;
FLAG_DISPLAY=1;
FLAG_DISPLAY_REULT=1;
%%
NUM_SUBJ=num2str(105923);
%% path
wb_command='D:\Software\workbench\bin_windows64\wb_command.exe';
PATH_DATASET='F:\MEEGfMRI\Data\HCP_S900\';
pipeline_path=mfilename('fullpath');
[pipeline_path, pipeline_name, ~] = fileparts(pipeline_path);

%% fmri downsampled signal
signal.fmri.path={'.\data\105923.rs.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.L.nii'...
    '.\data\105923.rs.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.R.nii'};


%% MEG raw signal
signal.meg_raw.path={'F:\MEEGfMRI\Data\HCP_S900\105923\unprocessed\MEG\3-Restin\4D\c,rfDC'};
signal.meg_raw.header=ft_read_header(signal.meg_raw.path);
%% MEG filterd
%% MRI
signal.mri.path={[PATH_DATASET,NUM_SUBJ,'\MEG\anatomy\',NUM_SUBJ,'.L.midthickness.4k_fs_LR.surf.gii'],...
    [PATH_DATASET,NUM_SUBJ,'\MEG\anatomy\',NUM_SUBJ,'.R.midthickness.4k_fs_LR.surf.gii']};
gii.left=gifti(signal.mri.path{1}); %cortical surface 
gii.right=gifti(signal.mri.path{2});
signal.mri.faces{1}=gii.left.faces;
signal.mri.faces{2}=gii.right.faces;

signal.mri.vertices{1}=gii.left.vertices;
signal.mri.vertices{2}=gii.right.vertices;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% file_read
if FLAG_LOAD_DATA==1
    signal.fmri.signal=niftiopen(signal.fmri.path);
    signal.meg_raw.signal=ft_read_data(signal.meg_raw.path);
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% figure
% MEG
idx=find(signal.meg_raw.header.grad.chanpos(:,3)>0.2);
plot3(signal.meg_raw.header.grad.chanpos(:,1),signal.meg_raw.header.grad.chanpos(:,2),signal.meg_raw.header.grad.chanpos(:,3),'.')
hold on
plot3(signal.meg_raw.header.grad.chanpos(idx,1),signal.meg_raw.header.grad.chanpos(idx,2),signal.meg_raw.header.grad.chanpos(idx,3),'o')
% MRI
% plotatlas(gii.left);
% plotatlas(gii.right);


