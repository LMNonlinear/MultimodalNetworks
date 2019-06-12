% close all;clear;clc;
restoredefaultpath
%% barinstorm
% addpath('E:\Rigel\codes\brainstorm3')
addpath('D:\codes\brainstorm\brainstorm_190516\brainstorm3')
addpath('.\function\')
brainstorm('setpath')
%% demo parameter
ProtocolName='HCPMEGPipeline';
% data_dir='E:\Rigel\MEEGfMRI\Data\HCP_S900\';
data_dir='M:\MEEGfMRI\Data\HCP_S900\';
SubjectName = '105923';
wb_command='D:\Software\workbench\bin_windows64\wb_command.exe';

%% save
filename = './temp/config.mat';
save(filename)



