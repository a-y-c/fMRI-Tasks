function TrialVariables = ParadigmJitter(BlockNumber, Params, ScreenHandels)
% TrialVariables = ...
% ExampleParadigmJitter(BlockNumber, Params, ScreenHandels)
%
%******************************************************************
%
% Written by Cameron Rodriguez
% Last Modified 2012/02/08
% MODIFIED FOR GoNoGo Task
%   2012/08/23
%
%******************************************************************
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
VGo = Params.VerticalTrials * Params.VerticalGo;
VNoGo = Params.VerticalTrials * Params.VerticalNoGo;
HGo = Params.HorizontalTrials * Params.HorizontalGo;
HNoGo = Params.HorizontalTrials * Params.HorizontalNoGo;

% Presentation Order (Randomized)
ix = randperm(Params.TotalTrials);

ONE = ones(1, VGo);
TWO = repmat(2, 1, VNoGo);
THREE = repmat(3, 1, HGo);
FOUR = repmat(4, 1, HNoGo);
TotalTrials = [ ONE, TWO, THREE, FOUR ];
%TotalTrials = [ [1]*VGo , [2]*VNoGo, [3]*HGo, [4]*HNoGo ]
TrialSet = TotalTrials(ix);


%% Create InterStimilus Timing
FixToCue = ISIGenerator(Params.Time.FixToCueMin, ... 
    Params.Time.FixToCueMax, Params.TotalTrials/2);
CueToStim = ISIGenerator(Params.Time.CueToStimMin, ... 
    Params.Time.CueToStimMax, Params.TotalTrials/2);
StimToFix = ISIGenerator(Params.Time.StimToFixMin, ...
    Params.Time.StimtoFixMax, Params.TotalTrials/2);


%% Preallocate Variable for Speed
VAT.TimeCodes = nan(1, 1000);
VAT.TimeStamps = nan(1, 1000);
VAT.KeyCodes = nan(1, 1000);
j = 1; %Counter

%% Set Initial Variable
VAT.TimeStamps(1) = GetSecs;
VAT.TimeCodes(1) = 3; % Block Begin
VAT.KeyCodes(1) = -1; % No Key Press


%%%%%%%%%%%%%%
% EXPERIMENT %
%%%%%%%%%%%%%%
% Horizontal/Vertical Counter
HC = 0;
VC = 0;
TimeIndex = 0;

% Loop Through Each Trial
for i = 1:Params.TotalTrials
    disp(i)
    % Check Which Version
    switch TrialSet(i)
        % Vertical Go
        case 1
            color = 'green';
            VC = VC+1;
            TimeIndex = VC;
            Orient = 'vertical';
        % Vertical No Go
        case 2
            color = 'red';
            VC = VC+1;
            TimeIndex = VC;
            Orient = 'vertical';
        % Horizontal Go
        case 3
            color = 'green';
            HC = HC+1;
            TimeIndex = HC;
            Orient = 'horizontal';
        % Horizontal No Go
        case 4
            color = 'red';
            HC = HC+1;
            TimeIndex = HC;
            Orient = 'horizontal';
    end

    % Fixation Point
    [VAT, j] = DrawFixationPt(WSS, RSS, VAT, j); 
    WaitSecs(FixToCue(TimeIndex));

    % Cue White Vertical/Horizontal
    Info = Params.Rectangle;
    SCenter = Params.ScreenCenter;
    [VAT, j] = DrawRectangle(WSS, VAT, j, Orient, SCenter, 'white', Info );
    WaitSecs(CueToStim(TimeIndex));

    % Green/Blue Vertical/Horizontal
    [VAT, j] = DrawRectangle(WSS, VAT, j, Orient, SCenter, color, Info );
   
    % Get Key Press 
    [VAT, j, RT] = GetKeyPressWithTimeOut(Keys, VAT, j, ...
        Params.Time.ResponseMax);
    if Params.Time.ResponseMax > RT + WaitSecs(StimToFix(TimeIndex));
        WaitSecs(StimToFix(TimeIndex));
    end


    %%%%%%%%%%%%%%%%%%%%%
    %% Record Information

    % Record TrialNumber
    Result.TrialNumber(i) = i;
    % Record Response
    if strcmp(color, 'red')
        % Correct Response [ Blue/No -> No Response ]
        if VAT.KeyCodes(j-1) == -1 
            Result.Response(i) = 1;
        % Incorrect Respones [ Blue/NO -> Response ]
        else
            Result.Response(i) = 0;
        end
    else
        % Incorrect Response [ Green/Go -> No Response ]
        if VAT.KeyCodes(j-1) == -1 
            Result.Response(i) = 0;
        % Correct Response [ Green/Go -> Response ]
        else
            Result.Response(i) = 1;
        end
    end
    % Record Cue Type 
    if strcmp(Orient, 'vertical')
        Result.CueType(i) = 1;
    else
        Result.CueType(i) = 0;
    end
    % Record Stimulus Type 
    Result.StimulusType(i) = TrialSet(i);
    % Record Latency 
    Result.Latency(i) = RT;
    % Record Time Cue Onset
    Result.Time_Cue_Onset(i) = FixToCue(TimeIndex);
    % Record Time Stim Onset
    Result.Time_Stim_Onset(i) = CueToStim(TimeIndex);
    % Record Time to Fixatoin
    if Params.Time.ResponseMax > RT + StimToFix(TimeIndex)
        Result.Time_to_Fix(i) =  RT + StimToFix(TimeIndex);
    else
        Result.Time_to_Fix(i) = Params.Time.ResponseMax;
    end

% End Loop 
end

Screen('Close'); % Close the Open Textures

VAT.TimeStamps(find(isnan(VAT.TimeStamps),1)) = GetSecs;
VAT.TimeCodes(find(isnan(VAT.TimeCodes),1)) = 4; % Block Ends
VAT.KeyCodes(find(isnan(VAT.KeyCodes),1)) = -1;

%% Trim off the excess and pack in a stuct to pass out
VAT.TimeStamps(isnan(VAT.TimeStamps)) = []; 
VAT.TimeCodes(isnan(VAT.TimeCodes)) = [];
VAT.KeyCodes(isnan(VAT.KeyCodes)) = [];

TrialVariables.TimeStamps = VAT.TimeStamps;
TrialVariables.TScode = VAT.TimeCodes;
TrialVariables.KeyCodes = VAT.KeyCodes;
TrialVariables.Results = Result;

end



%%%%%%%%%%%%%
% FUNCTIONS %
%%%%%%%%%%%%%
%% ISI Generator
function Time = ISIGenerator( Min, Max, Total)
    % Create random ISI's in the interval desired
    mu = 0.4;
    ISIs = ((Max-Min)*exprnd(mu, 1,Total ) )+Min;
    % round to the 1000th of a sec
    Time = round(ISIs*1000)/1000;     
end


%% Rectangle Displayer
function [ VAT, j ] = DrawRectangle(WSS, VAT, j, ...
        Orient, SCenter, Color, Info ) 
    switch Color
        case 'red'
            RectColor = Info.Color.red;
        case 'green'
            RectColor = Info.Color.green;
        case 'white'
            RectColor = Info.Color.white;
        otherwise
            RectColor = Info.Color.black;
    end
    RectDest = RSize ( SCenter, Info.RatioLength, ...
        Info.ScreenMultiplier, Orient);
    %% Print Fill Rect
    Screen('FillRect', WSS, RectColor, RectDest);
    TimeStamps(j) = Screen('Flip',WSS);
end


%% Rectangle Size Calculator
function [ DestRect ] = RSize( SCenter, Ratio, Mult, Orient)
    % Rectangle Size
    Length = SCenter(1) * Mult;
    switch Orient
        case 'vertical'
            X1 = SCenter(1) - Length*Ratio/2;
            X2 = SCenter(1) + Length*Ratio/2;
            Y1 = SCenter(2) - Length/2;
            Y2 = SCenter(2) + Length/2;
        case 'horizontal'
            X1 = SCenter(1) - Length/2;
            X2 = SCenter(1) + Length/2;
            Y1 = SCenter(2) - Length*Ratio/2;
            Y2 = SCenter(2) + Length*Ratio/2;
    end
    DestRect = [ X1 Y1 X2 Y2];
end


%% Draw Fixation Point
function [VAT, j] = DrawFixationPt(WSS, RSS, VAT, j)
    Screen('FillRect', WSS, 128, RSS);
    Screen('DrawDots', WSS, [0, 0], 10, 255*[1 0 0 1], ... 
           [RSS(3)/2 RSS(4)/2], 1); 
    Screen('DrawingFinished', WSS);
    VAT.TimeStamps(j) = Screen('Flip',WSS);
    VAT.KeyCodes(j) = -1; 
    VAT.TimeCodes(j) = 7;
    j = j+1; % Advance Counter
end

%% Get Key Press with Timeout 
function [VAT, j, RT] = GetKeyPressWithTimeOut(Keys, VAT, j, maxTime)

    baseTime = GetSecs;
    gotgood = false;
    
    while ~gotgood
        % while no key is pressed, wait a bit, then check again
        if( GetSecs-baseTime > maxTime )
            secs = baseTime + maxTime;
            RT = maxTime;
            key = 'T'; % Capitalized

             VAT.TimeStamps(j) = secs;
             VAT.KeyCodes(j) = 0;
             VAT.TimeCodes(j) = 8;
             j = j+1; % Advance Counter
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
    RT = secs-baseTime;

    % do not pass control back until the key has been released
    while KbCheck(-1)
        WaitSecs(0.001);
    end 

    VAT.TimeStamps(j) = secs;
    VAT.KeyCodes(j) = find(keyCode,1);
    VAT.TimeCodes(j) = 8;
    j = j+1; % Advance Counter
end

