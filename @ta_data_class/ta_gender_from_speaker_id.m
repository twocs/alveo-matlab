function gender = ta_gender_from_speaker_id(speaker_id)
%TA_GENDER_FROM_SPEAKER_ID Lookup class to determine if male or female
% Input:
%   'speaker_id': Text string of the speaker id
% Output:
%     gender: 'male' if male and 'female' if female
% only load the map the first time that this method is called. Other times, just use the map for lookup 
persistent gender_from_speaker_id_map
if isempty(gender_from_speaker_id_map)
    gender_from_speaker_id_map = ta_gender_from_speaker_id_map();
end

try
    gender = gender_from_speaker_id_map(speaker_id);
catch ME
    if strcmp(ME.identifier, 'MATLAB:Containers:Map:NoKey')
        warning('@ta Speaker id %s is not in the dataset', speaker_id);
    end
    rethrow(ME);
end
end

function [ gender_from_speaker_id_map ] = ta_gender_from_speaker_id_map( )
% TA_GENDER_FROM_SPEAKER_ID_MAP Helper class to load the table including gender metadata and make a map from the table
%   output:
%       returns a map that correlates speaker_id with gender
% Note: an alternate method would be to use the table directly like: participant_data{speaker_id, 'gender'}

%load MATLAB data file, which contains a table with row names set to participant_id and a variable named gender containing 'male' or 'female'
load('G:\Dropbox\datasets\austalk speaker data\participant_data.mat');

speaker_id_cell = participant_data.Properties.RowNames;
gender_cell = participant_data.gender;

gender_from_speaker_id_map = containers.Map;

for index = 1:length(speaker_id_cell)
    speaker_id = speaker_id_cell{index};
    gender = gender_cell{index};
    
    gender_from_speaker_id_map(speaker_id) = gender;
end

end

