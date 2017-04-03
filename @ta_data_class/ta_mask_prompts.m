function out_obj = ta_get_prompts(obj, target_prompts)
%% 
%    obj: the json data structure for each participant
%    target_prompts: the phonemes that are being searched for in prompts
% output:
%    marked_prompts: a logical array with parallel structure to the obj input that indicates each phoneme
categorical_target_prompts = categorical(target_prompts);

%% marked_prompts is parallel to obj.json_table.prompts with T/F for whether it is included
marked_prompts = cellfun(@(x) ismember(x.prompt, categorical_target_prompts), {obj.json_table}', 'UniformOutput', false);

% get a copy of the input
out_obj = obj;

for h = 1:length(obj)
    % add the logical array to the output table of tables
    out_obj(h).json_table = [obj(h).json_table, table(marked_prompts{h})];
    
    % indicate the T/F for phoneme as 'marked_prompt'
    out_obj(h).json_table.Properties.VariableNames = [obj(h).json_table.Properties.VariableNames, 'marked_prompt'];
end

end
