function [objType,objValDisp] = getObjectTypeValueDisplay(currentObject)
    if isnumeric(currentObject) || islogical(currentObject)
        objType = 'Numeric';
%         if (ndims(currentObject) == 2)
%             objType = 'Numeric2D';
%         elseif (ndims(currentObject) == 3)
%             objType = 'Numeric3D';
%         else
%             objType = 'NumericXD';
%         end
        if (length(currentObject) == 1)
            objValDisp = num2str(currentObject(1));
        elseif (length(currentObject) <= 3)
            objValDisp = '';
            for k = 1:length(currentObject)
                objValDisp = strcat(objValDisp, num2str(currentObject(k)),'; ');
            end
        else
            objValDisp = '';
            for k = 1:3
                objValDisp = strcat(objValDisp, num2str(currentObject(k)),'; ');
            end
            objValDisp = strcat(objValDisp, ' ... ');
        end
        
%     elseif islogical(currentObject)
%         if (ndims(currentObject) == 2)
%             objType = 'Logical2D';
%         elseif (ndims(currentObject) == 3)
%             objType = 'Logical3D';
%         else
%             objType = 'LogicalXD';
%         end
%         if (length(currentObject) == 1)
%             objValDisp = num2str(currentObject(1));
%         elseif (length(currentObject) <= 3)
%             objValDisp = '';
%             for k = 1:length(currentObject)
%                 objValDisp = strcat(objValDisp, num2str(currentObject(k)),'; ');
%             end
%         else
%             objValDisp = '';
%             for k = 1:3
%                 objValDisp = strcat(objValDisp, num2str(currentObject(k)),'; ');
%             end
%             objValDisp = objValDisp + ' ... ';
%         end
        
%      elseif ischar(currentObject)
%         objType = 'String';
%         objValDisp = 'String';
%         
%         objType = 'Char';
%         if (length(currentObject) == 1)
%             objValDisp = (currentObject(1));
%         elseif (length(currentObject) <= 10)
%             objValDisp = '';
%             for k = 1:length(currentObject)
%                 objValDisp = strcat(objValDisp,(currentObject(k)));
%             end
%         else
%             objValDisp = '';
%             for k = 1:10
%                 objValDisp = strcat(objValDisp,(currentObject(k)));
%             end
%             objValDisp = strcat(objValDisp,' ... ');
%         end
%         
    elseif iscell(currentObject) || ischar(currentObject)
        % Cells are used to hold strings
        objType = 'String';
        if iscell(currentObject)
            objValDisp = currentObject(1);
        else
            objValDisp = currentObject;
        end
        
        


%         
%         if (ndims(currentObject) == 2)
% %             objType = 'Char2D';
%             objValDisp = 'Char2D';
%         elseif (ndims(currentObject) == 3)
% %             objType = 'Char3D';
%             objValDisp = 'Char3D';
%         else
% %             objType = 'CharXD';
%             objValDisp = 'CharXD';
%         end
    elseif isstruct(currentObject)
            objType = 'Struct';
            objValDisp = 'Struct';
            
%         if (ndims(currentObject) == 2)
%             objType = 'Struct2D';
%             objValDisp = 'Struct2D';
%         elseif (ndims(currentObject) == 3)
%             objType = 'Struct3D';
%             objValDisp = 'Struct3D';
%         else
%             objType = 'StructXD';
%             objValDisp = 'StructXD';
%         end
    else
        % custom class objects defined in this toolbox
             objType = (class(currentObject));
            objValDisp = (class(currentObject));
            
%         if (ndims(currentObject) == 2)
%             objType = strcat(class(currentObject),'2D');
%             objValDisp = strcat(class(currentObject),'2D');
%         elseif (ndims(currentObject) == 3)
%             objType = strcat(class(currentObject),'3D');
%             objValDisp = strcat(class(currentObject),'3D');
%         else
%             objType = strcat(class(currentObject),'XD');
%             objValDisp = strcat(class(currentObject),'XD');
%         end
    end
    objType = {objType};
    objValDisp = {objValDisp};
end