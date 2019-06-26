mode=2;
switch mode
    case 1
        % use parameter in setup.m
        [pathData]=fun_hcp_match_label;
    case 2
        tic
        load ./temp/config.mat
        %         subjectName = '105923';
        fmriNiftiPath='.\result\105923.4k.surface.fMRI_REST_LR.nii';
        megNiftiPath='.\result\105923.4k.source.MEG_REST_LR.nii';
        fmriLabelPath={['.\result\105923.rs.from32k.4k.105923.aparc.32k_fs_LR.L.label.gii'],...
            ['.\result\105923.rs.from32k.4k.105923.aparc.32k_fs_LR.R.label.gii']};
        [pathData]=fun_hcp_match_label(subjectName,fmriNiftiPath,megNiftiPath,fmriLabelPath,'mat');
        toc
end
