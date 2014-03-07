function [  TimeStamps  TimeCodes  KeyCodes RTSec ] = ...
    Task2Paradigm( Params, ScreenHandels, Task )
% TrialVariables = ...
% ExampleParadigmBlock(BlockNumber, Params, ScreenHandels)
%******************************************************************
%	Description:
%		Runs TaskBlock based on given Task 
%
%	Inputs:
%		Params: is Parameters of the Project
%		ScreenHandels: is the variable for Montior output
%		Task: is Task with all the information
%
%	Output:
%		TrialVariables: all recorded information during Test	
%
%******************************************************************
%
% Written by Cameron Rodriguez
% Last Modified 2012/02/05
% Modded by Andrew Cho
% Last Modified 2012/06/05
%
%******************************************************************
%
%	Dependecies:
%		None
%	Used By:
%		StaglinPTB.m
%
%   see also: StaglinPTB, ExampleParadigmJitter, ...
%           Activate_Screens, RealTimeAnalysis 
%           [ 0 0 1280 1024 ] Horizontal, Vertical
%
%******************************************************************

%------------------------------------------------------------------
% SETUP -----------------------------------------------------------

%% Activate Keyboard
KbName('UnifyKeyNames');
FlushEvents('keyDown');

Keys.OKKey      = KbName('p');
Keys.KillKey    = KbName('k');
Keys.TRKey1     = KbName('t'); % TR signal key
Keys.TRKey2     = KbName('5'); % TR signal key
Keys.TRKB       = KbName('5%');  % Keyboard TR

Keys.KB1 = KbName('1!');   % Keyboard 1
Keys.KB2 = KbName('2@');   % Keyboard 1
Keys.KB3 = KbName('3#');   % Keyboard 1
Keys.KB4 = KbName('4$');   % Keyboard 1

Keys.BB1 = KbName('1');    % Button Box 1
Keys.BB2 = KbName('2');    % Button Box 2
Keys.BB3 = KbName('3');    % Button Box 3
Keys.BB4 = KbName('4');    % Button Box 4

Keys.BBb = KbName('b');    % Button Box r
Keys.BBy = KbName('y');    % Button Box g
Keys.BBg = KbName('g');    % Button Box b
Keys.BBr = KbName('r');    % Button Box y

% Keep KbCheck for looking for the TR signals
olddisabledkeys = DisableKeysForKbCheck([KbName('T'),KbName('5')]); 

%% Unpack Stucts
WES = ScreenHandels.WES;   % Window Handel Experimenter
RES = ScreenHandels.RES;   % Window Rectangle Experimenter
ifiE = ScreenHandels.ifiE; % interframe interval Experimenter
WSS = ScreenHandels.WSS;   % Window Handel Subject
RSS = ScreenHandels.RSS;   % Window Rectangle Subject
ifiS = ScreenHandels.ifiS; % interframe interval Subject

%% Sound Initiate
InitializePsychSound;

%% Preallocate Variable for Speed
TimeCodes = nan(1, 50);
TimeStamps = nan(1, 50);
KeyCodes = nan(1, 50);
RTSec = nan(1,50);
j = 0;

%% TimeCode Intpretation
CodeDrawText = 5;
CodeDisplayImage = 6;
CodeFixationPt = 7;
CodeKeyResponse = 8;

% ----------------------------------------------------------------
% Timing Blocks --------------------------------------------------

% Start Time 
TimeBlocks(1) = 0;
% Break 
TimeBlocks(2) = TimeBlocks(1) + Task.Timing.InstrBreak;
% Instructions
TimeBlocks(3) = TimeBlocks(2) + Task.Timing.Instr;

COUNTER = 3;
% Loop for Blocks
for j = 1:length(Task.Blocks)

    % Break
    COUNTER = COUNTER + 1;
    TimeBlocks(COUNTER) = TimeBlocks(COUNTER - 1) ...
        + Task.Timing.BlockBreak;

    % Loop for Images
    for i = 1:Task.BlocksTotal
        
        % Block Task
        COUNTER = COUNTER + 1;
        TimeBlocks(COUNTER) = TimeBlocks(COUNTER - 1) ...
            + Task.Timing.TaskTime;
    end
end

% Break
COUNTER = COUNTER + 1;
TimeBlocks(COUNTER) = TimeBlocks(COUNTER - 1) +  Task.Timing.BlockBreak

% ----------------------------------------------------------------
% START SCAN -----------------------------------------------------
%%%%%%%%

%% Wait for the Scan to begin
Text = 'Waiting for MRI scan to begin...';
DrawFormattedText(WSS, Text, 'center', 'center', 0 , 45);
Screen('Flip',WSS);
                    
%% Wait for Trigger
while KbCheck(-1); end % clear keyboard queue
Scanning = 0;
while Scanning ~= 1
    [keyIsDown, TimePt, keyCode] = KbCheck(-1);
    if ( keyCode(Keys.TRKey1) | keyCode(Keys.TRKey2) | ...
            keyCode(Keys.TRKB) )
        Scanning = 1; disp('Scan Has Begun');
        StartTime = GetSecs;
    end
end

% Keep KbCheck for looking for the TR signals
olddisabledkeys = DisableKeysForKbCheck([KbName('T'),KbName('5')]); 
 
% Start Up
j = 1;
TimeStamps(j) = 0;
TimeCodes(j) = 3; % Block Begin
KeyCodes(j) = -1; % No Key Press
RTSec(j) = -1; % No Response Time


% ----------------------------------------------------------------
% INTRO ----------------------------------------------------------
%%%%%%%%
%% Display Instructions  in the beginning

% Draw a Fixation Point onto the screen
[TStamp ] = DrawFixationPt(WSS, RSS);

% Save Info
j = j + 1;
TimeStamps(j) = TStamp - StartTime;
TimeCodes(j) = CodeFixationPt;
KeyCodes(j) = -1;
RTSec(j) = -1; 

% Wait till Block
WaitSecs(TimeBlocks(2) - (GetSecs - StartTime)); 

% Display Instruction Task
DisplayText = Task.Instr.Sentence;
[ TStamp ] = DrawText(WSS, DisplayText); 

% Save Info
j = j + 1;
TimeStamps(j) = TStamp - StartTime;
TimeCodes(j) = CodeDrawText;
KeyCodes(j) = -1;
RTSec(j) = -1; 

% Play Instructions
InstrSound = Task.Instr.Sounds{1};
InstrChannel = Task.Instr.Channel{1};
InstrFreq = Task.Instr.SoundsFreq{1};
% Play Sound
[ Handel ] = PlaySound(InstrSound, InstrChannel, InstrFreq);

% Wait X Seconds 
WaitSecs(TimeBlocks(3) - (GetSecs - StartTime));
% Close Sound Buffer
PsychPortAudio('Stop', Handel); 

% ----------------------------------------------------------------
%% START TASK ----------------------------------------------------
%%%%%%%
% Count Loops
loopCounter = 3;
%% Run The Experiment Based on which block it is
for BlockNumber = Task.Blocks 
 
% ----------------------------------------------------------------
% Rest Period ----------------------------------------------------
%%%%%%% inital

    % Draw a Fixation Point onto the screen
    [ TStamp ] = DrawFixationPt(WSS, RSS);
    % Save Info
    j = j + 1;
    TimeStamps(j) = TStamp - StartTime;
    TimeCodes(j) = CodeFixationPt;
    KeyCodes(j) = -1;
    RTSec(j) = -1; 

% ----------------------------------------------------------------
%% STETUP TASK ----------------------------------------------------
%%%%%%%
    % Texture Index
    TI = zeros(size(Task.Block{BlockNumber}.Images));
    
    % Make Textures for Images
    for i = 1:size(Task.Block{BlockNumber}.Images,2)
        TI(i)=Screen('MakeTexture', WSS, ...
            Task.Block{BlockNumber}.Images{i});
    end
 
     
% ----------------------------------------------------------------
% Start Block ----------------------------------------------------
%%%%%%%
    %% Draw the Textures
    for i = 1:size(Task.Block{BlockNumber}.Images,2) 

        % Wait time in Seconds
        loopCounter = loopCounter +1;

        % Draw Image
        [ TStamp ] = ...
            DrawImageCenter(WSS, TI(i), ...
                Task.Block{BlockNumber}.ImageSize{i}, ...
                Params.ScreenSize, TimeBlocks(loopCounter)+StartTime);
        % Save Info
        j = j + 1;
        TimeStamps(j) = TStamp - StartTime;
        TimeCodes(j) = CodeDisplayImage;
        KeyCodes(j) = -1;
        RTSec(j) = -1; 

    	% Play Sound Sentence
     	[ Handel ] = PlaySound(Task.Block{BlockNumber}.Sounds{i},...
                Task.Block{BlockNumber}.Channel{i}, ...
                Task.Block{BlockNumber}.SoundsFreq{i});
        % Wait for Sound
        WaitSecs(Task.Timing.Audio);

        % Get a Key Press
        [ TStamp, KCode, RT ] = GetKeyPressWithTimeOut(...
            Keys, Task.Timing.Response);
        % Save Info
        j = j + 1;
        TimeStamps(j) = TStamp - StartTime;
        TimeCodes(j) = CodeKeyResponse;
        KeyCodes(j) = KCode;
        RTSec(j) = RT;

        % Close Sound Buffer
        PsychPortAudio('Stop', Handel); 

   end
    % Finish Block
    Screen('Close', TI); % Close the Open Textures

    % Wait time in Seconds 
    loopCounter = loopCounter +1;
    WaitSecs(TimeBlocks(loopCounter) - (GetSecs - StartTime)); 
end

% -----------------------------------------------------------------
% Finish Up -------------------------------------------------------
%%%%%%%%%%%
% Draw a Fixation Point onto the screen
DrawFixationPt(WSS, RSS);

% Save Info
j = j + 1;
TimeStamps(j) = GetSecs - StartTime;
TimeCodes(j) = CodeFixationPt;
KeyCodes(j) = -1;
RTSec(j) = -1; 

% Close Sound Option
PsychPortAudio('Close', Handel); 

% Wait time in Seconds
loopCounter = loopCounter + 1;
WaitSecs(TimeBlocks(loopCounter) - (GetSecs - StartTime));

 
% -----------------------------------------------------------------
% Clean Up --------------------------------------------------------
%%%%%%%%%%%

TimeStamps(find(isnan(TimeStamps),1)) = (GetSecs - StartTime);
TimeCodes(find(isnan(TimeCodes),1)) = 4; % Block Ends
KeyCodes(find(isnan(KeyCodes),1)) = -1;
RTSec(find(isnan(TimeCodes),1)) = 0; % Block Ends

%% Trim off the excess and pack in a stuct to pass out
TimeStamps(isnan(TimeStamps)) = []; 
TimeCodes(isnan(TimeCodes)) = [];
KeyCodes(isnan(KeyCodes)) = [];
RTSec(isnan(RTSec)) = [];
end







% ----------------------------------------------------------------- 
%% Subfunctions ---------------------------------------------------
%%%%%

% PLAY SOUND
% ----------
function [ SoundHandel ] = PlaySound( SoundData, Channel, SoundFreq )
    SoundHandel = PsychPortAudio('Open', [], [], 0, SoundFreq, Channel);
    PsychPortAudio('FillBuffer', SoundHandel, SoundData');
    StartMusic = PsychPortAudio('Start', SoundHandel, 1, 0, 1);
end


% Draw Text
% ---------
function [ TStamp ] = DrawText(WSS, DisplayText)
    % Draw / Display Text            
    DrawFormattedText(WSS, DisplayText, 'center', 'center', 0 , 45);
    TStamp = Screen('Flip',WSS);
end

% Draw Fixation
% -------------
function [ TStamp ] = DrawFixationPt(WSS, RSS)

    % Draw / Display Fixation Point              
    Screen('FillRect', WSS, 128, RSS);
    Screen('DrawDots', WSS, [0, 0], 10, 255*[1 0 0 1], ...
           [RSS(3)/2 RSS(4)/2], 1);
    Screen('DrawingFinished', WSS);
    TStamp = Screen('Flip',WSS);
end

% Draw Image Center
% ---------------
function [TStamp] = ...
    DrawImageCenter(WSS, Image, ImageSize, ScreenSize, TIME)

% Draw / Display Image            
SCenter = ScreenSize / 2;
SourceDImage = [0 0 ImageSize(2) ImageSize(1)];

%%%%%%%%%%%%%%%%%%%%%%%%
% CHANGE MAX SIZE HERE %
%%%%%%%%%%%%%%%%%%%%%%%%
RATIO = 1/16;
if ScreenSize(1) < ScreenSize(2)
    X = (ScreenSize(1) - ScreenSize(1)*RATIO);
    Y = X;
else
    Y = (ScreenSize(2) - ScreenSize(2)*RATIO);
    X = Y;
end

% Calculate Resizing 
[X1 Y1] = Cize(X, Y,  ImageSize(2),  ImageSize(1));

%% Image Destination
DestDImage = Fsize( SCenter, X1, Y1, 0, 2 );
DestDWhite = Fsize( SCenter, X, Y, 0, 2 );
white = WhiteIndex(WSS);
Screen('FillRect', WSS, white, DestDWhite );
Screen('DrawTexture', WSS, Image, SourceDImage, DestDImage);
% Display Text
%DrawFormattedText(WSS, DisplayText,  'center', SCenter(1) - 350, 0 , 45);

TStamp = Screen('Flip',WSS, TIME);
end


%% Help Calculate Frame Size
function [XO YO] = Cize(RX, RY, X, Y)
    if (X > Y)
    	YO = RX / X * Y;
    	XO = RX;
    else
    	XO = RY / Y * X;
    	YO = RY;
    end
end

%% Help Calculate Screen Frame Size
function [ DestImage ] = Fsize( SCenter, X, Y, OFF, Mult)
    X1 = SCenter(1)*Mult/2 - (X)/2;
    Y1 = SCenter(2) - (Y)/2 + OFF;
    Y2 = SCenter(2) + (Y)/2 + OFF;
    X2 = SCenter(1)*Mult/2 + (X)/2;
    DestImage = [ X1 Y1 X2 Y2 ] ;
end

% Get Key Press
% -------------
function [ TStamp, KCode, RT ] = GetKeyPressWithTimeOut(Keys, maxTime)

    % Record Time
    BaseTime = GetSecs;
    % Default KCode
    KCode = 0;

    % For Loop
    Escape = false;
    while ~Escape
        % While no key Pressed, Wait, Check Again
    	if( GetSecs-BaseTime > maxTime )
            secs = BaseTime + maxTime;
            
            % Outputs
            RT = maxTime;
            TStamp = secs;
            KCode = 0;
            return;
        end
        WaitSecs(0.001);
    
        % Key is Down! Retrieve the Key and RT
        keyIsDown = 0;
        [keyIsDown, secs, keyCode] = KbCheck(-1);
        if ( keyIsDown == 1 )
            if (keyCode(Keys.BB1) | keyCode(Keys.KB1) | keyCode(Keys.BBb))
                KCode = 1;
                Escape = true;
            elseif (keyCode(Keys.BB2) | keyCode(Keys.KB2) | keyCode(Keys.BBy))
                KCode = 2;
                Escape = true;
            elseif (keyCode(Keys.BB3) | keyCode(Keys.KB3) | keyCode(Keys.BBg))
                KCode = 3;
                Escape = true;
            elseif (keyCode(Keys.BB4) | keyCode(Keys.KB4) | keyCode(Keys.BBr))
                KCode = 4; 
                Escape = true;

            % Not a Valid Key
            else
                keyIsDown = 0;
            end 
        end 
    end

    % Calculate Response Time
    RT = secs - BaseTime

    % Wait till Key is Release
    while KbCheck(-1)
        WaitSecs(0.001);
    end

    % Record Seconds
    TStamp = secs;
end

