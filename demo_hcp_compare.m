mode=0;
switch mode
    case 0
        % use parameter in setup.m
        [pathData]=fun_hcp_match_label;
    case 2
        tic
        %         data_dir='E:\Rigel\MEEGfMRI\Data\HCP_S900\';
        %         SubjectName = '105923';
        load ./temp/config.mat
        [pathData]=fun_hcp_match_label;        
        toc
end
