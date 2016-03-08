 function displaySystemConfiguration(optSystem,dispAperture,...
     dispGeneral,dispWavelength,dispField)
  % displays system configuration data to the command window
  % Inputs: Flags indicating which data to display
  if nargin == 1
     dispAperture = 1;
     dispGeneral  = 1;
     dispWavelength = 1;
     dispField = 1;
  elseif nargin == 2
     dispGeneral  = 1;
     dispWavelength = 1;
     dispField = 1; 
  elseif nargin == 3
     dispWavelength = 1;
     dispField = 1; 
  elseif nargin == 4
     dispField = 1;
  elseif nargin == 5

  end
 disp(' ');
 disp('************************************************************');
 disp('Optical System Configuration Data'); 
 disp('************************************************************');     
 disp(' ');
 if dispAperture 
     [systemApertureType] = getSupportedSystemApertureTypes(optSystem.SystemApertureType);
     disp('<<<<<<<<< Aperture Data >>>>>>>>>>>');
     disp(['Aperture Type : ' systemApertureType]);
     disp(['Aperture Value : ' num2str(optSystem.SystemApertureValue)]);
 end
 disp(' ');
 if dispGeneral
     [wavelengthUnit] = getSupportedWavelengthUnits(optSystem.WavelengthUnit);
     [lensUnit] = getSupportedLensUnits(optSystem.WavelengthUnit);
     
     disp('<<<<<<<<<< Genral Data >>>>>>>>>>>');
     disp(['Lens Name : ' optSystem.LensName]);
     disp(['Lens Note : ' (optSystem.LensNote)]);  
     disp(['Wavelength Unit : ' wavelengthUnit]);
     disp(['Lens Unit : ' lensUnit]);         
 end
 disp(' ');
 if dispWavelength
     disp('<<<<<<<<<<<<<< Wavelength Data >>>>>>>>>>>>>>');
     disp(['Total Number of Wavelength : ' num2str(getNumberOfWavelengths(optSystem))]);
     disp(['Primary Wavelength Index : ' num2str(optSystem.PrimaryWavelengthIndex)]);
     Wavelength_Matrix_Wav_Weight = ({optSystem.WavelengthMatrix});
     celldisp(Wavelength_Matrix_Wav_Weight);
 end
 if dispField 
     disp('<<<<<<<<<<<<<< Feild Point Data >>>>>>>>>>>>>>>');
     disp(['Total Number of Feild Points : ' num2str(getNumberOfFieldPoints(optSystem))]);
     Feild_Point_Matrix_X_Y_Weight = ({optSystem.FieldPointMatrix});
     celldisp(Feild_Point_Matrix_X_Y_Weight);  
 end 
 end
