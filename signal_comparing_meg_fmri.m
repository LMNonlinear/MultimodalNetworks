clear;close all;clc;
%% FLAG

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
surfSignal(1).path_fmri={'F:\MEEGfMRI\Data\SignalComparing\data\105923.rs.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.L.nii'...
'F:\MEEGfMRI\Data\SignalComparing\data\105923.rs.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.R.nii'};


%% fmri raw signal 
surfSignal(1).path_fmri_raw={'F:\MEEGfMRI\Data\HCP_S900\105923\MNINonLinear\Result\rfMRI_REST1_LR\rfMRI_REST1_LR_Atlas_hp2000_clean.R.nii' ...
'F:\MEEGfMRI\Data\HCP_S900\105923\MNINonLinear\Result\rfMRI_REST1_LR\rfMRI_REST1_LR_Atlas_hp2000_clean.L.nii'};

%% MEG raw signal 
surfSignal(1).path_meg={'F:\MEEGfMRI\Data\HCP_S900\105923\MEG\Restin\icablpenv'};
surfSignal(1).path_meg=file_find(surfSignal(1).path_meg{1},'*.power.dtseries.nii', 1,0);%brainsotrm
% for i=1:max(size(surfSignal.path_meg))

%% file_read
surfSignal(1).signal_fmri=niftiopen(surfSignal(1).path_fmri);
surfSignal(1).signal_fmri_raw=niftiopen(surfSignal(1).path_fmri_raw);
for i=1:2
    surfSignal(1).signal_meg{i}=ft_read_cifti(surfSignal(1).path_meg{i});
end

%% correlation
% corrMarix{1,2}.time=corr(surfSignal(1).signal_fmri{1},surfSignal(2).signal_fmri{1});
% figure;imagesc(corrMarix{1,2}.time,[-1,1]);
% figure;plot(diag(corrMarix{1,2}.time));
% corrMarix{1,2}.channel=corr(surfSignal(1).signal_fmri{1}',surfSignal(2).signal_fmri{1}');
% figure;imagesc(corrMarix{1,2}.channel,[-1,1]);
% figure;plot(diag(corrMarix{1,2}.channel));
%% leastsuqare
% mseMarix{1,2}.time=mse(surfSignal(1).signal_fmri{1},surfSignal(2).signal_fmri{1});
% figure;imagesc(mseMarix{1,2}.time,[-1,1]);
% figure;plot(diag(mseMarix{1,2}.time));
% mseMarix{1,2}.channel=mse(surfSignal(1).signal_fmri{1}',surfSignal(2).signal_fmri{1}');
% figure;imagesc(mseMarix{1,2}.channel,[-1,1]);
% figure;plot(diag(mseMarix{1,2}.channel));









