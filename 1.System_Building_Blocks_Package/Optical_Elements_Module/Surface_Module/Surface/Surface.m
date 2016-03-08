function NewSurface = Surface(surfType)
    % Surface Struct:
    %
    %   Defines surfaces of optical interfaces. All surfaces
    %   types are defined using external functions and this class makes
    %   calls to the external functions to work with the surfaces.
    %
    % Properties: 3 and Methods: 12
    %
    % Example Calls:
    %
    % newSurface = Surface()
    %   Returns a default STANDARD plane surface with air afterwards.
    %
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Oct 14,2013   Worku, Norman G.     Original Version       Version 3.0
    % Jun 17,2015   Worku, Norman G.     Make Aperture as objects
    
    % <<<<<<<<<<<<<<<<<<<<< Main Code Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    if nargin == 0
        % Make single surface component by default
        surfType = 1; %'Standard';
    end
    % If the type is given as string instead of number, then find the index
    % corresponding to the type string
    if ~isnumeric(surfType)
        supportedSurfaceTypes = GetSupportedSurfaceTypes();
        [isFound, foundAt] = ismember(surfType,supportedSurfaceTypes);
        if isFound
            surfType = foundAt;
        else
            disp(['Error: The surface type specified is not valid so the ',...
                'default Standard is used.']);
            surfType = 1;
        end
    end
    NewSurface.Comment = '';
    NewSurface.Type = surfType;
    NewSurface.Thickness = 10;
    NewSurface.Glass = Glass();
    NewSurface.Coating = Coating();
    NewSurface.Radius = Inf;
    NewSurface.Conic = 0;
    
    [fieldNames,fieldDisplayNames,fieldFormat,defaultUniqueParamStruct] = getSurfaceUniqueParameters(surfType);
    NewSurface.UniqueParameters = defaultUniqueParamStruct;
    
    NewSurface.ExtraData  = [];
    
    NewSurface.Aperture = Aperture();
    
    NewSurface.Grating = Grating();
    
    NewSurface.TiltDecenterOrder = 1; %{'Dx','Dy','Dz','Tx','Ty','Tz'};
    NewSurface.Tilt = [0 0 0];
    NewSurface.Decenter = [0 0];
    NewSurface.TiltMode = 1; %'DAR';
    
    % TM = transformation Matrix
    NewSurface.SurfaceCoordinateTM = ...
        [1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1];
    NewSurface.ReferenceCoordinateTM = ...
        [1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1];
    
    NewSurface.GlassBefore  = Glass();
    NewSurface.SurfaceColor = '';
    
    NewSurface.StopSurfaceIndex = 0;
    
    NewSurface.IsObject = 0;
    NewSurface.IsImage = 0;
%     NewSurface.IsStop = 0;
    NewSurface.IsHidden = 0;
    NewSurface.IsIgnored = 0;
    
    NewSurface.ClassName = 'Surface';
end