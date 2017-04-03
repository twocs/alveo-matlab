function [ train_data, test_data ] = ta_crossval( self, K )
%TA_CROSSVAL Produces the train and test datasets
%   K: the percentage of the dataset to hold out

train_indices = cell(self.ta_length(), 1);
test_indices = cell(self.ta_length(), 1);

for speaker = 1:self.ta_length()
    N = height( self.mfcc39{speaker} );
   [train_indices{speaker}, test_indices{speaker}]= crossvalind('holdout', N, K);
end

train_data = self.ta_subset(train_indices);
test_data =self.ta_subset(test_indices);

end

