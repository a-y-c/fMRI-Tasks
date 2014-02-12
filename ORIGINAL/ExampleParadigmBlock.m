function TrialVariables = ExampleParadigmBlock(BlockNumber, Params, ScreenHandels)
% TrialVariables = ...
% ExampleParadigmBlock(BlockNumber, Params, ScreenHandels)
%
%******************************************************************
%
% Written by Cameron Rodriguez
% Last Modified 2012/02/08
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

%% Create a .mat file for the experiment Images (Only done once)

% ImageNames = {['male5_45r.JPG'];...
%               ['male5_45l.JPG'];...
%               ['male4_90r.JPG'];...
%               ['male4_0.JPG'];...
%               ['female2_45r.JPG'];...
%               ['female2_0.JPG'];...
%               ['female1_90l.JPG'];...
%               ['female1_45l.JPG']};
%           
% ImageValues = [5 10 25 50 5 10 25 50];
% save([folder, '/ExperimentSettings.mat'], ...
%       'ImageNames', 'ImageValues', 'Images')
% 
% for i = 1:size(ImageNames,1)
%     Images{i} = imread([folder, ImageNames{i}]);
% end
% 
% save([folder, 'ExperimentSettings.mat'], 'ImageNames', ...
%       'ImageValues', 'Images')

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
        for i = 1:size(Images,2) % MAke the Textures
            % textureIndex = Screen('MakeTexture', WindowIndex, ...
            %                        imageMatrix, ...
            %                        [, optimizeForDrawAngle=0] ...
            %                        [, specialFlags=0] 
            %                        [, floatprecision=0] 
            %                        [, textureOrientation=0] 
            %                        [, textureShader=0]);
            TI(i)=Screen('MakeTexture', WSS, Images{Perm(i)});
        end
        j = 2;% Set inital point for counter
        for i = 1:size(Images,2) % Draw the Textures
            DisplayText = [num2str(ImageValues(Perm(i))),'¢'];
            DrawFormattedText(WSS, DisplayText, ...
                              'center', 'center', 0 , 45);
            TimeStamps(j) = Screen('Flip',WSS);
            TimeCodes(j) = 5;
            KeyCodes(j) = -1;
            j = j+1; % Advance Counter
            Screen('DrawTexture', WSS, TI(i));
            WaitSecs(0.5-ifiS);
            
            % Screen('DrawTexture', windowPointer, texturePointer
            % [,sourceRect] [,destinationRect] [,rotationAngle] ...
            % [, filterMode] [, globalAlpha] [, modulateColor] ...
            % [, textureShader] [, specialFlags] [, auxParameters])
            
            %Screen('PutImage', WLS, Images{Perm(i)});
            
            % [VBLTimestamp StimulusOnsetTime ...
            % TimeStampstamp Missed Beampos] = Screen('Flip', ...
            % windowPtr [, when] [, dontclear] [, dontsync] ...
            % [, multiflip]);
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
            if i~= size(Images,2)
                WaitSecs(0.5-ifiS);
            end  
        end
        
        Screen('Close', TI); % Close the Open Textures
        
    case 2
        for i = 1:size(Images,2) % Make the Textures
            TI(i)=Screen('MakeTexture', WSS, Images{Perm(i)});
        end
        j = 2;% Set inital point for counter
        for i = 1:size(Images,2) % Draw the Textures
            DisplayText = [num2str(ImageValues(Perm(i))),'¢'];
            DrawFormattedText(WSS, DisplayText, ...
                              'center', 'center', 0 , 45);
            TimeStamps(j) = Screen('Flip',WSS);
            TimeCodes(j) = 5;
            if i == 1
                KeyCodes(j) = -1;
            else
                KeyCodes(j) = find(keyCode,1);
            end
            j = j+1; % Advance Counter
            
            keyIsDown=0;
            while keyIsDown == 0
                [keyIsDown, KeyPressTime, keyCode] = KbCheck(-1);
                if keyIsDown == 1
                   if (keyCode(TRKey1) | ...
                       keyCode(TRKey2) | ...
                       keyCode(TRKB))
                       keyIsDown = 0;
                   end
                end
            end
            while KbCheck(-1); end % clear keyboard queue
            
            Screen('DrawTexture', WSS, TI(i));
            TimeStamps(j) = Screen('Flip',WSS);
            TimeCodes(j) = 2;
            KeyCodes(j) = find(keyCode,1);
            j = j+1; % Advance Counter
            
            keyIsDown=0;
            while keyIsDown == 0
                [keyIsDown, KeyPressTime, keyCode] = KbCheck(-1);
                if keyIsDown == 1
                   if (keyCode(TRKey1) | ...
                       keyCode(TRKey2) | ...
                       keyCode(TRKB))
                       keyIsDown = 0;
                   end
                end
            end
            while KbCheck(-1); end % clear keyboard queue
            
            Screen('FillRect', WSS, 128, RSS);
            Screen('DrawDots', WSS, [0, 0], 10, 255*[1 0 0 1], ...
                   [RSS(3)/2 RSS(4)/2], 1);
            Screen('DrawingFinished', WSS); 
            TimeStamps(j) = Screen('Flip',WSS);
            KeyCodes(j) = find(keyCode,1);
            TimeCodes(j) = 2;
            j = j+1; % Advance Counter
            
            keyIsDown=0;
            while keyIsDown == 0
                [keyIsDown, KeyPressTime, keyCode] = KbCheck(-1);
                if keyIsDown == 1
                   if (keyCode(TRKey1) | ...
                       keyCode(TRKey2) | ...
                       keyCode(TRKB))
                       keyIsDown = 0;
                   end
                end
            end
            while KbCheck(-1); end % clear keyboard queue
        end
        
        Screen('Close', TI); % Close the Open Textures
        
    case 3
        j = 2;% Set inital point for counter
        
        % Start playback of movie. This will start
        % the realtime playback clock and playback of audio tracks,
        % if any. Play 'movie', at a playbackrate = 1, and
        % 1.0 == 100% audio volume.
        
        MovieFile = 'MVI_1239.MOV'; % Splish Splash Norway
        % MovieFile = 'IMG_0288.MOV'; % Rargh Seal 
        [moviePtr movieduration fps imgw imgh] = ...
            Screen('OpenMovie', WSS, MovieFile);
        
        Screen('SetMovieTimeIndex', moviePtr, 0);
        rate = 1;
        Screen('PlayMovie', moviePtr, rate, 1, 1.0);
        i = 0;
        while i < movieduration*fps 
        i=i+1;
        % Only perform video image fetch/drawing if playback is 
        % active and the movie actually has a video track
        % (imgw and imgh > 0):
            if ((abs(rate)>0) & (imgw>0) & (imgh>0))
                % Return next frame in movie, in sync with current 
                % playback time and sound. tex either the texture
                % handle or zero if no new frame is ready yet. 
                % pts = Presentation timestamp in seconds.
                [tex pts] = ...
                  Screen('GetMovieImage', WSS, moviePtr,1,[],[],0);

                % Valid texture returned?
                if tex<=0
                    break;
                end

                % Draw the new texture immediately to screen:
                Screen('DrawTexture', WSS, tex);

                % Update display:
                vbl=Screen('Flip', WSS);
                TimeStamps(j) = vbl;
                KeyCodes(j) =  -1;
                TimeCodes(j) = 10;
                j=j+1;

                % Release texture:
                Screen('Close', tex);
                
                [keyIsDown,secs,keyCode]=KbCheck(-1);
                if (keyIsDown==1 & keyCode(space))
                % Exit while-loop: This will load the next movie...
                    break;
                end;
            end
        end

        Screen('CloseMovie', moviePtr);
        
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
