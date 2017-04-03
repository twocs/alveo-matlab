% load the data stored in the cellstr
function clone_of_self = ta_data_add(self, to_be_added_ta_data)
%     p = inputParser;
%     p.addParameter('mask', cell(0), @(x) isequal(size(x), size(self.speaker_id)));
%     p.parse(varargin{:});
%     pp = p.Results;
        
    % use the clone class to reduce duplication of code
    clone_of_self = self.ta_clone();

    
    % use reflection over the properties to copy the data across
    property_temp = properties(to_be_added_ta_data);
    for index = 1:length(property_temp)
        property = property_temp{index};
        if strcmp(property, 'userdata')
            clone_of_self.(property) = clone_of_self.(property);
            clone_of_self.(property).note = 'includes_labelled_data';
        elseif strcmp(property, 'textgrid')
            % do nothing, i.e. don't copy textgrid labels
        elseif strcmp(property, 'mfcc39')
            % all tables must have the same number of variables
            % mfcc labelled has extra columns so we remove them
            % TODO: make this process less ugly
            for mfcc_index = 1:size(to_be_added_ta_data.mfcc39, 1)       
                clone_of_self.(property){end+1} = table(to_be_added_ta_data.mfcc39{mfcc_index}.mfcc39, 'VariableNames', {'mfcc39'});
            end
        else
            
            clone_of_self.(property) = vertcat(clone_of_self.(property), to_be_added_ta_data.(property));
            
            
        end
    end

%     % if there is a mask, then reduce the size of the resulting copy
%     if ~isempty(pp.mask)
%         property_temp = properties(clone_of_self);
%         for index = 1:length(property_temp)
%             property = property_temp{index};
%             temp = clone_of_self.(property);
%             if isequal(size(temp), size(pp.mask)) % not every property has to be reduced
%                 clone_of_self.(property) = temp(pp.mask);
%             end
%         end
%     end

end