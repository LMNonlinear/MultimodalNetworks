restoredefaultpath
% addpath(genpath('..\ResamplingfMRIpipeline\external'));
% addpath(genpath('.\external'));
%%
% % addpath('F:\codes\spm12')
% % % spm
% % % spm('quit')
% % % spm_cfg
% % % spm('cmdline')
% % spm('defaults','EEG')
%% barinstorm
addpath('D:\codes\brainstorm\brainstorm_190516\brainstorm3')
% brainstorm('nogui')
brainstorm('setpath')
%% fieldtrip
% addpath('E:\Rigel\codes\fieldtrip-20161224')
% ft_defaults
%%
data_dir='M:\MEEGfMRI\Data\HCP_S900\';
%%
filename = './temp/config.mat';
save(filename)



