function ta_praat_textgrid_to_mfcc39_label(self, varargin)

p = inputParser;
p.addParameter('sampa_to_ipa', true, @islogical); % convert labels from sampa to ipa
p.parse(varargin{:});
pp = p.Results;
if pp.sampa_to_ipa
    sampa_to_ipa = ta_data_class.ta_SAMPA_to_IPA();
end
if ~self.ta_has_textgrid
    error('@ta The dataclass does not have a textgrid');
end

% iterate through each row of the input struct
for speaker_index = 1:self.ta_length()
    % add a column for the label data
  
    % get the textgrids
    current_speaker_textgrid = self.textgrid{speaker_index}.praat_textgrid;
    current_speaker_mfcc39_data = self.mfcc39{speaker_index}.mfcc39;
    
    % holding the data from the new labels
    mfcc39_labels = cell(length(current_speaker_mfcc39_data), 1);
    
    % iterate through each textgrid
    for index = 1:size(current_speaker_textgrid, 1)
        
        % do not process non-data
        if current_speaker_textgrid(index).size == 0
            continue
        end
        
        % get the interval table for the current utterance
        current_intervals = current_speaker_textgrid(index).get_interval();
        
        % create a temp data holder
        labels = repmat({''}, size(current_speaker_mfcc39_data{index},1), 1);
        
        % iterate through each label and put it in an array corresponding to the mfcc39 windows
        for interval_index=1:height(current_intervals)
            current_interval = current_intervals(interval_index, :);
            if pp.sampa_to_ipa
                labels(floor(current_interval.xmin*100) + 1:end) = {sampa_to_ipa(current_interval.text{:})};
            else
                labels(floor(current_interval.xmin*100) + 1:end) = {current_interval.text{:}};
            end
        end
        
        mfcc39_labels(index) = {labels};
    end
    
    % add the labels next to the mfcc39 data
    self.mfcc39{speaker_index}.labels = mfcc39_labels;
end

end