classdef TA_LATEX_TABLE
    %LATEX_TABLE Summary of this class goes here
    %   Class wrapper for latexTable method
    %   This wrapper is by Tom Anderson
    
    properties
        % the document
        doc
    end
    
    methods(Static)
        latex = latexTable(input);
        ta_latex = ta_latex_factory(data, varargin)
        ta_latex = ta_latex_document_factory(filename_cellstr)
    end
    
    methods
        % contructor 
        function self = TA_LATEX_TABLE(input, input2)
            if isa(input, 'char') && strcmp(input, 'doc')
                self.doc = input2;
            else
                self.doc = TA_LATEX_TABLE.latexTable(input);
            end
        end
        
        filename = write(self, filename)
    end
end

