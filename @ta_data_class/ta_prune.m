function ta_prune(self, varargin)
%%
% WARNING, CHANGES THE STRUCTURE ITSELF
%    self: the json data structure for each participant
%    prompt: a regex used for search, all non-matching prompts are deleted
%    mfcc39: if false, remove mfcc39 data (for compact storage of data)

p = inputParser;
p.addParameter('prompt', false, @ischar);
p.addParameter('mfcc39', true, @islogical);
% p.addParameter('vocabulary', ''); % TODO: compress data by changing strings to categoricals
p.parse(varargin{:});
pp = p.Results;

if pp.prompt
    
    %% MARK
    target_prompts_categorical =  self.ta_get_prompts_categorical(pp.prompt);
    
    %% marked_prompts is parallel to mat_files.json_metadata.prompts with T/F for whether it is included
    marked_prompts_cell = cellfun(@(x) ismember(x.prompt, target_prompts_categorical), self.json_metadata, 'UniformOutput', false);
    
    %% PRUNE
    
    % % get a copy of the input
    % out_obj = obj.ta_clone();
    
    for index = 1:self.ta_length()
        marked_prompts_cell_temp = marked_prompts_cell{index};
        
        % assign the value to the return value table
        temp = self.json_metadata{index};
        self.json_metadata{index} = temp(marked_prompts_cell_temp,:);
        
        % TODO: what if the data has no mfcc39 component?
        if self.mfcc39
            mfcc_temp = self.mfcc39{index};
            self.mfcc39{index} = mfcc_temp(marked_prompts_cell_temp,:);
        end
    end
end


if ~pp.mfcc39
    for index = 1:self.ta_length()
        mfcc_temp = table(self.mfcc39{index}.autolabels, self.mfcc39{index}.prompts, 'VariableNames', self.mfcc39{index}.Properties.VariableNames(2:3));
        self.mfcc39{index} = mfcc_temp;
    end
end


end