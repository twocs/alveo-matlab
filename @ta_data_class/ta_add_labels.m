function ta_add_labels( self, variable_name, labels_to_be_added, varargin)
%UNTITLED Takes flat label structure and labels the mfcc windows in self
p = inputParser;
p.addRequired('variable_name', @ischar);
p.addRequired('labels_to_be_added'); % length of labels_to_be_added should be the same as the flat mfcc39
p.addParameter('clobber', false, @islogical); % overwrite the existing value?
p.parse(variable_name, labels_to_be_added, varargin{:});
pp = p.Results;

start = 1;
for speaker_index = 1:self.ta_length()
    current_mfcc39_table = self.mfcc39{speaker_index};
    labels_cell = cell(height(current_mfcc39_table), 1);
    for table_index = 1:height(current_mfcc39_table)
        finish = start + size(current_mfcc39_table.mfcc39{table_index}, 1) - 1;
        
        labels_cell{table_index} = labels_to_be_added(start:finish);
        
        start = finish + 1;
    end
    
    % add column of labels
%     self.mfcc39{speaker_index} = [self.mfcc39{speaker_index}, table(labels_cell, self.json_metadata{speaker_index}.prompt, 'VariableNames', {pp.variable_name})];
    if pp.clobber
        self.mfcc39{speaker_index}.(pp.variable_name) = labels_cell;
    else
        self.mfcc39{speaker_index} = [self.mfcc39{speaker_index}, table(labels_cell, 'VariableNames', {pp.variable_name})];
    end
end

end

