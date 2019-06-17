function varargout=fun_sort_by_atlas(varargin)

%% stop work with this, sort the result is better

modality=[];
switch nargin
    case 0
        load ./temp/config.mat
    case 2
        SubjectName=varargin{1};
        modality=varargin{2};
    case 3
        SubjectName=varargin{1};
        modality=varargin{2};
        data=varargin{3};
        label=varargin{4};
end

%% read data
if nargin==0||nargin==2
   labelPath=['.\result\',SubjectName,'.rs.from32k.4k.105923.aparc.32k_fs_LR.label.mat'];
   labelMat=load(labelPath);
   label=labelMat.fmriLabel.label;   
elseif nargin==3
   
end
if isempty(modality)
    modality=['meg','fmri'];
end
%%
% switch modality
%     case ['meg','fmri']
%         dataPath={['.\result\',SubjectName,'.4k.surface.matched.fMRI_REST_LR.mat'],...
%             ['.\result\',SubjectName,'.4k.source.matched.band.envelope.MEG_REST_LR.mat']};
%     case 'meg'
%         megPath=['.\result\',SubjectName,'.4k.source.matched.band.envelope.MEG_REST_LR.mat'];
%         megMat=load(megPath);
%         megMat.
%     case 'fmri'
%         a=3
% end
%%
labelL=label(1:size(label,1)/2);
labelR=label(size(label,1)/2+1:end);
sort()


%%
megPath=['.\result\',SubjectName,'.4k.source.matched.band.envelope.MEG_REST_LR.mat'];
megMat=load(megPath);
megMat=megMat.megBandEnvelope;


for iBand=1:megMat.nFreqBands
    
end
