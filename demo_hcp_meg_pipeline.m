mode=2;
switch mode
    case 1
        % use parameter in setup
        [sHeadmodel,sFilesRest] =fun_hcp_meg_preprocessing_pipeline;
        [sSrcResults,sSrcResultsFile] =fun_hcp_meg_inverse_pipeline;
        [niftiFilePath]= fun_hcp_meg_saveas_nifti;
    case 2
        tic
        %         protocolName='HCPPipeline';
        %         dataDir='E:\Rigel\MEEGfMRI\Data\HCP_S900\';
        %         subjectName = '105923';
        load ./temp/config.mat
        [sHeadmodel,sFilesRest] =fun_hcp_meg_preprocessing_pipeline(protocolName,dataDir,subjectName);
        [sSrcResults,sSrcResultsFile,sSrcRestPsdBands]=fun_hcp_meg_inverse_pipeline(protocolName,dataDir,subjectName);
        [niftiFilePath]= fun_hcp_meg_export(subjectName,sSrcResults.ImageGridAmp);
        toc
end
