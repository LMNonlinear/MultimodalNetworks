
function [pool] = startmatlabpool(size)
pool=[];
isstart = 0;
if isempty(gcp('nocreate'))==1
    isstart = 1;
end
if isstart==1
    if nargin==0
        pool=parpool('local');
    else
        try
            pool=parpool('local',size);%matlabpool('open','local',size);
        catch ce
            pool=parpool('local');%matlabpool('open','local');
            size = pool.NumWorkers;
            display(ce.message);
            display(strcat('restart. wrong  size=',num2str(size)));
        end
    end
else
    display('matlabpool has started');
    if nargin==1
        closematlabpool;
        startmatlabpool(size);
    else
        startmatlabpool();
    end
end
% 
% --------------------- 
% ���ߣ�artzers 
% ��Դ��CSDN 
% ԭ�ģ�https://blog.csdn.net/lpsl1882/article/details/50781288?utm_source=copy 
% ��Ȩ����������Ϊ����ԭ�����£�ת���븽�ϲ������ӣ�