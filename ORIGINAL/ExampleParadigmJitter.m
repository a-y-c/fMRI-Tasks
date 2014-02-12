function TrialVariables = ExampleParadigmJitter(BlockNumber, Params, ScreenHandels)
% TrialVariables = ...
% ExampleParadigmJitter(BlockNumber, Params, ScreenHandels)
%
%******************************************************************
%
% Written by Cameron Rodriguez
% Last Modified 2012/02/08
%
%******************************************************************
%
% see also: StaglinPTB, ExampleParadigmBlock, ...
%           Activate_Screens, RealTimeAnalysis 
%
%******************************************************************

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

OKKey = KbName('p');
KillKey = KbName('k');
TRKey1 = KbName('t'); % TR signal key
TRKey2 = KbName('5'); % TR signal key
TRKB = KbName('5%');  % Keyboard TR

KB1 = KbName('1!');   % Keyboard 1
KB2 = KbName('2@');   % Keyboard 1
KB3 = KbName('3#');   % Keyboard 1
KB4 = KbName('4$');   % Keyboard 1

BB1 = KbName('1');    % Button Box 1
BB2 = KbName('2');    % Button Box 2
BB3 = KbName('3');    % Button Box 3
BB4 = KbName('4');    % Button Box 4

% Keep KbCheck for looking for the TR signals
olddisabledkeys = DisableKeysForKbCheck([KbName('T'),KbName('5')]); 
    
%% Set Experiment Data Folder location

folder = 'ExampleParadigmFiles/';

%% load the .mat file

load([folder, 'ExperimentSettings.mat']);

%% Unpack Stucts
WES = ScreenHandels.WES;   % Window Handel Experimenter
RES = ScreenHandels.RES;   % Window Rectangle Experimenter
ifiE = ScreenHandels.ifiE; % interframe interval Experimenter
WSS = ScreenHandels.WSS;   % Window Handel Subject
RSS = ScreenHandels.RSS;   % Window Rectangle Subject
ifiS = ScreenHandels.ifiS; % interframe interval Subject

MaxISI = Params.ISIMax;
MinISI = Params.ISIMin;

%% Create the ISIs

NumberOfImages = size(Images,2);

% % Create random ISI's in the interval desired
%     ISIs = ((MaxISI-MinISI)*rand(1,(NumberOfImages-1)))+MinISI;
% % round to the 1000th of a sec
%     ISIs = (round(ISIs*1000))/1000;
    
% Create random ISI's in the interval desired
    mu = 0.4;
    ISIs = ((MaxISI-MinISI)*exprnd(mu, 1,(NumberOfImages-1) ) )+MinISI;
% round to the 1000th of a sec
    ISIs = (round(ISIs*1000))/1000;     

%% Preallocate Variable for Speed

TimeCodes = nan(1, 1000);
TimeStamps = nan(1, 1000);
KeyCodes = nan(1, 1000);

%% Run The Experiment Based on which block it is

TimeStamps(1) = GetSecs;
TimeCodes(1) = 3; % Block Begin
KeyCodes(1) = -1; % No Key Press
switch BlockNumber
    case 1
        [TimeStamps, TimeCodes, KeyCodes, Perm] = ...
        Set1(TimeStamps, TimeCodes, KeyCodes, Images, ...
             ImageValues, ISIs, ScreenHandels);
    case 2
        [TimeStamps, TimeCodes, KeyCodes, Perm] = ...
        Set1(TimeStamps, TimeCodes, KeyCodes, Images, ...
             ImageValues, ISIs, ScreenHandels);
    case 3
        [TimeStamps, TimeCodes, KeyCodes, Perm] = ...
        Set1(TimeStamps, TimeCodes, KeyCodes, Images, ...
             ImageValues, ISIs, ScreenHandels);
    case 4

    % etc ...
end

TimeStamps(find(isnan(TimeStamps),1)) = GetSecs;
TimeCodes(find(isnan(TimeCodes),1)) = 4; % Block Ends
KeyCodes(find(isnan(KeyCodes),1)) = -1;

%% Trim off the excess and pack in a stuct to pass out

TimeStamps(isnan(TimeStamps)) = []; 
TimeCodes(isnan(TimeCodes)) = [];
KeyCodes(isnan(KeyCodes)) = [];

TrialVariables.TimeStamps = TimeStamps;
TrialVariables.TScode = TimeCodes;
TrialVariables.KeyCodes = KeyCodes;
TrialVariables.POrder = Perm;

end

%% Subfunctions

function [TimeStamps, TimeCodes, KeyCodes, Perm] = ...
    Set1(TimeStamps, TimeCodes, KeyCodes, Images, ImageValues, ...
         ISIs, ScreenHandels)

WES = ScreenHandels.WES;   % Window Handel Experimenter
RES = ScreenHandels.RES;   % Window Rectangle Experimenter
ifiE = ScreenHandels.ifiE; % interframe interval Experimenter
WSS = ScreenHandels.WSS;   % Window Handel Subject
RSS = ScreenHandels.RSS;   % Window Rectangle Subject
ifiS = ScreenHandels.ifiS; % interframe interval Subject

NumberOfImages = size(Images,2);

Perm = randperm(NumberOfImages);
TI = zeros(NumberOfImages);% Texture index


for i = 1:NumberOfImages % MAke the Textures
    TI(i)=Screen('MakeTexture', WSS, Images{Perm(i)});
end
j = 2;% Set inital point for counter
for i = 1:NumberOfImages % Draw the Textures
    DisplayText = [num2str(ImageValues(Perm(i))),'¢'];
    DrawFormattedText(WSS, DisplayText, 'center', 'center', 0, 45);
    TimeStamps(j) = Screen('Flip',WSS);
    TimeCodes(j) = 5;
    KeyCodes(j) = -1;
    j = j+1; % Advance Counter
    Screen('DrawTexture', WSS, TI(i));
    WaitSecs(0.5-ifiS);
    TimeStamps(j) = Screen('Flip',WSS);
    TimeCodes(j) = 6;
    KeyCodes(j) = -1;
    j = j+1; % Advance Counter
    Screen('FillRect', WSS, 128, RSS);
    Screen('DrawDots', WSS, [0, 0], 10, 255*[1 0 0 1], ...
        [RSS(3)/2 RSS(4)/2], 1);
    Screen('DrawingFinished', WSS); 
    WaitSecs(0.5-ifiS);
    TimeStamps(j) = Screen('Flip',WSS);
    KeyCodes(j) = -1;
    TimeCodes(j) = 7;
    j = j+1; % Advance Counter
    if i~= NumberOfImages
        % disp(ISIs(i))
        WaitSecs(ISIs(i));
    end
end

Screen('Close', TI); % Close the Open Textures

end

