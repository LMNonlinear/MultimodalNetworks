% function varargout=fun_cross_spectrum(varargin)
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
% labelPath=['.\result\',SubjectName,'.rs.from32k.4k.105923.aparc.32k_fs_LR.label.mat'];
% labelMat=load(labelPath);
%% meg
% if nargin==0||nargin==2
% if sum(strcmp(modality,'meg'))
if ~exist('megSignal','var')||isempty(megSignal)
    megPath=['.\result\',SubjectName,'.4k.source.matched.MEG_REST_LR.mat'];
    megMat=load(megPath);
    megSignal=megMat.megSignal(1:2,30*250:60*250-1);
end
% end
% if sum(strcmp(modality,'fmri'))
%     fmriPath=['.\result\',SubjectName,'.4k.surface.matched.fMRI_REST_LR.mat'];
%     fmriMat=load(fmriPath);
%     fmriSignal=fmriMat.fmriSignal;
% end
% end
%% weltch cross spectrum
% close all
% if sum(strcmp(modality,'meg'))
%     [pxy_mimo,f]=cpsd(megSignal',megSignal',[],[],[],250,'mimo');
% end
%% wavelet coherence
fs=250;
tm=0:1/fs:30-(1/fs);
% [wcoh,~,f,coi] = wcoherence(megSignal(1,:)',megSignal(2,:)',10,'numscales',16);
% helperPlotCoherence(wcoh,tm,f,coi,'Seconds','Hz');
[wcoh,wcs,f] = wcoherence(megSignal(1,:)',megSignal(2,:)',fs) ;
wcoherence(megSignal(1,:)',megSignal(2,:)',fs) ;
%% test sigmoid
% if sum(strcmp(modality,'meg'))
%     close all
%     %     [pxy,f
%     % megSignalSelected=megSignal+1000*sin(100*2*pi*([1:size(megSignal,2)])/250);
% %     megSignalNormalize=normalize(megSignal');
%     megSignalSelected(1,:)=megSignal(1,:);
%     megSignalSelected(2,:)=sigmoid(megSignal(2,:));
%     % megSignalSelected(2,:)=sigmoid(megSignalNormalize(2,:));
%     subplot(2,1,1)
%     plot(megSignalSelected(1,:));hold on
%     plot(megSignalSelected(2,:));
%     subplot(2,1,2)
%     cpsd(megSignalSelected(1,:)',megSignalSelected(2,:)',[],[],[],250);hold on
%     cpsd(megSignal(1,:)',megSignal(2,:)',[],[],[],250);
%
%     %     plot(pxy)
%
% end
