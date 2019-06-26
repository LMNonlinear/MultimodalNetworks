mode=2;
switch mode
    case 1
        % use parameter in setup.m
        [pathMegBand]=fun_group_in_freqs_bands;
    case 2
        tic
        load ./temp/config.mat
        [pathMegBand,megBand]= fun_group_in_freqs_bands(subjectName);
        [pathMegBandEnvelope,megBandEnvelope]= fun_bands_envelope(subjectName,megBand);
        toc
end
