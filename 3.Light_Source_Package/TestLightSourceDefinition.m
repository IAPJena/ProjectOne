% LightSourceDefinitionDialog
harmonicFieldSource = getappdata(0,'HarmonicFieldSource');
[ U_xyTot,xlinTot,ylinTot] = getHFSourceSpatialProfile( harmonicFieldSource );
figure;surf(xlinTot,ylinTot,U_xyTot)
shading interp