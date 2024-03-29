function varargout= fun_hcp_fmri_resampling(varargin)
load ./temp/config.mat
addpath('./external')
addpath('./external/cifti-nan-matlab/')
addpath('./external/nifti-spm-matlab/')

%% FLAG
FLAG.SPHERE_RESAMPLE=1;
FLAG.STRUC_RESAMPLE=1;
FLAG.FIX_FUNC_DILATE=0;
FLAG.FIX_LABEL_DILATE=0;
FLAG.LABEL_SEPRATE=1;
FLAG.LABEL_RESAMPLE=1;
FLAG.FUNC_SEPARATE=1;
FLAG.FUNC_RESAMPLE=1;
FLAG.DISPLAY=0;
FLAG.NIFITI_OUT=1;
%%
numVertices=4000;
%%
switch nargin
    case 0
        load ./temp/config.mat
    case 2
        load ./temp/config.mat
        dataDir=varargin{1};
        subjectName=varargin{2};
    case 3
        load ./temp/config.mat
        dataDir=varargin{1};
        subjectName=varargin{2};
        wb_command=varargin{3};
    case 4 % skip some step
        load ./temp/config.mat
        dataDir=varargin{1};
        subjectName=varargin{2};
        wb_command=varargin{3};
        FLAG=varargin{4};
end
%% path
% wb_command='D:\Software\workbench\bin_windows64\wb_command.exe';
% dataDir='C:\Data\HCP_S900\';
pipeline_path=mfilename('fullpath');
i=strfind(pipeline_path,'\');
% pipeline_name=pipeline_path(i(end)+1:end);
% pipeline_path=pipeline_path(1:i(end));
% pipeline_name=pipeline_path(i(end-2)+1:i(end-1));
% pipeline_path=pipeline_path(1:i(end-1));
[filepath,name,ext]=fileparts(pipeline_path);
[pipeline_path,pipeline_name,~]=fileparts(filepath);

tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CREAT NEW SPHERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%path to store
newSphere= {['./result/Sphere.',kiloVertices,'.L.surf.gii'],...
    ['./result/Sphere.',kiloVertices,'.R.surf.gii']};
% create sphere by workbench/ the sphere in freesurfer atlas
if FLAG.SPHERE_RESAMPLE==1
    system([wb_command ' -surface-create-sphere',' ',num2str(numVertices),' ',newSphere{2}]);
    system([wb_command ' -surface-flip-lr',' ',newSphere{2},' ', newSphere{1}]);
    system([wb_command ' -set-structure',' ',newSphere{2},' CORTEX_RIGHT']);
    system([wb_command ' -set-structure',' ',newSphere{1},' CORTEX_LEFT']);
end
%visualize the result
if FLAG.DISPLAY==1 && FLAG.SPHERE_RESAMPLE==1
    figure
    gii.left=gifti(newSphere{1});
    gii.right=gifti(newSphere{2});
    plotatlas(gii.left);
    hold on
    plotatlas(gii.right);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SURFACE DATA RESAMPLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
highResSurface={[dataDir,subjectName,'\MNINonLinear\fsaverage_LR32k\',subjectName,'.L.midthickness.32k_fs_LR.surf.gii'],...
    [dataDir,subjectName,'\MNINonLinear\fsaverage_LR32k\',subjectName,'.R.midthickness.32k_fs_LR.surf.gii']};

highResSphere={[dataDir,subjectName,'\MNINonLinear\fsaverage_LR32k\',subjectName,'.L.sphere.32k_fs_LR.surf.gii'],...
    [dataDir,subjectName,'\MNINonLinear\fsaverage_LR32k\',subjectName,'.R.sphere.32k_fs_LR.surf.gii']};

lowResSphere=newSphere;
lowResSurface={['./result/',subjectName,'.L.midthickness.from32k.',kiloVertices,'.fs_LR.surf.gii']...
    ['./result/',subjectName,'.R.midthickness.from32k.',kiloVertices,'.fs_LR.surf.gii']};
method='BARYCENTRIC ';
if FLAG.STRUC_RESAMPLE==1
    system([wb_command, ' -surface-resample ',' ',highResSurface{1},' ',highResSphere{1},' ',lowResSphere{1},' ', method,' ',lowResSurface{1}]);
    system([wb_command, ' -surface-resample ',' ',highResSurface{2},' ',highResSphere{2},' ',lowResSphere{2},' ', method,' ',lowResSurface{2}]);
end
lowResSurfaceGii{1}=gifti(lowResSurface{1});
lowResSurfaceGii{2}=gifti(lowResSurface{2});
numVerticesLR{1}=max(size(lowResSurfaceGii{1}.vertices));
numVerticesLR{2}=max(size(lowResSurfaceGii{2}.vertices));
numVerticesLR{3}=numVerticesLR{1}+numVerticesLR{2};
filename = './temp/config.mat';
save(filename,'numVerticesLR','-append')
if FLAG.DISPLAY==1 && FLAG.STRUC_RESAMPLE==1
    figure
    subplot(2,2,1)
    plotatlas(highResSurface{1});
    hold on
    plotatlas(highResSurface{2});
    tile_name=strrep(highResSurface{1},'\','/');
    tile_name=strrep(tile_name,'_','\_');
    title(['highResSurface=',tile_name]);
    
    subplot(2,2,2)
    plotatlas(highResSphere{1});
    hold on
    plotatlas(highResSphere{2});
    tile_name=strrep(highResSphere{1},'\','/');
    tile_name=strrep(tile_name,'_','\_');
    title(['highResSphere=',tile_name]);
    
    subplot(2,2,4)
    plotatlas(lowResSphere{1});
    hold on
    plotatlas(lowResSphere{2});
    tile_name=strrep(lowResSphere{1},'\','/');
    tile_name=strrep(tile_name,'_','\_');
    title(['lowResSphere=',tile_name]);
    
    subplot(2,2,3)
    plotatlas(lowResSurface{1});
    hold on
    plotatlas(lowResSurface{2});
    tile_name=strrep(lowResSurface{1},'\','/');
    tile_name=strrep(tile_name,'_','\_');
    title(['lowResSurface=',tile_name]);
    
    set(gcf,'outerposition',get(0,'screensize'));% matlab�������?
    picname=[pipeline_path,'\figure\',pipeline_name,'_surface_data_resample.fig'];%������ļ�������i=1ʱ��picname=1.fig
    saveas(gcf,picname)
    picname=strrep(picname,'.fig','.jpg');
    saveas(gcf,picname)
    pause(0.1)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIX LABEL DATA  (https://wiki.humanconnectome.org/display/PublicData/DIY+fix+for+zeroes+near+medial+wall+in+rfMRI+dtseries+data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ciftiIn=[dataDir,subjectName,'\MNINonLinear\fsaverage_LR32k\',subjectName,'.aparc.32k_fs_LR.dlabel.nii'];
direction='COLUMN';
surfaceDistance='4.0';
volumeDistance='4.0';
ciftiOut=ciftiIn;
badBrainordinateRoi=[dataDir,subjectName,'\MNINonLinear\Result\rfMRI_REST1_LR\rfMRI_REST1_LR_Atlas_hp2000_clean.dtseries.nii'];
if FLAG.FIX_LABEL_DILATE==1
    %     ciftiOut=[dataDir,subjectName,'\MNINonLinear\fsaverage_LR32k\',subjectName,'.aparc.32k_fs_LR_FIXED.dlabel.nii'];
    %     fun_command(wb_command, '-cifti-dilate ',ciftiIn,direction,surfaceDistance,volumeDistance,ciftiOut,'-nearest',...
    %         '-left-surface',highResSurface{1},'-right-surface',highResSurface{2},'-bad-brainordinate-roi',badBrainordinateRoi);
    disp('not finish LABEL DATA FIX yet, skip...');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIX FUNCTIONAL DATA  (https://wiki.humanconnectome.org/display/PublicData/DIY+fix+for+zeroes+near+medial+wall+in+rfMRI+dtseries+data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ciftiSignalIn=[dataDir,subjectName,'\MNINonLinear\Result\rfMRI_REST1_LR\rfMRI_REST1_LR_Atlas_hp2000_clean.dtseries.nii'];
direction='COLUMN';
surfaceDistance='4.0';
volumeDistance='4.0';
ciftiSignalOut=ciftiSignalIn;
badBrainordinateRoi=[dataDir,subjectName,'\MNINonLinear\fsaverage_LR32k\',subjectName,'.aparc.32k_fs_LR.dlabel.nii'];

if FLAG.FIX_FUNC_DILATE==1
    %     ciftiOut=[dataDir,subjectName,'\MNINonLinear\Result\rfMRI_REST1_LR\rfMRI_REST1_LR_Atlas_hp2000_clean_Fixed.dtseries.nii'];
    %     fun_command(wb_command, '-cifti-dilate ',ciftiIn,direction,surfaceDistance,volumeDistance,ciftiOut,'-nearest',...
    %         '-left-surface',highResSurface{1},'-right-surface',highResSurface{2},'-bad-brainordinate-roi',badBrainordinateRoi)
    disp('not finish FUNCTIONAL DATA FIX yet, skip...');
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LABEL SPERATE (Notice: output is the same as label files)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sperate surface label from all label in cifti
ciftiLabelIn=[dataDir,subjectName,'\MNINonLinear\fsaverage_LR32k\',subjectName,'.aparc.32k_fs_LR.dlabel.nii'];
sepDirection='COLUMN';
outputType= '-label';
outputStructure={'CORTEX_LEFT','CORTEX_RIGHT'};
outputLabelName{1}=strrep(ciftiLabelIn,['.dlabel.nii'],['.L.label.gii']);
outputLabelName{2}=strrep(ciftiLabelIn,['.dlabel.nii'],['.R.label.gii']);
%
if FLAG.LABEL_RESAMPLE==1
    system([wb_command, ' -cifti-separate ',ciftiLabelIn,' ',sepDirection,' ',outputType,' ',outputStructure{1},' ',outputLabelName{1}]);
    system([wb_command, ' -cifti-separate ',ciftiLabelIn,' ',sepDirection,' ',outputType,' ',outputStructure{2},' ',outputLabelName{2}]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LABEL RESAMPLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
labelIn=outputLabelName;%functional .func.nii
currentSphere={[dataDir,subjectName,'\MNINonLinear\fsaverage_LR32k\',subjectName,'.L.sphere.32k_fs_LR.surf.gii'],...
    [dataDir,subjectName,'\MNINonLinear\fsaverage_LR32k\',subjectName,'.R.sphere.32k_fs_LR.surf.gii']};
newSphere=newSphere;%generate by creat_sphere_template.m with NUM_VERTICES;
method='ADAP_BARY_AREA';
labelOut{1}=strrep(labelIn{1},[dataDir,subjectName,'\MNINonLinear\fsaverage_LR32k\',subjectName],['./result/',subjectName,'.rs.from32k.',kiloVertices]);
labelOut{2}=strrep(labelIn{2},[dataDir,subjectName,'\MNINonLinear\fsaverage_LR32k\',subjectName],['./result/',subjectName,'.rs.from32k.',kiloVertices]);
areaSurf='-area-surfs';
currentArea={[dataDir,subjectName,'\T1w\fsaverage_LR32k\',subjectName,'.L.midthickness.32k_fs_LR.surf.gii'],...
    [dataDir,subjectName,'\T1w\fsaverage_LR32k\',subjectName,'.R.midthickness.32k_fs_LR.surf.gii']};
newArea=lowResSurface;
if FLAG.LABEL_RESAMPLE==1
    system([wb_command,' -label-resample',' ',labelIn{1},' ',currentSphere{1},' ',newSphere{1},' ',method,' ',labelOut{1},' ',areaSurf,' ',currentArea{1},' ',newArea{1}]);
    system([wb_command,' -label-resample',' ',labelIn{2},' ',currentSphere{2},' ',newSphere{2},' ',method,' ',labelOut{2},' ',areaSurf,' ',currentArea{2},' ',newArea{2}]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FUNCTIONAL DATA SEPARATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sperate surface signal from all signal in cifti
ciftiSignalIn=ciftiSignalOut;
sepDirection='COLUMN';
outputType= '-metric';
outputStructure={'CORTEX_LEFT','CORTEX_RIGHT'};
outputSignalName{1}=strrep(ciftiSignalIn,['.dtseries.nii'],['.L.func.gii']);
outputSignalName{2}=strrep(ciftiSignalIn,['.dtseries.nii'],['.R.func.gii']);
%
if FLAG.FUNC_SEPARATE==1
    system([wb_command, ' -cifti-separate ',ciftiSignalIn,' ',sepDirection,' ',outputType,' ',outputStructure{1},' ',outputSignalName{1}]);
    system([wb_command, ' -cifti-separate ',ciftiSignalIn,' ',sepDirection,' ',outputType,' ',outputStructure{2},' ',outputSignalName{2}]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FUNCTIONAL DATA RESAMPLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
metricIn=outputSignalName;%functional .func.nii
currentSphere={[dataDir,subjectName,'\MNINonLinear\fsaverage_LR32k\',subjectName,'.L.sphere.32k_fs_LR.surf.gii'],...
    [dataDir,subjectName,'\MNINonLinear\fsaverage_LR32k\',subjectName,'.R.sphere.32k_fs_LR.surf.gii']};
newSphere=newSphere;%generate by creat_sphere_template.m with NUM_VERTICES=3000;
method='ADAP_BARY_AREA';
% metricOut={['./result/',subjectName,'.rs.from32k.',kiloVertices,'.rfMRI_REST1_LR_Atlas_hp2000_clean.L.func.gii'],...
%     ['./result/',subjectName,'.rs.from32k.',kiloVertices,'.rfMRI_REST1_LR_Atlas_hp2000_clean.R.func.gii']};
metricOut{1}=strrep(metricIn{1},[dataDir,subjectName,'\MNINonLinear\Result\rfMRI_REST1_LR\'],['./result/',subjectName,'.rs.from32k.',kiloVertices,'.']);
metricOut{2}=strrep(metricIn{2},[dataDir,subjectName,'\MNINonLinear\Result\rfMRI_REST1_LR\'],['./result/',subjectName,'.rs.from32k.',kiloVertices,'.']);
areaSurf='-area-surfs';
currentArea={[dataDir,subjectName,'\T1w\fsaverage_LR32k\',subjectName,'.L.midthickness.32k_fs_LR.surf.gii'],...
    [dataDir,subjectName,'\T1w\fsaverage_LR32k\',subjectName,'.R.midthickness.32k_fs_LR.surf.gii']};
newArea=lowResSurface;
if FLAG.FUNC_RESAMPLE==1
    system([wb_command,' -metric-resample',' ',metricIn{1},' ',currentSphere{1},' ',newSphere{1},' ',method,' ',metricOut{1},' ',areaSurf,' ',currentArea{1},' ',newArea{1}]);
    system([wb_command,' -metric-resample',' ',metricIn{2},' ',currentSphere{2},' ',newSphere{2},' ',method,' ',metricOut{2},' ',areaSurf,' ',currentArea{2},' ',newArea{2}]);
end
% NIFTI output
niiFilename{1}=strrep(metricOut{1},'.func.gii','.nii');
niiFilename{2}=strrep(metricOut{2},'.func.gii','.nii');
if FLAG.NIFITI_OUT==1
    system([wb_command ' -metric-convert -to-nifti ' metricOut{1},' ',niiFilename{1}]);
    system([wb_command ' -metric-convert -to-nifti ' metricOut{2},' ',niiFilename{2}]);
end
%%
if FLAG.DISPLAY==1 && FLAG.NIFITI_OUT==1
    figure
    subplot(2,2,2)
    plotatlas(currentSphere{1});
    hold on
    plotatlas(currentSphere{2});
    tile_name=strrep(currentSphere{1},'\','/');
    tile_name=strrep(tile_name,'_','\_');
    title(['currentSphere=',tile_name]);
    
    subplot(2,2,4)
    plotatlas(newSphere{1});
    hold on
    plotatlas(newSphere{2});
    tile_name=strrep(newSphere{1},'\','/');
    tile_name=strrep(tile_name,'_','\_');
    title(['newSphere=',tile_name]);
    
    subplot(2,2,1)
    plotatlas(currentArea{1});
    hold on
    plotatlas(currentArea{2});
    tile_name=strrep(currentArea{1},'\','/');
    tile_name=strrep(tile_name,'_','\_');
    title(['currentArea=',tile_name]);
    
    subplot(2,2,3)
    plotatlas(newArea{1});
    hold on
    plotatlas(newArea{2});
    tile_name=strrep(newArea{1},'\','/');
    tile_name=strrep(tile_name,'_','\_');
    title(['newArea=',tile_name]);
    
    set(gcf,'outerposition',get(0,'screensize'));% matlab�������?
    picname=[pipeline_path,'\figure\',pipeline_name,'_functional_data_resample.fig'];%������ļ�������i=1ʱ��picname=1.fig
    saveas(gcf,picname)
    picname=strrep(picname,'.fig','.jpg');
    saveas(gcf,picname)
    pause(0.1)
    
end
toc
%overlay signal
if FLAG.DISPLAY==1 && FLAG.DISPLAY==1
    
    frame=10;
    figure
    subplot(2,2,2)
    plotatlas(currentSphere{1},metricIn{1},frame,wb_command);
    hold on
    plotatlas(currentSphere{2},metricIn{2},frame,wb_command);
    tile_name=strrep(currentSphere{1},'\','/');
    tile_name=strrep(tile_name,'_','\_');
    title(['currentSphere=',tile_name]);
    
    subplot(2,2,4)
    plotatlas(newSphere{1},niiFilename{1},frame,wb_command);
    hold on
    plotatlas(newSphere{2},niiFilename{2},frame,wb_command);
    tile_name=strrep(newSphere{1},'\','/');
    tile_name=strrep(tile_name,'_','\_');
    title(['newSphere=',tile_name]);
    
    subplot(2,2,1)
    plotatlas(currentArea{1},metricIn{1},frame,wb_command);
    hold on
    plotatlas(currentArea{2},metricIn{2},frame,wb_command);
    tile_name=strrep(currentArea{1},'\','/');
    tile_name=strrep(tile_name,'_','\_');
    title(['currentArea=',tile_name]);
    
    subplot(2,2,3)
    plotatlas(newArea{1},niiFilename{1},frame,wb_command);
    hold on
    plotatlas(newArea{2},niiFilename{2},frame,wb_command);
    tile_name=strrep(newArea{1},'\','/');
    tile_name=strrep(tile_name,'_','\_');
    title(['newArea=',tile_name]);
    
    set(gcf,'outerposition',get(0,'screensize'));% matlab�������?
    picname=[pipeline_path,'\figure\',pipeline_name,'_functional_data_frame_',num2str(frame),'.fig'];%������ļ�������i=1ʱ��picname=1.fig
    saveas(gcf,picname)
    picname=strrep(picname,'.fig','.jpg');
    saveas(gcf,picname)
    pause(0.1)
end
filename = './temp/hcp_fmri_resampling.mat';
% clear ans
save(filename)
switch nargout
    case 1
        varargout{1}=niiFilename;
    case 2
        varargout{1}=niiFilename;
        varargout{2}=labelOut;
end
