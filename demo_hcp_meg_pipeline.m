mode=2;
switch mode
    case 1
        % use parameter in setup
        [sSrcResults,sSrcResultsFile]=fun_hcp_meg_preprocessing_pipeline;
        [sHeadmodel,sFilesRest]=fun_hcp_meg_inverse_pipeline;
    case 2
        tic
%         ProtocolName='HCPPipeline';
%         data_dir='E:\Rigel\MEEGfMRI\Data\HCP_S900\';
%         SubjectName = '105923';
        load ./temp/config.mat
        [sSrcResults,sSrcResultsFile]=fun_hcp_meg_preprocessing_pipeline(ProtocolName,data_dir,SubjectName);
        [sHeadmodel,sFilesRest]=fun_hcp_meg_inverse_pipeline(ProtocolName,data_dir,SubjectName);
        toc
end
