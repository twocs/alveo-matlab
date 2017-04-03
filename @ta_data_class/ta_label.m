function retVal = ta_label( self,  labels, varargin)
%UNTITLED Takes flat label structure and labels the mfcc windows in self

p = inputParser;
p.addParameter('clone', false, @islogical);
p.parse(varargin{:});
pp = p.Results;

if pp.clone
    retVal = self.ta_clone();
else
    % self is by reference so assigning retVal = self actually applies the results to self.
    retVal = self;
end

start = 1;
for speaker_index = 1:retVal.ta_length()
    current_mfcc39_table = retVal.mfcc39{speaker_index};
    labels_cell = cell(height(current_mfcc39_table), 1);
    for table_index = 1:height(current_mfcc39_table)
        finish = start + size(current_mfcc39_table.mfcc39{table_index}, 1) - 1;
        
        labels_cell{table_index} = labels(start:finish);
        
        start = finish + 1;
    end
    
    % add column of labels
    retVal.mfcc39{speaker_index} = [retVal.mfcc39{speaker_index}, table(labels_cell, retVal.json_metadata{speaker_index}.prompt, 'VariableNames', {'autolabels', 'prompts'})];
end

end

