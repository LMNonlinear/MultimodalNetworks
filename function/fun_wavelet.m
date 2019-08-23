function varargout=fun_wavelet(varargin)
load ./temp/config.mat
switch nargin
    case 1
        subjectName=varargin{1};
    case 3
        subjectName=varargin{1};
        megSignal=varargin{2};
        fmriSignal=varargin{3};
end

%% read
switch nargin
    case 0
        megMatPath=['.\result\',subjectName,'.4k.source.matched.MEG_REST_LR.mat'];
        megMat=load(megMatPath);
        megSignal=megMat.dtseries;
%         fmriMatPath=['.\result\',subjectName,'.4k.surface.matched.fMRI_REST_LR.mat'];
%         fmriMat=load(fmriMatPath);
%         fmriSignal=fmriMat.dtseries;
    case 1
        megMatPath=['.\result\',subjectName,'.4k.source.matched.MEG_REST_LR.mat'];
        megMat=load(megMatPath);
        megSignal=megMat.dtseries;
%         fmriMatPath=['.\result\',subjectName,'.4k.surface.matched.fMRI_REST_LR.mat'];
%         fmriMat=load(fmriMatPath);
%         fmriSignal=fmriMat.dtseries;
end

%% wavelet
megWaveletInfo.freqs=3:5:80;
megWaveletInfo.width=7;
megTfr = morletcwt(megSignal', 3:5:80, megInfo.sampleRate, 7);
% figure
% imagesc([0:399]/megInfo.sampleRate, 3:5:80, abs(megTfr(:,:,1)).^2'); axis xy
%% save
    megMatPath=strrep(megMatPath,'matched','matched.timefrequency');
%     dtseries=megTfr;
    dtseries=abs(megTfr.^2);
    waveletInfo=megWaveletInfo;
    save(megMatPath,'dtseries','waveletInfo','-v7.3')
varargout{1}=dtseries;
varargout{2}=megMatPath;

end