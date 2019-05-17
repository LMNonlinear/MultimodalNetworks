%%nan elements collosum

NUM_SUBJ=num2str(105923);
%% path
% wb_command='D:\Software\workbench\bin_windows64\wb_command.exe';
PATH_DATASET='E:\Rigel\MEEGfMRI\Data\HCP_S900\';
pipeline_path=mfilename('fullpath');

%%
fmri.surflabelpath={['.\data\105923.L.aparc.from32k.4k_fs_LR.label.gii'],...
    ['.\data\105923.R.aparc.from32k.4k_fs_LR.label.gii']};

fmri.labelstrc{1}=gifti(fmri.surflabelpath{1});
fmri.labelstrc{2}=gifti(fmri.surflabelpath{2});
fmri.label=[fmri.labelstrc{1}.cdata;fmri.labelstrc{2}.cdata];
fmri.label(fmri.label~=-1)=0;
%%
fmri.surfpath={[PATH_DATASET,NUM_SUBJ,'\MEG\anatomy\',NUM_SUBJ,'.L.midthickness.4k_fs_LR.surf.gii'],...
    [PATH_DATASET,NUM_SUBJ,'\MEG\anatomy\',NUM_SUBJ,'.R.midthickness.4k_fs_LR.surf.gii']};

fmri.surf{1}=gifti(fmri.surfpath{1});
fmri.surf{2}=gifti(fmri.surfpath{2});
fmri.faces=[fmri.surf{1}.faces; fmri.surf{2}.faces+size(fmri.surf{1}.vertices,1)];
fmri.vertices=[fmri.surf{1}.vertices; fmri.surf{2}.vertices];

%%
fmri.signalpath={'.\data\105923.rs.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.L.nii'...
    '.\data\105923.rs.4k.rfMRI_REST1_LR_Atlas_hp2000_clean.R.nii'};

fmri.signal=niftiopen(fmri.signalpath);
fmri.timeseries=[fmri.signal{1};fmri.signal{2}];


%%
fmri.label_surf=sum(fmri.timeseries,2);
% fmri.label_surf=fmri.label_surf(fmri.label_surf==0);
fmri.label_surf(fmri.label_surf==0)=-1;
fmri.label_surf(fmri.label_surf~=-1)=0;
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


num_collsum_label=sum(fmri.label==-1);
num_collsum_fmri=sum(fmri.label_surf==-1);

sum(fmri.label-fmri.label_surf);

% collosum_label=




