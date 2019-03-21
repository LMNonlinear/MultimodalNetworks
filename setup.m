restoredefaultpath
addpath(genpath('F:\MEEGfMRI\Data\ResamplingfMRIpipeline\external'));
% addpath(genpath('.\external'));
%%
addpath('F:\codes\spm12')
spm
%% barinstorm
addpath('F:\codes\brainstorm3')
brainstorm('nogui')
%% fieldtrip
addpath('F:\codes\fieldtrip-20161224')
ft_defaults
