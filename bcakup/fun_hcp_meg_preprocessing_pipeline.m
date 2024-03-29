function varargout=fun_hcp_meg_preprocessing_pipeline(varargin)
load ./temp/config.mat
%% default flag
FLAG.NEWPROTOCAOL=1;
FLAG.PREPROCESSING=1;
FLAG.HEADMODEL=1;
%% read vaiable input
switch nargin
    case 0
        load ./temp/config.mat
    case 3
        protocolName=varargin{1};
        dataDir=varargin{2};
        subjectName=varargin{3};
    case 4 % skip some step
        protocolName=varargin{1};
        dataDir=varargin{2};
        subjectName=varargin{3};
        FLAG=varargin{4};
end
%%
% dataDir='M:\MEEGfMRI\Data\HCP_S900\';
%% ===== FILES TO IMPORT =====
% You have to specify the folder in which the tutorial dataset is unzipped
% if (nargin == 0) || isempty(dataDir) || ~file_exist(dataDir)
if isempty(dataDir) || ~file_exist(dataDir)
    error('The second argument must be the full path to the tutorial dataset folder.');
end
% Subject name
% subjectName = '105923';
% Build the path of the files to import
AnatDir    = fullfile(dataDir, subjectName, 'MEG', 'anatomy');
Run1File   = fullfile(dataDir, subjectName, 'unprocessed', 'MEG', '3-Restin', '4D', 'c,rfDC');
NoiseFile  = fullfile(dataDir, subjectName, 'unprocessed', 'MEG', '1-Rnoise', '4D', 'c,rfDC');
% Check if the folder contains the required files
if ~file_exist(AnatDir) || ~file_exist(Run1File) || ~file_exist(NoiseFile)
    error(['The folder ' dataDir ' does not contain subject #105923 from the HCP-MEG distribution.']);
end
%% ===== CREATE PROTOCOL =====
% The protocol name has to be a valid folder name (no spaces, no weird characters...)
% protocolName = 'HCPsLoretaPsdBandsPipeline';
% Start brainstorm without the GUI
if ~brainstorm('status')
    brainstorm nogui
end
if FLAG.NEWPROTOCAOL==1
    % Delete existing protocol
    gui_brainstorm('DeleteProtocol', protocolName);
    % Create new protocol
    gui_brainstorm('CreateProtocol', protocolName, 0, 0);
end
% Start a new report
bst_report('Start');
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if FLAG.PREPROCESSING==1
    %% ===== IMPORT DATA =====
    % Process: Import anatomy folder
    bst_process('CallProcess', 'process_import_anatomy', [], [], ...
        'subjectname', subjectName, ...
        'mrifile',     {AnatDir, 'HCPv3'}, ...
        'nvertices',   15000);
    % Process: Create link to raw files
    sFilesRun1Raw = bst_process('CallProcess', 'process_import_data_raw', [], [], ...
        'subjectname',  subjectName, ...
        'datafile',     {Run1File, '4D'}, ...
        'channelalign', 1);
    sFilesNoiseRaw = bst_process('CallProcess', 'process_import_data_raw', [], [], ...
        'subjectname',  subjectName, ...
        'datafile',     {NoiseFile, '4D'}, ...
        'channelalign', 1);
    %% ===== RESAMPLE ===
    % Process: Resample: 250Hz
    sFilesRun1Resample = bst_process('CallProcess', 'process_resample', sFilesRun1Raw, [], ...
        'freq',     250, ...
        'read_all', 0);
    
    sFilesNoiseResample = bst_process('CallProcess', 'process_resample', sFilesNoiseRaw, [], ...
        'freq',     250, ...
        'read_all', 0);
    
    bst_process('CallProcess', 'process_delete', [sFilesRun1Raw, sFilesNoiseRaw], [], ...
        'target', 2);  % Delete folders
    sFilesRawResample = [sFilesRun1Resample, sFilesNoiseResample];
    
    %% ===== PRE-PROCESSING =====
    % Process: Notch filter: 60Hz 120Hz 180Hz 240Hz 300Hz
    sFilesNotch = bst_process('CallProcess', 'process_notch', sFilesRawResample, [], ...
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
    %%
    %     % Process: Power spectrum density (Welch)
    %     sFilesPsdAfter = bst_process('CallProcess', 'process_psd', sFilesBand, [], ...
    %         'timewindow',  [0 100], ...
    %         'win_length',  4, ...
    %         'win_overlap', 50, ...
    %         'sensortypes', 'MEG, EEG', ...
    %         'edit',        struct(...
    %         'Comment',         'Power', ...
    %         'TimeBands',       [], ...
    %         'Freqs',           [], ...
    %         'ClusterFuncTime', 'none', ...
    %         'Measure',         'power', ...
    %         'Output',          'all', ...
    %         'SaveKernel',      0));
    %
    %     % % Mark bad channels
    %     % bst_process('CallProcess', 'process_channel_setbad', sFilesBand, [], ...
    %     %             'sensortypes', 'A227, A244, A246, A248');%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %     % Process: Snapshot: Frequency spectrum
    %     bst_process('CallProcess', 'process_snapshot', sFilesPsdAfter, [], ...
    %         'target',         10, ...  % Frequency spectrum
    %         'modality',       1);      % MEG (All)
    
    % Process: Delete folders
    bst_process('CallProcess', 'process_delete', [sFilesRawResample, sFilesNotch], [], ...
        'target', 2);  % Delete folder
    
    
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
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if FLAG.HEADMODEL==1
    %% ===== HEADMODEL =====
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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% RELOAD SURFACE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% ===== IMPORT SURFACES =====
%     TessLhFile=['./result/',subjectName,'.L.midthickness.from32k.',kiloVertices,'.fs_LR.surf.gii'];
%     TessRhFile=['./result/',subjectName,'.R.midthickness.from32k.',kiloVertices,'.fs_LR.surf.gii'];
    TessLhFile=['F:\MEEGfMRI\Data\HCP_S900\105923\MEG\anatomy\105923.L.midthickness.4k_fs_LR.surf.gii'];
    TessRhFile=['F:\MEEGfMRI\Data\HCP_S900\105923\MEG\anatomy\105923.R.midthickness.4k_fs_LR.surf.gii'];
    

    TessLhFile=fun_fullpath(TessLhFile);
    TessRhFile=fun_fullpath(TessRhFile);

    [sSubject, iSubject] = bst_get('Subject', subjectName);
    % Left pial
    [iLh, BstTessLhFile, nVertOrigL] = import_surfaces(iSubject, TessLhFile, 'GII-MNI', 0);
    BstTessLhFile = BstTessLhFile{1};
    % Right pial
    [iRh, BstTessRhFile, nVertOrigR] = import_surfaces(iSubject, TessRhFile, 'GII-MNI', 0);
    BstTessRhFile = BstTessRhFile{1};
    
    
    %% ===== MERGE SURFACES =====
    % Merge surfaces
    origCortexFile = tess_concatenate({BstTessLhFile, BstTessRhFile}, sprintf('cortex_%dV', nVertOrigL + nVertOrigR), 'Cortex');
    % Rename high-res file
    origCortexFile = file_fullpath(origCortexFile);
    CortexFile     = bst_fullfile(bst_fileparts(origCortexFile), 'tess_cortex_mid.mat');
    file_move(origCortexFile, CortexFile);
    % Keep relative path only
    CortexFile = file_short(CortexFile);
    % Delete original files
    file_delete(file_fullpath({BstTessLhFile, BstTessRhFile}), 1);
    % Reload subject
    db_reload_subjects(iSubject);
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Process: Generate BEM surfaces
    sBemSurf = bst_process('CallProcess', 'process_generate_bem', sFilesRest, [], ...
        'subjectname', subjectName, ...
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
        'nVerticesInit', numVerticesLR{1}, ...%%%%4002
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
        'SplitLength',  4000 ));
end

%% SAVE RESULTS
% % save head model
% [sHeadmodelFileName,sHeadmodelType, sHeadmodelisAnatomy] = file_fullpath( sHeadmodel.FileName );
% [sHeadmodelPath, name, ext]=bst_fileparts(sHeadmodelFileName);
% file_copy(sHeadmodelPath,['.\result\',subjectName]);
% save signal
sFilesRestImported = bst_process('CallProcess', 'process_import_data_time', sFilesRest, [], ...
    'subjectname', subjectName, ...
    'condition',   '', ...
    'timewindow',  [], ...
    'split',       0, ...
    'ignoreshort', 0, ...
    'usectfcomp',  0, ...
    'usessp',      0, ...
    'freq',        [], ...
    'baseline',    []);

% [sFilesRestFileName,sFilesRestFileType, sFilesRestisAnatomy] = file_fullpath( sFilesRest.FileName );
% [sFilesRestFilePath, name, ext]=bst_fileparts(sFilesRestFileName);
% file_copy(sFilesRestFilePath,['.\result\',subjectName]);

%copy all
ProtocolInfo=bst_get('ProtocolInfo');
[ProtocolFolder, name, ext]=bst_fileparts(ProtocolInfo.STUDIES);
file_copy(ProtocolFolder,['.\result\',ProtocolInfo.Comment]);

% Process: Delete folders/ imported is unuseful for next steps in pipeline, but we can make a backup
bst_process('CallProcess', 'process_delete', sFilesRestImported, [], ...
    'target', 2);  % Delete folder

% save workspace
filename = './temp/hcp_meg_preprocessing_pipeline.mat';
clear ans
save(filename)

% output
switch nargout
    case 1
        varargout{1}=sHeadmodel;
    case 2
        varargout{1}=sHeadmodel;
        varargout{2}=sFilesRest;
end

%%
% Save and display report
ReportFile = bst_report('Save', []);
% bst_report('Open', ReportFile);
% end
