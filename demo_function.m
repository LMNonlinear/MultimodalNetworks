mode=2;
switch mode
    case 2
        tic
%         ProtocolName='HCPPipeline';
%         data_dir='E:\Rigel\MEEGfMRI\Data\HCP_S900\';
%         SubjectName = '105923';
        load ./temp/config.mat
        [sSrcResults,sSrcResultsFile]=fun_hcp_preprocessing_pipeline(ProtocolName,data_dir,SubjectName);
        [sHeadmodel,sFilesRest]=fun_hcp_inverse_pipeline(ProtocolName,data_dir,SubjectName);
        toc
end
