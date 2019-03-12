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
%% fMRI signal 32kto6k
surfSignal(1).path_fmri={'F:\MEEGfMRI\Data\SignalComparing\data\105923.rs.from32k.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.L.nii'...
'F:\MEEGfMRI\Data\SignalComparing\data\105923.rs.from32k.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.R.nii'};
surfSignal(1).signal_fmri=niftiopen(surfSignal(1).path_fmri);
%% fmri signal 8kto6k
surfSignal(2).path_fmri={'F:\MEEGfMRI\Data\SignalComparing\data\105923.rs.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.L.nii'...
'F:\MEEGfMRI\Data\SignalComparing\data\105923.rs.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.R.nii'};
surfSignal(2).signal_fmri=niftiopen(surfSignal(2).path_fmri);

%% correlation
corrMarix{1,2}.time=corr(surfSignal(1).signal_fmri{1},surfSignal(2).signal_fmri{1});
figure;imagesc(corrMarix{1,2}.time,[-1,1]);
figure;plot(diag(corrMarix{1,2}.time));
corrMarix{1,2}.channel=corr(surfSignal(1).signal_fmri{1}',surfSignal(2).signal_fmri{1}');
figure;imagesc(corrMarix{1,2}.channel,[-1,1]);
figure;plot(diag(corrMarix{1,2}.channel));
%% leastsuqare
% mseMarix{1,2}.time=mse(surfSignal(1).signal_fmri{1},surfSignal(2).signal_fmri{1});
% figure;imagesc(mseMarix{1,2}.time,[-1,1]);
% figure;plot(diag(mseMarix{1,2}.time));
% mseMarix{1,2}.channel=mse(surfSignal(1).signal_fmri{1}',surfSignal(2).signal_fmri{1}');
% figure;imagesc(mseMarix{1,2}.channel,[-1,1]);
% figure;plot(diag(mseMarix{1,2}.channel));









