function TrialVariables = ...
    ExampleParadigm(BlockNumber, Params, ScreenHandels)
% TrialVariables = ...
% ExampleParadigmBlock(BlockNumber, Params, ScreenHandels)
%
%******************************************************************
%
% Written by Cameron Rodriguez
% Last Modified 2012/02/05
%
%******************************************************************
%
% see also: StaglinPTB, ExampleParadigmJitter, ...
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


%% Preallocate Variable for Speed

TimeCodes = nan(1, 1000);
TimeStamps = nan(1, 1000);
KeyCodes = nan(1, 1000);

%% Run The Experiment Based on which block it is

Perm = randperm(size(Images,2));
TI = zeros(size(Images));% Texture index

TimeStamps(1) = GetSecs;
TimeCodes(1) = 3; % Block Begin
KeyCodes(1) = -1; % No Key Press
switch BlockNumber
    case 1
        for i = 1:size(Images,2) % Make the Textures
            TI(i)=Screen('MakeTexture', WSS, Images{Perm(i)});
        end
        j = 2;% Set inital point for counter
        for i = 1:size(Images,2) % Draw the Textures
            
            % Draw Text onto the screen
            DisplayText = [num2str(ImageValues(Perm(i))),'¢'];
            [TimeStamps, TimeCodes, KeyCodes, j] = ...
                DrawText(WSS, DisplayText, TimeStamps, ...
                         TimeCodes, KeyCodes, j);
            
            % Wait X Secs 
            WaitSecs(2); % Wait time in Seconds
            
            % Draw an Image onto the screen
            [TimeStamps, TimeCodes, KeyCodes, j] = ...
                DrawImage(WSS, TI(i), TimeStamps, ...
                          TimeCodes, KeyCodes, j);
            
            % Wait X Secs 
            WaitSecs(2); % Wait time in Seconds
            
            if i ~= size(Images,2) % Skip on the last round
            
            % Draw a Fixation Point onto the screen
            [TimeStamps, TimeCodes, KeyCodes, j] = ...
                DrawFixationPt(WSS, RSS, TimeStamps, ...
                               TimeCodes, KeyCodes, j);
            
            % Wait X Secs
            WaitSecs(2); % Wait time in Seconds
            
            end
            
        end
        
        Screen('Close', TI); % Close the Open Textures
        
    case 2
        
        for i = 1:size(Images,2) % Make the Textures
            TI(i)=Screen('MakeTexture', WSS, Images{Perm(i)});
        end
        j = 2;% Set inital point for counter
        for i = 1:size(Images,2) % Draw the Textures
            
            % Draw Text onto the screen
            DisplayText = [num2str(ImageValues(Perm(i))),'¢'];
            [TimeStamps, TimeCodes, KeyCodes, j] = ...
                DrawText(WSS, DisplayText, TimeStamps, ...
                         TimeCodes, KeyCodes, j);
            
            % Wait / Get a get Press
            [TimeStamps, TimeCodes, KeyCodes, j] = ...
                GetKeyPress(Keys, TimeStamps, ...
                            TimeCodes, KeyCodes, j);
            
            % Draw an Image onto the screen
            [TimeStamps, TimeCodes, KeyCodes, j] = ...
                DrawImage(WSS, TI(i), TimeStamps, ...
                          TimeCodes, KeyCodes, j);
            
            % Wait / Get a get Press
            [TimeStamps, TimeCodes, KeyCodes, j] = ...
                GetKeyPress(Keys, TimeStamps, ...
                            TimeCodes, KeyCodes, j);
            
            if i ~= size(Images,2) % Skip on the last round
            
            % Draw a Fixation Point onto the screen
            [TimeStamps, TimeCodes, KeyCodes, j] = ...
                DrawFixationPt(WSS, RSS, TimeStamps, ...
                               TimeCodes, KeyCodes, j);

            % Wait / Get a get Press
            [TimeStamps, TimeCodes, KeyCodes, j] = ...
                GetKeyPress(Keys, TimeStamps, ...
                            TimeCodes, KeyCodes, j);
            end
        end
        
        Screen('Close', TI); % Close the Open Textures
        
    case 3
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

function [TimeStamps, TimeCodes, KeyCodes, j] = ...
    DrawText(WSS, DisplayText, TimeStamps, TimeCodes, KeyCodes, j)

% Draw / Display Text            
DrawFormattedText(WSS, DisplayText,  'center', 'center', 0 , 45);
TimeStamps(j) = Screen('Flip',WSS);
KeyCodes(j) = -1;
TimeCodes(j) = 5;
j = j+1; % Advance Counter
end

function [TimeStamps, TimeCodes, KeyCodes, j] = ...
    DrawImage(WSS, Image, TimeStamps, TimeCodes, KeyCodes, j)

% Draw / Display Image            
Screen('DrawTexture', WSS, Image);
TimeStamps(j) = Screen('Flip',WSS);
TimeCodes(j) = 6;
KeyCodes(j) = -1;
j = j+1; % Advance Counter
end

function [TimeStamps, TimeCodes, KeyCodes, j] = ...
    DrawFixationPt(WSS, RSS, TimeStamps, TimeCodes, KeyCodes, j)

% Draw / Display Fixation Point              
Screen('FillRect', WSS, 128, RSS);
Screen('DrawDots', WSS, [0, 0], 10, 255*[1 0 0 1], ...
       [RSS(3)/2 RSS(4)/2], 1);
Screen('DrawingFinished', WSS);
TimeStamps(j) = Screen('Flip',WSS);
KeyCodes(j) = -1;
TimeCodes(j) = 7;
j = j+1; % Advance Counter
end

function [TimeStamps, TimeCodes, KeyCodes, j] = ...
    GetKeyPress(Keys, TimeStamps, TimeCodes, KeyCodes, j)

% Wait For Key Press / Get Responce            
keyIsDown=0;
while keyIsDown == 0
    [keyIsDown, KeyPressTime, keyCode] = KbCheck(-1);
    if keyIsDown == 1
       if (keyCode(Keys.TRKey1) | ...
           keyCode(Keys.TRKey2) | ...
           keyCode(Keys.TRKB))
           keyIsDown = 0;
       end
    end
end
while KbCheck(-1); end % clear keyboard queue
TimeStamps(j) = KeyPressTime;
KeyCodes(j) = find(keyCode,1);
TimeCodes(j) = 8;
j = j+1; % Advance Counter
end

