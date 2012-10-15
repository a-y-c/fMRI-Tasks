function [PPD,DPP] = PixelsPerDegreeE(ScreenSize, Resolution, ViewingDistance, Eccentricity)
%**************************************************************************
%
% [PPD,DPP] = PixelsPerDegreeE(ScreenSize, Resolution, ViewingDistance, Eccentricity)
%
%**************************************************************************
%
%**************************************************************************
%
% This program was written by Cameron Rodriguez under the direction of
% Dario Ringach, Ph.D. Professor in UCLA's Neurobiology Dept
%
% Last Modified 06/23/2010
%
%**************************************************************************

%%
if ~exist('ScreenSize', 'var') % Assumes Default of 0.33 Degrees Noise
    Eccentricity = 0:.5:30;
    POIE = 20;
    ScreenSize = [69.7708 39.4]; % Stimulus Screen in cm
    Resolution = [1360 768]; % Stimulus Screen Resolution in Pixels
    ViewingDistance = 309; % Screen Distance
    PlotsOn = 1;
else
    PlotsOn = 0;
end

PixelSize=ScreenSize/Resolution; %calculates the size of a pixel (cm/pixel)

SizeInCmOneDeg = ViewingDistance * (tand(Eccentricity + 0.5) - tand(Eccentricity - 0.5));

PPD = SizeInCmOneDeg ./ PixelSize;% (cm/deg)/(cm/pixel) = Pixels/Deg
DPP = 1./PPD;% Deg/Pixel

if PlotsOn == 1
figure(1)
subplot(2,1,1)
    plot(Eccentricity,PPD)
    hold on
    plot(POIE, PPD(2*POIE+1), 'rp')
    hold off
    xlabel('Eccentricity\circ');
    ylabel('Pixels Per Degree Visual Angle');
    title({'Pixels Per Degree Visual Angle'});
    legend(['Pixels Per Degree'],['At ',num2str(POIE),'\circ E, Pixels Per Degree = ',num2str(PPD(2*POIE+1)), ' Pixels'], 'Location', 'NorthWest');
subplot(2,1,2)
    plot(Eccentricity,DPP)
    hold on
    plot(POIE, DPP(2*POIE+1), 'rp')
    hold off
    xlabel('Eccentricity\circ');
    ylabel('Degrees Visual Angle Per Pixel');
    title({'Degree Visual Angle Per Pixel'});
    legend(['Pixels Per Degree'],['At ',num2str(POIE),'\circ E, Degrees Per Pixel = ',num2str(DPP(2*POIE+1)), '\circ'], 'Location', 'NorthEast');

% Supress Output
PPD = [];
DPP = [];
end
    
end

