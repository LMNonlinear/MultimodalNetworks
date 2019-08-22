%%
tic
load ./temp/config.mat
%% fmri
[niiFilename,label]=fun_hcp_fmri_resampling(dataDir,subjectName);
[niftiFilePath]= fun_hcp_fmri_export(subjectName,niiFilename(1),niiFilename(2));
%% meg
[sHeadmodel,sFilesRest] =fun_hcp_meg_preprocessing_pipeline(protocolName,dataDir,subjectName);
[sSrcResults,sSrcResultsFile,sSrcRestPsdBands]=fun_hcp_meg_inverse_pipeline(protocolName,dataDir,subjectName);
[niftiFilePath]= fun_hcp_meg_export(subjectName,sSrcResults.ImageGridAmp);
%% label
fmriNiftiPath='.\result\105923.4k.surface.fMRI_REST_LR.nii';
megNiftiPath='.\result\105923.4k.source.MEG_REST_LR.nii';
fmriLabelPath={['.\result\105923.rs.from32k.4k.aparc.32k_fs_LR.L.label.gii'],...
    ['.\result\105923.rs.from32k.4k.aparc.32k_fs_LR.R.label.gii']};
[pathData]=fun_hcp_match_label(subjectName,fmriNiftiPath,megNiftiPath,fmriLabelPath,'mat');
fun_hcp_sort_label
%% wavelet



%% partial correlation of time-freq 



%% %%%%%%
%% bands and envelope
% [pathMegBand,megBand]= fun_group_in_freqs_bands(subjectName);
% [pathMegBandEnvelope,megBandEnvelope]= fun_bands_envelope(subjectName,megBand);
%%
% fun_evelope_based_correlation
toc
