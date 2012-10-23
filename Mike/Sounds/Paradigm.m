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

%% Sound Initiate
InitializePsychSound;

%%%%%%%%%%%%%%
% EXPERIMENT %
%%%%%%%%%%%%%%
% Loop Through Each Trial
for i = 1:Task.TotalBlocks
    disp(i)

    % Play Instructions
    InstrSound = Task.Instr.Sounds{3*i - 2};
    InstrChannel = Task.Instr.Channel{3*i - 2};
    InstrFreq = Task.Instr.SoundsFreq{3*i - 2};
    [ Handel ] = PlaySound(InstrSound, InstrChannel, ...
                InstrFreq);
    
    WaitSecs(Params.Time.SoundLength);

    % Play Instructions
    InstrSound = Task.Instr.Sounds{3*i - 1};
    InstrChannel = Task.Instr.Channel{3*i - 1};
    InstrFreq = Task.Instr.SoundsFreq{3*i - 1};
    [ Handel ] = PlaySound(InstrSound, InstrChannel, ...
                InstrFreq);
    
    WaitSecs(Params.Time.SoundLength);

    % Play Instructions
    InstrSound = Task.Instr.Sounds{3*i};
    InstrChannel = Task.Instr.Channel{3*i};
    InstrFreq = Task.Instr.SoundsFreq{3*i};
    [ Handel ] = PlaySound(InstrSound, InstrChannel, ...
                InstrFreq);
    
    WaitSecs(Params.Time.SoundLength);

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

%% PLAY SOUND
function [ SoundHandel ] = PlaySound( SoundData, Channel, SoundFreq )
    SoundHandel = PsychPortAudio('Open', [], [], 0, SoundFreq, Channel);
    PsychPortAudio('FillBuffer', SoundHandel, SoundData');
    StartMusic = PsychPortAudio('Start', SoundHandel, 1, 0, 1); 
end

