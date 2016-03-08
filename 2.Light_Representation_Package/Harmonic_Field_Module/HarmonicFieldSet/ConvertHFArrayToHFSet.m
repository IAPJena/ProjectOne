function [ harmonicFieldSet ] = ConvertHFArrayToHFSet( harmonicFieldArray )
    %CONVERTHARMONICFIELDARRAYTOHARMONICFIELDSET Summary of this function goes here
    %   Detailed explanation goes here
    
    nFields = length(harmonicFieldArray);
    Ny = size(harmonicFieldArray(1).ComplexAmplitude(:,:,1),1);
    Nx = size(harmonicFieldArray(1).ComplexAmplitude(:,:,1),2);
    
    Ex = zeros(Ny,Nx,nFields);
    Ey = zeros(Ny,Nx,nFields);
    sampDistX = zeros(1,nFields);
    sampDistY = zeros(1,nFields);
    wavelen = zeros(1,nFields);
    center = zeros(2,nFields);
    direction = zeros(3,nFields);
    domain = zeros(1,nFields);
    for kk = 1:nFields
        Ex(:,:,kk) = harmonicFieldArray(kk).ComplexAmplitude(:,:,1);
        Ey(:,:,kk) = harmonicFieldArray(kk).ComplexAmplitude(:,:,2);
        sampDistX(kk) = harmonicFieldArray(kk).SamplingDistance(1);
        sampDistY(kk) = harmonicFieldArray(kk).SamplingDistance(2);
        wavelen(kk) = harmonicFieldArray(kk).Wavelength;
        center(:,kk) = harmonicFieldArray(kk).Center;
        direction(:,kk) = harmonicFieldArray(kk).Direction;
        domain(kk) = harmonicFieldArray(kk).Domain;
    end
    harmonicFieldSet = HarmonicFieldSet(Ex,Ey,sampDistX,sampDistY,wavelen,center,direction,domain);
end

