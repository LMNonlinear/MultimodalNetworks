%% 
%use hcp data source signal

clear;clc;
close all;
%% FLAG
FLAG_LOAD_SIGNAL=1;
FLAG_LOAD_SURFACE=1;
FLAG_DISPLAY=1;
FLAG_DISPLAY_REULT=1;
FLAG_COMPARE=1;

%%
NUM_SUBJ=num2str(105923);
%% path
% wb_command='D:\Software\workbench\bin_windows64\wb_command.exe';
PATH_DATASET='E:\Rigel\MEEGfMRI\Data\HCP_S900\';
pipeline_path=mfilename('fullpath');
% [pipeline_path, pipeline_name, ~] = fileparts(pipeline_path);

%% fmri downsampled signal
fmri.signalpath={'.\data\105923.rs.from32k.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.L.nii'...
    '.\data\105923.rs.from32k.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.R.nii'};
% fmri.surfpath={[PATH_DATASET,NUM_SUBJ,'\MEG\anatomy\',NUM_SUBJ,'.L.midthickness.4k_fs_LR.surf.gii'],...
%     [PATH_DATASET,NUM_SUBJ,'\MEG\anatomy\',NUM_SUBJ,'.R.midthickness.4k_fs_LR.surf.gii']};
fmri.surfpath={['./data/105923.L.midthickness.from32k.4k_fs_LR.surf.gii'],...
    ['./data/105923.R.midthickness.from32k.4k_fs_LR.surf.gii']};
fmri.surflabelpath={['.\data\105923.L.aparc.from32k.4k_fs_LR.label.gii'],...
    ['.\data\105923.R.aparc.from32k.4k_fs_LR.label.gii']};
%% MEG source

meg.signalpath='./result/timefreq_hilbert_190408_1541.mat';
meg.surfpath='.\result\tess_cortex_mid.mat';


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% file_read
tic

if FLAG_LOAD_SIGNAL==1
    fmri.signal=niftiopen(fmri.signalpath);
    fmri.timeseries=[fmri.signal{1};fmri.signal{2}];
    meg.signal=load(meg.signalpath);
    meg.timeseries=meg.signal.TF;
    meg.timeseries=(abs(meg.timeseries)).^2;
end
if FLAG_LOAD_SURFACE==1
    fmri.surf{1}=gifti(fmri.surfpath{1});
    fmri.surf{2}=gifti(fmri.surfpath{2});
    fmri.faces=[fmri.surf{1}.faces; fmri.surf{2}.faces+size(fmri.surf{1}.vertices,1)];
    fmri.vertices=[fmri.surf{1}.vertices; fmri.surf{2}.vertices];
%     
%     fmri.labelstrc{1}=gifti(fmri.surflabelpath{1});
%     fmri.labelstrc{2}=gifti(fmri.surflabelpath{2});
%     fmri.label=[fmri.labelstrc{1}.cdata;fmri.labelstrc{2}.cdata];
    
    fmri.label=sum(fmri.timeseries,2);
    % fmri.label_surf=fmri.label_surf(fmri.label_surf==0);
    fmri.label(fmri.label==0)=-1;
    fmri.label(fmri.label~=-1)=0;
    
    meg.surf=load(meg.surfpath);
    meg.vertices=meg.surf.Vertices;
    meg.faces=meg.surf.Faces;    
    meg.timeseries(fmri.label==-1,:)=0;
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
    for i=300:300
        % val{1}=zscore(mean(fmri.timeseries,2));
        % val{2}=zscore(mean(meg.timeseries,2));
        val{1}=zscore(fmri.timeseries(:,i));
        val{2}=zscore(meg.timeseries(:,i,5));
        
        val{1}=(val{1}-min(val{1}))/(max(val{1})-min(val{1}));
        val{2}=(val{2}-min(val{2}))/(max(val{2})-min(val{2}));
        
        subplot(2,2,1);axis equal
        p=patch('faces',fmri.faces,'vertices',fmri.vertices, 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val{1});
        subplot(2,2,2);axis equal
        p=patch('faces',fmri.faces,'vertices',fmri.vertices, 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val{2});
        subplot(2,1,2)
        plot(val{1},'r');hold on;
        plot(val{2},'b')
        pause(0.1)
    end
    % error=sum(sum((meg.faces(:,[2,1,3])-double(fmri.faces)),2)); the same
end
%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if FLAG_COMPARE==1
    fmri_timeseries=fmri.timeseries;
    meg_timeseries=meg.timeseries;
    
    
    startmatlabpool
    tic
    % fmri
    fmri_corrmat=zeros(8004,8004);
    fmri_pvalmat=zeros(8004,8004);
    for i=1:8004
        for j=1:8004
            if j>=i
                
                [fmri_corrmat(i,j),fmri_pvalmat(i,j)]=corr(fmri_timeseries(i,:)',fmri_timeseries(j,:)');
                
            end
        end
    end
    %meg
    for iband=1:7
        meg_corrmat{iband}=zeros(8004,8004);
        meg_pvalmat{iband}=zeros(8004,8004);
    end
    
    for iband=1:7
        meg_timeseries_passing=meg_timeseries(:,:,iband);
        parfor i=1:8004
            meg_timeseries_passing_x=meg_timeseries_passing(i,:);
            for j=1:8004
                if j>=i
                    [meg_rho(i,j),meg_pval(i,j)] =corr(meg_timeseries_passing_x',meg_timeseries_passing(j,:)');
                end
            end
        end
        meg_corrmat{iband}=meg_rho;
        meg_pvalmat{iband}=meg_pval;
    end
    closematlabpool
    toc
    save('HcpRestCorrmat.mat', 'fmri_corrmat', 'meg_corrmat','fmri_pvalmat','meg_pvalmat','-v7.3')
    
end
%delta
%theta
%alpha
%beta
%gamma
%gamma1
%gamma2

%%
%%
fmri.label_surf=sum(fmri.timeseries,2);
% fmri.label_surf=fmri.label_surf(fmri.label_surf==0);
fmri.label_surf(fmri.label_surf==0)=-1;
fmri.label_surf(fmri.label_surf~=-1)=0;
fmri.label(fmri.label~=-1)=0;
%%
close all
% double(fmri.label)-fmri.label_surf;
plot(double(fmri.label)-fmri.label_surf),'b';
% hold on;
figure
plot(fmri.label,'r')
hold on
plot(fmri.label_surf,'g')

%%
close all

val{1}=fmri.label_surf(1:4002);
val{2}=fmri.label(1:4002);

subplot(1,2,1);axis equal
p=patch('faces',fmri.faces(1:8000,:),'vertices',fmri.vertices(1:4002,:), 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val{1});
subplot(1,2,2);axis equal
p=patch('faces',fmri.faces(1:8000,:),'vertices',fmri.vertices(1:4002,:), 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val{2});
%%
