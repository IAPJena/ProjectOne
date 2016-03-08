function [ fullName ] = createMatAGFCatalogue(glassCatalogueFullName,ask_replace,initialGlassArray )
    % createMatAGFCatalogue: Create a new Glass catalogue in matlab and intialize
    % empty array of glass struct.

	% <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
	%   Written By: Worku, Norman Girma  
	%   Advisor: Prof. Herbert Gross
	%	Optical System Design Research Group
	%   Institute of Applied Physics
	%   Friedrich-Schiller-University of Jena   
							 
	% <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
	% Date----------Modified By ---------Modification Detail--------Remark
	% July 28,2014   Worku, Norman G.     Original Version        
    
    objectType = 'Glass';
    objectCatalogueFullName = glassCatalogueFullName;
    initialObjectArray = initialGlassArray;
    [ fullName ] = createNewObjectCatalogue(objectType, objectCatalogueFullName,ask_replace,initialObjectArray );
    
    
    % Default values
    if nargin == 0
        % Put the new glass catalogue in the same folder as the function
        % importAGF.m
        defaultFileName = which ('importAGF.m');
        [pathstr,name,ext] = fileparts(defaultFileName);   
        glassCatalogueFullName = [pathstr,'\New_AGF.mat'];
        ask_replace = 'ask';
    elseif nargin == 1
        % If path string is not specified use the default path string
        if isempty(fileparts(glassCatalogueFullName))
            defaultFileName = which ('importAGF.m');
            [pathstr,name,ext] = fileparts(defaultFileName);   
            glassCatalogueFullName = [pathstr,'\',glassCatalogueFullName];
        end
        ask_replace = 'ask';
    end

    switch lower(ask_replace)
        case lower('ask')
            Ask = 1;
            Replace = 0;
        case lower('replace')
            Ask = 0;
            Replace = 1;
    end

    %check if the catalogue already exsit
    if exist(glassCatalogueFullName,'file')
        [pathstr,name,ext] = fileparts(glassCatalogueFullName);
        alternativeName = fullfile(pathstr,[name,'1',ext]);
        if Ask
            button = ...
                questdlg(strcat('There already exists a Glass catalogue named ', ...
                name, '. Do you want to create the catalogue with new name: ',...
                name, '1 ?'),'New Catalogue Name','Yes Save','No Replace','Yes Save');
            switch button
                case 'Yes Save'
                    newGlassCatalogueFullName = alternativeName;
                    fullName = createMatAGFCatalogue(newGlassCatalogueFullName );
                case 'No Replace'
                    % delete the exsisting and create anew one
                    delete(glassCatalogueFullName);
                    fullName = createMatAGFCatalogue(glassCatalogueFullName );
            end
        else
            % delete the exsisting and create anew one
            delete(glassCatalogueFullName);
            fullName = createMatAGFCatalogue(glassCatalogueFullName );
        end
    else
        ObjectArray = (struct...
            ('Name',{},'NMExtraData',{},'GlassType',{},'GlassComment',{},...
            'ExtraData',{},'CoefficientData',{},'ThermalData',{},...
            'OtherData',{},'LambdaData',{},'InternalTransmittance',{}));

        FileInfoStruct =  struct();   
        FileInfoStruct.Type = 'Glass';  
        FileInfoStruct.Date = fix(clock); % Clock = [YYYY MM DD HH MM SS]
        save(glassCatalogueFullName,'ObjectArray','FileInfoStruct');
        save(glassCatalogueFullName,'ObjectArray','FileInfoStruct','-append');
        fullName = glassCatalogueFullName;
    end
end

