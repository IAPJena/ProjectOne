function [ objectDisplayTable, fieldsExist ] = getObjectDisplayTable( myHandles)
    % returns the field name- field type and value table
    % for all fields of the class(struct) or the 2D or 3D matrix of values for
    % classes with no fields (Numeric,Logical,char)
    
%     currentObject = get(myHandles.Value,'UserData');
%     fixedSize = get(myHandles.FixedSize,'UserData');

    currentObject = myHandles.Data.Value;
    fixedSize = myHandles.Data.FixedSize;
    
    [objType,objValDisp] = getObjectTypeValueDisplay(currentObject);
    switch lower(objType{1})
        case {lower('Numeric'), lower('String')}
            [dim1,dim2,dim3,dim4] = size(currentObject);
            objectDisplayTable = cell(dim1,dim2,dim3);
            for k=1:dim3
            if dim4 > 1
                disp('Error: More than 3D matrices can not be displayed.');
                return;
            else
                if strcmpi(objType{1},'String')
%                     objectDisplayTable = cell(1,1,1);
%                     objectDisplayTable{1,1,k} = (currentObject(:,:,k));
                    if ischar(currentObject)
                        objectDisplayTable = cell(1,1,1);
                      objectDisplayTable{1,1,k} = (currentObject(:,:,k));
                    else
                    objectDisplayTable{:,:,k} = (currentObject(:,:,k));
                    end
                else
                    objectDisplayTable(:,:,k) = num2cell(currentObject(:,:,k));
                end
             end
            end
            fieldsExist = 0;
        otherwise
            % if the object is not fixed then display its name only
            if sum(~fixedSize)
                
                [dim1,dim2,dim3,dim4] = size(currentObject);
%                 for k = 1:dim3
                if dim4 > 1
                    disp('Error: More than 3D matrices can not be displayed.');
                    return;
                else
                    [objType,objValDisp] = getObjectTypeValueDisplay(currentObject());
                    objectDisplayTable = cell(dim1,dim2,dim3);
                    
                    objectDisplayTable(:)  = objType;
                    fieldsExist = 0;
                end
%                 end
            else % determine the fields of the object
                allFieldNames = fieldnames(currentObject);
                tempFieldName_Type_Value_Table = cell(length(allFieldNames),3);
                for k = 1:length(allFieldNames)
                    fieldName = allFieldNames(k);
                    fieldValue = currentObject.(allFieldNames{k});
                    [fieldType,fieldValueDisp] = getObjectTypeValueDisplay(fieldValue);
                    
                    tempFieldName_Type_Value_Table(k,1) = fieldName;
                    tempFieldName_Type_Value_Table(k,2) = fieldType;
                    tempFieldName_Type_Value_Table(k,3) = fieldValueDisp;
                end
                objectDisplayTable =   tempFieldName_Type_Value_Table;
                fieldsExist = 1;
            end
    end
end

