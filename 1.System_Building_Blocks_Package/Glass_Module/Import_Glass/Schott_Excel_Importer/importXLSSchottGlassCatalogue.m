function [ importedGlassArray,catalogueFullFileName ] = ...
        importXLSSchottGlassCatalogue( xlsFullFileName,glassCatalogueFullFileName )
    % importXlsSchottGlassCatalogue : Read glass datanfrom excel sheet downloaded from Schott website
    % Inputs:
    %   (xlsFullFileName,glassCatalogueFullFileName)
    % Outputs:
    %   [importedGlassArray,catalogueFullFileName]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 17,2015   Worku, Norman G.     Original Version
    
    if nargin == 0
        [FileName,PathName] = uigetfile('*.xls','Select Glasss Catalogue File');
        if ~isempty(FileName)&&~isempty(PathName) && ...
                ~isnumeric(FileName) && ~isnumeric(PathName)
            [pathstr,name,ext] = fileparts(FileName);
            glassCatalogueFullFileName = addNewGlassCatalogue(myParent,[name,'_XLS']);
        else
            importedGlassArray = 0;
            return;
        end
    elseif nargin == 1
        [pathstr,name,ext] = fileparts(xlsFullFileName);
        FileName = [name,'.',ext];
        PathName = pathstr;
        glassCatalogueFullFileName = addNewGlassCatalogue(myParent,[name,'_XLS']);
    else
        
    end
    
    if (FileName~=0) % FileName=0 when no file is selected
        % 'G:\MSc Photonics 2st Semster Docs\OOP version of Basic Ray Tracer\...
        % Ray Tracer Toolbox 2.1 (OOP Version)\DatabaseFiles\...
        % schott_optical_glass_catalogue_excel_april_2013.xls';
        fullFileName = [PathName,'\',FileName];
        [~,~,alldata]  = xlsread(fullFileName,'A5:L200');
        tableSize = size(alldata);
        
        %add each glass to the catalogue
        for kk = 1:tableSize(1)
            name = cell2mat(alldata(kk,1));
            if isnan(name)
                break;
            end
            glassName = num2str(name);
            glassType = 'ZemaxFormula';
            formulaType = 'Sellmeier1';
            % NB: The order of the coefficients in the xls doc
            coefficientData = ...
                [cell2mat(alldata(kk,7)),cell2mat(alldata(kk,9)),...
                cell2mat(alldata(kk,11)),cell2mat(alldata(kk,8)),...
                cell2mat(alldata(kk,10)),cell2mat(alldata(kk,12))]';
            % Zero padding to make the glassParameters [10,N]
            coefficientData = [coefficientData;zeros(4,size(coefficientData,2))];
            
            glassParameters = struct();
            glassParameters.FormulaType = formulaType;
            glassParameters.CoefficientData = coefficientData;
            glassParameters.ReferenceWavelength = 0.55*10^-6;

            newGlass = Glass(glassName,'All',glassType,glassParameters);
            addObjectToMLTObjectCatalogue...
                ('glass', newGlass,glassCatalogueFullFileName,'replace' );
        end
        %load the glass catalogue file and return object arrray which is the glass array
        load(glassCatalogueFullFileName,'ObjectArray','FileInfoStruct');
        importedGlassArray = ObjectArray;
        catalogueFullFileName = glassCatalogueFullFileName;
    else
        importedGlassArray = 0;
        catalogueFullFileName = '';
        return;
    end
end

