function Intro(ScreenHandels)
%******************************************************************
%   Description:
%       Display Introduction and Instructions
%
%   Inputs:
%       ScreenHandels: is the variable for Montior output
%
%   Output:
%
%******************************************************************
%******************************************************************
%
%   Dependecies:
%       None
%   Used By:
%       StaglinPTB.m
%
%******************************************************************


IntroText = 'Welcome to the Go/No-Go Task! \n\n  GREEN = PRESS \n RED = Do Not Press \n\n Try to respond as quickly as possible while making as few errors as possible. \n\n Press any button to begin.'

%% Unpack Stucts
WES = ScreenHandels.WES;   % Window Handel Experimenter
RES = ScreenHandels.RES;   % Window Rectangle Experimenter
ifiE = ScreenHandels.ifiE; % interframe interval Experimenter
WSS = ScreenHandels.WSS;   % Window Handel Subject
RSS = ScreenHandels.RSS;   % Window Rectangle Subject
ifiS = ScreenHandels.ifiS; % interframe interval Subject

DrawFormattedText(WSS, IntroText, 'center', 'center', 0 , 45);
Screen('Flip',WSS);


%% Waiting for Button Press
% doc KbCheck
while KbCheck(-1); end % clear keyboard queue
while ~KbCheck(-1); end % wait for a key press
while KbCheck(-1); end % clear keyboard queue
