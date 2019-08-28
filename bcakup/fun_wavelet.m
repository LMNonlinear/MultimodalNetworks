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



%%
switch nargin
    case 0
        megMatPath=['.\result\',subjectName,'.',kiloVertices,'.source.matched.MEG_REST_LR.mat'];
        megMat=load(megMatPath);
        megSignal=megMat.dtseries;
        fmriMatPath=['.\result\',subjectName,'.',kiloVertices,'.surface.matched.fMRI_REST_LR.mat'];
        fmriMat=load(fmriMatPath);
        fmriSignal=fmriMat.dtseries;
    case 1
        megMatPath=['.\result\',subjectName,'.',kiloVertices,'.source.matched.MEG_REST_LR.mat'];
        megMat=load(megMatPath);
        megSignal=megMat.dtseries;
        fmriMatPath=['.\result\',subjectName,'.',kiloVertices,'.surface.matched.fMRI_REST_LR.mat'];
        fmriMat=load(fmriMatPath);
        fmriSignal=fmriMat.dtseries;
end
% %%
% % Coefs = morlet_transform(sin(2*pi*10*t),t,f,[],[],'n');
% % megCoefs=morlet_transform(sin(2*pi*10*t),t,f,[],[],'2');
% %    S         Signal: Array which first dimension is time in seconds.
% %    freqVec   Frequency grid in Hz
% %    Fs        sampling rate in Hertz
% %    width     Wavelet parameter (see Tallon-Baudry, 1997)
% % function TFR = morletcwt(S, freqVec, Fs, width);
% %%%Help or morletcwt
% % INPUT
% %    S         Signal: Array which first dimension is time in seconds.
% %    freqVec   Frequency grid in Hz
% %    Fs        sampling rate in Hertz
% %    width     Wavelet parameter (see Tallon-Baudry, 1997)
% % OUTPUT
% %    TFR       Wavelets coefficients matrix
% %    
% 
% plotEEG(1/megInfo.sampleRate,[0:399]/megInfo.sampleRate,megSignal(1,:));
% % megTfr = morletcwt(megSignal(1,:)', [3,6,10,22,60,45,75], megInfo.sampleRate, 7);
% % 
% % 
% % 
% % imagesc(megInfo.time, [3,6,10,22,60,45,75], abs(megTfr).^2'); axis xy
% % fmriTfr = morletcwt(fmriSignal(1,:)', [3,6,10,22,60,45,75], fmriInfo.sampleRate, 7);
% figure
% for i=1:size(megInfo.bandsFreqs)
% %     megTfr(:,i) = morletcwt(megSignal(1,:)', str2num(megInfo.bandsFreqs{i,4}), megInfo.sampleRate, str2num(megInfo.bandsFreqs{i,5})/2);
%     megTfr(:,i) = morletcwt(megSignal(1,:)', str2num(megInfo.bandsFreqs{i,4}), megInfo.sampleRate,7);
% end
% imagesc(megInfo.time, [3,6,10,22,60,45,75], abs(megTfr).^2'); axis xy
% 
% figure
% TFR = morletcwt(megSignal(1,:)', 3:0.5:80, megInfo.sampleRate, 7);
% imagesc([0:399]/megInfo.sampleRate, 3:0.5:80, abs(TFR).^2'); axis xy
% 

%%
% figure
% megTfr = morletcwt(megSignal(1,:)', 3:5:80, megInfo.sampleRate, 7);
% imagesc([0:399]/megInfo.sampleRate, 3:0.5:80, abs(megTfr).^2'); axis xy
% figure
% TFR = morletcwt(megSignal(1,:)', 3:0.5:80, megInfo.sampleRate, 7);
% imagesc([0:399]/megInfo.sampleRate, 3:0.5:80, abs(TFR).^2'); axis xy
%
figure
megTfr = morletcwt(megSignal', 3:5:80, megInfo.sampleRate, 7);
imagesc([0:399]/megInfo.sampleRate, 3:5:80, abs(megTfr(:,:,1)).^2'); axis xy
% fmriTfr = morletcwt(fmriSignal', 3:5:80, fmriInfo.sampleRate, 7);
% fmriTfr = morletcwt(fmriSignal(1,:)', 0.05:0.01:2, fmriInfo.sampleRate, 50);
% imagesc([0:299]/fmriInfo.sampleRate, 0.05:0.01:2, abs(fmriTfr).^2'); axis xy

end