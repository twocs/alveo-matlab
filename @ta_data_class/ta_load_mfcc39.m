function ta_load_mfcc39(self)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% hold the data in field mfcc39
self.mfcc39 = cell(self.ta_length(), 1);

for speaker_index = 1:self.ta_length()
    % create a cell array to hold the data
    mfcc39 = cell(height(self.json_metadata{speaker_index}), 1);
    for prompt_index = 1:height(self.json_metadata{speaker_index})
        % determine the path of the wav file
        json_metadata_temp = self.json_metadata{speaker_index};
        pathstr = self.dataset_path{:};
        wav_filename = fullfile(pathstr, json_metadata_temp(prompt_index,:).wav_filename{:});

        % read the wav data
        [in_wav, Fs] = audioread(wav_filename);

        % for debugging purposes
%         ap = audioplayer(in_wav, 5000);
%         ap.play();

        % do any preprocessing
        [wav, Fs] = ta_preprocessing(in_wav, Fs);

        % we have the assumption that the sample rate is always 16000Hz
        assert(Fs == 16000, '@ta sample rate is not 16000 for file %s', wav_filename);
                
        % do mfcc conversion
        file_data = ta_mfcc(wav);
        
        % hold the mfcc data
        mfcc39{prompt_index} = file_data;
    end

    % put the data into the table
    self.mfcc39{speaker_index} = table(mfcc39);
end

end