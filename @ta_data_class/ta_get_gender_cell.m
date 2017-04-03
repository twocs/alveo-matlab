function [ gender_cell ] = ta_get_gender_cell( self )
%ta_get_gender_cell Get a cell array of the genders 

% get an array of speaker_id
speaker_id_cell = self.speaker_id;

% get an array of gender from the speaker_id
gender_cell = cellfun(@(x) ta_data_class.ta_gender_from_speaker_id(x), speaker_id_cell, 'uni', false);

end

