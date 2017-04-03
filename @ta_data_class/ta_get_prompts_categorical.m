function target_prompts = ta_get_prompts_categorical(self, target_regex)
%% scan the data structure obj to find all prompts that match the regex
%    obj: the ta_data_class data structure
%    target_prompts: the phonemes that are being searched for in prompts
% output:
%    target_prompts: a list of all prompts that match the regex
%
% Note: We don't care about the structure of obj, just the prompts that match the target. So the goal is to stack all prompts then apply regex and prune

% get all prompts
stacked_prompts = cellfun(@(x) x.prompt, self.json_metadata, 'UniformOutput', false);

% reshape into a one-dimensional array
stacked_prompts = cat(1, stacked_prompts{:});

% discard non-unique
stacked_prompts = unique(stacked_prompts);

if exist('target_regex', 'var')
    % apply regex
    hVd_logical = ta_regex(stacked_prompts, target_regex);

    % discard non-unique
    target_prompts = stacked_prompts(hVd_logical);
else
    target_prompts = stacked_prompts;
end

% 
% categorical_target_prompts = categorical(target_regex);
% 
% %% marked_prompts is parallel to obj.json_metadata.prompts with T/F for whether it is included
% marked_prompts = cellfun(@(x) ismember(x.prompt, categorical_target_prompts), {obj.json_metadata}', 'UniformOutput', false);
% 
% % get a copy of the input
% out_obj = obj;
% 
% for h = 1:length(obj)
%     % add the logical array to the output table of tables
%     out_obj(h).json_metadata = [obj(h).json_metadata, table(marked_prompts{h})];
%     
%     % indicate the T/F for phoneme as 'marked_prompt'
%     out_obj(h).json_metadata.Properties.VariableNames = [obj(h).json_metadata.Properties.VariableNames, 'marked_prompt'];
% end

end
