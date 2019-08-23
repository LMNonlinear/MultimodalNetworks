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
    case 'KBOLABPC'
        %% barinstorm
        addpath('F:\codes\brainstorm\brainstorm_190820\brainstorm3')
        addpath('.\function\')
        addpath('.\external\')
        brainstorm('setpath')
        %% directory parameter
        dataDir='F:\MEEGfMRI\Data\HCP_S900\';
        wb_command='D:\Software\workbench\workbench\bin_windows64\wb_command.exe';
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
rootPath=pwd;
%% default parameter for processing signal
%not finish passing to all place needed
%fmri
fmriInfo.sampleRate=1000.0/750.0;
fmriInfo.indexTime=[fmriInfo.sampleRate*30:fmriInfo.sampleRate*60-1];%% use part of data,30s->60s
fmriInfo.time=(fmriInfo.indexTime-fmriInfo.indexTime(1))/fmriInfo.sampleRate;
%mri
megInfo.sampleRateRaw=2034.5101;%raw data is 2034.5101Hz, need as an iput
megInfo.sampleRate=250;%raw data is 2034.5101Hz, need as an iput
megInfo.indexTime=[megInfo.sampleRate*30:megInfo.sampleRate*60-1];
megInfo.time=double(megInfo.indexTime-megInfo.indexTime(1))/double(megInfo.sampleRate);
megInfo.bandsFreqs= {'delta', '2, 4', 'mean','3','2';...
    'theta', '5, 7', 'mean','6','2';...
    'alpha', '8, 12', 'mean','10','4';...
    'beta', '15, 29', 'mean','22','29';...
    'gamma', '30, 90', 'mean','60','60';...
    'gamma1', '30, 59', 'mean','45','30';...
    'gamma2', '60, 90', 'mean','75','30'};
megInfo.bandBounds = process_tf_bands('GetBounds', megInfo.bandsFreqs);
megInfo.nFreqBands=size(megInfo.bandBounds,1);
%% file folder
if exist('temp','dir')==0
   mkdir('temp');
end
if exist('result','dir')==0
   mkdir('result');
end
if exist('figure','dir')==0
   mkdir('figure');
end
%% save
filename = './temp/config.mat';
save(filename)

