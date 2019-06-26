%% nan elements collosum
%initial
clear;close all;clc
addpath('../external/cifti-nan-matlab/')
addpath('../external/cifti-nonan-matlab/')
addpath('../external/nifti-spm-matlab/')

% subjectName=num2str(105923);
load ../temp/config.mat
wb_command='D:\Software\workbench\bin_windows64\wb_command.exe';
% dataDir='E:\Rigel\MEEGfMRI\Data\HCP_S900\';
% pipeline_path=mfilename('fullpath');
%% load surface
% fmri.surfPath={[dataDir,subjectName,'\MEG\anatomy\',subjectName,'.L.midthickness.4k_fs_LR.surf.gii'],...
%     [dataDir,subjectName,'\MEG\anatomy\',subjectName,'.R.midthickness.4k_fs_LR.surf.gii']};
fmri.surfPath={'M:\MEEGfMRI\Data\HCP_S900\105923\MNINonLinear\fsaverage_LR32k\105923.L.midthickness.32k_fs_LR.surf.gii'...
'M:\MEEGfMRI\Data\HCP_S900\105923\MNINonLinear\fsaverage_LR32k\105923.R.midthickness.32k_fs_LR.surf.gii'};
fmri.surf{1}=gifti(fmri.surfPath{1});
fmri.surf{2}=gifti(fmri.surfPath{2});
fmri.surfFaces=[fmri.surf{1}.faces; fmri.surf{2}.faces+size(fmri.surf{1}.vertices,1)];
fmri.surfVertices=[fmri.surf{1}.vertices; fmri.surf{2}.vertices];
%% extract label from label file(automatic cortical parcellation )
% % fmri.aparcPath={['..\result\105923.rs.from32k.4k.105923.aparc.32k_fs_LR.L.label.gii'],...
% %     ['..\result\105923.rs.from32k.4k.105923.aparc.32k_fs_LR.R.label.gii']};
% fmri.aparcPath={'M:\MEEGfMRI\Data\HCP_S900\105923\MNINonLinear\fsaverage_LR32k\105923.L.aparc.32k_fs_LR.label.gii'...
% 'M:\MEEGfMRI\Data\HCP_S900\105923\MNINonLinear\fsaverage_LR32k\105923.R.aparc.32k_fs_LR.label.gii'};
% fmri.aparc{1}=gifti(fmri.aparcPath{1});
% fmri.aparc{2}=gifti(fmri.aparcPath{2});
% fmri.aparcLabel=[fmri.aparc{1}.cdata;fmri.aparc{2}.cdata];
% fmri.aparcLabelAttribute=[fmri.aparc{1}.labels;fmri.aparc{2}.labels];
% fmri.aparcLabelCollosum=zeros(size(fmri.aparcLabel));
% fmri.aparcLabelCollosum(fmri.aparcLabel==-1)=int32(-1);
% fmri.aparcLabelCollosum=fmri.aparcLabelCollosum(:);

%%
% fmri.aparcDlabelPath='M:\MEEGfMRI\Data\HCP_S900\105923\MNINonLinear\fsaverage_LR32k\105923.aparc.32k_fs_LR.dlabel.nii';
% fmri.aparcDlabel=ciftiopen(fmri.aparcDlabelPath,wb_command);

%% extract label from signal file
% fmri.signalPath={'..\result\105923.rs.from32k.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.L.nii'...
%     '..\result\105923.rs.from32k.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.R.nii'};
fmri.signalPath={'M:\MEEGfMRI\Data\HCP_S900\105923\MNINonLinear\Result\rfMRI_REST1_LR\rfMRI_REST1_LR_Atlas_hp2000_clean.L.nii',...
'M:\MEEGfMRI\Data\HCP_S900\105923\MNINonLinear\Result\rfMRI_REST1_LR\rfMRI_REST1_LR_Atlas_hp2000_clean.R.nii'};
[fmri.signalCell,nifti_struct]=niftiopen(fmri.signalPath);
fmri.signalMat=[fmri.signalCell{1};fmri.signalCell{2}];
fmri.signalLabelCollosum=sum(fmri.signalMat,2);
% fmri.signalLabelCollosum=fmri.signalLabelCollosum(fmri.signalLabelCollosum==0);
fmri.signalLabelCollosum(fmri.signalLabelCollosum==0)=-1;
fmri.signalLabelCollosum(fmri.signalLabelCollosum~=-1)=0;
fmri.signalLabelCollosum=fmri.signalLabelCollosum(:);
% %% extract label from fixed signal file
% % fmri.signalPath={'.\data\105923.rs.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.L.nii'...
% %     '.\data\105923.rs.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.R.nii'};
% fmri.signalFixedPath={'M:\MEEGfMRI\Data\HCP_S900\105923\MNINonLinear\Result\rfMRI_REST1_LR\rfMRI_REST1_LR_Atlas_hp2000_clean_Fixed.L.nii',...
% 'M:\MEEGfMRI\Data\HCP_S900\105923\MNINonLinear\Result\rfMRI_REST1_LR\rfMRI_REST1_LR_Atlas_hp2000_clean_Fixed.R.nii'};
% [fmri.signalFixedCell,nifti_struct]=niftiopen(fmri.signalFixedPath);
% fmri.signalFixedMat=[fmri.signalFixedCell{1};fmri.signalCell{2}];
% fmri.signalFixedLabelCollosum=sum(fmri.signalFixedMat,2);
% % fmri.signalLabelCollosum=fmri.signalLabelCollosum(fmri.signalLabelCollosum==0);
% fmri.signalFixedLabelCollosum(fmri.signalFixedLabelCollosum==0)=-1;
% fmri.signalFixedLabelCollosum(fmri.signalFixedLabelCollosum~=-1)=0;
% fmri.signalFixedLabelCollosum=fmri.signalFixedLabelCollosum(:);
%% dlabel
% fmri.aparcDlabelPath='M:\MEEGfMRI\Data\HCP_S900\105923\MNINonLinear\fsaverage_LR32k\105923.aparc.32k_fs_LR.dlabel.nii';
% fmri.aparcDlabel=ft_read_cifti(fmri.aparcDlabelPath,'readsurface', false,'mapname','array');%, 'mapname','array'   
% fmri.aparcDlabelLabel=[fmri.aparcDlabel.aparc];
% fmri.aparcDlabelLabelName=[fmri.aparcDlabel.aparclabel];
% % fmri.aparcDlabel=ciftiopen(fmri.aparcDlabelPath,wb_command);
% % fmri.aparcDlabelLabel=fmri.aparcDlabel.cdata;
% % % fmri.aparcDlabelLabelCollosum=zeros(size(fmri.aparcDlabelLabel));
% % % fmri.aparcDlabelLabelCollosum(fmri.aparcDlabelLabel==-1)=int32(-1);
% % % fmri.aparcDlabelLabelCollosum=fmri.aparcDlabelLabelCollosum(:);
% % % fmri.aparcDlabelLabel=fmri.aparcDlabel.cdata
% fmri.aparcDlabelLabelCollosum=isnan(fmri.aparcDlabelLabel);
% fmri.aparcDlabelLabelCollosum=fmri.aparcDlabelLabelCollosum(:);
% fmri.aparcDlabelLabel(isnan(fmri.aparcDlabelLabel))=-1;
%% dscalar
% fmri.aparcDscalarPath='M:\MEEGfMRI\Data\HCP_S900\105923\MNINonLinear\fsaverage_LR32k\105923.thickness.32k_fs_LR.dscalar.nii';
% % fmri.aparcDlabel=ft_read_cifti(fmri.aparcDlabelPath{1});%, 'mapname','array'   
% % fmri.aparcDlabelLabel=[fmri.aparcDlabel.x105923_aparc];
% fmri.aparcDscalar=ciftiopen(fmri.aparcDscalarPath,wb_command);
% fmri.aparcDscalarLabel=fmri.aparcDscalar.cdata;
% % fmri.aparcDlabelLabelCollosum=zeros(size(fmri.aparcDlabelLabel));
% % fmri.aparcDlabelLabelCollosum(fmri.aparcDlabelLabel==-1)=int32(-1);
% % fmri.aparcDlabelLabelCollosum=fmri.aparcDlabelLabelCollosum(:);
% % fmri.aparcDscalarLabel=fmri.aparcDscalar.cdata
%% sperated label
fmri.aparcDlabelSperatedPath={'M:\MEEGfMRI\Data\HCP_S900\105923\MNINonLinear\fsaverage_LR32k\105923.aparc.32k_fs_LR.L.label.gii'...
    'M:\MEEGfMRI\Data\HCP_S900\105923\MNINonLinear\fsaverage_LR32k\105923.aparc.32k_fs_LR.R.label.gii'};
fmri.aparcDlabelSperated=gifti(fmri.aparcDlabelSperatedPath);
% fmri.aparcDlabelSperatedLabel={fmri.aparcDlabelSperated(1).cdata,fmri.aparcDlabelSperated(2).cdata};
fmri.aparcDlabelSperatedLabel=[fmri.aparcDlabelSperated(1).cdata;fmri.aparcDlabelSperated(2).cdata];
fmri.aparcDlabelSperatedLabelAttribute=[fmri.aparcDlabelSperated(1).labels,fmri.aparcDlabelSperated(2).labels];
% fmri.aparcDlabelSperatedLabelName={fmri.aparcDlabelSperatedLabelAttribute(1).name,fmri.aparcDlabelSperatedLabelAttribute(2).name};
fmri.aparcDlabelSperatedLabelName=fmri.aparcDlabelSperatedLabelAttribute(1).name;
fmri.aparcDlabelSperatedLabelCollosum=zeros(size(fmri.aparcDlabelSperatedLabel));
fmri.aparcDlabelSperatedLabelCollosum(fmri.aparcDlabelSperatedLabel==0)=int32(-1);
fmri.aparcDlabelSperatedLabelCollosum=fmri.aparcDlabelSperatedLabelCollosum(:);
%%
close all
figure
% double(fmri.label)-fmri.label_surf;
subplot(2,1,1)
plot(-double(fmri.signalLabelCollosum)+double(fmri.aparcDlabelSperatedLabelCollosum),'b');
% hold on;
subplot(2,1,2)
plot(fmri.signalLabelCollosum*2,'r')
hold on
plot(fmri.aparcDlabelSperatedLabelCollosum,'g')


%%
% close all
figure
val{1}=fmri.aparcDlabelSperatedLabelCollosum(1:size(fmri.surfVertices,1)/2);
val{2}=fmri.aparcDlabelSperatedLabel(1:size(fmri.surfVertices,1)/2);
val{3}=fmri.signalLabelCollosum(1:size(fmri.surfVertices,1)/2);
val{4}=fmri.signalMat(1:size(fmri.surfVertices,1)/2,1);

% val{4}=fmri.signalFixedLabelCollosum(1:size(fmri.surfVertices,1)/2);
% val{5}=double(fmri.aparcDlabelSperatedLabelCollosum(1:size(fmri.surfVertices,1)/2));
% val{6}=fmri.aparcDlabelSperatedLabel(1:size(fmri.surfVertices,1)/2);
% val{7}=-double(fmri.aparcDlabelLabelCollosum(1:size(fmri.surfVertices,1)/2));
% val{8}=fmri.aparcDlabelLabel(1:size(fmri.surfVertices,1)/2);


az = 90;
el = 0;

% subplot(2,4,1);axis equal;view(az, el);
% p=patch('faces',fmri.surfFaces(1:size(fmri.surfFaces,1)/2,:),'vertices',fmri.surfVertices(1:size(fmri.surfVertices,1)/2,:), 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val{1});
% subplot(2,4,2);axis equal;view(az, el);
% p=patch('faces',fmri.surfFaces(1:size(fmri.surfFaces,1)/2,:),'vertices',fmri.surfVertices(1:size(fmri.surfVertices,1)/2,:), 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val{2});
% subplot(2,4,3);axis equal;view(az, el);
% p=patch('faces',fmri.surfFaces(1:size(fmri.surfFaces,1)/2,:),'vertices',fmri.surfVertices(1:size(fmri.surfVertices,1)/2,:), 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val{3});
% subplot(2,4,4);axis equal;view(az, el);
% p=patch('faces',fmri.surfFaces(1:size(fmri.surfFaces,1)/2,:),'vertices',fmri.surfVertices(1:size(fmri.surfVertices,1)/2,:), 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val{4});
% subplot(2,4,5);axis equal;view(az, el);
% p=patch('faces',fmri.surfFaces(1:size(fmri.surfFaces,1)/2,:),'vertices',fmri.surfVertices(1:size(fmri.surfVertices,1)/2,:), 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val{5});
% subplot(2,4,6);axis equal;view(az, el);
% p=patch('faces',fmri.surfFaces(1:size(fmri.surfFaces,1)/2,:),'vertices',fmri.surfVertices(1:size(fmri.surfVertices,1)/2,:), 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val{6});
% subplot(2,4,7);axis equal;view(az, el);
% p=patch('faces',fmri.surfFaces(1:size(fmri.surfFaces,1)/2,:),'vertices',fmri.surfVertices(1:size(fmri.surfVertices,1)/2,:), 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val{7});
% subplot(2,4,8);axis equal;view(az, el);
% p=patch('faces',fmri.surfFaces(1:size(fmri.surfFaces,1)/2,:),'vertices',fmri.surfVertices(1:size(fmri.surfVertices,1)/2,:), 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val{8});
subplot(2,2,1);axis equal;view(az, el);
p=patch('faces',fmri.surfFaces(1:size(fmri.surfFaces,1)/2,:),'vertices',fmri.surfVertices(1:size(fmri.surfVertices,1)/2,:), 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val{1});
subplot(2,2,2);axis equal;view(az, el);
p=patch('faces',fmri.surfFaces(1:size(fmri.surfFaces,1)/2,:),'vertices',fmri.surfVertices(1:size(fmri.surfVertices,1)/2,:), 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val{2});
subplot(2,2,3);axis equal;view(az, el);
p=patch('faces',fmri.surfFaces(1:size(fmri.surfFaces,1)/2,:),'vertices',fmri.surfVertices(1:size(fmri.surfVertices,1)/2,:), 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val{3});
subplot(2,2,4);axis equal;view(az, el);
p=patch('faces',fmri.surfFaces(1:size(fmri.surfFaces,1)/2,:),'vertices',fmri.surfVertices(1:size(fmri.surfVertices,1)/2,:), 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val{4});

%%
% 
% 
% num_collsum_label=sum(fmri.label==-1);
% num_collsum_fmri=sum(fmri.label_surf==-1);
% 
% sum(fmri.label-fmri.label_surf);
% 
% % collosum_label=
% 
% 
% 
% 
