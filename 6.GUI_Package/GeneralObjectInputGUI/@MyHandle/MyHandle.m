classdef MyHandle < handle
    %MYHANDLE General class for defining variables passed by reference.
    
	properties
		Data
	end
	methods
		function h = MyHandle(data)
            h.Data = struct();
            if nargin == 0
                data = NaN;
            else
            end
		  h.Data.Value = data;
          h.Data.CurrentIndex = 1; % indicates the current index of 
                                   % multidimensional value matrix
          [objType,objValDisp] = getObjectTypeValueDisplay(data);
          h.Data.Type = objType{:};
          h.Data.Name = objType{:};
          h.Data.FixedSize = 1;
		end
	end
end

