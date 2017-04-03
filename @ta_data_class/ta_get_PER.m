function [ ret_val ] = ta_get_PER( self, vocabulary)
%TA_GET_PER run on a self with a predicted_binary_labels column to determine the error rate per word
        % TODO: FIX if the labels are empty then don't include the data because we are only testing with labelled data
        
% max that is not silence, /d/ or /h/
vowel_indices = arrayfun(@(x) ~ismember(x, {'(...)', 'h', 'd'}), vocabulary); 

% just vowels
vowel_vocabulary = vocabulary(vowel_indices);

prompts = cellfun(@(x) x.prompt, self.json_metadata, 'uni', false);
temp_binary_labels = cellfun(@(x) x.predicted_binary_labels, self.mfcc39, 'uni', false);

counts = cell(size(temp_binary_labels));


predicted_phoneme = cell(size(temp_binary_labels, 1), 1);


for index = 1:size(temp_binary_labels, 1)
    indexed_temp_binary_labels = temp_binary_labels{index};
    
    % create cells for storing the data
    temp_counts = cell(size(indexed_temp_binary_labels, 1), 1);
    current_max_vowel = cell(size(indexed_temp_binary_labels, 1), 1);
    
    % iterate through each cell
    for current_index = 1:size(indexed_temp_binary_labels, 1)
        % if the labels are empty then don't include the data because we are only testing with labelled data
        if ~isempty(indexed_temp_binary_labels{current_index})
%             % do nothing
% %             temp_counts{current_index} =[];
% %             current_max_vowel = [];
%         else
           % get the count of each vowel         
           current_temp = indexed_temp_binary_labels{current_index};
            temp_counts{current_index} = sum(current_temp(vowel_indices,:),2);
            
                
            % get index of the most likely vowel
            [~, current_max_vowel{current_index}] = max(temp_counts{current_index});
        end
    end
 
    %store the actual phoneme predicted by the classifier
    predicted_phoneme{index} = cellfun(@(x) vowel_vocabulary(x), current_max_vowel, 'uni', false);
    
    % store the count of each vowel
    counts{index} = temp_counts;
end

% a list of the words and the matching predictions corresponding to the order in vocabulary
ret_val = table(prompts, counts, predicted_phoneme);


