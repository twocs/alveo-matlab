function retVal = ta_subset(self, indices_cell, varargin)
%% returns a data structure that contains only those items matching indices_cell
% input:
%    indices_cell: the items to retain
% optional input:
%   type: the type of the subset, where 'file' which is standard method and takes file by file or 'flat' and all the data is considered to be flattened
% output:
%    retVal: the ta_data_class to return

p = inputParser(); % parse optional arguments
p.addRequired('indices_cell', @(x) isa(x, 'cell') || isa(x, 'double'));
p.addParameter('type', 'file', @ischar)
p.parse(indices_cell, varargin{:});

if strcmp(p.Results.type, 'file')

    % return value starts as a clone of self
    retVal = ta_data_class('clone', self);

    % get a list of all the properties0
    properties_temp = properties(self);

    % need to iterate through each property
    for property_index = 1:length(properties_temp)

        % set current property
        property = properties_temp{property_index};

        % do not modify speaker_id or dataset_path, but go through all the other properties and reduce them 
        if isempty(self.(property)) 
            % do nothing
        elseif strcmp(property, 'speaker_id') 
            % retain data
        elseif strcmp(property, 'dataset_path') 
            % retain all data
        elseif strcmp(property, 'mat_filename_cellstr')
            % retain all data
        elseif strcmp(property, 'userdata')
            % retain all data
        elseif strcmp(property, 'textgrid')
            % loop through each speaker
            for i = 1:retVal.ta_length()           
                if isa(indices_cell, 'cell')
                    retVal.textgrid{i}.praat_textgrid = self.textgrid{i}.praat_textgrid(indices_cell{i});
                elseif isa(indices_cell, 'double')
                    retVal.textgrid{i}.praat_textgrid = self.textgrid{i}.praat_textgrid(indices_cell(i));
                end                    
            end 
        elseif strcmp(property, 'mfcc39') || strcmp(property, 'json_metadata') || strcmp(property, 'wav_file')
            % loop through each speaker
            for i = 1:retVal.ta_length()

                % get handle on the data
                temp = retVal.(property){i};

                % reduce the data
                if isa(indices_cell, 'cell')
                    retVal.(property){i} = temp(indices_cell{i},:);
                elseif isa(indices_cell, 'double')
                    retVal.(property){i} = temp(indices_cell(i),:);
                end
            end
        else
            error('@ta property %s unaccounted for', property);
        end
    end
elseif strcmp(p.Results.type, 'flat')

    % return value starts as a clone of self
    retVal = ta_data_class('clone', self);

    % get a list of all the properties0
    properties_temp = properties(self);

    % need to iterate through each property
    for property_index = 1:length(properties_temp)

        % set current property
        property = properties_temp{property_index};

        % do not modify speaker_id or dataset_path, but go through all the other properties and reduce them 
        if isempty(self.(property)) 
            % do nothing
        elseif strcmp(property, 'speaker_id') 
            % retain data
        elseif strcmp(property, 'dataset_path') 
            % retain all data
        elseif strcmp(property, 'mat_filename_cellstr')
            % retain all data
        elseif strcmp(property, 'userdata')
            % retain all data
        elseif strcmp(property, 'json_metadata') || strcmp(property, 'wav_file') || strcmp(property, 'textgrid')
            % do nothing, because we assume that every single file is retained, but only some data from each file is retained
        elseif strcmp(property, 'mfcc39')
            % indices correspond to the flattened data, so need to project it to see the proper mfcc data
            
            start = 1;

            
            % indices_cell is Kx1 data row indexes, but our data is shaped as cells of speakers of files of mfcc39
            % we can number all the mfcc39 then use those numbers 

            start = 1;
            % loop through each speaker
            for i = 1:retVal.ta_length()

                mfcc39_numbering = cell(retVal.ta_length(), 1);
                for j = 1:height(retVal.mfcc39{i})
                    current_height = size(retVal.mfcc39{i}.mfcc39{j}, 1);
                    
                    finish = start + current_height- 1;
                    % get handle on the data
                    mfcc39_numbering(j) = {[start:finish]'};
                    start = finish + 1;
                    
                    mfcc39_temp = retVal.mfcc39{i}.mfcc39{j};
                    retVal.mfcc39{i}.mfcc39{j} = mfcc39_temp(ismember(mfcc39_numbering{j}, indices_cell), :);
                    
                    if ismember('labels', retVal.mfcc39{i}.Properties.VariableNames) && ~isempty(retVal.mfcc39{i}.labels{j})
                        mfcc39_labels_temp = retVal.mfcc39{i}.labels{j};
                        retVal.mfcc39{i}.labels{j} = mfcc39_labels_temp(ismember(mfcc39_numbering{j}, indices_cell), :);
                    end
                    % TODO binary_labels
                end
                
%                 % attach data as additional variable
%                 retVal.mfcc39{i} = [retVal.mfcc39{i} mfcc39_numbering];
%                 
%                 % give the new variable a name
%                 retVal.mfcc39{i}.Properties.VariableNames{2} = 'numbering';
            end
        else
            error('@ta property %s unaccounted for', property);
        end
    end
else
    error('@ta type not defined');
end



end