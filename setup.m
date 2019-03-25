restoredefaultpath
addpath(genpath('F:\MEEGfMRI\Data\ResamplingfMRIpipeline\external'));
% addpath(genpath('.\external'));
%%
% % addpath('F:\codes\spm12')
% % % spm
% % % spm('quit')
% % % spm_cfg
% % % spm('cmdline')
% % spm('defaults','EEG')
%% barinstorm
addpath('F:\codes\brainstorm3')
% brainstorm('nogui')
brainstorm('setpath')
%% fieldtrip
addpath('F:\codes\fieldtrip-20161224')
ft_defaults
