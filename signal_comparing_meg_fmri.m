clear;clc;
close all;
%% FLAG
FLAG_LOAD_SIGNAL=1;
FLAG_LOAD_SURFACE=1;
FLAG_DISPLAY=1;
FLAG_DISPLAY_REULT=1;

%%
NUM_SUBJ=num2str(105923);
%% path
wb_command='D:\Software\workbench\bin_windows64\wb_command.exe';
PATH_DATASET='F:\MEEGfMRI\Data\HCP_S900\';
pipeline_path=mfilename('fullpath');
% [pipeline_path, pipeline_name, ~] = fileparts(pipeline_path);

%% fmri downsampled signal
fmri.signalpath={'.\data\105923.rs.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.L.nii'...
    '.\data\105923.rs.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.R.nii'};
fmri.surfpath={[PATH_DATASET,NUM_SUBJ,'\MEG\anatomy\',NUM_SUBJ,'.L.midthickness.4k_fs_LR.surf.gii'],...
    [PATH_DATASET,NUM_SUBJ,'\MEG\anatomy\',NUM_SUBJ,'.R.midthickness.4k_fs_LR.surf.gii']};

%% MEG source
meg.signalpath=dir('.\result\results_dSPM_MEG_KERNEL*.mat');
meg.signalpath=fullfile(meg.signalpath.folder,meg.signalpath.name);
meg.surfpath='.\result\tess_cortex_mid.mat';


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% file_read
tic
if FLAG_LOAD_SIGNAL==1
    fmri.signal=niftiopen(fmri.signalpath);
    meg.signal=load(meg.signalpath);
    fmri.timeseries=[fmri.signal{1};fmri.signal{2}];
    meg.timeseries=meg.signal.ImageGridAmp;
    
end
if FLAG_LOAD_SURFACE==1
    fmri.surf=gifti(fmri.surfpath);
    
    fmri.faces=[fmri.surf(1).faces; fmri.surf(2).faces+size(fmri.surf(1).vertices,1)];
    fmri.vertices=[fmri.surf(1).vertices; fmri.surf(2).vertices];
    meg.surf=load(meg.surfpath);
    meg.vertices=meg.surf.Vertices;
    meg.faces=meg.surf.Faces;
end
toc
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure
if FLAG_LOAD_SIGNAL==1 && FLAG_DISPLAY==1
    %% anatomical figure
    % axis equal
    % val=linspace(0,10,size(fmri.vertices,1))';
    % p=patch('faces',fmri.faces,'vertices',fmri.vertices, 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val);
    % figure
    % axis equal
    % val=linspace(0,10,size(meg.vertices,1))';
    % p=patch('faces',meg.faces,'vertices',meg.vertices, 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val);
    % % error=sum(sum((meg.faces(:,[2,1,3])-double(fmri.faces)),2)); the same
    
    %% signal
    close all
    % for i=1:480
    for i=1:1
        
        % val{1}=zscore(mean(fmri.timeseries,2));
        % val{2}=zscore(mean(meg.timeseries,2));
        val{1}=zscore(fmri.timeseries(:,i));
        val{2}=zscore(meg.timeseries(:,i*1525));
        
        
        val{1}=(val{1}-min(val{1}))/(max(val{1})-min(val{1}));
        val{2}=(val{2}-min(val{2}))/(max(val{2})-min(val{2}));
        subplot(2,2,1);axis equal
        p=patch('faces',fmri.faces,'vertices',fmri.vertices, 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val{1});
        subplot(2,2,2);axis equal
        p=patch('faces',fmri.faces,'vertices',fmri.vertices, 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val{2});
        subplot(2,1,2)
        plot(val{1},'r');hold on;
        plot(val{2},'b')
    end
    % error=sum(sum((meg.faces(:,[2,1,3])-double(fmri.faces)),2)); the same
end
%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
for i=1:8004
    for j=1:8004
        if j>=i
            fmri.corrmat(i,j)=corr(fmri.timeseries(i,:)',fmri.timeseries(j,:)');
            meg.corrmat(i,j)=corr(meg.timeseries(i,1:1200)',meg.timeseries(j,1:1200)');
        end
    end
end
toc





