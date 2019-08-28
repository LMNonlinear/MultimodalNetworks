mode=2;
switch mode
    case 1
        % use parameter in setup.m
        [pathData]=fun_hcp_match_label;
    case 2
        tic
        load ./temp/config.mat
        %         subjectName = '105923';
        fmriNiftiPath='.\result\105923.',kiloVertices,'.surface.fMRI_REST_LR.nii';
        megNiftiPath='.\result\105923.',kiloVertices,'.source.MEG_REST_LR.nii';
        fmriLabelPath={['.\result\105923.rs.from32k.',kiloVertices,'.105923.aparc.32k_fs_LR.L.label.gii'],...
            ['.\result\105923.rs.from32k.',kiloVertices,'.105923.aparc.32k_fs_LR.R.label.gii']};
        [pathData]=fun_hcp_match_label(subjectName,fmriNiftiPath,megNiftiPath,fmriLabelPath,'mat');
        toc
end
