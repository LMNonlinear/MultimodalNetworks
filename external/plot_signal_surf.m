function varargout = plot_surf(varargin)

cdata = [];
ax = [];

%% not finish


end



% plot method for GIfTI objects
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% Guillaume Flandin
% $Id: plot.m 7381 2018-07-25 10:27:54Z guillaume $

% if ishandle(varargin{1})
%     h = figure(varargin{1});
% else
%     h = figure;
%     %axis equal;
%     %axis off;
%     %camlight;
%     %camlight(-80,-10);
%     %lighting gouraud;
% end
% cameratoolbar;


cdata = [];
ax = [];
if nargin == 1
    if isobject(varargin{1})
        this = varargin{1};
        h = gcf;
    elseif ischar(varargin{1})
        this = gifti(varargin{1});
        h = gcf;
    end
else
    if ishandle(varargin{1})
        ax = varargin{1};
        h = figure(get(ax,'parent'));
        this = varargin{2};
    elseif isobject(varargin{2})%%2 is a metric shape 
        this = varargin{1};
        h = gcf;
        cdata = subsref(varargin{2},struct('type','.','subs','cdata'));
    elseif ischar(varargin{1}) && ischar(varargin{2})
%         if(varargin{2})
        
        this = gifti(varargin{1});
        [pathstr, name, ext] = fileparts(varargin{2});
        if contains([name, ext],'.func.gii')
            wb_command=varargin{4};
            nii_filename=strrep(varargin{2},'.func.gii','.nii');
            system([wb_command ' -metric-convert -to-nifti ' varargin{2},' ',nii_filename]);
            cdata= nifti(nii_filename);
            cdata= squeeze(double(cdata.dat)); 
        elseif contains(ext,'.dtseries.nii')
            wb_command=varargin{4};
            cdata= ciftiopen(varargin{2},wb_command);
            cdata= cdata.cdata; 
        elseif contains(ext,'.nii')
            cdata= nifti(varargin{2});
            cdata= squeeze(double(cdata)); 
            
        end
              
        h = gcf;
    end
    if nargin > 2 
        indc = varargin{3};
%     elseif nargin > 2 && max(size(varargin{3}))>1
%         indc=mean(varargin{3});        
    else
        indc = 1;
    end
end

% if isempty(ax)
%     ax = axes('Parent',h); 
% end
% axis(ax,'equal');
% axis(ax,'off');

% hp = patch(struct(...
%     'vertices',  subsref(this,struct('type','.','subs','vertices')),...
%     'faces',     subsref(this,struct('type','.','subs','faces'))),...
%     'FaceColor', 'b',...
%     'EdgeColor', 'none',...
%     'Parent',ax);
hp = patch(struct(...
    'vertices',  subsref(this,struct('type','.','subs','vertices')),...
    'faces',     subsref(this,struct('type','.','subs','faces'))),...
    'FaceColor', 'b',...
    'EdgeColor', 'none');

axis equal
if ~isempty(cdata)&& max(size(indc))==1
    set(hp,'FaceVertexCData',cdata(:,indc), 'FaceColor','interp')
elseif ~isempty(cdata)&& max(size(indc))>1
%     cdata=mean
    set(hp,'FaceVertexCData',mean(cdata(:,indc),2), 'FaceColor','interp')
else
    val=linspace(0,10,size(subsref(this,struct('type','.','subs','vertices')),1))';
    set(hp,'FaceVertexCData',val, 'FaceColor','interp')
end

% camlight(ax);
% camlight(ax,-80,-10);
% lighting(ax,'gouraud');
% cameratoolbar(h);

if nargout
    varargout{1} = hp;
end
