mode=2;
switch mode
    case 1
        % use parameter in setup.m
        [pathMegBand]=fun_group_in_freqs_bands;
    case 2
        tic
        load ./temp/config.mat
        [pathMegBand,megBand]= fun_group_in_freqs_bands(SubjectName);
        [pathMegBandEnvelope,megBandEnvelope]= fun_bands_envelope(SubjectName,megBand);
        toc
end
