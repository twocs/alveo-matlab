function [ prompt_to_phoneme_map ] = ta_get_prompt_to_phoneme_map(self)
%TA_GET_PROMPT_TO_PHONEME_MAP Scans the data structure to build a map of prompts to vowel labels from manual annotation

prompt_to_phoneme_map = containers.Map;

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
            vowel_index = ~ismember(current_phonemes, {'', '(...)', 'h', 'd'});
            if ~any(vowel_index)
                % there are no vowels to be processed
                assert(any(vowel_index), 'No vowels appear in the map, so we cannot classify vowels using the map!');
            end
            
            % find the current vowel
            vowel = current_phonemes{vowel_index};

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

