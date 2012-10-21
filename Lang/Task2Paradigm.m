function TrialVariables = ...
    Task2Paradigm(BlockNumber, Params, ScreenHandels, Task)
% TrialVariables = ...
% ExampleParadigmBlock(BlockNumber, Params, ScreenHandels)
%******************************************************************
%	Description:
%		Runs TaskBlock based on given Task and BlockNumber
%
%	Inputs:
%		BlockNumber: is which block to run under Task
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
% see also: StaglinPTB, ExampleParadigmJitter, ...
%           Activate_Screens, RealTimeAnalysis 
% [ 0 0 1280 1024 ] Horizontal, Vertical
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
% Set Images
Images      = Task.Block{BlockNumber}.Images;
ImageNames  = Task.Block{BlockNumber}.ImageNames;
ImageSize   = Task.Block{BlockNumber}.ImageSize;

% Set Sentences
Sentences   = Task.Block{BlockNumber}.Sentences;

% Set Sound
SoundData   = Task.Block{BlockNumber}.Sounds;
SoundFreq   = Task.Block{BlockNumber}.SoundsFreq;
Channel     = Task.Block{BlockNumber}.Channel;

%Set Timing
Time =  Task.Timing;


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
TimeCodes = nan(1, 1000);
TimeStamps = nan(1, 1000);
KeyCodes = nan(1, 1000);

%% Run The Experiment Based on which block it is
TI = zeros(size(Images));% Texture index

TimeStamps(1) = GetSecs;
TimeCodes(1) = 3; % Block Begin
KeyCodes(1) = -1; % No Key Press

% Make Textures for Images
for i = 1:size(Images,2)
    TI(i)=Screen('MakeTexture', WSS, Images{i});
end

switch BlockNumber
    %  Object vs Subject Production
    case { 1, 2, 3, 4}
        j = 2;% Set inital point for counter
        
        %% Display Instructions only if First Block
        if ( BlockNumber == 1 ) 
            % Transition Slides
            [TimeStamps, TimeCodes, KeyCodes, j] = ... 
                DrawFixationPt(WSS, RSS, TimeStamps, ...
                        TimeCodes, KeyCodes, j);
            WaitSecs(Time.InstrProBreak);

            % Display Text
            DisplayText = Task.Instr.Pro
            [TimeStamps, TimeCodes, KeyCodes, j] = ... 
                DrawText(WSS, DisplayText, TimeStamps, ... 
                TimeCodes, KeyCodes, j); 

            % Play Instructions
            InstrSound = Task.Instr.Sounds{Task.Instr.ProChoice+1};
            InstrChannel = Task.Instr.Channel{Task.Instr.ProChoice+1};
            InstrFreq = Task.Instr.SoundsFreq{Task.Instr.ProChoice+1};
            [ Handel ] = PlaySound(InstrSound, InstrChannel, ...
                    InstrFreq);

            % Wait X Seconds 
            WaitSecs(Time.InstrPro);
            % Close Sound Buffer
            PsychPortAudio('Stop', Handel); 

        end
   
        %% Draw the Textures
        for i = 1:size(Images,2)

            % Draw an Image onto the screen
            [TimeStamps, TimeCodes, KeyCodes, j] = ...
                DrawImageCenter(WSS, TI(i), TimeStamps, TimeCodes, ... 
                KeyCodes, j, ImageSize{i}, Params.ScreenSize);
                %char(Sentences(i))

	    	% Play Sound Sentence
	    	[ Handel ] = PlaySound(SoundData{i}, Channel{i}, SoundFreq{i});

            % Wait X Secs 
            WaitSecs(Time.ResponsePro+Time.AudioPro); 
            
            if i ~= size(Images,2) % Skip on the last round
                % Draw a Fixation Point onto the screen
                [TimeStamps, TimeCodes, KeyCodes, j] = ...
                    DrawFixationPt(WSS, RSS, TimeStamps, ...
                                   TimeCodes, KeyCodes, j);

                % Finish/Close
                WaitSecs(Time.StimBreak); % Wait time in Seconds
                %i = i+1;
                
            end
            PsychPortAudio('Stop', Handel); % Close Sound Buffer
        end
        Screen('Close', TI); % Close the Open Textures
        
    otherwise
    % etc ...
	    % Draw an Image onto the screen
            % [TimeStamps, TimeCodes, KeyCodes, j] = ...
            %    DrawImageCenter(WSS, TI(i), TimeStamps, ...
            %            TimeCodes, KeyCodes, j, ... 
            %            ImageSize{i}, Params.ScreenSize, ...
            %            char(Sentences(1)) );
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
TrialVariables.POrder = [];

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
Screen('DrawTexture', WSS, Image, [0 0 640 512] );
TimeStamps(j) = Screen('Flip',WSS);
TimeCodes(j) = 6;
KeyCodes(j) = -1;
j = j+1; % Advance Counter
end


%%%%%%%%%%%%%%%%%%%%%%%
%%% DRAW SINGLE IMAGE %
%%%%%%%%%%%%%%%%%%%%%%%
function [TimeStamps, TimeCodes, KeyCodes, j] = ...
    DrawImageCenter(WSS, Image, TimeStamps, TimeCodes, KeyCodes, j, ...
        ImageSize, ScreenSize)

% Draw / Display Image            
SCenter = ScreenSize / 2;
SourceDImage = [0 0 ImageSize(2) ImageSize(1)];

%%%%%%%%%%%%%%%%%%%%%%%%
% CHANGE MAX SIZE HERE %
%%%%%%%%%%%%%%%%%%%%%%%%
% Set Image Max Size
X = SCenter(2) * 3/2;
Y = SCenter(1) * 3/2;
if X < Y
    X = Y;
else
    Y = X;
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

TimeStamps(j) = Screen('Flip',WSS);
TimeCodes(j) = 6;
KeyCodes(j) = -1;
j = j+1; % Advance Counter
end

%%%%%%%%%%%%%%%%%%%%%
%%% DRAW Dual IMAGE %
%%%%%%%%%%%%%%%%%%%%%
function [TimeStamps, TimeCodes, KeyCodes, j] = ...
    DrawImageDual(WSS, Image1, Image2, TimeStamps, TimeCodes, KeyCodes, ...
        j, Image1Size, Image2Size, ScreenSize, LEFT)

% Draw / Display Image            
SCenter = ScreenSize / 2;
SourceD1Image = [0 0 Image1Size(2) Image1Size(1)];
SourceD2Image = [0 0 Image2Size(2) Image2Size(1)];
%%%%%%%%%%%%%%%%%%%%%%%%
% CHANGE MAX SIZE HERE %
%%%%%%%%%%%%%%%%%%%%%%%%
% Set Image Max Size
X = 600;
Y = 600;

% Calculate Resizing 
[X1 Y1] = Cize(X, Y,  Image1Size(2),  Image1Size(1));
[X2 Y2] = Cize(X, Y,  Image2Size(2),  Image2Size(1));

%% Image Destination
DestD1Image = Fsize( SCenter, X1, Y1, 0, 1 );
DestD2Image = Fsize( SCenter, X2, Y2, 0, 3 );

% Draw White Background Image
DestD1White = Fsize( SCenter, X, Y, 0, 1 );
DestD2White = Fsize( SCenter, X, Y, 0, 3 );
white = WhiteIndex(WSS)
Screen('FillRect', WSS, white, DestD1White );
% Draw Image on Top
Screen('DrawTexture', WSS, Image1, SourceD1Image, DestD1Image);
if LEFT == 0
    Screen('FillRect', WSS, white, DestD2White );
    Screen('DrawTexture', WSS, Image2, SourceD2Image, DestD2Image);
end

% Display Text
%DrawFormattedText(WSS, DisplayText,  'center', SCenter(1) - 450, 0 , 45);

TimeStamps(j) = Screen('Flip',WSS);
TimeCodes(j) = 6;
KeyCodes(j) = -1;
j = j+1; % Advance Counter
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
DestImage = [ X1 Y1 X2 Y2 ];
end


%% PLAY SOUND
function [ SoundHandel ] = PlaySound( SoundData, Channel, SoundFreq )
SoundHandel = PsychPortAudio('Open', [], [], 0, SoundFreq, Channel);
PsychPortAudio('FillBuffer', SoundHandel, SoundData');
StartMusic = PsychPortAudio('Start', SoundHandel, 1, 0, 1);
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

function [TimeStamps, TimeCodes, KeyCodes, j, RT] = ...
    GetKeyPressWithTimeOut(Keys, TimeStamps, TimeCodes, KeyCodes, j)

baseTime = GetSecs;
gotgood = false;
maxTime = 4;

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
    KeyCodes(j) = find(keyCode,1);
    TimeCodes(j) = 8;
    j = j+1; % Advance Counter
end

