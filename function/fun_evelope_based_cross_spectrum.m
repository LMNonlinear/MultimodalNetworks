% function varargout=fun_evelope_based_cross_spectrum(varargin)

modality={'meg','fmri'};
load ./temp/config.mat

if ~exist('megSignal','var')||isempty(megSignal)
    megPath=['.\result\',subjectName,'.',kiloVertices,'.source.matched.band.envelope.MEG_REST_LR.mat'];
    megMat=load(megPath);
    for i=1:megMat.megBandEnvelope.nFreqBands        
        megSignal{i}=megMat.megBandEnvelope.megBandEnvelope{i};
    end
end

%%
close all
 if sum(strcmp(modality,'meg'))
     for i=1:megMat.megBandEnvelope.nFreqBands
%             [pxy{i},f{i}]=cpsd(megSignal{i}',megSignal{i}',[],[],[],250); 
        cpsd(megSignal{i}',megSignal{i}',[],[],[],250); 

     end
end
