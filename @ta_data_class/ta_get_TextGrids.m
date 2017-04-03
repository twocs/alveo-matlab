function ta_get_TextGrids(self)
%% append labels from textgrid files to the data structure

self.textgrid = cell(self.ta_length(), 1);

% iterate through each speaker
for speaker_index = 1:self.ta_length()    
     % dummy data to add column for the praat_textgrid, one for each mfcc file
    self.textgrid{speaker_index}.praat_textgrid = repmat(ta_praat_textgrid(), height(self.json_metadata{speaker_index}), 1);   
    
    % iterate through each file
    for file_index = 1:height(self.json_metadata{speaker_index})
        
        temp_filename = strrep(self.json_metadata{:}.wav_filename{file_index}, 'wav', 'TextGrid');
        textgrid_filename = fullfile(self.dataset_path, strrep(temp_filename, ' ', '_'));

        % load textgrid for the file
        current_textgrid = ta_praat_textgrid(textgrid_filename{:});            

%         % build the name of the textgrid for the file
%         % Assumption: The TextGrid is located in the same folder as its matching audio/json data
%         [current_dirpath, ~] = fileparts(self.json_metadata{speaker_index}.json_fullfilename{file_index});
% 
%         % get the filename, we assume there is only one .TextGrid file in that folder
%         textgrid_filename = dir(fullfile(current_dirpath, '*.TextGrid'));

%         % ensure that the textgrid exists
%         if isempty(textgrid_filename)
%             textgrid_filename = dir(fullfile(self.dataset_path{:}, '*.TextGrid'));
%         end
%         
%         if isempty(textgrid_filename)            
%             warning('@ta: no textgrid found in folder %s', current_dirpath);
%             
%             % if there's no textgrid, simply append an empty textgrid 
%             current_textgrid = ta_praat_textgrid();
%         elseif size(textgrid_filename, 1) > 1 % hack to enable praat loading from different folder structure
%             % create full filename
%             textgrid_filename_temp = fullfile(self.dataset_path{:}, textgrid_filename(file_index).name);
% 
%             % load textgrid for the file
%             current_textgrid = ta_praat_textgrid(textgrid_filename_temp);            
%         else
%             % create full filename
%             textgrid_filename = fullfile(current_dirpath, textgrid_filename.name);
% 
% 
%             % load textgrid for the file
%             current_textgrid = ta_praat_textgrid(textgrid_filename);
%         end

        % append the textgrid to the table column
        self.textgrid{speaker_index}.praat_textgrid(file_index) = current_textgrid;    
    end

end

end