function [ binary_label_cell ] = ta_get_vowel_phoneme_from_word__binary_label_cell( self, prompt_to_phoneme_map )
%TA_GET_VOWEL_PHONEME_FROM_WORD__BINARY_LABEL_CELL converts the 
% Input:
%   prompt_to_phoneme_map: Gained from manual annotations in labelled_ta_data
% Output:
%   binary_labels: A one-dimensional vector of binary labels

% make parallel arrays
temp = vertcat(self.json_metadata{:});
prompts = temp.prompt;

windows = vertcat(self.mfcc39{:});
window_lengths = cellfun(@(x) size(x, 1), windows.mfcc39);

% convert prompts to phonemes
phonemes = arrayfun(@(x) prompt_to_phoneme_map(char(x)), prompts, 'uni', false);

binary_label_cell = cell(0);

% make labels onto each window frame
for index = 1:size(window_lengths,1)
    curr = repmat(phonemes(index), window_lengths(index), 1);
    binary_label_cell = vertcat(binary_label_cell, curr);
end

end

