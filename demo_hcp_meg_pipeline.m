mode=2;
switch mode
    case 1
        % use parameter in setup
        [sHeadmodel,sFilesRest] =fun_hcp_meg_preprocessing_pipeline;
        [sSrcResults,sSrcResultsFile] =fun_hcp_meg_inverse_pipeline;
        [niftiFilePath]= fun_hcp_meg_saveas_nifti;
    case 2
        tic
        %         ProtocolName='HCPPipeline';
        %         data_dir='E:\Rigel\MEEGfMRI\Data\HCP_S900\';
        %         SubjectName = '105923';
        load ./temp/config.mat
        [sHeadmodel,sFilesRest] =fun_hcp_meg_preprocessing_pipeline(ProtocolName,data_dir,SubjectName);
%         [sSrcResults,sSrcResultsFile,sSrcRestPsdBands]=fun_hcp_meg_inverse_pipeline(ProtocolName,data_dir,SubjectName);
%         [niftiFilePath]= fun_hcp_meg_saveas_nifti(SubjectName,sSrcResults.ImageGridAmp);
        toc
end
