function varargout= fun_group_in_freqs_bands(varargin)
switch nargin
    case 0
        load ./temp/config.mat
    case 1
        SubjectName=varargin{1};
    case 2
        SubjectName=varargin{1};
        megSignal=varargin{2};
end

%% read data
if nargin==0||nargin==1
    megMatPath=['.\result\',SubjectName,'.4k.source.matched.MEG_REST_LR.mat'];
    sampleRateMeg=int32(250);%raw data is 2034.5101Hz, need as an iput
    indexTimeMeg=[sampleRateMeg*30:sampleRateMeg*60-1];
    timeMeg=double(indexTimeMeg-indexTimeMeg(1))/double(sampleRateMeg);
    % megNifti=load(megMatPath, [idxTimeMeg]);
    megMat=load(megMatPath);
    megSignal=megMat.megSignal;
elseif nargin==2
    sampleRateMeg=int32(250);%raw data is 2034.5101Hz, need as an iput
    indexTimeMeg=[sampleRateMeg*30:sampleRateMeg*60-1];
    timeMeg=double(indexTimeMeg-indexTimeMeg(1))/double(sampleRateMeg);
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
isMirror=0;
for iBand = 1:nFreqBands
    %     megBand{iBand} = process_bandpass('Compute',fmriSignal(1,:), sampleRateMeg, BandBounds(iBand,1), BandBounds(iBand,2), 'bst-hfilter-2019', isMirror);
    [megBandSignal{iBand}, filtSpec{iBand}, Messages{iBand}] = process_bandpass('Compute',megSignal, sampleRateMeg, bandBounds(iBand,1), bandBounds(iBand,2), 'bst-hfilter-2019', isMirror);
%     [megBandSignal{iBand}, filtSpec{iBand}, Messages{iBand}] = process_bandpass('Compute',megSignal(1:2,:), sampleRateMeg, bandBounds(iBand,1), bandBounds(iBand,2), 'bst-hfilter-2019', isMirror);

    %     subplot(nFreqBands,1,iBand)
    %     plot(megBandSignal{iBand}')
end
%% output
megBand.megBandSignal=megBandSignal;
megBand.nFreqBands=nFreqBands;
megBand.sampleRateMeg=sampleRateMeg;
megBand.indexTimeMeg=indexTimeMeg;
megBand.timeMeg=timeMeg;
megBand.filtSpec=filtSpec;
megBand.bandsFreqs=bandsFreqs;
megBand.bandBounds=bandBounds;

megPathOutput=strrep(megMatPath,['matched'],['matched.band']);
save(megPathOutput,'megBand', '-v7.3');
switch nargout
    case 1
        varargout=megPathOutput;
    case 2
        varargout{1}=megPathOutput;
        varargout{2}=megBand;
end


