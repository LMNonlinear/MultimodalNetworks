function fun_save_mat(varargin)
timeNow=strcat('_',string(datetime('now','Format','d-MMM-y-HH-mm-ss')));

switch nargin
    case 1
        variables=varargin{1};
        filename=char(strcat('.\temp\',timeNow));
    case 2
        variables=varargin{1};
        filename=varargin{2};
    case 3
        variables=varargin{1};
        filename=varargin{2};
        FLAG_PARTS=varargin{3};
        if FLAG_PARTS
            [path,name]=fileparts(filename);
            filename=char(strcat('.\temp\',name));
        end
        filename=char(strcat('.\temp\',filename));
    case 4  
        variables=varargin{1};
        filename=varargin{2};
        FLAG_PARTS=varargin{3};
        FLAG_TIME=varargin{4};
        if FLAG_PARTS
            [path,name]=fileparts(filename);
            filename=char(strcat('.\temp\',name));
        else
            filename=char(strcat('.\temp\',filename));
        end
        if FLAG_TIME
            filename=strcat(filename,timeNow);
        end
    case 5
        variables=varargin{1};
        filename=varargin{2};
        FLAG_PARTS=varargin{3};
        FLAG_TIME=varargin{4};
        extern=varargin{5};
        if FLAG_PARTS
            [path,name]=fileparts(filename);
            filename=char(strcat('.\temp\',name));
        else
            filename=char(strcat('.\temp\',filename));
        end        
        if FLAG_TIME
            filename=strcat(filename,timeNow);
        end
        filename=strcat(filename,strcat('_',extern));
end
save(filename, '-struct', 'variables');
% saveas(variables,filename)
end
