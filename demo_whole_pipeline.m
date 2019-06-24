%%
tic
load ./temp/config.mat
%% fmri
[niiFilename,label]=fun_hcp_fmri_resampling(data_dir,SubjectName);
[niftiFilePath]= fun_hcp_fmri_export(SubjectName,niiFilename(1),niiFilename(2));
%% meg
[sHeadmodel,sFilesRest] =fun_hcp_meg_preprocessing_pipeline(ProtocolName,data_dir,SubjectName);
[sSrcResults,sSrcResultsFile,sSrcRestPsdBands]=fun_hcp_meg_inverse_pipeline(ProtocolName,data_dir,SubjectName);
[niftiFilePath]= fun_hcp_meg_export(SubjectName,sSrcResults.ImageGridAmp);
%% label
fmriNiftiPath='.\result\105923.4k.surface.fMRI_REST_LR.nii';
megNiftiPath='.\result\105923.4k.source.MEG_REST_LR.nii';
fmriLabelPath={['.\result\105923.rs.from32k.4k.105923.aparc.32k_fs_LR.L.label.gii'],...
    ['.\result\105923.rs.from32k.4k.105923.aparc.32k_fs_LR.R.label.gii']};
[pathData]=fun_hcp_match_label(SubjectName,fmriNiftiPath,megNiftiPath,fmriLabelPath,'mat');
%% bands and envelope
[pathMegBand,megBand]= fun_group_in_freqs_bands(SubjectName);
[pathMegBandEnvelope,megBandEnvelope]= fun_bands_envelope(SubjectName,pathMegBand);
%%
toc
