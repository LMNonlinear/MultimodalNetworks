function msg=fun_command(varargin)
command_mat=[];
for i=1:nargin
    command_mat=[command_mat,' ',cell2mat(varargin(i))];
end
msg=system(command_mat);
end
