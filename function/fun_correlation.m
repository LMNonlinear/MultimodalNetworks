function varargout=fun_evelope_based_correlation(varargin)
modality={'meg','fmri'};
FLAG_SORTBYLABEL=1;
%
switch nargin
    case 0
        load ./temp/config.mat
    case 2
        subjectName=varargin{1};
        modality=varargin{2};
    case 3
        subjectName=varargin{1};
        modality=varargin{2};
        FLAG_SORTBYLABEL=varargin{3};
    case 6
        subjectName=varargin{1};
        modality=varargin{2};
        FLAG_SORTBYLABEL=varargin{3};
        megPath=varargin{4};
        fmriPath=varargin{5};
        labelPath=varargin{6};
end
%% READ DATA
if nargin==0||nargin==2||nargin==3
    %% label
    labelPath=['.\result\',subjectName,'.rs.from32k.4k.aparc.32k_fs_LR.label.mat'];
    labelMat=load(labelPath);
    %% meg
    if sum(strcmp(modality,'meg'))
        megPath=['.\result\',subjectName,'.4k.source.matched.band.MEG_REST_LR.mat'];
        megMat=load(megPath);
        %         megSignal=megMat.megBandEnvelope.megBandEnvelope;
        megSignal=megMat.megBandEnvelope;
        
    end
    %% fmri
    if sum(strcmp(modality,'fmri'))
        fmriPath=['.\result\',subjectName,'.4k.surface.matched.fMRI_REST_LR.mat'];
        fmriMat=load(fmriPath);
        fmriSignal=fmriMat.fmriSignal;
    end
elseif nargin==6
    labelMat=load(labelPath);
    megMat=load(megPath);
    %     megSignal=megMat.megBandEnvelope.megBandEnvelope;
    megSignal=megMat.megBandEnvelope;
    fmriMat=load(fmriPath);
    fmriSignal=fmriMat.fmriSignal;
end
%% CALCU CORR
% meg
if sum(strcmp(modality,'meg'))
    if iscell(megSignal)
        for iBand=1:max(size(megSignal))
            megCorr{iBand}=corr(megSignal{iBand}');
            %             figure;imagesc(megCorr{iBand});title(['meg corr ',megMat.bandsFreqs{iBand,1}]);colorbar;
            %             fun_save_figure(['correlation MEG ',megMat.bandsFreqs{iBand,1}])
        end
    end
end
% fmri
if sum(strcmp(modality,'fmri'))
    if iscell(fmriSignal)
        for iBand=1:size(fmriSignal,1)
            fmriCorr{iBand}=corr(fmriSignal{iBand}');
            %             figure;imagesc(fmriCorr{iBand});title(['fmri corr ',fmriMat.bandsFreqs{iBand,1}]);colorbar;
            %             fun_save_figure(['correlation fMRI ', fmriMat.bandsFreqs{iBand,1}])
        end
    elseif ismatrix(fmriSignal)
        fmriCorr=corr(fmriSignal');
        %         figure;imagesc(fmriCorr);title(['fmri corr']);colorbar;
        %         fun_save_figure(['correlation fMRI'])
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
    fmriCorr=fmriCorrSort;
%     figure;imagesc(fmriCorrSort);title(['fmri corr sorted']);colorbar;
%     fun_save_figure(['correlation fMRI sorted'])
    
    %% meg sort
    if iscell(megSignal)
        for iBand=1:max(size(megSignal))
            megCorrSort{iBand}=megCorr{iBand}([idxSortL;idxSortR+nHemiSphere],:);
            megCorrSort{iBand}=megCorrSort{iBand}(:,[idxSortL;idxSortR+nHemiSphere]);
            megCorr{iBand}=megCorrSort{iBand};
            %             figure;imagesc(megCorrSort{iBand});title(['meg corr ', megMat.bandsFreqs{iBand,1}]);colorbar;
            %             fun_save_figure(['correlation MEG sorted ', megMat.bandsFreqs{iBand,1}])
        end
    elseif ismatrix(megSignal)
        megCorrSort=megCorr([idxSortL;idxSortR+nHemiSphere],:);
        megCorrSort=megCorrSort(:,[idxSortL;idxSortR+nHemiSphere]);
        megCorr=megCorrSort;
        %         figure;imagesc(megCorrSort);title(['meg corr sorted']);colorbar;
        %         fun_save_figure(['correlation MEG sorted'])
    end
end

%% PLOT MATRIX
title1='fMRI connectivity- correlation of signal';
title2='MEG connectivity- correlation of signal';
ext1=[];
for iBand=1:1:max(size(megSignal))
    ext2{iBand}=strcat(megMat.bandsFreqs{iBand,1},' band');
end
fun_imagesc_two(fmriCorrSort,megCorrSort,title1,title2,ext1,ext2);

%% save
label=labelMat;
if FLAG_SORTBYLABEL==1
    labelSorted={labelSortL,labelSortR,idxSortL,idxSortR};
    comment=[modality,'correltion sorted by labels'];
    corrPath=['.\result\',subjectName,'_suface.correlation.mat'];
    save(corrPath,'fmriCorr','megCorr','label','labelSorted','comment','-v7.3')
elseif FLAG_SORTBYLABEL==0
    comment=[modality,'correltion'];
    corrPath=['.\result\',subjectName,'_suface.correlation.mat'];
    save(corrPath,'fmriCorr','megCorr','label','comment','-v7.3')
end
varargout{1}=fmriCorr;
varargout{2}=megCorr;
