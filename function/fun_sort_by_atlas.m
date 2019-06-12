function fun_sort_by_atlas
switch nargin
    case 0
        load ./temp/config.mat
    case 1
        SubjectName=varargin{1};
    case 2
        SubjectName=varargin{1};
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
