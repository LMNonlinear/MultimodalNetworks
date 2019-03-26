pool = startmatlabpool(4);
N=1000;
M=100;
data = cell(1,N);
for kk = 1:N
   data{kk} = rand(M);
end
display(strcat('datasize:',num2str(N*M*M/1024/1024),'M doubles'));
tic;
parfor ii = 1:N
     c1(:,ii) = eig(data{ii});
end
t1 = toc; 
display(strcat('parafor:',num2str(t1),'seconds'));
 
tic;
for ii = 1:N
     c2(:,ii) = eig(data{ii});
end
t2 = toc; 
display(strcat('for:',num2str(t2),'seconds'));
 
closematlabpool;
% 
% --------------------- 
% 作者：artzers 
% 来源：CSDN 
% 原文：https://blog.csdn.net/lpsl1882/article/details/50781288?utm_source=copy 
% 版权声明：本文为博主原创文章，转载请附上博文链接！