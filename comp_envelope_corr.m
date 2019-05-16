%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% meg_timefreq_hilbert=load('./result/timefreq_hilbert_190408_1541.mat');

%%
gamma=meg_timefreq_hilbert.TF(:,:,5);
%%
gamma_power=(abs(gamma)).^2;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% display
meg.surfpath='.\result\tess_cortex_mid.mat';
meg.surf=load(meg.surfpath);
meg.vertices=meg.surf.Vertices;
meg.faces=meg.surf.Faces;
val{1}=zscore(gamma_power(:,1));
p=patch('faces',meg.faces,'vertices',meg.vertices, 'facecolor', 'interp',  'edgecolor', 'none', 'facealpha', 1,'FaceVertexCData',val{1});
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


