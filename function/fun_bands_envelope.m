function varargout= fun_bands_envelope(varargin)
addpath('./external/parpool/');
switch nargin
    case 0
        load ./temp/config.mat
    case 1
        SubjectName=varargin{1};
    case 2
        SubjectName=varargin{1};
        megBandMat=varargin{2};
end
load ./temp/config.mat

%% read data
if nargin==0||nargin==1
    megBandMatPath=['.\result\',SubjectName,'.4k.source.matched.band.MEG_REST_LR.mat'];
    megBandMat=load(megBandMatPath);
    megBandMat=megBandMat.megBand;
    %     megBandSignal=megBandMat.megBandSignal;
elseif nargin==2
    megBandMatPath=['.\result\',SubjectName,'.4k.source.matched.band.MEG_REST_LR.mat'];
    
end
%% process
startmatlabpool
parfor iBand = 1:megBandMat.nFreqBands
    megBandHilebert{iBand} = hilbert(megBandMat.megBandSignal{iBand}')';
    %     megBandHilebertEnvelope{iBand}=abs(megBandHilebert{iBand}).^2;
    megBandHilebertEnvelope{iBand}=abs(megBandHilebert{iBand});
    %     subplot(megBandMat.nFreqBands,1,iBand)
    %     plot(megBandMat.megBandSignal{iBand}');hold on;
    %     plot(megBandHilebertEnvelope{iBand}');
    %cut head and end parts
    megBandHilebertEnvelope{iBand}=megBandHilebert{iBand}(:,(megBandMat.sampleRateMeg)*30:(megBandMat.sampleRateMeg)*60);
end
closematlabpool
% figure
% plot(megBandMat.megBandSignal{1}');hold on;
% plot(megBandHilebertEnvelope{1}');
% [yupper,ylower] = envelope(megBandMat.megBandSignal{1}');
% plot(yupper)
% figure
% plot(zscore(megBandHilebertEnvelope{1})');hold on
% plot(zscore(yupper));
%% output

megBandEnvelope= rmfield(megBandMat,'megBandSignal');
megBandEnvelope.megBandHilebertEnvelope=megBandHilebertEnvelope;
megPathOutput=strrep(megBandMatPath,['matched'],['matched.band.envelope']);
save(megPathOutput,'megBandEnvelope', '-v7.3');

switch nargout
    case 1
        varargout=megPathOutput;
    case 2
        varargout{1}=megPathOutput;
        varargout{2}=megBandEnvelope;
end
