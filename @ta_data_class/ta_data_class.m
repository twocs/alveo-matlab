classdef ta_data_class < handle % hgsetget
    %UNTITLED Stores data for the 
    %   Contains helper functions so that MATLAB idiosyncracies don't cause problems
    %   For struct2table functions differently, depending on whether there are one or two records
    %   All the properties are parallel 
    
    properties
        % all the json data loaded from file
        json_metadata
        
        % the speaker_id for the given speaker
        speaker_id
        
        % a path to the alveo folder containing the data
        dataset_path
        
        % a list of .mat files that the data comes from
        mat_filename_cellstr
        
        % PRAAT TextGrid
        textgrid
        
        % wav files
        wav_file
        
        % mfcc39 data
        mfcc39
        
        % stores current state and any extra data needed
        userdata

    end
    
    % convert adhoc SAMPA labels to IPA
    methods(Static)
        [ sampa2ipa ] = ta_SAMPA_to_IPA()        
        [ prompt2ipa ] = ta_hVd_prompt_to_IPA()
        gender = ta_gender_from_speaker_id(speaker_id)
    end
    
    methods
        %% signatures of external file defined methods
        ta_add_labels( self, variable_name, labels_to_be_added, varargin)
        sMap = ta_batchtrain_lininit(self, SOMwidth, varargin) 
    	clone_of_self = ta_clone(self, varargin)    
        [ train_data, test_data ] = ta_crossval( self, K )
        [ Train_indices, Test_indices ] = ta_crossval__one_left_out___indices( self )
        clone_of_self = ta_data_add(self, to_be_added_ta_data)
        retVal = ta_flat_stack(self)
        gender_cell = ta_get_gender_cell( self )
        my_clone = ta_get_only( self,  varargin )
        out_self = ta_get_PER( self, vocabulary)
        phoneme_to_prompt_map = ta_get_phoneme_to_prompt_map(self, varargin)
		labels = ta_get_phonemes_categorical(self, vocabulary)
        prompt_to_phoneme_map = ta_get_prompt_to_phoneme_map(self, varargin)
        target_prompts = ta_get_prompts_categorical(obj, target_regex)
        binary_label_cell = ta_get_vowel_phoneme_from_word__binary_label_cell( self, prompt_to_phoneme_map )
        retVal = ta_label( self,  labels, varargin)
        ta_label_mfcc39_from_TextGrid(self)
        ta_load_mfcc39(self)
        output = ta_mask_prompts(obj,arg1,arg2)
        ta_normalise(self, mode);
        ta_prune(self, varargin)
        [mfcc39_retVal, label_retVal] = ta_stack_mfcc39(self, property)
        [mfcc39_stack, speaker_id_stack, prompt_stack] = ta_stack_mfcc39_and_speaker_id(self)
        output_args = ta_stack_predicted_binary_labels( self, predicted_binary_labels, varargin)
        retVal = ta_subset(self, indices_cell, varargin)
%         sMap= ta_gtm_attempt(self, SOMwidth)  

        
        %% constructor
        function self = ta_data_class(varargin)
            % empty constructor
            if nargin == 0 
                return
            end
            
            % not empty
            p = inputParser; % check the input
            p.FunctionName = 'TA_DATA_CLASS constructor';
            p.addParameter('clone', false);
            p.addParameter('dirpath', false);
            p.addParameter('prompt', false, @ischar);
            p.addParameter('TextGrid', false, @islogical);
            p.addParameter('mfcc39', false, @islogical); % only perform this step if it is specified
            p.addParameter('label', false, @islogical);
            p.addParameter('mat_label', false, @ischar);
            p.addParameter('sampa_to_ipa', true, @islogical); % use SAMPA lookup?
            p.parse(varargin{:});
            pp = p.Results;
            
            if isa(pp.clone, 'ta_data_class')
                self = pp.clone.ta_clone();
                % TODO: verify that cloning can perform other functions such as pruning without affecting the cloned object
            end
            
            if pp.dirpath
                self.get_all_mat_files_in_a_folder_cellstr(pp.dirpath);
                self.load_mat_files();
                
                % store the dirpath that was used
                self.userdata.dirpath = pp.dirpath;
            end
            
            % retain the mat_label that is used when outputting to describe the dataset
            if pp.mat_label
                self.userdata.mat_label = pp.mat_label;
            end
            
            %% are we pruning based on 'prompt'?
            if pp.prompt % prune using regex
                % prune data that doesn't match the target
                self.ta_prune('prompt', pp.prompt);
            end
            
            %% are we loading TextGrid files?
            if pp.TextGrid
                    self.ta_get_TextGrids();
            end
            
            %% are we creating mfcc39?  Create them after pruning!
            if pp.mfcc39
                self.ta_load_mfcc39();
            end
            
            if pp.label
                %% use the textgrid to create labels for the mfcc39_data 
                self.ta_praat_textgrid_to_mfcc39_label('sampa_to_ipa', pp.sampa_to_ipa);

                % add the binary labels that are used for comparing actual labels with predicted labels
                self.ta_mfcc39_category_labels_to_binary_labels();
            end
        end
        
        % load the data stored as wav files with filenames in  mat_filename_cellstr
        function load_mat_files(self)
            mat_files = cellfun(@load, self.mat_filename_cellstr);
            % TODO: compartmentalise json_metadata, e.g. self.json_metadata = ta_json_data_class({mat_files.json_metadata});
            self.json_metadata = {mat_files.json_table}';
            self.speaker_id = {mat_files.speaker_id}';
            self.dataset_path = {mat_files.dataset_path}';
        end
        
        function get_all_mat_files_in_a_folder_cellstr(obj, mat_dirpath)
            % get a list of all .mat files in the folder
            mat_filenames = dir(fullfile(mat_dirpath, '*.mat'));
            mat_filenames_name = {mat_filenames.name}';
            mat_fullfilename = cellfun(@(x) strcat(mat_dirpath, '\', x), mat_filenames_name, 'UniformOutput', false);

            % cellstr of filenames
            obj.mat_filename_cellstr = mat_fullfilename;
        end
        
        % prune data structure to a subsample of speakers
        function ta_prune_speakers(self, speaker_selection)
            
            % we assume that selection is a subset of row numbers
            assert isa(speaker_selection, 'double')
                
            % end if there is an error
            if max(speaker_selection) > self.ta_length()
                error('@ta there are more items in the subset than in the data structure');
            end

            % iterate through each of the properties
            for property = properties(self)'
                % store the value of the property
                temp = self.(property{:});

                % skip empty properties
                if isempty(temp)
                    self.(property{:}) = temp;
                else
                    % the item's property is equal to the subset of speaker data specified by selection
                    self.(property{:}) = temp(speaker_selection);
                end
            end

        end
        
        function retVal = ta_length(self)
            if isfield(self.userdata, 'state') && strcmp(self.userdata.state, 'flat')
                retVal = length(self.mfcc39);
            else
                % assumption: the length of all the parallel arrays is equal, so we return the length of one of them
                retVal = length(self.json_metadata);
            end
        end
        
        function retVal_bool = ta_has_textgrid(self)
            retVal_bool = ~isempty(self.textgrid);
        end
        
        % get the set of all sorted, unique label tokens for a given speaker
        function complete_vocabulary = ta_get_complete_vocabulary(self)
            % isolate the mfcc39 data
            all_mfcc39_table = cat(1, self.mfcc39{:});

            % isolate the labels
            temp_labels1 = all_mfcc39_table.labels; % only works for labelled data
            temp_labels2 = vertcat(temp_labels1{:}); % note that vertcat(all_mfcc39_table.labels{:}) does not give the same result as these two lines...
            
            % get the unique labels
            complete_vocabulary = unique({temp_labels2{:}}'); % results of unique are sorted
        end
    end
end