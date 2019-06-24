mode=2;
switch mode
    case 1
        % use parameter in setup.m
        [niiFilename,label]=fun_hcp_fmri_resampling;
    case 2
        tic
%         data_dir='E:\Rigel\MEEGfMRI\Data\HCP_S900\';
%         SubjectName = '105923';
        load ./temp/config.mat
        [niiFilename,label]=fun_hcp_fmri_resampling(data_dir,SubjectName);
        [niftiFilePath]= fun_hcp_fmri_export(SubjectName,niiFilename(1),niiFilename(2));
        toc
end
