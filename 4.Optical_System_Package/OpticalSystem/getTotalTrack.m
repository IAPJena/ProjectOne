function totalTrack = getTotalTrack(optSystem)
    % getTotalTrack: returns total length of the system from 1st
    % optical surface to image plane.
    totalThick = 0;
    maxZ = 0;
    minZ = 0;
    [surfaceArray,nSurf] = getSurfaceArray(optSystem);
    for kk = 2:1:nSurf;
        currentSurf = surfaceArray(kk);
        surfZ = currentSurf.SurfaceCoordinateTM(3,4);
        if surfZ > maxZ
            maxZ =  surfZ;
        elseif surfZ < minZ
            minZ =  surfZ;
        end
    end
    totalTrack = maxZ - minZ;
end