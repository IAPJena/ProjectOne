classdef HarmonicFieldSet
    %HarmonicFieldSet Set of harmonic fields. Can be used to define
    %ultrashort pulses
    
    properties
        HarmonicFieldArray % Array of monochromatic plane waves with spectral weight included
        ReferenceFieldIndex % Index of the field used as reference among the set (like central wavelength in pulse)
        Center % common center coordinate for all field arrays [x;y]
        ClassName % (String) - Name of the class. Here it is just redundunt but used to identify structures representing different objects when struct are used instead of objects.    

    end
    
    methods
        % constructor
         function NewHarmonicFieldSet = HarmonicFieldSet(arrayOfHarmonicFields,refIndex)
              if nargin == 0
                  arrayOfHarmonicFields =  HarmonicField;
                  refIndex = 1;
              elseif nargin == 1
                  if length(arrayOfHarmonicFields) > 1
                    refIndex = floor(length(arrayOfHarmonicFields)/2);
                  else
                      refIndex = 1;
                  end
              else
                  
              end
              NewHarmonicFieldSet.ReferenceFieldIndex = refIndex;
              nFields = length(arrayOfHarmonicFields);
              
              
              % If each harmonic field has different center, make the center of all
              % fields components to be that of the reference field.
              centerRef = arrayOfHarmonicFields(refIndex).Center;
              newInterpolatedArrayOfField = arrayOfHarmonicFields;
              for ff = 1:nFields
                  centerCurrent = arrayOfHarmonicFields(ff).Center;
                  if (centerRef(1)~= centerCurrent(1))||(centerRef(2)~= centerCurrent(2))
                      % Interpolate the field to coordinate centered at
                      % centerRef
                      newCx = centerRef(1);
                      newCy = centerRef(2);
                      interpMethod = 'cubic';
                      [ interpolatedField ] = interpolateField(...
                          arrayOfHarmonicFields(ff),interpMethod,newCx,newCy );
                      
                      newInterpolatedArrayOfField(ff) = interpolatedField;
                  else
                      newInterpolatedArrayOfField(ff) = arrayOfHarmonicFields(ff);
                  end
              end
              NewHarmonicFieldSet.HarmonicFieldArray = newInterpolatedArrayOfField;
              NewHarmonicFieldSet.Center = centerRef;
              NewHarmonicFieldSet.ClassName = 'HarmonicFieldSet';
         end
    end
    methods(Static)
        function newObj = InputGUI()
            newObj = ObjectInputDialog(MyHandle(HarmonicFieldSet()));
        end
    end        
end

