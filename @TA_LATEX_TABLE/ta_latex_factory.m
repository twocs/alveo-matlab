function ta_latex = ta_latex_factory(data, varargin)
% Factory method for creating latex table
% Input:
%     data: A table of data
% Output:
%     A cellstr of latex data
% by Tom Anderson

p = inputParser;
p.KeepUnmatched = true;

% this field has to be a matrix or MATLAB table datatype
p.addRequired('data', @istable);
p.parse(data, varargin{:});

% create a struct for latex table generation
input.data = data;

pU = p.Unmatched;

% reflection on all properties in Unmatched get put into input
props = fields(pU);
for prop_index= 1:size(props,1)
    prop = props{prop_index};
    input.(prop) =pU.(prop);
end

% create an object using latexTable based on input
ta_latex = TA_LATEX_TABLE(input);