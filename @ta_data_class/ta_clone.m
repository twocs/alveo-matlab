% load the data stored in the cellstr
function clone_of_self = ta_clone(self, varargin)
    p = inputParser;
    p.addParameter('single_speaker', false, @islogical); % usually split is done by speaker, not file
    p.addParameter('mask', [], @islogical);
    p.addParameter('indices', [], @isnumeric); % a vector of indices to retain
    p.parse(varargin{:});
    pp = p.Results;
    
    assert((isempty(pp.mask) || isempty(pp.indices)), 'Cannot use both a mask and indices to get a subset of the data');
    
    % create empty class
    clone_of_self = ta_data_class();

    % use reflection over the properties to copy the data across
    property_temp = properties(self);
    for index = 1:length(property_temp)
        property = property_temp{index};
        clone_of_self.(property) = self.(property);
    end

    % if there is a mask, then reduce the size of the resulting copy
    if any(pp.mask)
        property_temp = properties(clone_of_self);
        for index = 1:length(property_temp)
            property = property_temp{index};
            temp = clone_of_self.(property);
            if ~pp.single_speaker
                if isequal(size(temp), size(pp.mask)) % not every property has to be reduced
                    clone_of_self.(property) = temp(pp.mask);
                end
            else
                if isa(temp, 'cell') && isequal(size(temp{1}, 1), size(pp.mask, 1)) % not every property has to be reduced
                    clone_of_self.(property) = {temp{1}(pp.mask,:)};
                end
            end
        end
    end
    
    % if there is a mask, then reduce the size of the resulting copy
    if pp.indices
        property_temp = properties(clone_of_self);
        for index = 1:length(property_temp)
            property = property_temp{index};
            temp = clone_of_self.(property);
            if ~pp.single_speaker
                if size(temp,1) > 1 % not every property has to be reduced
                    clone_of_self.(property) = temp(pp.indices);
                end
            else
                if isa(temp, 'cell') 
                    if size(temp{1},1) > 1 % not every property has to be reduced
                        clone_of_self.(property) = {temp{1}(pp.indices,:)};
                    elseif isfield(temp{1}, 'praat_textgrid')
                        clone_of_self.(property) = {temp{1}.praat_textgrid(pp.indices,:)};
%                     else
%                         k = 2332;
                    end
                end                
        end
    end

    
end