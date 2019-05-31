% function varargout= fun_hcp_meg_saveas_nifti(varargin)
% 
% switch nargin
%     case 0
%         load .\temp\fun_hcp_meg_inverse_pipeline.mat
%     case 1
%         megSignal=varargin{1};
% end
%%
load .\temp\hcp_inverse_pipeline.mat
%%
niftiObj=nifti;
file_arrayObj=file_array;
% niftiObj.dat=Results.ImageGridAmp;



% end


