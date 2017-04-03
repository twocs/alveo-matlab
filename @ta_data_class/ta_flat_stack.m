  % stack all the data to windows in order for data processing, flatten into single row all round with access to speaker_id and prompt
function [retVal] = ta_flat_stack(self)
    retVal = ta_data_class();
    properties_temp =  properties(self);
    for property_index =1:length(properties_temp)
        property = properties_temp{property_index};
        %return stack of speaker_id parallel with mfcc39 data
        if strcmp(property, 'speaker_id')
            %return stack of speaker_id parallel with mfcc39 data
            speaker_id_cell = cell(self.ta_length(), 1);

            % get height of each speaker_id_stack
            for i = 1:self.ta_length()
                total = sum(cellfun(@length, self.mfcc39{i}.mfcc39));
                speaker_id_cell{i} = repmat(self.speaker_id(i), total, 1);
            end

            %             TODO: create an extra column containing 'speaker_idXprompt' column that will be used for grouping
            
            prompts_categorical = cellfun(@(x) x.prompt, self.json_metadata, 'UniformOutput', false);
            prompt_cell = cell(self.ta_length(), 1);
            
            for i = 1:self.ta_length()
                current_prompt_categorical = prompts_categorical{i};
                assert(length(current_prompt_categorical) == height( self.json_metadata{i} ))

                temp = cellfun(@length, self.mfcc39{i}.mfcc39);
                prompt_temp_cell = cell(length(current_prompt_categorical), 1);
                for j = 1:length(current_prompt_categorical)
                    prompt_temp_cell{j} = repmat(current_prompt_categorical(j), temp(j), 1);
                end
                prompt_cell{i} = vertcat(prompt_temp_cell{:});
                assert(length(prompt_cell{i}) == sum(temp));
            end
            
            speaker_id= vertcat(speaker_id_cell{:});
            prompts = vertcat(prompt_cell{:});
            
            group = cellfun(@(x, y) sprintf('%s_%s', x, y), speaker_id, cellstr(prompts), 'uni', false);

            retVal.speaker_id = speaker_id;
            retVal.userdata.group = table(categorical(speaker_id), prompts, categorical(group), 'VariableNames', {'speaker_id', 'prompts', 'group'});
            retVal.userdata.state = 'flat';
        elseif strcmp(property, 'mfcc39')
                % simply flatten mfcc39 data (which also contains labels)
                temp1 = vertcat(self.mfcc39{:});
                mfcc39_cell = temp1.mfcc39;
                retVal.mfcc39 = vertcat(mfcc39_cell{:});
        else
            % leave the data alone if already filled
            if isempty(retVal.(property))
                retVal.(property) = self.(property);
            end
        end
    end

end