function [NewOpticalSystem] =  OpticalSystem(fullFilePath)
    % Constructs a new Optical system object either from previously
    % saved file or empty
    if nargin < 1
        % default constructor with empty argument. By default it is
        % surface based so 3 surfaces are defined.
        tempSurfaceArray{1} = Surface();
        tempSurfaceArray{2} = Surface();
        tempSurfaceArray{3} = Surface();
        
        tempSurfaceArray{1}.IsObject = 1;
        tempSurfaceArray{2}.StopSurfaceIndex = 1;
        tempSurfaceArray{3}.IsImage = 1;
        
        % Cell array of surface or components as they apear in the system
        % defintion
        NewOpticalSystem.OpticalElementArray = tempSurfaceArray;
        
        NewOpticalSystem.SurfaceArray = [tempSurfaceArray{:}];
        NewOpticalSystem.ElementToSurfaceMap = [{1},{2},{3}];
        NewOpticalSystem.SurfaceToElementMap = [{1},{2},{3}];
        % Component array will be NaN for surface based defintion
        NewOpticalSystem.ComponentArray = Component();
        
        NewOpticalSystem.SystemApertureType = 1; % ENPD
        NewOpticalSystem.SystemApertureValue = 5;
        NewOpticalSystem.ComputeFastSemidiameter = 1;
        
        NewOpticalSystem.LensName = 'Lens 01';
        NewOpticalSystem.LensNote = 'No comment';
        NewOpticalSystem.WavelengthUnit = 2; %'um';
        NewOpticalSystem.LensUnit = 1; % mm
        NewOpticalSystem.WavelengthMatrix = [0.55 1];
        NewOpticalSystem.PrimaryWavelengthIndex = 1;
        NewOpticalSystem.FieldType = 2; %'Angle';
        NewOpticalSystem.FieldPointMatrix = [0 0 1];
        
        NewOpticalSystem.IsObjectAfocal = 0;
        NewOpticalSystem.IsImageAfocal = 0;
        NewOpticalSystem.IsObjectTelecenteric = 0;
        NewOpticalSystem.IsImageTelecenteric = 0;
        
        NewOpticalSystem.IsUpdatedSurfaceArray = 0;
        
        NewOpticalSystem.CoatingCataloguesList =  getAllObjectCatalogues('Coating');
        
        NewOpticalSystem.ApodizationType = 1; %'None';
        NewOpticalSystem.ApodizationParameters = '';
        
        NewOpticalSystem.FieldNormalization = 1; %'Rectangular';
        NewOpticalSystem.SystemMode = 'SEQ';
        NewOpticalSystem.GlassCataloguesList = getAllObjectCatalogues('Glass');
        NewOpticalSystem.SoftwareVersion = '';
    else
        % Open previously saved optical system from file
        if ~isempty(fullFilePath)
            % Determine weather the optical system is .mat file (Format
            % used by MatLightTracer) or .zmx (Zemax format).
            [pathstr,name,ext] = fileparts(fullFilePath);
            if strcmpi(ext,'.mat')
                load(fullFilePath);
                % load the object SavedOpticalSystem object to new optical
                % system
                NewOpticalSystem = SavedOpticalSystem;
            elseif strcmpi(ext,'.zmx')
                NewOpticalSystem = importZemaxFile (fullFilePath);
            else
                disp('Error:The file does not exist');
                NewOpticalSystem = OpticalSystem;
            end
        else
            disp('Error:The file does not exist');
            NewOpticalSystem = OpticalSystem;
        end
        
    end
    NewOpticalSystem.ClassName = 'OpticalSystem';
end

