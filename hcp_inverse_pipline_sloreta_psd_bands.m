% function tutorial_hcp_s900(tutorial_dir)
% TUTORIAL_HCP: Script that reproduces the results of the online tutorial "Human Connectome Project: Resting-state MEG".
%
% CORRESPONDING ONLINE TUTORIALS:
%     https://neuroimage.usc.edu/brainstorm/Tutorials/HCP-MEG
%
% INPUTS:
%     tutorial_dir: Directory where the HCP files have been unzipped

% @=============================================================================
% This function is part of the Brainstorm software:
% https://neuroimage.usc.edu/brainstorm
%
% Copyright (c)2000-2018 University of Southern California & McGill University
% This software is distributed under the terms of the GNU General Public License
% as published by the Free Software Foundation. Further details on the GPLv3
% license can be found at http://www.gnu.org/copyleft/gpl.html.
%
% FOR RESEARCH PURPOSES ONLY. THE SOFTWARE IS PROVIDED "AS IS," AND THE
% UNIVERSITY OF SOUTHERN CALIFORNIA AND ITS COLLABORATORS DO NOT MAKE ANY
% WARRANTY, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, NOR DO THEY ASSUME ANY
% LIABILITY OR RESPONSIBILITY FOR THE USE OF THIS SOFTWARE.
%
% For more information type "brainstorm license" at command prompt.
% =============================================================================@
%
% Author: Francois Tadel, 2017
% Modified by: Rigel 03/24/2019
clear;clc;close all;
tutorial_dir='E:\Rigel\MEEGfMRI\Data\HCP_S900\';
%% ===== FILES TO IMPORT =====
% You have to specify the folder in which the tutorial dataset is unzipped
% if (nargin == 0) || isempty(tutorial_dir) || ~file_exist(tutorial_dir)
if isempty(tutorial_dir) || ~file_exist(tutorial_dir)
    error('The first argument must be the full path to the tutorial dataset folder.');
end
% Subject name
% SubjectName = '175237';
SubjectName = '105923';

% Build the path of the files to import
AnatDir    = fullfile(tutorial_dir, SubjectName, 'MEG', 'anatomy');
Run1File   = fullfile(tutorial_dir, SubjectName, 'unprocessed', 'MEG', '3-Restin', '4D', 'c,rfDC');
NoiseFile  = fullfile(tutorial_dir, SubjectName, 'unprocessed', 'MEG', '1-Rnoise', '4D', 'c,rfDC');
% Check if the folder contains the required files
if ~file_exist(AnatDir) || ~file_exist(Run1File) || ~file_exist(NoiseFile)
    error(['The folder ' tutorial_dir ' does not contain subject #105923 from the HCP-MEG distribution.']);
end


%% ===== CREATE PROTOCOL =====
% The protocol name has to be a valid folder name (no spaces, no weird characters...)
ProtocolName = 'HCPsLoretaPsdBandsPipeline';
% Start brainstorm without the GUI
if ~brainstorm('status')
    brainstorm nogui
end
% Delete existing protocol
gui_brainstorm('DeleteProtocol', ProtocolName);
% Create new protocol
gui_brainstorm('CreateProtocol', ProtocolName, 0, 0);
% Start a new report
bst_report('Start');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ===== IMPORT DATA =====
% Process: Import anatomy folder
bst_process('CallProcess', 'process_import_anatomy', [], [], ...
    'subjectname', SubjectName, ...
    'mrifile',     {AnatDir, 'HCPv3'}, ...
    'nvertices',   15000);

% Process: Create link to raw files
sFilesRun1 = bst_process('CallProcess', 'process_import_data_raw', [], [], ...
    'subjectname',  SubjectName, ...
    'datafile',     {Run1File, '4D'}, ...
    'channelalign', 1);
sFilesNoise = bst_process('CallProcess', 'process_import_data_raw', [], [], ...
    'subjectname',  SubjectName, ...
    'datafile',     {NoiseFile, '4D'}, ...
    'channelalign', 1);
%%
%% ===== Resample Raw ===

% Process: Resample: 250Hz
sFilesRun1 = bst_process('CallProcess', 'process_resample', sFilesRun1, [], ...
    'freq',     250, ...
    'read_all', 1);

sFilesNoise = bst_process('CallProcess', 'process_resample', sFilesNoise, [], ...
    'freq',     250, ...
    'read_all', 1);

sFilesRaw = [sFilesRun1, sFilesNoise];


%% ===== PRE-PROCESSING =====
% Process: Notch filter: 60Hz 120Hz 180Hz 240Hz 300Hz
sFilesNotch = bst_process('CallProcess', 'process_notch', sFilesRaw, [], ...
    'freqlist',    [60, 120, 180, 240], ...
    'sensortypes', 'MEG, EEG', ...
    'read_all',    1);

% Process: High-pass:0.3Hz
sFilesBand = bst_process('CallProcess', 'process_bandpass', sFilesNotch, [], ...
    'sensortypes', 'MEG, EEG', ...
    'highpass',    0.3, ...
    'lowpass',     0, ...
    'attenuation', 'strict', ...  % 60dB
    'mirror',      0, ...
    'useold',      0, ...
    'read_all',    1);

% Process: Power spectrum density (Welch)
sFilesPsdAfter = bst_process('CallProcess', 'process_psd', sFilesBand, [], ...
    'timewindow',  [0 100], ...
    'win_length',  4, ...
    'win_overlap', 50, ...
    'sensortypes', 'MEG, EEG', ...
    'edit',        struct(...
    'Comment',         'Power', ...
    'TimeBands',       [], ...
    'Freqs',           [], ...
    'ClusterFuncTime', 'none', ...
    'Measure',         'power', ...
    'Output',          'all', ...
    'SaveKernel',      0));

% % Mark bad channels
% bst_process('CallProcess', 'process_channel_setbad', sFilesBand, [], ...
%             'sensortypes', 'A227, A244, A246, A248');%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%


% Process: Snapshot: Frequency spectrum
bst_process('CallProcess', 'process_snapshot', sFilesPsdAfter, [], ...
    'target',         10, ...  % Frequency spectrum
    'modality',       1);      % MEG (All)

% Process: Delete folders
bst_process('CallProcess', 'process_delete', [sFilesRaw, sFilesNotch], [], ...
    'target', 2);  % Delete folders


%% ===== ARTIFACT CLEANING =====
% Process: Select data files in: */*
sFilesBand = bst_process('CallProcess', 'process_select_files_data', [], [], ...
    'subjectname', 'All');

% Process: Select file names with tag: 3-Restin
sFilesRest = bst_process('CallProcess', 'process_select_tag', sFilesBand, [], ...
    'tag',    '3-Restin', ...
    'search', 1, ...  % Search the file names
    'select', 1);  % Select only the files with the tag

% Process: Detect heartbeats
bst_process('CallProcess', 'process_evt_detect_ecg', sFilesRest, [], ...
    'channelname', 'ECG+, -ECG-', ...
    'timewindow',  [], ...
    'eventname',   'cardiac');

% Process: SSP ECG: cardiac
bst_process('CallProcess', 'process_ssp_ecg', sFilesRest, [], ...
    'eventname',   'cardiac', ...
    'sensortypes', 'MEG', ...
    'usessp',      1, ...
    'select',      1);

% Process: Snapshot: Sensors/MRI registration
bst_process('CallProcess', 'process_snapshot', sFilesRest, [], ...
    'target',         1, ...  % Sensors/MRI registration
    'modality',       1, ...  % MEG (All)
    'orient',         1);  % left

% Process: Snapshot: SSP projectors
bst_process('CallProcess', 'process_snapshot', sFilesRest, [], ...
    'target',         2, ...  % SSP projectors
    'modality',       1);     % MEG (All)

% %% ===== Resample Raw ===
% 
% % Process: Resample: 250Hz
% sFilesRestResample = bst_process('CallProcess', 'process_resample', sFilesRest, [], ...
%     'freq',     250, ...
%     'read_all', 1);

%% ===== SOURCE ESTIMATION =====
% Process: Select file names with tag: task-rest
sFilesNoise = bst_process('CallProcess', 'process_select_tag', sFilesBand, [], ...
    'tag',    '1-Rnoise', ...
    'search', 1, ...  % Search the file names
    'select', 1);  % Select only the files with the tag

% Process: Compute covariance (noise or data)
bst_process('CallProcess', 'process_noisecov', sFilesNoise, [], ...
    'baseline',       [], ...
    'sensortypes',    'MEG', ...
    'target',         1, ...  % Noise covariance     (covariance over baseline time window)
    'dcoffset',       1, ...  % Block by block, to avoid effects of slow shifts in data
    'identity',       0, ...
    'copycond',       1, ...
    'copysubj',       0, ...
    'replacefile',    1);  % Replace

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Process: Compute head model
% bst_process('CallProcess', 'process_headmodel', sFilesRest, [], ...
%     'sourcespace', 1, ...  % Cortex surface. (Cortex surface;volume;mixed)
%     'meg',         3);     % Overlapping spheres. ('';'meg_sphere';'Single sphere'; 'OpenMEEG BEM')

% Process: Generate BEM surfaces
sBemSurf = bst_process('CallProcess', 'process_generate_bem', sFilesRest, [], ...
    'subjectname', SubjectName, ...
    'nscalp',      1922, ...%%%%8004
    'nouter',      1922, ...
    'ninner',      1922, ...
    'thickness',   4,...
    'copycond',       1);


% Process: Compute head model
sHeadmodel = bst_process('CallProcess', 'process_headmodel', sBemSurf, [], ...
    'Comment',     '', ...
    'sourcespace', 1, ...  % Cortex surface
    'volumegrid',  struct(...
    'Method',        'adaptive', ...
    'nLayers',       17, ...
    'Reduction',     3, ...
    'nVerticesInit', 8004, ...%%%%4002
    'Resolution',    0.005, ...
    'FileName',      []), ...
    'meg',         4, ...  % OpenMEEG BEM
    'eeg',         1, ...  %
    'ecog',        1, ...  %
    'seeg',        1, ...  %
    'openmeeg',    struct(...
    'BemSelect',    [1, 1, 1], ...
    'BemCond',      [1, 0.0125, 1], ...
    'BemNames',     {{'Scalp', 'Skull', 'Brain'}}, ...
    'BemFiles',     {{}}, ...
    'isAdjoint',    0, ...
    'isAdaptative', 1, ...
    'isSplit',      0, ...
    'copycond',       1, ...
    'SplitLength',  4000));




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Process: Compute sources [2018]
sSrcRest = bst_process('CallProcess', 'process_inverse_2018', sFilesRest, [], ...
    'output',  1, ...  % Kernel only: shared
    'inverse', struct(...
    'Comment',        'sLORETA: MEG', ...
    'InverseMethod',  'minnorm', ...
    'InverseMeasure', 'sloreta', ...
    'SourceOrient',   {{'fixed'}}, ...
    'Loose',          0.2, ...
    'UseDepth',       0, ...
    'WeightExp',      0.5, ...
    'WeightLimit',    10, ...
    'NoiseMethod',    'reg', ...
    'NoiseReg',       0.1, ...
    'SnrMethod',      'fixed', ...
    'SnrRms',         1e-06, ...
    'SnrFixed',       3, ...
    'ComputeKernel',  1, ...
    'DataTypes',      {{'MEG'}}));

%%

% Process: Power spectrum density (Welch)
sSrcRestPsdBands = bst_process('CallProcess', 'process_psd', sSrcRest, [], ...
    'timewindow',  [], ...
    'win_length',  1, ...
    'win_overlap', 50, ...
    'sensortypes', 'MEG', ...
    'win_std',     0, ...
    'edit',        struct(...
         'Comment',         'Power,FreqBands', ...
         'TimeBands',       [], ...
         'Freqs',           {{'delta', '2, 4', 'mean'; 'theta', '5, 7', 'mean'; 'alpha', '8, 12', 'mean'; 'beta', '15, 29', 'mean'; 'gamma', '30,70', 'mean'; 'gamma1', '30, 59', 'mean'; 'gamma2', '60, 90', 'mean'}}, ...
         'ClusterFuncTime', 'none', ...
         'Measure',         'power', ...
         'Output',          'all', ...
         'SaveKernel',      0));
     
     
%% downsample raw_notch_high_resampled to raw_notch_high_resampled_signal
%% export sensor level raw_notch_high_resampled_signal to file
%% in_bst_results to get source results
%% export to file
% %%
% Protocol = bst_get('Protocol', ProtocolName);
% 
% ProtocolInfo = bst_get('ProtocolInfo');
% 
% % Load
% sFilesRestResampleSignalFile = import_raw_to_db(sFilesRestResample.FileName);
% sFilesRestResampleSignalFile=sFilesRestResampleSignalFile{1};
% % Modify
% sSrcRestResampleSignal=sSrcRestResample;
% sSrcRestResampleSignal.DataFile=file_short( sFilesRestResampleSignalFile);
% % Save
% sSrcRestResampleSignalFile=bst_fullfile(ProtocolInfo.STUDIES,sSrcRestResampleSignal.FileName);
% % sSrcRestResampleSignalFile=strrep(sSrcRestResampleSignalFile,'.mat','_raw.mat');
% % save(sSrcRestResampleSignalFile, '-struct', 'sSrcRestResampleSignal','-append');
% % Load
% sSrcRestResampleSignal=in_bst_results(sSrcRestResampleSignalFile,1);
% % save(sSrcRestResampleSignalFile, '-struct', 'sSrcRestResampleSignal','-v7.3');
% % SUCCESS = copyfile(sSrcRestResampleSignalFile, '.\result');
% %%
% save('.\result\results_sLORETA_KERNEL.mat', '-struct', 'sSrcRestResampleSignal','-v7.3');

% [SUCCESS,MSG] = copyfile(bst_fullfile(ProtocolInfo.SUBJECTS,sHeadmodel.SurfaceFile), '.\result');

% save('.\result\meg_surfacefile.mat',sHeadmodel.SurfaceFile)

%%
% db_reload_database(Protocol);

% Save and display report
ReportFile = bst_report('Save', []);
bst_report('Open', ReportFile);
% end
