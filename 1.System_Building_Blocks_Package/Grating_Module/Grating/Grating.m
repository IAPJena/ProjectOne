function newGratingRuling = Grating(type,order,uniqueParameters)
    % GratingRuling Struct:
    %
    %   Defines grating ruling attached to an optical surfaces. All ruling 
    %   types are defined using external functions and this class makes
    %   calls to the external functions to work with the grating ruling.
    %
    % Properties: - and Methods: -
    %
    % Example Calls:
    %
    % newGratingRuling = GratingRuling()
    %   Returns a default prallel plane grating ruling
    %
    % newGratingRuling = GratingRuling(type,order,uniqueParameters)
    %   Returns a new Grating Ruling struct with the given parameters (If
    %   the second parameter is omited then the default values will be used).
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Sep 17,2015   Worku, Norman G.     Original Version
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    if nargin < 1
        type = 1;%'ParallelPlaneGrating';
    end
        % If the type is given as string instead of number, then find the index
    % corresponding to the type string
    if ~isnumeric(type)
        supportedGratingTypes = GetSupportedGratingTypes();
        [isFound, foundAt] = ismember(type,supportedGratingTypes);
        if isFound
            type = foundAt;
        else
            disp(['Error: The grating type specified is not valid so the ',...
                'default ParallelPlaneGrating is used.']);
            type = 1;
        end
    end
    if nargin < 2
        order = 0;
    end
    if nargin < 3
        gratingRulingDefinitionHandle = str2func(GetSupportedGratingTypes(type));
        returnFlag = 1;
        [returnDataStruct] = gratingRulingDefinitionHandle(returnFlag);
        defaultParameters = returnDataStruct.DefaultUniqueParametersStruct;
        uniqueParameters = defaultParameters;
    end
    
    newGratingRuling.Type = type;
    newGratingRuling.DiffractionOrder = order;
    newGratingRuling.UniqueParameters = uniqueParameters;
    newGratingRuling.ClassName = 'Grating';
end
