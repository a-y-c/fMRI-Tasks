function [ VAT ] = Anaylsis( Params, VAT )
% VAT = ...
% ParadigmJitter(BlockNumber, Params, ScreenHandels, VAT)
%
%******************************************************************
%   INPUT:
%       BlockNumber = Block Number
%       VAT ->
%               .StartTime      = Time Start
%               .TimeStamp[]    = Time Log of Events
%               .TSCode{}       = Name of Events
%               .j              = Global Counter
%               .Results{}      = Result Struct 
%   
%******************************************************************
%
%
% Written by Cameron Rodriguez
%   2012/02/08
% Refractor by Andrew Cho
%   2012/08/23
%
%******************************************************************
%   DEPENDENCIES:
%
%   DEPENDENT BY:
%       StaglingPTB.m
%
%******************************************************************

Running.ACC.hundred = 0;   
Running.ACC.twothirds = 0;   
Running.ACC.halfs = 0;   

% Loop THrough All the Data
for i = 1:Params.TotalTrials
    %[100 0 66 33 50]
    if Params.CueNumber == 1
        
    elseif Params.CueNumber == 2

    elseif Params.CueNumber == 3

    elseif Params.CueNumber == 4

    else

    end
