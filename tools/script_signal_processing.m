load ..\temp\config.mat

% fmriNiftiPath=['..\result\',subjectName,'.4k.surface.matched.fMRI_REST_LR.nii'];
% megNiftiPath=['..\result\',subjectName,'.4k.source.matched.MEG_REST_LR.nii'];
%
% sampleRateFmri=1000/750;
% idxTimeFmri=[1:1200];
% tFmri=(idxTimeFmri-idxTimeFmri(1))/sampleRateFmri;
%
% fmriNifti=load_nii(fmriMatPath, [idxTimeFmri]);
% % fmriNifti=load_nii(fmriNiftiPath);
% fmriSignal=squeeze(fmriNifti.img);
%
% sampleRateMeg=int32(250);%raw data is 2034.5101Hz
% idxTimeMeg=[sampleRateMeg*30:sampleRateMeg*60];
% tMeg=double(idxTimeMeg-idxTimeMeg(1))/double(sampleRateMeg);
% megNifti=load_nii(megNiftiPath, [idxTimeMeg]);
% % megNifti=load_nii(megNiftiPath);
% megSignal=squeeze(megNifti.img);
%%
clear; close all; clc
load ..\temp\config.mat
fmriMatPath=['..\result\',subjectName,'.4k.surface.matched.fMRI_REST_LR.mat'];
megMatPath=['..\result\',subjectName,'.4k.source.matched.MEG_REST_LR.mat'];

sampleRateFmri=1000/750;
idxTimeFmri=[1:1200];
tFmri=(idxTimeFmri-idxTimeFmri(1))/sampleRateFmri;
% fmriMat=load(fmriMatPath, [idxTimeFmri]);
fmriMat=load(fmriMatPath);
fmriSignal=fmriMat.fmriSignal;

sampleRateMeg=int32(250);%raw data is 2034.5101Hz
idxTimeMeg=[sampleRateMeg*30:sampleRateMeg*60];
tMeg=double(idxTimeMeg-idxTimeMeg(1))/double(sampleRateMeg);
% megNifti=load(megMatPath, [idxTimeMeg]);
megMat=load(megMatPath);
megSignal=megMat.megSignal;
%%
figure
subplot(2,1,1)
plot(fmriSignal(1,:)');
subplot(2,1,2)
plot(megSignal(1,:)');
% %%
% figure
% subplot(2,1,1)
% [fmriPxx,fmriF] = periodogram(fmriSignal(1,:),[],length(tFmri),sampleRateFmri);
% plot(fmriF,10*log10(fmriPxx))
% subplot(2,1,2)
% [megPxx,megF] = periodogram(megSignal(1,:),[],length(tMeg),sampleRateMeg);
% plot(megF,10*log10(megPxx))
% %%




%%

% 
% % Process: Power spectrum density (Welch)
% sFiles = bst_process('CallProcess', 'process_psd', sFiles, [], ...
%     'timewindow',  [], ...
%     'win_length',  4, ...
%     'win_overlap', 50, ...
%     'sensortypes', 'MEG, EEG', ...
%     'win_std',     0, ...
%     'edit',        struct(...
%          'Comment',         'Power', ...
%          'TimeBands',       [], ...
%          'Freqs',           [], ...
%          'ClusterFuncTime', 'none', ...
%          'Measure',         'power', ...
%          'Output',          'all', ...
%          'SaveKernel',      0));
% 
% % Process: Group in time or frequency bands
% sFiles = bst_process('CallProcess', 'process_tf_bands', sFiles, [], ...
%     'isfreqbands', 1, ...
%     'freqbands',   {'delta', '2, 4', 'mean'; 'theta', '5, 7', 'mean'; 'alpha', '8, 12', 'mean'; 'beta', '15, 29', 'mean'; 'gamma1', '30, 59', 'mean'; 'gamma2', '60, 90', 'mean'}, ...
%     'istimebands', 0, ...
%     'timebands',   {}, ...
%     'overwrite',   0);



