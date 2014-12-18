function TrialVariables = Paradigm(BlockNum, Params, ScreenHandels)
% TrialVariables = ...
% Paradigm(BlockNum, Params, ScreenHandels)
%
%******************************************************************
%
% Written by Cameron Rodriguez
% Last Modified 2012/02/08
% Modified by Andrew Cho
%   FOR Alcohol Implicit TaskTask
%   2014/12
%
%******************************************************************
%
%   DEPENDENCIES:
%
%   DEPENDENT BY:
%       StaglingPTB
%
%******************************************************************

%%%%%%%%%%%%%
% CONSTANTS %
%%%%%%%%%%%%%
%% Activate Keyboard
KbName('UnifyKeyNames');
FlushEvents('keyDown');

space=KbName('SPACE');
esc=KbName('ESCAPE');
right=KbName('RightArrow');
left=KbName('LeftArrow');
up=KbName('UpArrow');
down=KbName('DownArrow');
shift=KbName('RightShift');

Keys.OKKey = KbName('p');
Keys.KillKey = KbName('k');
Keys.TRKey1 = KbName('t'); % TR signal key
Keys.TRKey2 = KbName('5'); % TR signal key
Keys.TRKB = KbName('5%');  % Keyboard TR

Keys.KB1 = KbName('1!');   % Keyboard 1
Keys.KB2 = KbName('2@');   % Keyboard 1
Keys.KB3 = KbName('3#');   % Keyboard 1
Keys.KB4 = KbName('4$');   % Keyboard 1

Keys.BB1 = KbName('1');    % Button Box 1
Keys.BB2 = KbName('2');    % Button Box 2
Keys.BB3 = KbName('3');    % Button Box 3
Keys.BB4 = KbName('4');    % Button Box 4

% Keep KbCheck for looking for the TR signals
olddisabledkeys = DisableKeysForKbCheck([KbName('T'),KbName('5')]); 
    
%% Unpack Stucts
WES = ScreenHandels.WES;   % Window Handel Experimenter
RES = ScreenHandels.RES;   % Window Rectangle Experimenter
ifiE = ScreenHandels.ifiE; % interframe interval Experimenter
WSS = ScreenHandels.WSS;   % Window Handel Subject
RSS = ScreenHandels.RSS;   % Window Rectangle Subject
ifiS = ScreenHandels.ifiS; % interframe interval Subject


%%%%%%%%%
% SETUP %
%%%%%%%%%
Task = Params.Task{BlockNum};
Timing = Params.Timing;

% Presentation Order (Randomized)
TotalWords = [ Task.LeftLeaningWord; Task.RightLeaningWord ];
ix = randperm(length(TotalWords));

LeftTextPos = Params.ScreenCenter / 2;
RightTextPos = [ Params.ScreenCenter(1)*3/2 Params.ScreenCenter(2)/2 ];

%% Preallocate Variable for Speed
VAT.TimeStamps = nan(1, 100);
VAT.ResponseChoice = nan(1, 100);
VAT.ResponseTime  = nan(1, 100);
VAT.CorrectTime  = nan(1, 100);
VAT.BlockNum = nan(1, 100);
VATCount = 1;


%%%%%%%%%
% INTRO %
%%%%%%%%%
Text = Task.Intro;
DrawFormattedText(WSS, Text, 'center', 'center', 0 , 45);
TimeStamp = Screen('Flip',WSS);

VAT.TimeStamps(VATCount)        = TimeStamp;
VAT.ResponseChoice(VATCount)    = 0; 
VAT.ResponseTime(VATCount)     = 0;
VAT.CorrectTime(VATCount)      = 0;
VAT.BlockNum(VATCount)         = 0;
VATCount = VATCount + 1;

WaitSecs(Timing.Intro);


%%%%%%%%%%%%%%
% EXPERIMENT %
%%%%%%%%%%%%%%
for n = 1:length(TotalWords)

    LeftText = Task.LeftWord;
    RightText = Task.RightWord;

    CenterText = TotalWords{ix(n)};
    DrawFormattedText(WSS, CenterText, 'center', 'center', 0 , 45);
    DrawFormattedText(WSS, LeftText, LeftTextPos(1), LeftTextPos(2), 0 , 45);
    DrawFormattedText(WSS, RightText, RightTextPos(1), RightTextPos(2), 0 , 45);

    % Flip Screen
    TimeStamp = Screen('Flip',WSS);
    
    % Get Key Press 
    Timing.ResponseTime
    [ RT, RC ] = GetKeyPressWithTimeOut(Keys, Timing.ResponseTime);

    % Store Record
    VAT.TimeStamps(VATCount)       = TimeStamp;
    VAT.ResponseChoice(VATCount)   = RC; 
    VAT.ResponseTime(VATCount)     = RT;
    VAT.CorrectTime(VATCount)      = 0;
    VAT.BlockNum(VATCount)         = BlockNum;
    VATCount = VATCount + 1;
    
% End Loop 
end

Screen('Close'); % Close the Open Textures

%% Trim off the excess and pack in a stuct to pass out
VAT.TimeStamps(isnan(VAT.TimeStamps)) = [];
VAT.ResponseChoice(isnan(VAT.ResponseChoice)) = []; 
VAT.ResponseTime(isnan(VAT.ResponseTime)) = [];
VAT.CorrectTime(isnan(VAT.CorrectTime)) = [];
VAT.BlockNum(isnan(VAT.BlockNum)) = [];
 
TrialVariables = VAT;
% End Function
end

%%%%%%%%%%%%%
% FUNCTIONS %
%%%%%%%%%%%%%
%% Get Key Press with Timeout 
function [ RT, Response ] = GetKeyPressWithTimeOut(Keys, maxTime)

    baseTime = GetSecs;
    gotgood = false;
    
    while ~gotgood
        % while no key is pressed, wait a bit, then check again
        if( GetSecs-baseTime > maxTime )
            secs = baseTime + maxTime;
            RT = maxTime;
            Response = 'T'; % Capitalized
            return; 
        end 
        WaitSecs(0.001);
    
        % got here? a key is down! retrieve the key and RT
        keyIsDown = 0;
        [keyIsDown, secs, keyCode] = KbCheck(-1);
        if keyIsDown == 1
           if (keyCode(Keys.TRKey1) | ... 
               keyCode(Keys.TRKey2) | ... 
               keyCode(Keys.TRKB))
               keyIsDown = 0;
            else
                gotgood = true;
            end 
        end 
    end

    % do not pass control back until the key has been released
    while KbCheck(-1)
        WaitSecs(0.001);
    end

    % Format Output to be Read. Only Button Box
    if keyCode(Keys.KB1) || keyCode(Keys.BB1)
        Response = '1';
    elseif keyCode(Keys.KB2) || keyCode(Keys.BB2)
        Response = '2';
    elseif keyCode(Keys.KB3) || keyCode(Keys.BB3)
        Response = '3';
    elseif keyCode(Keys.KB4) || keyCode(Keys.BB4)
        Response = '4';
    else
        Response = '0';
    end

    RT = secs-baseTime;
end

