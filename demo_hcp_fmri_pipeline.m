mode=2;
switch mode
    case 1
        % use parameter in setup.m
        [niiFilename,label]=fun_hcp_fmri_resampling;
    case 2
        tic
%         dataDir='E:\Rigel\MEEGfMRI\Data\HCP_S900\';
%         subjectName = '105923';
        load ./temp/config.mat
        [niiFilename,label]=fun_hcp_fmri_resampling(dataDir,subjectName);
        [niftiFilePath]= fun_hcp_fmri_export(subjectName,niiFilename(1),niiFilename(2));
        toc
end
