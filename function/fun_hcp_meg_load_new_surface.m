function fun_hcp_meg_load_new_surface(varargin)
load ./temp/config.mat
switch nargin
    case 1
        subjectName=varargin{1};
    case 3
        protocolName=varargin{1};
        dataDir=varargin{2};
        subjectName=varargin{3};
    case 4 % skip some step
        protocolName=varargin{1};
        dataDir=varargin{2};
        subjectName=varargin{3};
        FLAG=varargin{4};
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RELOAD SURFACE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[sSubject, iSubject] = bst_get('Subject', subjectName);
%% Delete surfaces
if ~isempty(sSubject.Surface)
    file_delete(file_fullpath({sSubject.Surface.FileName}), 1);
    sSubject.Surface(1:end) = [];
end
%% Empty defaults lists
sSubject.iCortex = [];
sSubject.iScalp = [];

%% ===== IMPORT SURFACES =====
    TessLhFile=['./result/',subjectName,'.L.midthickness.from32k.',kiloVertices,'.fs_LR.surf.gii'];
    TessRhFile=['./result/',subjectName,'.R.midthickness.from32k.',kiloVertices,'.fs_LR.surf.gii'];
% TessLhFile=['F:\MEEGfMRI\Data\HCP_S900\105923\MEG\anatomy\105923.L.midthickness.4k_fs_LR.surf.gii'];
% TessRhFile=['F:\MEEGfMRI\Data\HCP_S900\105923\MEG\anatomy\105923.R.midthickness.4k_fs_LR.surf.gii'];
%

TessLhFile=fun_fullpath(TessLhFile);
TessRhFile=fun_fullpath(TessRhFile);

% Left pial
[iLh, BstTessLhFile, nVertOrigL] = import_surfaces(iSubject, TessLhFile, 'GII-MNI', 0);
BstTessLhFile = BstTessLhFile{1};
% Right pial
[iRh, BstTessRhFile, nVertOrigR] = import_surfaces(iSubject, TessRhFile, 'GII-MNI', 0);
BstTessRhFile = BstTessRhFile{1};
%% ===== MERGE SURFACES =====
% Merge surfaces
origCortexFile = tess_concatenate({BstTessLhFile, BstTessRhFile}, sprintf('cortex_%dV', nVertOrigL + nVertOrigR), 'Cortex');
% Rename high-res file
origCortexFile = file_fullpath(origCortexFile);
CortexFile     = bst_fullfile(bst_fileparts(origCortexFile), 'tess_cortex_mid.mat');
file_move(origCortexFile, CortexFile);
% Keep relative path only
CortexFile = file_short(CortexFile);
% Delete original files
file_delete(file_fullpath({BstTessLhFile, BstTessRhFile}), 1);
% Reload subject
db_reload_subjects(iSubject);
%% ===== GENERATE HEAD =====
% Generate head surface
HeadFile = tess_isohead(iSubject, 10000, 0, 2);
%% ===== UPDATE GUI =====
% Update subject node
panel_protocols('UpdateNode', 'Subject', iSubject);
panel_protocols('SelectNode', [], 'subject', iSubject, -1 );
% Save database
db_save();
% Unload everything
bst_memory('UnloadAll', 'Forced');
% Give a graphical output for user validation
%     if isInteractive
%         % Display the downsampled cortex + head + ASEG
%         hFig = view_surface(HeadFile);
%         % Display cortex
%         view_surface(CortexFile);
%         % Set orientation
%         figure_3d('SetStandardView', hFig, 'left');
%     end
% Close progress bar
bst_progress('stop');