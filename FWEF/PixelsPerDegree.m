function [PixelPerDegree,DegreePerPixel]= PixelsPerDegree(ScreenSize, Resolution, ViewingDistance)
% function [pixperdeg, degperpix]= PixelsPerDegree(ScreenSize, Resolution, ViewingDistance)
%
% Takes as input containing:
% Resolution - the resolution of the monitor in pixels
% ScreenSize - the size of the monitor in cm
% (these values can either be along a single dimension or
% for both the width and height)
% ViewingDistance - the viewing distance in cm.
%
% Calculates the visual angle subtended by a single pixel
%
% Returns the pixels per degree
% and it's reciprocal - the degrees per pixel (in degrees,not radians)
%
% written by Cameron Rodriguez, modified code from IF 7/2000

pix=ScreenSize/Resolution; %calculates the size of a pixel in cm
DegreePerPixel=(atan(pix./(ViewingDistance))).*(180/pi);
PixelPerDegree=1./DegreePerPixel;
