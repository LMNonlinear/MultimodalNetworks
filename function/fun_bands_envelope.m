function varargout= fun_bands_envelope(varargin)
addpath('./external/parpool/');
load .\temp\config.mat
switch nargin
    case 1
        subjectName=varargin{1};
    case 2
        subjectName=varargin{1};
        megBandMat=varargin{2};
end
load ./temp/config.mat

%% read data
if nargin==0||nargin==1
    megBandMatPath=['.\result\',subjectName,'.',kiloVertices,'.source.matched.band.MEG_REST_LR.mat'];
    megBandMat=load(megBandMatPath);
    %     megBandMat=megBandMat.megBand;
    megBandSignal=megBandMat.dtseries;
elseif nargin==2
%     %     megBandMatPath=['.\result\',subjectName,'.',kiloVertices,'.source.matched.band.MEG_REST_LR.mat'];
%     megBandMat=load(megBandMatPath);
    megBandSignal=megBandMat.dtseries;
    megBandMatPath=['.\result\',subjectName,'.',kiloVertices,'.source.matched.band.MEG_REST_LR.mat'];
end
%% process


%% debug, need remove
[~, hostname] = system('hostname');
hostname=string(strtrim(hostname));
if isDebug==1
    
        for iBand = 1:megBandMat.nFreqBands
            megBandHilebert{iBand} = hilbert(megBandSignal{iBand}')';
            megBandHilebertEnvelope{iBand}=abs(megBandHilebert{iBand});
            megBandHilebertEnvelope{iBand}=megBandHilebertEnvelope{iBand};
        end
   
    else
        startmatlabpool
        parfor iBand = 1:megBandMat.nFreqBands
            %     for iBand = 1:megBandMat.nFreqBands
            megBandHilebert{iBand} = hilbert(megBandSignal{iBand}')';
            %     megBandHilebertEnvelope{iBand}=abs(megBandHilebert{iBand}).^2;
            megBandHilebertEnvelope{iBand}=abs(megBandHilebert{iBand});
            %     subplot(megBandMat.nFreqBands,1,iBand)
            %     plot(megBandMat.megBandSignal{iBand}');hold on;
            %     plot(megBandHilebertEnvelope{iBand}');
            %cut head and end parts
            %             megBandHilebertEnvelope{iBand}=megBandHilebertEnvelope{iBand}(:,(megBandMat.sampleRateMeg)*30:(megBandMat.sampleRateMeg)*60-1);
            megBandHilebertEnvelope{iBand}=megBandHilebertEnvelope{iBand};
        end
        closematlabpool
end




% figure
% plot(megBandMat.megBandSignal{1}');hold on;
% plot(megBandHilebertEnvelope{1}');
% [yupper,ylower] = envelope(megBandMat.megBandSignal{1}');
% plot(yupper)
% figure
% plot(zscore(megBandHilebertEnvelope{1})');hold on
% plot(zscore(yupper));
%% output

megBandEnvelope= rmfield(megBandMat,'dtseries');
megBandEnvelope.dtseries=megBandHilebertEnvelope;
megPathOutput=strrep(megBandMatPath,['band'],['band.envelope']);
save(megPathOutput,'-struct','megBandEnvelope', '-v7.3');

switch nargout
    case 1
        varargout=megPathOutput;
    case 2
        varargout{1}=megPathOutput;
        varargout{2}=megBandEnvelope;
end
