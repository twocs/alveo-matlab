function [ Train_indices, Test_indices ] = ta_crossval__one_left_out___indices( self )
%TA_CROSSVAL Produces the train and test datasets
%   Leaving speakers out of the test set.
%   Returns indices because when we return data it gets too big!


% get cell array of gender
groups = self.ta_get_gender_cell();

% smallest group in cell array
N = min(cell2mat(cellfun(@(x) sum(strcmp(groups, x)), unique(groups), 'uni', false)));


[Train_indices, Test_indices] = crossvalind('HoldOut', groups, 1/N);