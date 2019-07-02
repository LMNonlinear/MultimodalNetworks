function varargout=fun_imagesc_two(varargin)
%% fun_imagesc_two(data1,data2,title1,title2,ext1,ext2)
switch nargin
    case 2
        data1=varargin{1};
        data2=varargin{2};
        title1='data1';
        title2='data2';
    case 4
        data1=varargin{1};
        data2=varargin{2};
        title1=varargin{3};
        title2=varargin{4};
    case 6
        data1=varargin{1};
        data2=varargin{2};
        title1=varargin{3};
        title2=varargin{4};
        ext1=varargin{5};
        ext2=varargin{6};
        
end

type1=typeof(data1);
type2=typeof(data2);

%% max and min for color bar
if type1==1&&type2==1
    dataMin=min(min(min(data1)),min(min(data2)));
    dataMax=max(max(max(data1)),max(max(data2)));
elseif type1==2&&type2==1
    dataMin=min(min(data2));
    dataMax=max(max(data2));
    for i=1:max(size(data1))
        dataMin=min(dataMin,min(min(data1{i})));
        dataMax=max(dataMax,max(max(data1{i})));
    end
elseif type1==1&&type2==2
    dataMin=min(min(data1));
    dataMax=max(max(data1));
    for i=1:max(size(data2))
        dataMin=min(dataMin,min(min(data2{i})));
        dataMax=max(dataMax,max(max(data2{i})));
    end
elseif type1==2&&type2==2
    dataMin=nan;
    dataMax=nan;
    for i=1:max(size(data1))
        dataMin=min(dataMin,min(min(data1{i})));
        dataMax=max(dataMax,max(max(data1{i})));
    end
    for i=1:max(size(data2))
        dataMin=min(dataMin,min(min(data2{i})));
        dataMax=max(dataMax,max(max(data2{i})));
    end
end
% varargout{1}=dataMin;
% varargout{2}=dataMax;
%%
if type1==1&&type2==1
    imegsc_two(data1,data2,title1,title2,dataMin,dataMax)
elseif type1==2&&type2==1
    for i=1:max(size(data1))
        title1temp=strcat(title1,'-',ext1{i});
        imegsc_two(data1{i},data2,title1temp,title2,dataMin,dataMax)
    end
elseif type1==1&&type2==2
    for i=1:max(size(data2))
        title2temp=strcat(title2,'-',ext2{i});
        imegsc_two(data1,data2{i},title1,title2temp,dataMin,dataMax)
    end
elseif type1==2&&type2==2
    for i=1:max(size(data1))
        title1temp=strcat(title1,'-',ext1{i});
        for j=1:max(size(data2))
            title2temp=strcat(title2,'-',ext2{j}); 
            imegsc_two(data1{i},data2{j},title1temp,title2temp,dataMin,dataMax)
        end       
    end
end

end

function varout=typeof(varin)
if iscell(varin)
    varout=2;
elseif ismatrix(varin)
    varout=1;
end
end

function varout=imegsc_two(mat1,mat2,title1,title2,colorBarMin,colorBarMax)

figure

subplot(121)
imagesc(mat1)
axis equal
axis([1,size(mat1,1),1,size(mat1,2)]);
title(title1)
colorbar
caxis([colorBarMin,colorBarMax]);
colormap pink

subplot(122)
imagesc(mat2)
axis equal
axis([1,size(mat2,1),1,size(mat2,2)]);
title(title2)
colorbar
caxis([colorBarMin,colorBarMax]);
colormap pink

set(gcf,'outerposition',get(0,'screensize'));
picname=strcat(title1,'  and  ',title2);
fun_save_figure(picname)

% varout{1}=gcf;
% varout{2}=picname;
end


