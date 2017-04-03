function sData = ta_get_som_data_struct(self, varargin)
%% unwraps the struct data to create an sData 

% optional input:
%   name: the name given to the SOM data structure
%   label: boolean, if the SOM data structure is to be labelled
%   normalise: boolean, if the data to be returned should be normalised
% output:
%   sData: som_data_struct

%% parse input
p = inputParser; % check input
p.FunctionName = 'TA_GET_SOM_DATA_STRUCT'; % used to describe errors
p.addRequired('self');
p.addParameter('name', '@ta', @ischar); % the name given to the SOM data structure
p.addParameter('label', false, @islogical); % if the SOM data structure is labelled
p.addParameter('normalise', false); % if the data to be returned should be normalised
p.parse(self, varargin{:});
pp = p.Results;

%% if labelled or unlabelled data is to be returned
if pp.label
    % reshape the data into a single table of data
    [mfcc39_data, label_data] = self.ta_stack_mfcc39('labels');
    sData = som_data_struct(mfcc39_data, 'name', p.Results.name, 'labels', label_data);
    if iscell(pp.normalise) || isstruct(pp.normalise) || ischar(pp.normalise) || islogical(pp.normalise) && pp.normalise
        sData = som_normalize(sData, pp.normalise);
    end
else
    % reshape the data into a single table of data
    mfcc39_data = self.ta_stack_mfcc39('mfcc39');
    sData = som_data_struct(mfcc39_data, 'name', p.Results.name);
    if isstruct(pp.normalise)
        sData = som_normalize(sData, pp.normalise);
    elseif islogical(pp.normalise) 
        if pp.normalise
            sData = som_normalize(sData, 'var');
        end
        % if pp.normalise is false, don't normalise
    elseif ischar(pp.normalise)
        sData = som_normalize(sData, pp.normalise);
    else
        error('Normalisation undefined')
    end
end

end