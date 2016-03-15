function [ fullNames,displayNames ] = GetSupportedSurfaceTypes(index)
    %GETSUPPORTEDSURFACES Returns the currntly supported surfaces as cell array
    if nargin < 1
        index = 0;
    end
    displayNames = {'Standard','Ideal Lens','Example Surface','Kostenbauder',...
        'Dummy','Even Asphere','Extended Parameter Test Surface','Toroidal',...
        'LinearAxicon','Surface From File'};
    fullNames = {'Standard','IdealLens','ExampleSurface','Kostenbauder','Dummy',...
        'EvenAsphere','ExtendedParameterTestSurface','Toroidal',...
        'LinearAxicon','SurfaceFromFile'};
    if index
        displayNames = displayNames{index};
        fullNames = fullNames{index};
    end
end

