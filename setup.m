close all;clear;clc;
restoredefaultpath
[~, hostname] = system('hostname');
hostname=string(strtrim(hostname));
switch hostname
    case 'KBOMATEBOOKXPRO'
        %% barinstorm
        addpath('D:\codes\brainstorm\brainstorm_190516\brainstorm3')
        addpath('.\function\')
        addpath('.\external\')
        brainstorm('setpath')
        %% directory parameter
        dataDir='M:\MEEGfMRI\Data\HCP_S900\';
        wb_command='D:\Software\workbench\bin_windows64\wb_command.exe';
    case 'HPCwin'
        %% barinstorm
        addpath('E:\Rigel\codes\brainstorm\brainstorm3')
        addpath('.\function\')
        addpath('.\external\')
        brainstorm('setpath')
        %% directory parameter
        dataDir='E:\Rigel\MEEGfMRI\Data\HCP_S900\';
        wb_command='E:\Rigel\codes\workbench\bin_windows64\wb_command.exe';
end
%% demo parameter
subjectName = '105923';
protocolName='HCPMEGPipeline';%for brainstorm hcp meg preprocessing and inverse pipeline

%% default parameter for processing signal
%not finish passing to all place needed
%fmri
fmriInfo.sampleRate=1000/750;
fmriInfo.indexTime=[fmriInfo.sampleRate*30:fmriInfo.sampleRate*60-1];%% use part of data,30s->60s
fmriInfo.time=(fmriInfo.indexTime-fmriInfo.indexTime(1))/fmriInfo.sampleRate;
%mri
megInfo.sampleRateRaw=2034.5101;%raw data is 2034.5101Hz, need as an iput
megInfo.sampleRate=250;%raw data is 2034.5101Hz, need as an iput
megInfo.indexTime=[megInfo.sampleRate*30:megInfo.sampleRate*60-1];
megInfo.time=double(megInfo.indexTime-megInfo.indexTime(1))/double(megInfo.sampleRate);
megInfo.bandsFreqs= {'delta', '2, 4', 'mean';...
    'theta', '5, 7', 'mean';...
    'alpha', '8, 12', 'mean';...
    'beta', '15, 29', 'mean';...
    'gamma', '30, 90', 'mean';...
    'gamma1', '30, 59', 'mean';...
    'gamma2', '60, 90', 'mean'};
megInfo.bandBounds = process_tf_bands('GetBounds', megInfo.bandsFreqs);
megInfo.nFreqBands=size(megInfo.bandBounds,1);

%% save
filename = './temp/config.mat';
save(filename)

