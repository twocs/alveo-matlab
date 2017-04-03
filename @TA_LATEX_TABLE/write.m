function [ name_cellstr ] = write( self, name_str )
% WRITE takes an LT object writes the document self.doc with the filename specified
% Output: status of the file
% Written by Tom Anderson
    fid = fopen(name_str, 'wt', 'n', 'UTF-8');
    cellfun(@(x) fprintf(fid, '%s\n', x), self.doc);
    status = fclose(fid);
    assert(status == 0, '@ta file %s did not write or close properly', name_str);
    name_cellstr = {name_str};
end

