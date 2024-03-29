function varargout=fun_sort_label(varargin)
switch nargin
    case 0
        load ./temp/config.mat
    case 1
        subjectName=varargin{1};
end
%% label
labelPath=['.\result\',subjectName,'.rs.from32k.',kiloVertices,'.aparc.32k_fs_LR.label.mat'];
labelMat=load(labelPath);
%% label sort
nHemiSphere=length(labelMat.labelL);
[labelSortL,idxSortL] = sort(labelMat.labelL);
[labelSortR,idxSortR] = sort(labelMat.labelR);
%% save
labelRaw=labelMat;
labelSorted.attribute=labelRaw.attribute;
labelSorted.labelSortL=labelSortL;
labelSorted.labelSortR=labelSortR;
labelSorted.idxRaw2SortL=idxSortL;
labelSorted.idxRaw2SortR=idxSortR;
labelSortedPath=strrep(labelPath,'.',kiloVertices,'','.',kiloVertices,'.sorted');
save(labelSortedPath,'labelRaw','labelSorted');
end
