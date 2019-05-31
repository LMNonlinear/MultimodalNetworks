function [dat,nifti_struct] = niftiopen(varargin)


% if ischar(varargin{1})
%     if size(varargin{1},1)>1
%         h = nifti(cellstr(varargin{1}));
%     end
if ischar(varargin{1})
    h = nifti(varargin{1});
    dat = h.dat;
    dat=squeeze(double(dat));
elseif iscell(varargin{1})
    fnames = varargin{1};
    h(numel(fnames)) = struct('hdr',[],'dat',[],'extras',struct);
%     h     = class(h,'nifti');
    for i=1:numel(fnames)
        h(i) = nifti(fnames{i});
        dat{i} = h.dat;
        dat{i}=squeeze(double(dat{i}));
    end
end



if nargout > 1
    nifti_struct=h;
end


