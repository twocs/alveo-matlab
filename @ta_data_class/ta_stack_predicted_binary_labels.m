function [ out_self ] = ta_stack_predicted_binary_labels( self, binary_labels, varargin)
%TA_GET_PER unstacks predicted_labels to determine the error rate per word
%   If labels is false, then the stack of binary labels is assigned to every mfcc frame
%   If labels is true, then the binary labels are assigned to every mfcc frame that already has a label

p = inputParser();
p.addParameter('labels', true, @islogical); % if labels is false, then the ignore
p.parse(varargin{:});
pp = p.Results;

out_self = self.ta_clone();
stacked_predicted_binary_labels = cell(size(self.mfcc39));

start = 1;
% convert predicted labels into a stack that looks like mfcc39 stack in self
for base_index = 1:size(stacked_predicted_binary_labels, 1)    
    current_stack_predicted_binary_labels = cell(size(self.mfcc39{base_index}, 1), 1);
    for current_index = 1:size(self.mfcc39{base_index}.mfcc39, 1)
        % do not count if there aren't any labels for this word
        % if pp.labels is true, then an error is thrown if self.mfcc39.labels doesn't exist
        if pp.labels && isempty(self.mfcc39{base_index}.labels{current_index})
            continue
        else
            temp = self.mfcc39{base_index}.mfcc39{current_index};
            finish = start + size(temp, 1) - 1;
            current_stack_predicted_binary_labels{current_index} = binary_labels(:, start:finish);
            start = finish + 1;
        end
    end
    
    variable_names = out_self.mfcc39{base_index}.Properties.VariableNames;
    % add the predicted labels to self
    out_self.mfcc39{base_index} = [out_self.mfcc39{base_index} current_stack_predicted_binary_labels];
    out_self.mfcc39{base_index}.Properties.VariableNames = [variable_names, 'predicted_binary_labels'];
end

% counts of phonemes for each word



end

