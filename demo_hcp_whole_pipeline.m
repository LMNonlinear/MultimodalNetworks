%%
tic
load ./temp/config.mat
%% fmri
[niiFilename,label]=fun_hcp_fmri_resampling(dataDir,subjectName);
[~]= fun_hcp_fmri_export(subjectName,niiFilename(1),niiFilename(2));
%% meg
[sHeadmodel,sFilesRest] =fun_hcp_meg_preprocessing_pipeline(protocolName,dataDir,subjectName);
[sSrcResults,sSrcResultsFile]=fun_hcp_meg_inverse_pipeline(protocolName,dataDir,subjectName);
[~]= fun_hcp_meg_export(subjectName,sSrcResults.ImageGridAmp);
%% label
fmriNiftiPath=['.\result\105923.',kiloVertices,'.surface.fMRI_REST_LR.nii'];
megNiftiPath=['.\result\105923.',kiloVertices,'.source.MEG_REST_LR.nii'];
fmriLabelPath={['.\result\105923.rs.from32k.',kiloVertices,'.aparc.32k_fs_LR.L.label.gii'],...
    ['.\result\105923.rs.from32k.',kiloVertices,'.aparc.32k_fs_LR.R.label.gii']};
[pathData]=fun_hcp_match_label(subjectName,fmriNiftiPath,megNiftiPath,fmriLabelPath,'mat');
labelSortedPath=fun_hcp_sort_label(subjectName);
%% wavelet
[~,megTfMatPath]=fun_wavelet(subjectName);
% fun_partial_correlation

%% partial correlation of time-freq 



%% %%%%%%
%% bands and envelope
% [pathMegBand,megBand]= fun_group_in_freqs_bands(subjectName);
% [pathMegBandEnvelope,megBandEnvelope]= fun_bands_envelope(subjectName,megBand);
%%
% fun_evelope_based_correlation
toc
