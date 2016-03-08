 function displaySurfaceData(optSystem,dispStandard,dispAperture,...
         dispCoating,dispAspheric,dispTiltDecenter)
     % Displays the surface properties of an optical system 
     % Inputs: Flags indicating which data to display
     if nargin == 1
         dispStandard = 1;
         dispAperture = 1;
         dispCoating = 1;
         dispAspheric = 1;
         dispTiltDecenter = 1;
     elseif nargin == 2
         dispAperture = 1;
         dispCoating = 1;
         dispAspheric = 1;
         dispTiltDecenter = 1;             
     elseif nargin == 3
         dispCoating = 1;
         dispAspheric = 1;
         dispTiltDecenter = 1;             
     elseif nargin == 4
         dispAspheric = 1;
         dispTiltDecenter = 1;             
     elseif nargin == 5
         dispTiltDecenter = 1;             
     elseif nargin == 6

     end         
    disp('************************************************************');
    disp('Optical System Surface Data'); 
    disp(['Total Number of Surface : ' num2str(optSystem.NumberOfSurfaces)]); 
    disp('************************************************************');
    if dispStandard             
        Standard_Data = {'Index' 'Type' 'Radius' 'Thickness' 'Glass'... 
        'Deviation Mode' 'SemiDiameter';'------' '-----' '------'... 
        '----------' '------' '--------------'  '------------'};
        for k=1:1:optSystem.NumberOfSurfaces
            Index = k;
            if optSystem.getSurfaceArray(k).ObjectSurface
                Index = 'OBJECT ';
            end
            if optSystem.getSurfaceArray(k).ImageSurface
                Index = 'IMAGE ';
            end
            if optSystem.getSurfaceArray(k).Stop
                Index = 'STOP';
            end    

            Type = optSystem.getSurfaceArray(k).Type;
            Radius = (optSystem.getSurfaceArray(k).Radius);
            Thickness = (optSystem.getSurfaceArray(k).Thickness);
            Glass = (optSystem.getSurfaceArray(k).Glass.Name);
            Deviation_Mode = optSystem.getSurfaceArray(k).DeviationMode;
            SemiDiameter =  (optSystem.getSurfaceArray(k).SemiDiameter);
            currentRow={Index  Type Radius  Thickness Glass Deviation_Mode SemiDiameter};
            Standard_Data = [Standard_Data; currentRow];
        end
         Standard_Data
    end
    if dispAperture 
        Aperture_Data = {'Index' 'Type' 'Aper Type' 'Aper Param1'...
            'Aper Param2' 'Aper DecentX' 'Aper DecentY';
            '-----' '----' '---------' '-----------'...
            '-----------' '------------' '-----------'}; 
    for k=1:1:optSystem.NumberOfSurfaces
        Index = k;
        if optSystem.getSurfaceArray(k).ObjectSurface
            Index = 'OBJECT ';
        end
        if optSystem.getSurfaceArray(k).ImageSurface
            Index = 'IMAGE ';
        end
        if optSystem.getSurfaceArray(k).Stop
            Index = 'STOP';
        end                 
        Type = optSystem.getSurfaceArray(k).Type;
        Aperture_Type = (optSystem.getSurfaceArray(k).ApertureType);
        Aperture_Param1 = (optSystem.getSurfaceArray(k).ApertureParameter(1));
        Aperture_Param2 = (optSystem.getSurfaceArray(k).ApertureParameter(2));

        Aperture_DecentX = (optSystem.getSurfaceArray(k).ApertureParameter(3));
        Aperture_DecentY = (optSystem.getSurfaceArray(k).ApertureParameter(4));
        currentRow = {Index  Type  Aperture_Type  Aperture_Param1  Aperture_Param2... 
        Aperture_DecentX  Aperture_DecentY};  
        Aperture_Data = [Aperture_Data;currentRow];
    end
    Aperture_Data
    end
    if dispCoating 
        Coating_Data = {'Index' 'Type' 'Coating Type' 'Name' 'Param2'... 
        'Param3' 'Param4';'-----' '----' '----------' '------' '------'...
        '------' '------'};
     for k=1:1:optSystem.NumberOfSurfaces
        Index = k;
        if optSystem.getSurfaceArray(k).ObjectSurface
            Index = 'OBJECT ';
        end
        if optSystem.getSurfaceArray(k).ImageSurface
            Index = 'IMAGE ';
        end
        if optSystem.getSurfaceArray(k).Stop
            Index = 'STOP';
        end             
        Type = optSystem.getSurfaceArray(k).Type;
        Coating_Type = optSystem.getSurfaceArray(k).Coating.Type;
        Param1 = optSystem.getSurfaceArray(k).Coating.Name;
        Param2 =  '--';
        Param3 = '--';
        Param4 = '--';
        currentRow = {Index  Type  Coating_Type  Param1  Param2 Param3  Param4};
        Coating_Data = [Coating_Data;currentRow];
     end
     Coating_Data
    end
    if dispAspheric 
        Aspheric_Data = {'Index' 'Type' 'Conic' 'A1' 'A2' 'A3' 'A4'... 
        'A5' 'A6' 'A7' 'A8' 'A9' 'A10' 'A11' 'A12';'-----' '----' '-----'...
        '----' '----' '----' '----' '----' '----' '----' '----'...
        '----' '----' '----' '----'};  
     for k=1:1:optSystem.NumberOfSurfaces
        Index = k;
        if optSystem.getSurfaceArray(k).ObjectSurface
            Index = 'OBJECT ';
        end
        if optSystem.getSurfaceArray(k).ImageSurface
            Index = 'IMAGE ';
        end
        if optSystem.getSurfaceArray(k).Stop
            Index = 'STOP';
        end              
        Type = optSystem.getSurfaceArray(k).Type;
        Conic = (optSystem.getSurfaceArray(k).ConicConstant);
        coeff = optSystem.getSurfaceArray(k).PloynomialCoefficients;
        A1 = (coeff(1));A2 = (coeff(2));A3 = (coeff(3));A4 = (coeff(4));
        A5 = (coeff(5));A6 = (coeff(6));A7 =(coeff(7));A8 = (coeff(8));
        A9 = (coeff(9));A10 = (coeff(10));A11 = (coeff(11));A12 = (coeff(12));
        currentRow = {Index Type Conic  A1 A2 A3  A4 A5 A6 A7 A8 A9 A10 A11 A12 };            
        Aspheric_Data = [Aspheric_Data;currentRow];
     end
     Aspheric_Data
    end
    if dispTiltDecenter 
        Tilt_and_Decenter_Data = {'Index' 'Type' 'Order' 'Decent X' 'Decent Y'... 
        'Tilt X' 'Tilt Y' 'Tilt Z';'-----' '----' '----' '--------' '--------'...
        '--------' '--------' '--------'};   
     for k=1:1:optSystem.NumberOfSurfaces
        Index = k;
        if optSystem.getSurfaceArray(k).ObjectSurface
            Index = 'OBJECT ';
        end
        if optSystem.getSurfaceArray(k).ImageSurface
            Index = 'IMAGE ';
        end
        if optSystem.getSurfaceArray(k).Stop
            Index = 'STOP';
        end              
        Type = optSystem.getSurfaceArray(k).Type; 
        Order = optSystem.getSurfaceArray(k).TiltDecenterOrder;
        Decent_X = num2str(optSystem.getSurfaceArray(k).DecenterParameter(1));
        Decent_Y = num2str(optSystem.getSurfaceArray(k).DecenterParameter(2));
        Tilt_X = num2str(optSystem.getSurfaceArray(k).TiltParameter(1));
        Tilt_Y = num2str(optSystem.getSurfaceArray(k).TiltParameter(2));
        Tilt_Z = num2str(optSystem.getSurfaceArray(k).TiltParameter(3));
        currentRow = {Index Type Order Decent_X  Decent_Y Tilt_X Tilt_Y  Tilt_Z};                         
        Tilt_and_Decenter_Data = [Tilt_and_Decenter_Data;currentRow];
     end
     Tilt_and_Decenter_Data
    end
 end