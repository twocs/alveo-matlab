classdef ta_praat_textgrid
%ta_read_textgrid Read a Praat TextGrid
% input:
%    filename: the name of the Praat textgrid
% output:
%    textgrid_table: a table containing the data from the Praat textgrid

properties
    file_type
    object_class
    
    % start of the file in seconds
    xmin
    
    % end of the file in seconds
    xmax
    tiers
    
    % number of items
    size
    
    % the data structure, consists of 3 cells of data named ORT, OBJ and MAU
    items
end

methods

    function return_value = ta_textscan_1(~, fid, search_string)
        % input:
        %    fid: file id of open file for reading with textscan
        %    search_string: a string containing the text for scanning
        %         e.g. 'File type = %q', where q is a string inside quotes like "ooTextFile"

        % read one line of file
        return_value = textscan(fid, search_string, 1);

        % unwrap cells
        while ~isempty(return_value) && iscell(return_value)
            return_value = return_value{:};
        end

    end
    
    %% return a table of the labels and timings
    function interval = get_interval(self)
        if self.size == 0 % manual annotation does not exist
            interval = [];
        else
            interval = self.items{3}.interval;
        end
    end
    
    %% return a list of all labels used in the annotation
    function all_labels = get_all_labels(self)
        if self.size == 0
            all_labels = {};
        else
           all_labels = self.items{3}.interval.text;
        end
    end
    
    %% reading in the data
    % create the lowest level structure
    function obj = ta_praat_textgrid(filename)
        
        % if no filename, just return an empty obj 
        if nargin == 0
            obj.size = 0;
            return
        end
        
        %% initialise the object with data from a TextGrid file
        fid = fopen(filename, 'r');
        
        % get data, line by line
        obj.file_type = obj.ta_textscan_1(fid, 'File type = %q');
        obj.object_class = obj.ta_textscan_1(fid, 'Object class = %q');
        obj.xmin= obj.ta_textscan_1(fid, 'xmin = %f');
        obj.xmax= obj.ta_textscan_1(fid, 'xmax = %f');
        obj.tiers = obj.ta_textscan_1(fid, 'tiers? %q');
        obj.size = obj.ta_textscan_1(fid, 'size = %d');

        obj.items = obj.ta_items(fid);

        % close the file
        fclose(fid);
    end
    
    % read in the items
    function items = ta_items(obj, fid)
        items = cell(obj.size, 1);

        % read in unneeded Praat file structural information 
        obj.ta_textscan_1(fid, 'item []:');

        % read in the (three) intervals
        for current_item_index=1:obj.size
            items{current_item_index} = obj.ta_interval(fid);
        end
    end
    
    % read in the intervals
    function current_item = ta_interval(obj, fid)
            % read in unneeded structural information 
            % note: the value of %f here is the same as the index i
            obj.ta_textscan_1(fid, 'item [%f]:');

            current_item.class = obj.ta_textscan_1(fid, 'class = %q');
            current_item.name = obj.ta_textscan_1(fid, 'name = %q');
            current_item.xmin= obj.ta_textscan_1(fid, 'xmin = %f');
            current_item.xmax= obj.ta_textscan_1(fid, 'xmax = %f');
            current_item.intervals_size = obj.ta_textscan_1(fid, 'intervals: size = %f');
            current_item.interval = cell(current_item.intervals_size, 1);
            for interval_index = 1:current_item.intervals_size
                current_interval = struct();

                % read in unneeded structural information 
                % note: the value of %f here is the same as interval_index
                obj.ta_textscan_1(fid, 'intervals [%f]:');

                current_interval.xmin= obj.ta_textscan_1(fid, 'xmin = %f');
                current_interval.xmax= obj.ta_textscan_1(fid, 'xmax = %f');
                current_interval.text = obj.ta_textscan_1(fid, 'text = %q');

                current_item.interval{interval_index} = current_interval;
            end
            current_item.interval = struct2table([current_item.interval{:}]);
    end
end

end