function fun_save_figure(varargin)
timeNow=strcat('_',string(datetime('now','Format','d-MMM-y-HH-mm-ss')));

switch nargin
    case 0
        gcfHandle=gcf;
        filename=char(strcat('.\figure\',timeNow,'.jpg'));
    case 1
        gcfHandle=gcf;
        filename=varargin;
    case 2
        gcfHandle=gcf;
        filename=varargin{1};
        FLAG_PARTS=varargin{2};
        if FLAG_PARTS
            [path,name]=fileparts(filename);
            filename=char(strcat('.\figure\',name,'.jpg'));
        end
        filename=char(strcat('.\figure\',filename,'.jpg'));
    case 3
        gcfHandle=gcf;
        filename=varargin{1};
        FLAG_PARTS=varargin{2};
        FLAG_TIME=varargin{3};
        if FLAG_PARTS
            [path,name]=fileparts(filename);
            filename=char(strcat('.\figure\',name,'.jpg'));
        else
            filename=char(strcat('.\figure\',filename,'.jpg'));
        end
        if FLAG_TIME
            filename=char(strrep(filename,'.jpg',strcat(timeNow,'.jpg')));
        end
    case 4
        gcfHandle=gcf;
        filename=varargin{1};
        FLAG_PARTS=varargin{2};
        FLAG_TIME=varargin{3};
        extern=varargin{4};
        if FLAG_PARTS
            [path,name]=fileparts(filename);
            filename=char(strcat('.\figure\',name,'.jpg'));
        else
            filename=char(strcat('.\figure\',filename,'.jpg'));
        end
        
        if FLAG_TIME
            filename=char(strrep(filename,'.jpg',strcat(timeNow,'.jpg')));
        end
        filename=char(strrep(filename,'.jpg',strcat('_',extern,'.jpg')));
    case 5
        filename=varargin{1};
        FLAG_PARTS=varargin{2};
        FLAG_TIME=varargin{3};
        extern=varargin{4};
        if FLAG_PARTS
            [path,name]=fileparts(filename);
            filename=char(strcat('.\figure\',name,'.jpg'));
        else
            filename=char(strcat('.\figure\',filename,'.jpg'));
        end
        if FLAG_TIME
            filename=char(strrep(filename,'.jpg',strcat(timeNow,'.jpg')));
        end
        filename=char(strrep(filename,'.jpg',strcat('_',extern,'.jpg')));
        
        gcfHandle=varargin{5};
end
saveas(gcfHandle,filename)
end
