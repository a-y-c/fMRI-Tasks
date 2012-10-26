function TrialVariables = ParadigmJitter(BlockNumber, Params, ScreenHandels)
% TrialVariables = ...
% ExampleParadigmJitter(BlockNumber, Params, ScreenHandels)
%
%******************************************************************
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
%% Preallocate Variable for Speed
VAT.TimeCodes = nan(1, 1000);
VAT.TimeStamps = nan(1, 1000);
VAT.KeyCodes = nan(1, 1000);
j = 1; %Counter

%% Set Initial Variable
VAT.TimeStamps(1) = GetSecs;
VAT.TimeCodes(1) = 3; % Block Begin
VAT.KeyCodes(1) = -1; % No Key Press

%% Set Up 
Params.TotalCue1 = 24;
Params.TotalCue2 = 24;
Params.TotalCue3 = 24;
Params.TotalCue4 = 24;
Params.TotalCue5 = 24;

ONE = ones(1, Params.TotalCue1);
TWO = repmat(2, 1, Params.TotalCue2);
THREE = repmat(3, 1, Params.TotalCue3);
FOUR = repmat(4, 1, Params.TotalCue4);
FIVE = repmat(5, 1, Params.TotalCue5);

% Presentation Order (Randomized)
ix = randperm(Params.TotalTrials);
UnorderedTrialSet = [ ONE, TWO, THREE, FOUR, FIVE ];
Params.TrialSet = UnorderedTrialSet(ix);

%%%%%%%%%%%%%%
% EXPERIMENT %
%%%%%%%%%%%%%%
% Loop Through Each Trial
for i = 1:Task.TotalBlocks
    disp(i)

    % Draw Cue  
    [VAT, j] = DrawCard(WSS, Params.ScreenSize, ...
        Params.CardRatio, Params.CardSize, ...
        CueText, Params.CardBackground, VAT, j );

    WaitSecs(Params.Timing.Cue);
    WaitSecs(Params.Timing.ITI1);

    % Draw Question Cue / FeedBack Period 
    [VAT, j] = DrawCard(WSS, Params.ScreenSize, ...
        Params.CardRatio, Params.CardSize, ...
        CueText, Params.CardBackground, VAT, j );

    WaitSecs(Params.Time.PictureLength);

    % Draw Image
    [VAT, j] = DrawImage(WSS, Params.Image(3*i), Params.ImageSize(3*i) ...
        Params.ScreenSize, Params.PictureRatio, VAT, j );
    WaitSecs(Params.Time.PictureLength);

    % Fixation Point
    [VAT, j] = DrawFixationPt(WSS, RSS, VAT, j); 
    WaitSecs(Params.Time.ISILength);

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

%% These are the Variables to Bounce OUT
TrialVariables.TimeStamps = VAT.TimeStamps;
TrialVariables.TScode = VAT.TimeCodes;
TrialVariables.KeyCodes = VAT.KeyCodes;
end



%%%%%%%%%%%%%
% FUNCTIONS %
%%%%%%%%%%%%%
%% Draw Fixation Point
function [VAT, j] = DrawFixationPt(WSS, RSS, VAT, j)
    Screen('FillRect', WSS, 128, RSS);
    Screen('DrawDots', WSS, [0, 0], 10, 255*[1 0 0 1], ... 
           [RSS(3)/2 RSS(4)/2], 1); 
    Screen('DrawingFinished', WSS);

    % Record Timing
    VAT.TimeStamps(j) = Screen('Flip',WSS);
    VAT.KeyCodes(j) = -1; 
    VAT.TimeCodes(j) = 7;
    j = j+1; % Advance Counter
end

% Draw / Display Text            
function [VAT, j] = DrawCard(WSS, ScreenSize, CardRatio, ...
             CardSize, CueText, Color, VAT, j)
    
    % Calculate Location of Image
    CardX1 = ScreenSize(1)/2 - ...
        (ScreenSize(1)/2*CardSize) 
    CardX2 = ScreenSize(1)/2 + ...
        (ScreenSize(1)/2*CardSize) 
    CardY1 = ScreenSize(2)/2 - ...
        (ScreenSize(2)/2*CardRatio*CardSize) 
    CardY1 = ScreenSize(2)/2 - ...
        (ScreenSize(2)/2*CardRatio*CardSize) 

    Dest = [ CardX1 CardX2 CardY1 CardY2 ]; 
    
    % Display Image Screen
    Screen('FillRect', WSS, Color, Dest);

    % Display Text
    DrawFormattedText(WSS, CueText, 'center', 'center', 0, 45);
    
    % Record Timing
    TimeStamps(j) = Screen('Flip',WSS);
    KeyCodes(j) = -1; 
    TimeCodes(j) = 5;
    j = j+1; % Advance Counter
end

function [VAT, j, RT] = ...
    GetKeyPressWithTimeOut(Keys, VAT, j, maxTime)

    baseTime = GetSecs;
    gotgood = false;
    
    while ~gotgood
        % while no key is pressed, wait a bit, then check again
        if( GetSecs-baseTime > maxTime )
            secs = baseTime + maxTime;
            RT = maxTime;
            key = 'T'; % Capitalized
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

    TimeStamps(j) = secs;
    %disp( KbName(keyCode));
    %KeyCodes(j) = str(KbName(keyCode))); 
    KeyCodes(j) = find(keyCode,1);
    TimeCodes(j) = 8;
    j = j+1; % Advance Counter
end

