% function varargout=fun_evelope_based_correlation(varargin)
modality={'meg','fmri'};
%
% switch nargin
%     case 0
load ./temp/config.mat
%
%     case 2
%         SubjectName=varargin{1};
%         modality=varargin{2};
% end
%%
labelPath=['.\result\',SubjectName,'.rs.from32k.4k.105923.aparc.32k_fs_LR.label.mat'];
labelMat=load(labelPath);
%% meg
% if nargin==0||nargin==2
if sum(strcmp(modality,'meg'))
    megPath=['.\result\',SubjectName,'.4k.source.matched.band.envelope.MEG_REST_LR.mat'];
    megMat=load(megPath);
    megSignal=megMat.megBandEnvelope.megBandEnvelope;
end
if sum(strcmp(modality,'fmri'))
    fmriPath=['.\result\',SubjectName,'.4k.surface.matched.fMRI_REST_LR.mat'];
    fmriMat=load(fmriPath);
    fmriSignal=fmriMat.fmriSignal;
end
% end
%%
if sum(strcmp(modality,'meg'))
    if iscell(megSignal)
        for iBand=1:max(size(megSignal))
            megCorr{iBand}=corr(megSignal{iBand}');
            figure;imagesc(megCorr{iBand});title(['meg corr',iBand]);colorbar;
        end
    end
end
if sum(strcmp(modality,'fmri'))
    if iscell(fmriSignal)
        for iBand=1:size(fmriSignal,1)
            fmriCorr{iBand}=corr(fmriSignal{iBand}');
            figure;imagesc(fmriCorr{iBand});title(['fmri corr',iBand]);colorbar;
            
        end
    elseif ismatrix(fmriSignal)
        fmriCorr=corr(fmriSignal');
        figure;imagesc(fmriCorr);title(['fmri corr',iBand]);colorbar;
    end
end

%%
close all
nHemiSphere=length(labelMat.labelL);
[labelSortL,idxSortL] = sort(labelMat.labelL);
[labelSortR,idxSortR] = sort(labelMat.labelR);
fmriCorrSort=fmriCorr([idxSortL;idxSortR+nHemiSphere],:);
fmriCorrSort=fmriCorrSort(:,[idxSortL;idxSortR+nHemiSphere]);
figure;imagesc(fmriCorrSort);title(['fmri corr']);colorbar;


