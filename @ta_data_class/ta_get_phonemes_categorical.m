function labels = ta_get_phonemes_categorical(self, vocabulary)
%% scan the data structure obj to find all prompts that match the regex
%    self: the ta_data_class data structure
%    vocabulary (optional): the complete set of tokens
% output:
%    target_prompts: a list of all phonemes that appear in the text grids
%

[~, labels] = self.ta_stack_mfcc39('labels');

if exist('vocabulary', 'var')
    % ordinal allows the labels to be converted to double
    labels = categorical(labels, vocabulary, 'Ordinal', true);
else
   labels = categorical(labels, 'Ordinal', true); 
end
end