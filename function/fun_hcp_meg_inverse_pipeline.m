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
        ProtocolName=varargin{1};
        data_dir=varargin{2};
        SubjectName=varargin{3};
        load ./temp/hcp_meg_preprocessing_pipeline.mat
        FLAG.RELOAD=0;
        FLAG.NEWPROTOCAOL=0;
        FLAG.SAMPLE=1;
        FLAG.INVERSE=1;
        FLAG.READRESULT=1;
    case 4
        load ./temp/hcp_meg_preprocessing_pipeline.mat
        ProtocolName=varargin{1};
        data_dir=varargin{2};
        SubjectName=varargin{3};
        timeWindow=varargin{4};
        FLAG.RELOAD=0;
        FLAG.NEWPROTOCAOL=0;
        FLAG.SAMPLE=1;
        FLAG.INVERSE=1;
        FLAG.READRESULT=1;
    case 5 % skip some step
        load ./temp/hcp_meg_preprocessing_pipeline.mat
        ProtocolName=varargin{1};
        data_dir=varargin{2};
        SubjectName=varargin{3};
        FLAG=varargin{4};
        timeWindow=varargin{5};        
end


%% ===== FILES TO IMPORT =====
if FLAG.RELOAD==1
    % You have to specify the folder in which the tutorial dataset is unzipped
    % if (nargin == 0) || isempty(data_dir) || ~file_exist(data_dir)
    if isempty(data_dir) || ~file_exist(data_dir)
        error('The first argument must be the full path to the tutorial dataset folder.');
    end
    % Subject name
    %     SubjectName = '105923';
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
% ProtocolName = 'HCPsLoretaPsdBandsPipeline';
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
    % save source space signal
    [sSrcResults, sSrcResultsFile]=in_bst_results(sSrcRestKernel.FileName, 1);
    % save all
    %     [sSrcRestKernelFileName,sSrcRestKernelType, sSrcRestKernelisAnatomy] = file_fullpath( sSrcRestKernel.FileName );
    %     [sSrcRestKernelPath, name, ext]=bst_fileparts(sSrcRestKernelFileName);
    %     [sSrcRestKernelFolder, name, ext]=bst_fileparts(sSrcRestKernelPath);
    %     file_copy(sSrcRestKernelFolder,['.\result\',SubjectName]);
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
end
%%
% Save and display report
ReportFile = bst_report('Save', []);
% bst_report('Open', ReportFile);
% end