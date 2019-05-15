%%
clear
%%
load HcpRestCorrmat.mat
%%
fmri_corr=fmri_corrmat+fmri_corrmat';
fmri_corr(logical(eye(size(fmri_corrmat))))=diag(fmri_corrmat);
fmriMin=min(min(fmri_corr));
fmriMax=max(max(fmri_corr));

megMin=1;
megMax=-1;
for iband=1:7
    val_temp=meg_corrmat{iband};
    meg_corr{iband}=val_temp+val_temp';
    meg_corr{iband}(logical(eye(size(val_temp))))=diag(val_temp);
    megMin=min(min(min(meg_corr{iband})),megMin);
    megMax=max(max(max(meg_corr{iband})),megMax);
end

colorBarMin=(min(megMin,fmriMin));
colorBarMax=(max(megMax,fmriMax));


%%
close all
%delta
%theta
%alpha
%beta
%gamma
%gamma1
%gamma2
megBands={'delta 2-4Hz','theta 5-7Hz','alpha 8-12Hz','beta 15-29Hz','gamma 30-70Hz','low gamma 30-59Hz','high gamma 60-90Hz'};
for iband=1:7
    figure
    subplot(121)
    imagesc(fmri_corr)
    axis equal
    axis([0,8004,0,8004]);  
    title('correlation matrix of fMRI')
    colorbar
    caxis([colorBarMin,colorBarMax]);
    
    subplot(122)
    imagesc(meg_corr{iband})     
    axis equal
    axis([0,8004,0,8004]);   
    title(['correlation matrix of source level MEG envelope in ',megBands{iband}])
    colorbar
    caxis([colorBarMin,colorBarMax]);
    
    set(gcf,'outerposition',get(0,'screensize'));% matlab窗口最大化
    picname=['.\figure\','correlation matrix fmri and meg in ', megBands{iband},'.fig'];%保存的文件名：如i=1时，picname=1.fig
    %     saveas(gcf,picname)
    picname=strrep(picname,'.fig','.jpg');
    saveas(gcf,picname)
end


%%
fmri_corr_nonan=fmri_corr(~isnan(fmri_corr));
for iband=1:7
    meg_corr_nonan{iband}=meg_corr{iband}(~isnan(meg_corr{iband}));
    fmriMegCorr{iband}=corr2(fmri_corr_nonan,meg_corr_nonan{iband});
end
save fmriMegCorr fmriMegCorr
%  for iband=1:7
% mse_error(iband)=sum(sum((fmri_corr-meg_corr{iband}).^2))/size(fmri_corr);
%  end