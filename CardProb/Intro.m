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


IntroText = 'In this task, you will be presented with different cues along with a card.\n You are to guess if the card is a high card (Greater than 5) or a low card (Less than 5) based on the cue.\n\n Each cue represents a different probability so try your best to pay attention to the cues presented in order to guess the correct probability.\n\n Press any button to continue.'

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
