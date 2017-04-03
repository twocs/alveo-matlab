function retVal = ta_normalise( self, mode, varargin)
%TA_NORMALISE Loop through each mfcc file and normalise in place
%   mode:
%       'file' - normalise based on individual files
% TODO? - add modes: 'dataset', 'frame' (note that they can be done on entire data set, so perhaps not necessary.


% variance and mean

p = inputParser;
p.addRequired('mode', @(x) strcmp(x, 'file'));
p.addParameter('clone', false, @islogical); % operate on a copy?
p.parse(mode, varargin{:});
pp = p.Results;

if pp.clone
    retVal = self.ta_clone();
else
    retVal = self; % self is passed by reference
end

% loop through each speaker
for speaker_index = 1:size(retVal.mfcc39, 1) % if mfcc39 does not exist, it cannot be normalised
    % loop through each mfcc
    for mfcc_index = 1:size(retVal.mfcc39{speaker_index}, 1)
        % normalise in place
        retVal.mfcc39{speaker_index}.mfcc39{mfcc_index} = som_normalize(retVal.mfcc39{speaker_index}.mfcc39{mfcc_index}, 'var');
    end
end

retVal.userdata.normalised = mode;

end

