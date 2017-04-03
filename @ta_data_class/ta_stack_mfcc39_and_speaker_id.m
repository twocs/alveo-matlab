function [mfcc39_stack, speaker_id_stack, prompt_stack] = ta_stack_mfcc39_and_speaker_id(self)
%% we need to unwrap the data (flatten the data structure) so it can be used to train the SOM

[~, speaker_id_stack] = self.ta_stack_mfcc39('speaker_id');
mfcc39_stack = self.ta_stack_mfcc39('mfcc39');
prompt_stack = []; % self.ta_stack_mfcc39  %TODO??

end