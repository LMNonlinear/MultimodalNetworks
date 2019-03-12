function events = in_events_bids(sFile, EventFile)
% IN_EVENTS_BIDS: Read a BIDS _events.tsv file (columns "onset", "duration", "trial_type").
%
% OUTPUT:
%    - events(i): array of structures with following fields (one structure per event type) 
%        |- label   : Identifier of event #i
%        |- samples : Array of unique time indices for event #i in the corresponding raw file
%        |- times   : Array of unique time latencies (in seconds) for event #i in the corresponding raw file

% @=============================================================================
% This function is part of the Brainstorm software:
% https://neuroimage.usc.edu/brainstorm
% 
% Copyright (c)2000-2019 University of Southern California & McGill University
% This software is distributed under the terms of the GNU General Public License
% as published by the Free Software Foundation. Further details on the GPLv3
% license can be found at http://www.gnu.org/copyleft/gpl.html.
% 
% FOR RESEARCH PURPOSES ONLY. THE SOFTWARE IS PROVIDED "AS IS," AND THE
% UNIVERSITY OF SOUTHERN CALIFORNIA AND ITS COLLABORATORS DO NOT MAKE ANY
% WARRANTY, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, NOR DO THEY ASSUME ANY
% LIABILITY OR RESPONSIBILITY FOR THE USE OF THIS SOFTWARE.
%
% For more information type "brainstorm license" at command prompt.
% =============================================================================@
%
% Authors: Francois Tadel, 2019

% Read tsv file
Markers = in_tsv(EventFile, {'onset', 'duration', 'trial_type'});
if isempty(Markers) || isempty(Markers{1,1}) || isempty(Markers{1,3})
    events = [];
    return;
end
% List of events
uniqueEvt = unique(Markers(:,3)');
% Initialize returned structure
events = repmat(db_template('event'), [1, length(uniqueEvt)]);
% Create events list
for iEvt = 1:length(uniqueEvt)
    % Find all the occurrences of event #iEvt
    iMrk = find(strcmpi(Markers(:,3)', uniqueEvt{iEvt}));
    % Get event onsets and durations
    onsets = cellfun(@(c)sscanf(c,'%f',1), Markers(iMrk,1), 'UniformOutput', 0);
    durations = cellfun(@(c)sscanf(c,'%f',1), Markers(iMrk,2), 'UniformOutput', 0);
    % Find and reject events with no latency
    iEmpty = find(cellfun(@isempty, onsets));
    if ~isempty(iEmpty)
        iMrk(iEmpty) = [];
        onsets(iEmpty) = [];
        durations(iEmpty) = [];
    end
    % Add event structure
    events(iEvt).label  = uniqueEvt{iEvt};
    events(iEvt).epochs = ones(1, length(iMrk));
    events(iEvt).times  = [onsets{:}];
    % Extended events if durations are defined for all the markers
    if all(~cellfun(@isempty, durations)) && all(~cellfun(@(c)isequal(c,0), durations))
        events(iEvt).times(2,:) = events(iEvt).times + [durations{:}];
    end
    events(iEvt).samples    = round(events(iEvt).times .* sFile.prop.sfreq);
    events(iEvt).reactTimes = [];
    events(iEvt).select     = 1;
end





