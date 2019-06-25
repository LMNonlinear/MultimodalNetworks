function varargout=fun_cross_spectrum(varargin)
modality={'meg','fmri'};
FLAG_DISPLAY=0;

switch nargin
    case 0
        load ./temp/config.mat
    case 2
        SubjectName=varargin{1};
        modality=varargin{2};
end
%% label
labelPath=['.\result\',SubjectName,'.rs.from32k.4k.aparc.32k_fs_LR.label.mat'];
labelMat=load(labelPath);
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
%% cross spectrum
if sum(strcmp(modality,'meg'))
    [pxy,f]=cpsd(megSignal',megSignal',[],[],[],250,'mimo'); %should not use mimo?
end
%% coherence
cxy=[];
for i=1:size(pxy,2)
    cxy(:,i,:)=(abs(pxy(:,i,:)).^2)./real(pxy(:,i,i));
end
for j=1:size(pxy,3)
    cxy(:,:,j)=cxy(:,:,j)./real(pxy(:,j,j));
end
fs=250;
tm=0:1/fs:30-(1/fs);
% f=linspace(0,125,size(cxy_mino,1));

if FLAG_DISPLAY==1
    figure
end
%% bands
bandsFreqs= {'delta', '2, 4', 'mean';...
    'theta', '5, 7', 'mean';...
    'alpha', '8, 12', 'mean';...
    'beta', '15, 29', 'mean';...
    'gamma', '30, 90', 'mean';...
    'gamma1', '30, 59', 'mean';...
    'gamma2', '60, 90', 'mean'};
bandBounds = process_tf_bands('GetBounds', bandsFreqs);
nFreqBands=size(bandBounds,1);

%%
% mean of bands.


%
% iFreq = find((TimefreqMat.Freqs >= BandBounds(iBand,1)) & (TimefreqMat.Freqs <= BandBounds(iBand,2)));
% switch lower(FreqBands{iBand,3})
% case 'mean', TF_bands(:,:,iBand) = mean(TimefreqMat.TF(:,:,iFreq), 3);
% case 'median', TF_bands(:,:,iBand) = median(TimefreqMat.TF(:,:,iFreq), 3);
% case 'max', TF_bands(:,:,iBand) = max(TimefreqMat.TF(:,:,iFreq), [], 3);
% case 'std', TF_bands(:,:,iBand) = std(TimefreqMat.TF(:,:,iFreq), [], 3);
% end

