function varargout=fun_correlation(varargin)
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
        megSignal=megMat.dtseries;
        
    end
    %% fmri
    if sum(strcmp(modality,'fmri'))
        fmriPath=['.\result\',subjectName,'.4k.surface.matched.fMRI_REST_LR.mat'];
        fmriMat=load(fmriPath);
        fmriSignal=fmriMat.dtseries;
    end
elseif nargin==6
    labelMat=load(labelPath);
    megMat=load(megPath);
    megSignal=megMat.dtseries;
    fmriMat=load(fmriPath);
    fmriSignal=fmriMat.dtseries;
end
%% CALCU CORR
% meg
if sum(strcmp(modality,'meg'))
    if iscell(megSignal)
        for iBand=1:max(size(megSignal))
            megConn{iBand}=corr(megSignal{iBand}');
        end
    end
end
% fmri
if sum(strcmp(modality,'fmri'))
    if iscell(fmriSignal)
        for iBand=1:size(fmriSignal,1)
            fmriConn{iBand}=corr(fmriSignal{iBand}');
        end
    elseif ismatrix(fmriSignal)
        fmriConn=corr(fmriSignal');
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
    fmriConnSort=fmriConn([idxSortL;idxSortR+nHemiSphere],:);
    fmriConnSort=fmriConnSort(:,[idxSortL;idxSortR+nHemiSphere]);
    %     fmriConn=fmriConnSort;
    %% meg sort
    if iscell(megSignal)
        for iBand=1:max(size(megSignal))
            megConnSort{iBand}=megConn{iBand}([idxSortL;idxSortR+nHemiSphere],:);
            megConnSort{iBand}=megConnSort{iBand}(:,[idxSortL;idxSortR+nHemiSphere]);
        end
    elseif ismatrix(megSignal)
        megConnSort=megConn([idxSortL;idxSortR+nHemiSphere],:);
        megConnSort=megConnSort(:,[idxSortL;idxSortR+nHemiSphere]);
    end
end

%% PLOT MATRIX
title1='fMRI connectivity- correlation of signal';
title2='MEG connectivity- correlation of signal';
ext1=[];
for iBand=1:1:max(size(megSignal))
    ext2{iBand}=strcat(megMat.bandsFreqs{iBand,1},' band');
end
fun_imagesc_two(fmriConnSort,megConnSort,title1,title2,ext1,ext2);
close all;
%% SAVE
label=labelMat;
if FLAG_SORTBYLABEL==1
    labelSorted={labelSortL,labelSortR,idxSortL,idxSortR};
    comment=['correltion sorted by labels, label and index refer to sorted label mat'];
    megConnPath=['.\result\',subjectName,'_meg_suface.correlation.mat'];
    dtconn=megConnSort;
    save(megConnPath,'dtconn','comment','-v7.3')
    fmriConnPath=['.\result\',subjectName,'_fmri_suface.correlation.mat'];
    dtconn=fmriConnSort;
    save(fmriConnPath,'fmriConn','comment','-v7.3')
elseif FLAG_SORTBYLABEL==0
    comment=['correltion, label and index refer to label mat'];
    megConnPath=['.\result\',subjectName,'_meg_suface.correlation.mat'];
    dtconn=megConn;    
    save(megConnPath,'megConn','comment','-v7.3')
    fmriConnPath=['.\result\',subjectName,'_fmri_suface.correlation.mat'];
    dtconn=fmriConn;    
    save(fmriConnPath,'fmriConn','comment','-v7.3')
end
if nargin~=0
    varargout{1}=fmriConn;
    varargout{2}=megConn;
end
