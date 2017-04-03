function ta_latex = ta_latex_document_factory(filename_cellstr, varargin)
%TA_WRITE_LATEX_DOCUMENT Create a latex document containing all the files in filename_cellstr

p = inputParser;
p.addParameter('debug', false, @islogical)
p.parse(varargin{:});
pp = p.Results;

%% Create the document
latex = cellfun(@(x) sprintf('\\input{%s}', x), filename_cellstr, 'uni', false)';

% add header, footer    
latexHeader = {'\documentclass[a4paper,11pt]{IEEEtran}';'\usepackage[utf8]{inputenc}';'% allows for temporary adjustment of side margins';'\usepackage{chngpage}';'\begin{document}'};
latexFooter = {'\end{document}'};
latex = [latexHeader;latex;latexFooter];

% return member of LT class
ta_latex = TA_LATEX_TABLE('doc', latex);

% % for debug purposes
if pp.debug
    disp(char(latex));
end

end

