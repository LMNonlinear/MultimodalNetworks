function varargout= fun_hcp_meg_inverse_pipeline(varargin)
%% default window size
timeWindow=[0,100];
%% read vaiable input
switch nargin
    case 0
        load ./temp/config.mat
        load ./temp/hcp_meg_preprocessing_pipeline.mat
        FLAG.RELOAD=0;
        FLAG.NEWPROTOCAOL=0;
        FLAG.SAMPLE=1;
        FLAG.INVERSE=1;
        FLAG.READRESULT=1;
    case 3
        protocolName=varargin{1};
        dataDir=varargin{2};
        subjectName=varargin{3};
        load ./temp/hcp_meg_preprocessing_pipeline.mat
        FLAG.RELOAD=0;
        FLAG.NEWPROTOCAOL=0;
        FLAG.SAMPLE=1;
        FLAG.INVERSE=1;
        FLAG.READRESULT=1;
    case 4
        load ./temp/hcp_meg_preprocessing_pipeline.mat
        protocolName=varargin{1};
        dataDir=varargin{2};
        subjectName=varargin{3};
        timeWindow=varargin{4};
        FLAG.RELOAD=0;
        FLAG.NEWPROTOCAOL=0;
        FLAG.SAMPLE=1;
        FLAG.INVERSE=1;
        FLAG.READRESULT=1;
    case 5 % skip some step
        load ./temp/hcp_meg_preprocessing_pipeline.mat
        protocolName=varargin{1};
        dataDir=varargin{2};
        subjectName=varargin{3};
        FLAG=varargin{4};
        timeWindow=varargin{5};
end


%% ===== FILES TO IMPORT =====
if FLAG.RELOAD==1
    % You have to specify the folder in which the tutorial dataset is unzipped
    % if (nargin == 0) || isempty(dataDir) || ~file_exist(dataDir)
    if isempty(dataDir) || ~file_exist(dataDir)
        error('The first argument must be the full path to the tutorial dataset folder.');
    end
    % Subject name
    %     subjectName = '105923';
    % Build the path of the files to import
    AnatDir    = fullfile(dataDir, subjectName, 'MEG', 'anatomy');
    Run1File   = fullfile(dataDir, subjectName, 'unprocessed', 'MEG', '3-Restin', '4D', 'c,rfDC');
    NoiseFile  = fullfile(dataDir, subjectName, 'unprocessed', 'MEG', '1-Rnoise', '4D', 'c,rfDC');
    % Check if the folder contains the required files
    if ~file_exist(AnatDir) || ~file_exist(Run1File) || ~file_exist(NoiseFile)
        error(['The folder ' dataDir ' does not contain subject #105923 from the HCP-MEG distribution.']);
    end
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if FLAG.SAMPLE==1
    % Process: Import MEG/EEG: Time
    sFilesRestImported = bst_process('CallProcess', 'process_import_data_time', sFilesRest, [], ...
        'subjectname', subjectName, ...
        'condition',   '', ...
        'timewindow',  [timeWindow(1), timeWindow(2)], ...% avoid bound effect, we will only use 30-60
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
        % Process: Power spectrum density (Welch)
%         sSrcRestPsd = bst_process('CallProcess', 'process_psd', sSrcRestKernel, [], ...
%             'timewindow',  [], ...
%             'win_length',  4, ...
%             'win_overlap', 50, ...
%             'clusters',    {}, ...
%             'scoutfunc',   1, ...  % Mean
%             'win_std',     0, ...
%             'edit',        struct(...
%             'Comment',         'Power', ...
%             'TimeBands',       [], ...
%             'Freqs',           [], ...
%             'ClusterFuncTime', 'none', ...
%             'Measure',         'power', ...
%             'Output',          'all', ...
%             'SaveKernel',      0));
%         
%         % Process: Group in time or frequency bands
%         sSrcRestPsdBands = bst_process('CallProcess', 'process_tf_bands', sSrcRestPsd, [], ...
%             'isfreqbands', 1, ...
%             'freqbands',   {'delta', '2, 4', 'mean'; 'theta', '5, 7', 'mean'; 'alpha', '8, 12', 'mean'; 'beta', '15, 29', 'mean'; 'gamma1', '30, 59', 'mean'; 'gamma2', '60, 90', 'mean'}, ...
%             'istimebands', 0, ...
%             'timebands',   '', ...
%             'overwrite',   0);
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
        % Process: Power spectrum density (Welch)
%         sSrcRestPsd = bst_process('CallProcess', 'process_psd', sSrcRestKernel, [], ...
%             'timewindow',  [], ...
%             'win_length',  4, ...
%             'win_overlap', 50, ...
%             'clusters',    {}, ...
%             'scoutfunc',   1, ...  % Mean
%             'win_std',     0, ...
%             'edit',        struct(...
%             'Comment',         'Power', ...
%             'TimeBands',       [], ...
%             'Freqs',           [], ...
%             'ClusterFuncTime', 'none', ...
%             'Measure',         'power', ...
%             'Output',          'all', ...
%             'SaveKernel',      0));
%         
%         % Process: Group in time or frequency bands
%         sSrcRestPsdBands = bst_process('CallProcess', 'process_tf_bands', sSrcRestPsd, [], ...
%             'isfreqbands', 1, ...
%             'freqbands',   {'delta', '2, 4', 'mean'; 'theta', '5, 7', 'mean'; 'alpha', '8, 12', 'mean'; 'beta', '15, 29', 'mean'; 'gamma1', '30, 59', 'mean'; 'gamma2', '60, 90', 'mean'}, ...
%             'istimebands', 0, ...
%             'timebands',   '', ...
%             'overwrite',   0);
    end
end
%% === Read Results===
if FLAG.READRESULT==1
    % save source space signal
    [sSrcResults, sSrcResultsFile]=in_bst_results(sSrcRestKernel.FileName, 1);
    % save all
    %     [sSrcRestKernelFileName,sSrcRestKernelType, sSrcRestKernelisAnatomy] = file_fullpath( sSrcRestKernel.FileName );
    %     [sSrcRestKernelPath, name, ext]=bst_fileparts(sSrcRestKernelFileName);
    %     [sSrcRestKernelFolder, name, ext]=bst_fileparts(sSrcRestKernelPath);
    %     file_copy(sSrcRestKernelFolder,['.\result\',subjectName]);
    ProtocolInfo=bst_get('ProtocolInfo');
    [ProtocolFolder, name, ext]=bst_fileparts(ProtocolInfo.STUDIES);
    file_copy(ProtocolFolder,['.\result\',ProtocolInfo.Comment]);
end

%%
filename = './temp/fun_hcp_meg_inverse_pipeline.mat';
clear ans
save(filename)
switch nargout
    case 1
        varargout{1}=sSrcResults;
    case 2
        varargout{1}=sSrcResults;
        varargout{2}=sSrcResultsFile;
    case 3
        varargout{1}=sSrcResults;
        varargout{2}=sSrcResultsFile;
%         varargout{3}=sSrcRestPsdBands;
end
%%
% Save and display report
ReportFile = bst_report('Save', []);
% bst_report('Open', ReportFile);
% end
