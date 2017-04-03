function ta_mfcc39_category_labels_to_binary_labels(self, complete_vocabulary)

% copy the input labels
binary_label_struct = self.mfcc39;

if ~exist('complete_vocabulary', 'var')
    complete_vocabulary = self.ta_get_complete_vocabulary();
end

for speaker_index = 1:self.ta_length()
    % get the letter labels
    current_labels = self.mfcc39{speaker_index}.labels;
    
    %% convert letter labels to binary labels
    
    % temp to hold data
    actual_binary_labels = cell(length(current_labels), 1);

    % iterate through each label
    for h = 1:length(current_labels)

        % skip uninitialised data
        if ~iscell(current_labels{h})
            continue
        end
        
        % rows are the phonemes, columns are the frames
        temp= cellfun(@(y) cellfun(@(x) strcmp(x, y), complete_vocabulary), current_labels{h}, 'UniformOutput', false);
        actual_binary_labels{h} = [temp{:}];
    end
    
    % add the data to the object
    self.mfcc39{speaker_index}.binary_labels = actual_binary_labels;
end


end
