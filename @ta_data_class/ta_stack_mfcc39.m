  % stack all the data in order for data processing
        function [mfcc39_retVal, label_retVal] = ta_stack_mfcc39(self, property)
        % property should be 'labels', 'binary_labels', or 'mfcc39'
        % note that if you want mfcc39 only for labelled data points, then you must use 'labels'
            
        
        
            % determine if labels are to be returned
            if strcmp(property, 'binary_labels') || strcmp(property, 'labels')
                
                % get the binary labels
                temp1 = vertcat(self.mfcc39{:});
                mfcc39_cell = temp1.(property);

                % only select mfcc39 data that corresponds with labelled data
                pruning = cellfun(@isempty, mfcc39_cell);
                pruned_table = temp1(~pruning,:);

                % collect the desired labels
                label_temp = pruned_table.(property);

                if strcmp(property, 'binary_labels')                
                    % binary labels are sideways
                    label_retVal = horzcat(label_temp{:});
                else % property == 'labels'
                    % text is stored in cellstr
                    label_temp2 = vertcat(label_temp{:});
                    label_retVal = {label_temp2{:}}';
                end
                
                % collect the mfcc39     
                mfcc39_temp = pruned_table.mfcc39;
                mfcc39_retVal = vertcat(mfcc39_temp{:});   
            elseif strcmp(property, 'mfcc39')
                % simply collate mfcc39 data
                temp1 = vertcat(self.mfcc39{:});
                mfcc39_cell = temp1.(property);
                mfcc39_retVal = vertcat(mfcc39_cell{:});
                label_retVal = [];
                
                                
%                 temp1 = vertcat(self.mfcc39{:});
%                 mfcc39_cell = temp1.(property);
%                 mfcc39_retVal = vertcat(mfcc39_cell{:});
%                 label_retVal = [];
            elseif strcmp(property, 'speaker_id')
                %return stack of speaker_id parallel with mfcc39 data
                speaker_id_cell = cell(self.ta_length(), 1);
                
                % get height of each speaker_id_stack
                for i = 1:self.ta_length()
                    length_temp = self.mfcc39{i}.mfcc39;
                    speaker_id_cell{i} = repmat(self.speaker_id(i), length(vertcat(length_temp{:})), 1);
                end
                
                label_retVal = vertcat(speaker_id_cell{:});
                
                % don't need this data
                mfcc39_retVal = [];
            else
                error('@ta undefined');
            end
        end