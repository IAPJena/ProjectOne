function [ importedGlassArray, catalogueFullFileName ] = importAGFGlassCatalogue...
        (agfFullFileName,glassCatalogueFullFileName)
    % importAGFGlassCatalogue: importes glass catalogue from ANSI Glass File (AGF)
    % which is zemax format specified in agfFullFileName to a mat catalogue file
    % stored in glassCatalogueFullFileName
    % Inputs:
    %   (agfFullFileName,glassCatalogueFullFileName)
    % Outputs:
    %   [importedGlassArray, catalogueFullFileName].
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % July 28,2014   Worku, Norman G.     Original Version
    
    % Get the file name and path name of the AGF file
    if nargin == 0
        [FileName,PathName] = uigetfile('*.agf','Select AGF File');
        if ~isempty(FileName)&&~isempty(PathName) && ...
                ~isnumeric(FileName) && ~isnumeric(PathName)
            [pathstr,name,ext] = fileparts(FileName);
            [ glassCatalogueFullFileName ] = createNewObjectCatalogue('Glass', [pwd,'\Catalogue_Files\',name,'_AGF.mat']);
        else
            importedGlassArray = 0;
            return;
        end
    elseif nargin == 1
        [pathstr,name,ext] = fileparts(agfFullFileName);
        FileName = [name,ext];
        PathName = pathstr;
        [ glassCatalogueFullFileName ] = createNewObjectCatalogue('Glass', [pwd,'\Catalogue_Files\',name,'_AGF.mat']);
    else
        
    end
    
    if (FileName~=0) % FileName = 0 when no file is selected
        fullFileName = [PathName,'\',FileName];
        % convert unicode to ascii format running DOS command
        command = ['TYPE "',fullFileName,'">"temAsciiFile"'];
        status = dos(command);
        
        % read the input file
        inputAgfFile = fopen('temAsciiFile', 'r');
        glassCounter = 0;
        
        while ~feof(inputAgfFile)
            % read the next valid line
            currentLine = fgets(inputAgfFile);
            % read the line as space separated string
            currentLineArray = strread(currentLine,'%s');
            % The first element of the array is the 2 character AGF code
            agfCode = char(currentLineArray(1,:));
            switch upper(agfCode)
                case 'NM' % Name
                    ITcounter = 0;
                    if glassCounter ~= 0
                        % Add current newGlass to the catalogue and reset it
                        addObjectToObjectCatalogue('Glass', newGlass,...
                            glassCatalogueFullFileName,'replace' )
                    end
                    glassCounter = glassCounter + 1;
                    
                    glass_name = char(currentLineArray(2,:));
                    Dispersion_Formula_No = str2num(char(currentLineArray(3,:)));
                    MIL_No = str2num(char(currentLineArray(4,:)));
                    Nd = str2num(char(currentLineArray(5,:)));
                    Vd = str2num(char(currentLineArray(6,:)));
                    Exclude_Sub = str2num(char(currentLineArray(7,:)));
                    Status = str2num(char(currentLineArray(8,:)));
                    Melt_Freq = str2num(char(currentLineArray(9,:)));
                    
                    newGlass = Glass;
                    newGlass.Name = upper(glass_name);
                    
                    newGlass.Type = 'ZemaxFormula';
                    newGlass.UniqueParameters = struct();
                    newGlass.UniqueParameters.FormulaType = Dispersion_Formula_No;
                    newGlass.OtherData(6) = MIL_No;
                    newGlass.OtherData(7) = Nd;
                    newGlass.OtherData(8) = Vd;
                    newGlass.OtherData(5) = Exclude_Sub;
                    newGlass.OtherData(4) = Status;
                    newGlass.OtherData(3) = Melt_Freq;
                case 'GC' % Glass Comment
                    try
                        newGlass.Comment =  char(currentLineArray(2,:));
                    catch
                        newGlass.Comment =  '';
                    end
                case 'ED' % Extra data
                    TCE70 = str2num(char(currentLineArray(2,:)));
                    TCE300 = str2num(char(currentLineArray(3,:)));
                    Density = str2num(char(currentLineArray(4,:)));
                    dPgF = str2num(char(currentLineArray(5,:)));
                    Ignore_Thermal_Exp = str2num(char(currentLineArray(6,:)));
                    
                    newGlass.ThermalData(8) = TCE70;
                    newGlass.ThermalData(9) = TCE300;
                    newGlass.ThermalData(10) = Ignore_Thermal_Exp;
                    
                    newGlass.OtherData(2) = Density;
                    newGlass.OtherData(9) = dPgF;
                case 'CD' % Coefficient Data
                    coefficientData = (str2num(char((currentLineArray(2:11)))));
                    newGlass.UniqueParameters.CoefficientData = coefficientData ;
                case 'TD'
                    D0 = str2num(char(currentLineArray(2,:)));
                    D1 = str2num(char(currentLineArray(3,:)));
                    D2 = str2num(char(currentLineArray(4,:)));
                    E0 = str2num(char(currentLineArray(5,:)));
                    E1 = str2num(char(currentLineArray(6,:)));
                    Ltk = str2num(char(currentLineArray(7,:)));
                    Temp = str2num(char(currentLineArray(8,:)));
                    
                    newGlass.ThermalData(1) = D0;
                    newGlass.ThermalData(2) = D1;
                    newGlass.ThermalData(3) = D2;
                    newGlass.ThermalData(4) = E0;
                    newGlass.ThermalData(5) = E1;
                    newGlass.ThermalData(6) = Ltk;
                    newGlass.ThermalData(7) = Temp;
                    
%                     newGlass.ThermalData = [D0,D1,D2,E0,E1,Ltk,Temp];
                case 'OD'
                    Rel_Cost = str2num(char(currentLineArray(2,:)));
                    CR = str2num(char(currentLineArray(3,:)));
                    FR = str2num(char(currentLineArray(4,:)));
                    SR = str2num(char(currentLineArray(5,:)));
                    AR = str2num(char(currentLineArray(6,:)));
                    PR = str2num(char(currentLineArray(7,:)));
                    
                    newGlass.OtherData(1) = Rel_Cost;
                    newGlass.ResistanceData(1) = CR;
                    newGlass.ResistanceData(2) = FR;
                    newGlass.ResistanceData(3) = SR;
                    newGlass.ResistanceData(4) = AR;
                    newGlass.ResistanceData(5) = PR;
                case 'LD'
                    Min_Lambda = str2num(char(currentLineArray(2,:)));
                    Max_Lambda = str2num(char(currentLineArray(3,:)));
                    
                    newGlass.WavelengthRange(1) = Min_Lambda;
                    newGlass.WavelengthRange(2) = Max_Lambda;
                case 'IT'
                    ITcounter = ITcounter + 1;
                    Lambda = str2num(char(currentLineArray(2,:)));
                    Transmission = str2num(char(currentLineArray(3,:)));
                    Thickness = str2num(char(currentLineArray(4,:)));
                    
                    newGlass.InternalTransmittance(ITcounter,:) = [Lambda,Transmission,Thickness];
                otherwise
                    % Do nothing just ignoring all other glass properties
            end
        end
        %load the glass catalogue file and return object arrray which is the glass array
        load(glassCatalogueFullFileName,'ObjectArray','FileInfoStruct');
        importedGlassArray = ObjectArray;
        catalogueFullFileName = glassCatalogueFullFileName;
    else
        catalogueFullFileName = '';
        importedGlassArray = 0;
        return;
    end
    
