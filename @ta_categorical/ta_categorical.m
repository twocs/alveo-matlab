classdef ta_categorical
    %TA_CATEGORICAL Summary of this class goes here
    %   Helper to convert between categorical, double, and logical vectors
    %   Written by Tom Anderson
    
    properties
        % categorical
        value
    end
    
    methods(Static)
                
        function retVal_categorical = double_to_categorical(input_double, vocabulary)
                        
            assert(isdouble(input_categorical), 'input to double_to_categorical must be a double data type');

            valueset = ta_categorical.categorical_to_double(categorical(vocabulary), vocabulary);
            retVal_categorical = categorical(input_double, valueset, vocabulary, 'Ordinal', true, 'Protected', true);
        end
        
        function retVal_double = categorical_to_double(input_categorical, vocabulary)
            assert(iscategorical(input_categorical), 'input to categorical_to_double must be a categorical data type');
            num_rows_of_output =size(input_categorical, 1);
            if num_rows_of_output == 1
                retVal_double = double(categorical(input_categorical, vocabulary, 'Ordinal', true));
                return;
            end
            
            retVal_double = zeros(size(input_categorical));
            for row_index = 1:size(input_categorical, 1)
                retVal_double(row_index, :) = ta_categorical.categorical_to_double(input_categorical(row_index, :), vocabulary);
            end
        end
        
        function retVal_logical_vector = categorical_to_logical_vector(input_categorical, vocabulary)
            % categorical is oriented horizontally
            % multiple rows means multiple rows of input
            assert(iscategorical(input_categorical), 'input to categorical_to_logical_vector must be a categorical data type');
            
            if size(input_categorical, 1)==1
                retVal_logical_vector = ta_categorical.single_row_categorical_to_logical_vector(input_categorical, vocabulary);
                return;
            end
            
            temp = cell(size(input_categorical, 1), 1);
            for row_index = 1:size(input_categorical, 1)
                row_categorical = input_categorical(row_index, :);
                temp{row_index} = ta_categorical.categorical_to_logical_vector(row_categorical, vocabulary);
            end
            retVal_logical_vector = vertcat(temp{:});
        end
        
        function retVal_logical_vector = single_row_categorical_to_logical_vector(input_categorical, vocabulary)
            % TODO: assert dimentionality
            assert(iscategorical(input_categorical), 'input to single_row_categorical_to_logical_vector must be a categorical data type');
            if iscellstr(vocabulary)
                temp = cellfun(@(x) ismember(input_categorical, x), vocabulary, 'uni', false);
                retVal_logical_vector = vertcat(temp{:});
            else
                % TODO: speedup?
                temp = zeros(size(vocabulary, 2), size(input_categorical,2));
                for i = 1:size(input_categorical, 2)
                    temp(input_categorical(i), i) = 1;
                end
                retVal_logical_vector = logical(temp);
            end
        end
        
        function retVal_categorical = logical_vector_to_categorical(input_logical_vector, vocabulary)
            % output:
            %    retVal_categorical: single row of categorical information            
            assert(islogical(input_logical_vector), 'input to logical_vector_to_categorical must be a logical vector data type');

            retVal_categorical = cell(1, size(input_logical_vector, 2));
            
            % put each group of logical vectors into a cell
            for col_index = 1:size(input_logical_vector, 2)
                retVal_categorical(col_index) = vocabulary(input_logical_vector(:, col_index)');
            end
        end
    end
    
    methods
        function self = ta_categorical(input, vocabulary)
            % convert into ordinal categorical
            self.value = categorical(input, vocabulary, 'Ordinal', true, 'Protected', true);
        end
    end
end

