% function tutorial_hcp_s900(data_dir)
% TUTORIAL_HCP: Script that reproduces the results of the online tutorial "Human Connectome Project: Resting-state MEG".
%
% CORRESPONDING ONLINE TUTORIALS:
%     https://neuroimage.usc.edu/brainstorm/Tutorials/HCP-MEG
%
% INPUTS:
%     data_dir: Directory where the HCP files have been unzipped

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
%%
clear;clc;close all;
%%
load ./temp/config.mat
load ./temp/hcp_preprocessing_pipeline.mat
%%
FLAG.RELOAD=0;
FLAG.NEWPROTOCAOL=0;
FLAG.PREPROCESSING=0;
FLAG.HEADMODEL=0;
FLAG.SAMPLE=1;
FLAG.INVERSE=1;
FLAG.READRESULT=1;
%% ===== FILES TO IMPORT =====
if FLAG.RELOAD==1
    % You have to specify the folder in which the tutorial dataset is unzipped
    % if (nargin == 0) || isempty(data_dir) || ~file_exist(data_dir)
    if isempty(data_dir) || ~file_exist(data_dir)
        error('The first argument must be the full path to the tutorial dataset folder.');
    end
    % Subject name
    SubjectName = '105923';
    
    % Build the path of the files to import
    AnatDir    = fullfile(data_dir, SubjectName, 'MEG', 'anatomy');
    Run1File   = fullfile(data_dir, SubjectName, 'unprocessed', 'MEG', '3-Restin', '4D', 'c,rfDC');
    NoiseFile  = fullfile(data_dir, SubjectName, 'unprocessed', 'MEG', '1-Rnoise', '4D', 'c,rfDC');
    % Check if the folder contains the required files
    if ~file_exist(AnatDir) || ~file_exist(Run1File) || ~file_exist(NoiseFile)
        error(['The folder ' data_dir ' does not contain subject #105923 from the HCP-MEG distribution.']);
    end
end
%% ===== CREATE PROTOCOL =====
% The protocol name has to be a valid folder name (no spaces, no weird characters...)
ProtocolName = 'HCPsLoretaPsdBandsPipeline';
% Start brainstorm without the GUI
if ~brainstorm('status')
    brainstorm nogui
end
if FLAG.NEWPROTOCAOL==1
    % Delete existing protocol
    gui_brainstorm('DeleteProtocol', ProtocolName);
    % Create new protocol
    gui_brainstorm('CreateProtocol', ProtocolName, 0, 0);
end
% Start a new report
bst_report('Start');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if FLAG.SAMPLE==1
    % Process: Import MEG/EEG: Time
    sFilesRestImported = bst_process('CallProcess', 'process_import_data_time', sFilesRest, [], ...
        'subjectname', SubjectName, ...
        'condition',   '', ...
        'timewindow',  [0, 100], ...% avoid bound effect, we will only use 30-60
        'split',       0, ...
        'ignoreshort', 0, ...
        'usectfcomp',  0, ...
        'usessp',      1, ...
        'freq',        [], ...
        'baseline',    []);
end
%
%  bst_get('HeadModelFile', HeadModelFile)
ProtocolInfo=bst_get('ProtocolInfo');
NoiseCovFile=file_find(ProtocolInfo.STUDIES, 'noisecov_full.mat', 3);
[NoiseCovCond, NoiseCovFilename]=bst_fileparts(NoiseCovFile);
ProtocolSubjects=bst_get('ProtocolSubjects');
SubjectFile=ProtocolSubjects.Subject.FileName;
ConditionsForSubject=bst_get('ConditionsForSubject', SubjectFile);

[NoiseCovStudy, iNoiseCovStudy] = bst_get('StudyWithCondition', [ProtocolSubjects.Subject.Name,'/' ,ConditionsForSubject{2}]);
[NoNoiseCovStudy, iNoNoiseCovStudy] = bst_get('StudyWithCondition', [ProtocolSubjects.Subject.Name,'/' ,ConditionsForSubject{3}]);
OutputFiles = db_set_noisecov(iNoiseCovStudy, iNoNoiseCovStudy);

HeadModelFile=file_find(ProtocolInfo.STUDIES, 'headmodel_surf_openmeeg.mat', 3);
OutputFiles = db_set_headmodel(HeadModelFile, 'AllConditions');
%%
if FLAG.INVERSE==1
    if FLAG.SAMPLE==0
        % Process: Compute sources [2018]
        sSrcRestKernel = bst_process('CallProcess', 'process_inverse_2018', sFilesRestImported, [], ...
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
    end
    if FLAG.SAMPLE==1
        % Process: Compute sources [2018]
        sSrcRestKernel = bst_process('CallProcess', 'process_inverse_2018', sFilesRestImported, [], ...
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
            'ComputeKernel',  0, ...
            'DataTypes',      {{'MEG'}}));
    end
end
%% === Read Results===
if FLAG.READRESULT==1
    [sSrcResults, sSrcResultsFile]=in_bst_results(sSrcRestKernel.FileName, 1);
end
%%
% Save and display report
ReportFile = bst_report('Save', []);
bst_report('Open', ReportFile);
% end
%%
filename = './temp/hcp_inverse_pipeline.mat';
clear ans 
save(filename)
