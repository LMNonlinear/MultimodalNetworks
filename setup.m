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
addpath('E:\Rigel\codes\brainstorm3')
% brainstorm('nogui')
brainstorm('setpath')
%% fieldtrip
% addpath('E:\Rigel\codes\fieldtrip-20161224')
% ft_defaults
%% default demo para
ProtocolName='HCPPipeline';
data_dir='E:\Rigel\MEEGfMRI\Data\HCP_S900\';
SubjectName = '105923';
%%
filename = './temp/config.mat';
save(filename)



