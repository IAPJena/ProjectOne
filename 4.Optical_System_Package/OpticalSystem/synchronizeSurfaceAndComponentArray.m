function [ updatedSystem ] = synchronizeSurfaceAndComponentArray( savedOpticalSystem )
    %synchronizeSurfaceAndComponentArray Computes surface array from the
    %component array if the optical system is defined using component based
    %definition  or Computes component array from the surface array if the
    % optical system is defined using surface based definition. This makes
    % sure that both arrays are synchronized. In addition to syncing the
    % two array, theis function recalculates the surface coordinate
    % transformation matrices.
    
    updatedSystem = savedOpticalSystem;
    if IsSurfaceBased(savedOpticalSystem)
        [ updatedSystem ] = updateComponentFromSurfaceArray( savedOpticalSystem );
    else
        [ updatedSystem ] = updateSurfaceFromComponentArray( savedOpticalSystem );
    end
end
