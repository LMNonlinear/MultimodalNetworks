function varargout=fun_evelope_based_correlation(varargin)
modality={'meg','fmri'};
FLAG_SORTBYLABEL=1;
%
switch nargin
    case 0
        load ./temp/config.mat
    case 2
        SubjectName=varargin{1};
        modality=varargin{2};
    case 3
        SubjectName=varargin{1};
        modality=varargin{2};
        FLAG_SORTBYLABEL=varargin{3};
    case 6
        SubjectName=varargin{1};
        modality=varargin{2};
        FLAG_SORTBYLABEL=varargin{3};
        megPath=varargin{4};
        fmriPath=varargin{5};
        labelPath=varargin{6};
end
%% READ DATA
if nargin==0||nargin==2||nargin==3
    %% label
    labelPath=['.\result\',SubjectName,'.rs.from32k.4k.105923.aparc.32k_fs_LR.label.mat'];
    labelMat=load(labelPath);
    %% meg
    if sum(strcmp(modality,'meg'))
        megPath=['.\result\',SubjectName,'.4k.source.matched.band.envelope.MEG_REST_LR.mat'];
        megMat=load(megPath);
        megSignal=megMat.megBandEnvelope.megBandEnvelope;
    end
    %% fmri
    if sum(strcmp(modality,'fmri'))
        fmriPath=['.\result\',SubjectName,'.4k.surface.matched.fMRI_REST_LR.mat'];
        fmriMat=load(fmriPath);
        fmriSignal=fmriMat.fmriSignal;
    end
elseif nargin==6
    labelMat=load(labelPath);
    megMat=load(megPath);
    megSignal=megMat.megBandEnvelope.megBandEnvelope;
    fmriMat=load(fmriPath);
    fmriSignal=fmriMat.fmriSignal;
end
%% CALCU CORR
% meg
if sum(strcmp(modality,'meg'))
    if iscell(megSignal)
        for iBand=1:max(size(megSignal))
            megCorr{iBand}=corr(megSignal{iBand}');
            figure;imagesc(megCorr{iBand});title(['meg corr',iBand]);colorbar;
            fun_save_figure(['envelope based correlation MEG', iBand])
        end
    end
end
% fmri
if sum(strcmp(modality,'fmri'))
    if iscell(fmriSignal)
        for iBand=1:size(fmriSignal,1)
            fmriCorr{iBand}=corr(fmriSignal{iBand}');
            figure;imagesc(fmriCorr{iBand});title(['fmri corr',iBand]);colorbar;
            fun_save_figure(['correlation fMRI', iBand])
        end
    elseif ismatrix(fmriSignal)
        fmriCorr=corr(fmriSignal');
        figure;imagesc(fmriCorr);title(['fmri corr',iBand]);colorbar;
        fun_save_figure(['correlation fMRI'])
    end
end

%% SORT BY LABEL
% close all
if FLAG_SORTBYLABEL==1
    %% label sort
    nHemiSphere=length(labelMat.labelL);
    [labelSortL,idxSortL] = sort(labelMat.labelL);
    [labelSortR,idxSortR] = sort(labelMat.labelR);
    %% fmri sort
    fmriCorrSort=fmriCorr([idxSortL;idxSortR+nHemiSphere],:);
    fmriCorrSort=fmriCorrSort(:,[idxSortL;idxSortR+nHemiSphere]);
    figure;imagesc(fmriCorrSort);title(['fmri corr sorted']);colorbar;
    fmriCorr=fmriCorrSort;
    fun_save_figure(['correlation fMRI sorted'])

    %% meg sort
    if iscell(megSignal)
        for iBand=1:size(megSignal,1)
            megCorrSort=megCorr{iBand}([idxSortL;idxSortR+nHemiSphere],:);
            megCorrSort=megCorrSort{iBand}(:,[idxSortL;idxSortR+nHemiSphere]);
            figure;imagesc(megCorrSort{iBand});title(['meg corr', num2str(iBand)]);colorbar;
            megCorr=megCorrSort;
            fun_save_figure(['correlation MEG sorted', iBand])
        end
    elseif ismatrix(megSignal)
        megCorrSort=megCorr([idxSortL;idxSortR+nHemiSphere],:);
        megCorrSort=megCorrSort(:,[idxSortL;idxSortR+nHemiSphere]);
        figure;imagesc(megCorrSort);title(['meg corr sorted']);colorbar;
        megCorr=megCorrSort;
        fun_save_figure(['correlation MEG sorted', iBand])

    end
end
%% save
if FLAG_SORTBYLABEL==1
    labelOut={labelSortL,labelSortR,idxSortL,idxSortR};
    comment=[modality,'correltion sorted by labels'];
    corrPath=['.\result\',SubjectName,'suface.correlation.mat'];
    save(corrPath,'fmriCorr','megCorr','labelOut','comment')
elseif FLAG_SORTBYLABEL==0
    comment=[modality,'correltion'];
    corrPath=['.\result\',SubjectName,'suface.correlation.mat'];
    save(corrPath,'fmriCorr','megCorr','comment')
end
varargout{1}=fmriCorr;
varargout{2}=megCorr;
