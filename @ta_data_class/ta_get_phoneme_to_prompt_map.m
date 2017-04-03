function [ phoneme_to_prompt_map ] = ta_get_phoneme_to_prompt_map(self,  varargin)
%TA_GET_PROMPT_TO_PHONEME_MAP Builds a map that converts between phonemes to show the corresponding prompt according to the manual annotation

p = inputParser;
p.addRequired('self', @(x) isa(x, 'ta_data_class'));
% p.addParameter('prompt_to_phoneme_map', self.ta_get_prompt_to_phoneme_map(), isa();
p.parse(self, varargin{:});

if ~exist('prompt_to_phoneme_map', 'var')
    prompt_to_phoneme_map = self.ta_get_prompt_to_phoneme_map();
end

% prompt_to_phoneme_map = pp.Results.prompt_to_phoneme_map;

% go through each prompt and phoneme label
for speaker_index = 1:size(self.mfcc39, 1)
    % extract the key and value data
    prompts = cellstr(self.json_metadata{speaker_index}.prompt);
    mfcc39_labels = self.mfcc39{speaker_index}.labels;
    
    assert(size(prompts,1) ==size(mfcc39_labels,1)); % the prompts must be the same as the labels to match them 
    
    for current_index = 1:size(mfcc39_labels, 1)
        current_phonemes = unique(mfcc39_labels{current_index});
        
        % only process labelled data
        if ~isempty(current_phonemes)
            % find the current vowel
            vowel = current_phonemes{~ismember(current_phonemes, {'', '(...)', 'h', 'd'})};

            % check if the key exists
            if isKey(prompt_to_phoneme_map, prompts{current_index})
                % if it exists, verify that it matches, or otherwise the manual annotation doesn't match
                assert(strcmp(prompt_to_phoneme_map(prompts{current_index}), vowel));
            else
                % if not, add it to the container
                prompt_to_phoneme_map(prompts{current_index}) = vowel;
            end
        end
    end
end
    
end

