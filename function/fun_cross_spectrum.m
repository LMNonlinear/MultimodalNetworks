function varargout=fun_cross_spectrum(varargin)
connMethod='cross spectrum';
modality={'meg','fmri'};
FLAG_SORTBYLABEL=1;
load ./temp/config.mat
addpath('.\external\parpool\')
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
    labelPath=['.\result\',subjectName,'.rs.from32k.4k.sorted.aparc.32k_fs_LR.label.mat'];
    labelMat=load(labelPath);
    %% meg
    if sum(strcmp(modality,'meg'))
        megPath=['.\result\',subjectName,'.4k.source.matched.MEG_REST_LR.mat'];
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
%% cross spectrum
[~, hostname] = system('hostname');
hostname=string(strtrim(hostname));
% meg
switch hostname
    case 'KBOMATEBOOKXPRO'
        megConn=repmat(triu(ones(size(megSignal,1) ,size(megSignal,1))),1,1,2);
        megF=zeros(1,2);
    otherwise
        startmatlabpool
        [megConn(1,1,:),megF]=cpsd(megSignal(1,:)',megSignal(1,:)',[],[],125,megInfo.sampleRate);
        megConn=zeros(size(megSignal,1) ,size(megSignal,1) ,size(megConn,3));
        Fs=megInfo.sampleRate;
        n=size(megSignal,1);
        tempSignal=megSignal';
        parfor i=1:n
            [megConn(i,:,:),~]=cpsd(tempSignal(:,i),tempSignal,[],[],125,Fs);
        end
end
% fmri
switch hostname
    case 'KBOMATEBOOKXPRO'
        fmriConn=repmat(triu(ones(size(fmriSignal,1) ,size(fmriSignal,1))),1,1,2);
        fmriF=zeros(1,2);
    otherwise
        [fmriConn(1,1,:),fmriF]=cpsd(fmriSignal(1,:)',fmriSignal(1,:)',[],[],125,fmriInfo.sampleRate);
        fmriConn=zeros(size(fmriSignal,1) ,size(fmriSignal,1) ,size(fmriConn,3));
        Fs=fmriInfo.sampleRate;
        n=size(fmriSignal,1);
        tempSignal=fmriSignal';
        parfor i=1:n
            [fmriConn(i,:,:),~]=cpsd(tempSignal(:,i),tempSignal,[],[],125,Fs);
        end
        closematlabpool
end
%
for i=1:size(megConn,3)
    megConn(:,:,i)=triu(megConn(:,:,i),1)+triu(megConn(:,:,i))';
    fmriConn(:,:,i)=triu(fmriConn(:,:,i),1)+triu(fmriConn(:,:,i))';
end

%% SORT BY LABEL
% close all
if FLAG_SORTBYLABEL==1
    %% label sort
    nHemiSphere=length(labelMat.labelRaw.labelL);
    %     [labelSortL,idxSortL] = sort(labelMat.labelL);
    %     [labelSortR,idxSortR] = sort(labelMat.labelR);
    idxSortL=labelMat.labelSorted.idxRaw2SortL;
    idxSortR=labelMat.labelSorted.idxRaw2SortR;
    
    %% fmri sort
    fmriConnSort=fmriConn([idxSortL;idxSortR+nHemiSphere],:,:);
    fmriConnSort=fmriConnSort(:,[idxSortL;idxSortR+nHemiSphere],:);
    %% meg sort
    if iscell(megSignal)
        for iBand=1:max(size(megSignal))
            megConnSort{iBand}=megConn{iBand}([idxSortL;idxSortR+nHemiSphere],:,:);
            megConnSort{iBand}=megConnSort{iBand}(:,[idxSortL;idxSortR+nHemiSphere],:);
        end
    elseif ismatrix(megSignal)
        megConnSort=megConn([idxSortL;idxSortR+nHemiSphere],:,:);
        megConnSort=megConnSort(:,[idxSortL;idxSortR+nHemiSphere],:);
    end
end

%% PLOT MATRIX
% title1=['fMRI connectivity- ',connMethod, 'of signal'];
% title2=['MEG connectivity- ',connMethod, 'of signal'];
% ext1=[];
% for iBand=1:1:max(size(megSignal))
%     ext2{iBand}=strcat(megMat.bandsFreqs{iBand,1},' band');
% end
% fun_imagesc_two(fmriConnSort,megConnSort,title1,title2,ext1,ext2);
% close all;
%% SAVE
if FLAG_SORTBYLABEL==1
    comment=[connMethod, ' sorted by labels, label and index refer to sorted label mat'];
    connMethod=strrep(connMethod,' ','_');
    megConnPath=['.\result\',subjectName,'_meg_suface.',connMethod,'.mat'];
    dtconn=megConnSort;
    save(megConnPath,'dtconn','megF','comment','-v7.3')
    fmriConnPath=['.\result\',subjectName,'_fmri_suface.',connMethod,'.mat'];
    dtconn=fmriConnSort;
    save(fmriConnPath,'dtconn','fmriF','comment','-v7.3')
elseif FLAG_SORTBYLABEL==0
    comment=[connMethod, ', label and index refer to label mat'];
    connMethod=strrep(connMethod,' ','_');
    megConnPath=['.\result\',subjectName,'_meg_suface',connMethod,'.mat'];
    dtconn=megConn;
    save(megConnPath,'dtconn','megF','comment','-v7.3')
    fmriConnPath=['.\result\',subjectName,'_fmri_suface',connMethod,'.mat'];
    dtconn=fmriConn;
    save(fmriConnPath,'dtconn','fmriF','comment','-v7.3')
end

