function varargout=fun_partial_correlation(varargin)

load ./temp/config.mat
addpath([rootPath,'\external\QUIC_MEX_1.2'])
switch nargin
    case 1
        subjectName=varargin{1};
    case 3
        subjectName=varargin{1};
        megSignal=varargin{2};
        fmriSignal=varargin{3};
end

%% read
switch nargin
    case 0
        megMatPath=['.\result\',subjectName,'.',kiloVertices,'.source.matched.timefrequency.MEG_REST_LR.mat'];
        megMat=load(megMatPath);
        megSignal=megMat.dtseries;
        fmriMatPath=['.\result\',subjectName,'.',kiloVertices,'.surface.matched.fMRI_REST_LR.mat'];
        fmriMat=load(fmriMatPath);
        fmriSignal=fmriMat.dtseries;
    case 1
        megMatPath=['.\result\',subjectName,'.',kiloVertices,'.source.matched.timefrequency.MEG_REST_LR.mat'];
        megMat=load(megMatPath);
        megSignal=megMat.dtseries;
        fmriMatPath=['.\result\',subjectName,'.',kiloVertices,'.surface.matched.fMRI_REST_LR.mat'];
        fmriMat=load(fmriMatPath);
        fmriSignal=fmriMat.dtseries;
end
megSignal=permute(megSignal,[1,3,2]);
megSignal=reshape(megSignal,[400,8004*16]);
% megSignal=[1,3,5,7,9,11;2,4,6,8,10,12]; %test reshape
% megSignal=reshape(megSignal,[2,3,2]);
maxIter=2;
isStand=1;
PM = PM_QUIC(megSignal', maxIter, isStand);
end






