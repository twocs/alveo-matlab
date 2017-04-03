function my_clone = ta_get_only( self,  varargin )
%UNTITLED Strips out all data except for the desired target data. which matches the prompt

% works, tested by manually checking that it worked for 'horde'
% TODO: reduce unnecessary copying then pruning for ta_clone and simply copy what is needed

p = inputParser;
p.addParameter('prompt', '', @ischar); % keep only the prompt given as a text string
p.addParameter('speaker_id', false, @islogical); % copy speaker_id as a variable_name in mfcc39
p.parse(varargin{:});
pp = p.Results;

my_clone = self.ta_clone();

if ~isempty(pp.prompt)
    for speaker_index = 1:self.ta_length()
        current_json_metadata = my_clone.json_metadata{speaker_index};
        match_indices = strcmp(current_json_metadata.prompt, pp.prompt);
        
                
        my_clone.textgrid{speaker_index} = my_clone.textgrid{speaker_index}.praat_textgrid(match_indices);
        my_clone.json_metadata{speaker_index} = current_json_metadata(match_indices,:);
        my_clone.mfcc39{speaker_index} = my_clone.mfcc39{speaker_index}(match_indices,:);

    end
end

if ~isempty(pp.speaker_id)
    for speaker_index = 1:self.ta_length()
        current_json_metadata = my_clone.json_metadata{speaker_index};
        match_indices = strcmp(current_json_metadata.prompt, pp.prompt);
        
        speaker_ids = table(cellstr(repmat(my_clone.speaker_id{speaker_index}, sum(match_indices), 1)), 'VariableNames', {'speaker_id'});
        my_clone.json_metadata{speaker_index} = current_json_metadata(match_indices,:);
        my_clone.mfcc39{speaker_index} = [my_clone.mfcc39{speaker_index}(match_indices,:), speaker_ids];
    end
end