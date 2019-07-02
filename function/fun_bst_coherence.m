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
