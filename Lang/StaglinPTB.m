function StaglinPTB(TestSubject)
% StaglinPTB(TestSubject) *****************************************
%
% 2012/07/13
% Redesigned into FMRI_Language Test for Monika Polczynska
%
%
%
%
% 2012/02/07
% This program was written for for Dr Bookhiemers Lab 
% group on on Pyschtoolbox 3 on 2012/02/07. This was designed to be 
% template from which other code can be made. The StaglinPTB 
% program acts as a skeleton from which programs that run the Block 
% or Jitter design are called. The function Activate_Screens is 
% called to open screen(s)in PTB. RealTimeAnalysis displays the 
% captured data as a way to do a quick and dirty quality control of
% the run.    
%
%******************************************************************
%
% Written by Cameron Rodriguez cameron.rodrigue@gmail.com
% Last Modified 2012/02/08
% Modded by Andrew Cho	andrew.cho.52@gmail.com
% Last Modified 2012/06/011
%
%******************************************************************
%
% see also: ExampleParadigmBlock, ExampleParadigmJitter, ...
%           Activate_Screens, RealTimeAnalysis 
%
%******************************************************************


%%%%%%%%%
% SETUP %
%%%%%%%%%
%% Who is the Subject ?
if nargin < 1
  TestSubject = input('Who is the Test Subject? Ex: JD ==> ', 's');
end

if isempty(TestSubject)
    TestMode = 1;
    disp('***** Test mode enabled. No data saving. *****')   
else
    TestMode = 0;
end

%% Set up the program
TaskNumber = input('What Task Number do you want to do? [1-4]  ==> ');

if ~isnumeric(TaskNumber) || TaskNumber > 4 || TaskNumber < 1 
	eval error('Not within Range, Exiting')
end

%% Product or Comprehension
BlockChoice = input('Comprehension or Production? [C or P] ==> ', 's');

if ~(BlockChoice == 'P' || BlockChoice == 'C' || BlockChoice == 'p' || ...
        BlockChoice == 'c')
    eval error('Need C or P')
end
BlockChoice = upper(BlockChoice);

Params = Parameters(TestMode, TestSubject, TaskNumber, BlockChoice);
DataFile = [ 'Data_Task' num2str(TaskNumber) ];

%% Load Data
load(DataFile);
if (TaskNumber == 1 && BlockChoice == 'C')
    load( 'Data_Intro1' );
end

%% Unpack The Param Struct to save on typing
%NumberOfBlocks = Task.TotalBlocks;
if (BlockChoice == 'C')
    LBlocks = Task.CBlocks;
else
    LBlocks = Task.PBlocks;
end


% Store the Variables for all trials (VAT) 
VAT.TimeStamps = [];
VAT.TScode     = [];
VAT.KeyCode    = [];
VAT.PresentationOrder = [];


%% Activate Keyboard
KbName('UnifyKeyNames');
FlushEvents('keyDown');

OKKey = KbName('p');
KillKey = KbName('k');
TRKey1 = KbName('T'); % TR signal key
TRKey2 = KbName('5'); % TR signal key
TRKB = KbName('5%');  % Keyboard TR

KB1 = KbName('1!');   % Keyboard 1
KB2 = KbName('2@');   % Keyboard 2
KB3 = KbName('3#');   % Keyboard 3
KB4 = KbName('4$');   % Keyboard 4

%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%
% Button Box Mode: %
%    HHSC 1X5D     %
%  HID Key 12345   %
%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%

BB1 = KbName('1');    % Button Box 1 (Blue Key)
BB2 = KbName('2');    % Button Box 2 (Yellow Key)
BB3 = KbName('3');    % Button Box 3 (Green Key)
BB4 = KbName('4');    % Button Box 4 (Red Key)

% Code to be used to later on diable the MRI TR trigger Keys
% olddisabledkeys=DisableKeysForKbCheck([KbName('T'), KbName('5')])

% Code to be used to later on restore the MRI TR trigger Keys
% olddisabledkeys=DisableKeysForKbCheck([])

%% Initialize the random stream
%RandStream.setDefaultStream(...
%                    RandStream('mt19937ar','seed',sum(100*clock)));


%%%%%%%%%%%%%%%%%%
%% Open Screens %
%%%%%%%%%%%%%%%%%
[ScreenHandels, Screen_Parameters, PPD_DPP] = ...
    Activate_Screens(Params.Constants, Params);
WES = ScreenHandels.WES; % Window Handel Right Screen
RES = ScreenHandels.RES; % Window Rectangle Right Screen
WSS = ScreenHandels.WSS; % Window Handel Left Screen
RSS = ScreenHandels.RSS; % Window Rectangle Left Screen

Params.Screen_Parameters = Screen_Parameters;
Params.ScreenSize = Screen_Parameters.ResolutionSubject;
Params.ScreenCenter = Screen_Parameters.ResolutionSubject / 2;
Params.PPD_DPP = PPD_DPP;


%%%%%%%%%%%%%%%%%%%%
% START EXPERIMENT %
%%%%%%%%%%%%%%%%%%%%
%% Start Intro
if ( TaskNumber == 1 && BlockChoice == 'C')
    IntroParadigm(1, Params, ScreenHandels, Intro);
end


%% Wait for the Scan to begin
Text = 'Waiting for MRI scan to begin...';
DrawFormattedText(WSS, Text, 'center', 'center', 0 , 45);
Screen('Flip',WSS);
                    
while KbCheck(-1); end % clear keyboard queue
Scanning = 0;
while Scanning ~= 1
    [keyIsDown, TimePt, keyCode] = KbCheck(-1);
    if ( keyCode(TRKey1) | keyCode(TRKey2) | keyCode(TRKB) )
        Scanning = 1; disp('Scan Has Begun');
        VAT.TimeStamps = [VAT.TimeStamps, TimePt];
        VAT.TScode     = [VAT.TScode, 1];
        VAT.KeyCode    = [VAT.KeyCode, find(keyCode,1)];
    end
end

% Keep KbCheck for looking for the TR signals
olddisabledkeys = DisableKeysForKbCheck([KbName('T'),KbName('5')]); 



%%%%%%%%%%%%%%%%%%%
%% Run Experiment %
%%%%%%%%%%%%%%%%%%%
try % Start Try - Catch
    %% Run The Display loop    
    switch Params.DesignType
        case 0
            disp('BLOCK DESIGN')

            %%%%%%%%%%%%%%%%%%%%%
            % TEST Variable %%%%%
            %NumberOfBlocks = 1;
            %for i = 5:9
            for i = LBlocks
            disp(i)            
                
                %%%%%%%%%%%%%%%%%%%%%
                % TEST Variable %%%%%
                %i = 6;
                switch TaskNumber
                    case 1
                        TrialVariables = ...
                            Task1Paradigm(i, Params, ScreenHandels, Task);
                    case 2
                        TrialVariables = ...
                            Task2Paradigm(i, Params, ScreenHandels, Task);
                    case 3
                        TrialVariables = ...
                            Task3Paradigm(i, Params, ScreenHandels, Task);
                    case 4
                        TrialVariables = ...
                            Task4Paradigm(i, Params, ScreenHandels, Task);
                end

                % Block Break
                Screen('FillRect', WSS, 128, RSS);
                Screen('DrawDots', WSS, [0, 0], 10, ...
                        255*[1 0 0 1], [RSS(3)/2 RSS(4)/2], 1);
                Screen('DrawingFinished', WSS); 
                Screen('Flip',WSS);
                WaitSecs(Task.Timing.BlockBreak);
            
                VAT.TimeStamps = ...
                    [VAT.TimeStamps, TrialVariables.TimeStamps];
                VAT.TScode     = ...
                    [VAT.TScode, TrialVariables.TScode];
                VAT.KeyCode    = ...
                    [VAT.KeyCode, TrialVariables.KeyCodes];
                VAT.PresentationOrder = ...
                   [VAT.PresentationOrder, TrialVariables.POrder];
                
            end
        case 1
            disp('JITTER DESIGN')
            for i = 1:NumberOfBlocks
                
                if i~=1 %Skip on the first round
                    Text = ['Another Set Starting in ', ...
                            num2str(ISI), ' Seconds'];
                    DrawFormattedText(WSS, Text, ...
                                      'center', 'center', 0 , 45);
                    Screen('Flip',WSS);
                    WaitSecs(2);
                    Screen('FillRect', WSS, 128, RSS);
                    Screen('DrawDots', WSS, [0, 0], 10, ...
                            255*[1 0 0 1], [RSS(3)/2 RSS(4)/2], 1);
                    Screen('DrawingFinished', WSS); 
                    Screen('Flip',WSS);
                    WaitSecs(ISI-2);
                end
                
                TrialVariables = ...
                   ExampleParadigmJitter(i, Params, ScreenHandels);
               
                VAT.TimeStamps = ...
                    [VAT.TimeStamps, TrialVariables.TimeStamps];
                VAT.TScode = ...
                    [VAT.TScode, TrialVariables.TScode];
                VAT.KeyCode = ...
                    [VAT.KeyCode, TrialVariables.KeyCodes];
                VAT.PresentationOrder = ...
                    [VAT.PresentationOrder, TrialVariables.POrder];
                
            end
    end

   
%% Save The Raw Data
   % End Event Capture
    VAT.TimeStamps = [VAT.TimeStamps, GetSecs];
    VAT.TScode     = [VAT.TScode, -1];
    VAT.KeyCode    = [VAT.KeyCode,-1];
    if TestMode == 0
        % Vat.TimeStamp Remade for better read
        Base = VAT.TimeStamps(1);
        VAT.TimeSec = [];
        for time = VAT.TimeStamps
            VAT.TimeSec = [VAT.TimeSec, time - Base];
        end
        
        save([Params.Data_DIR,Params.Filename,'.mat'], ...
            'Params', 'VAT');
        %save([Params.Backup_Data_DIR,Params.Filename,'.mat'], ...
        %    'Params', 'VAT');
        
        xlsVAT = [VAT.TimeSec; VAT.TScode; VAT.KeyCode];
        xlswrite([Params.Data_DIR,Params.Filename], ...
            xlsVAT);
    end


%% Do some clean up
    Screen('CloseAll'); % Close PTB windows
    ShowCursor;   

        
%% Run Some Quick Stats % Analysis
    RTA = 0;
    if RTA == 1        
        RealTimeAnalysis(VAT, Params);
    end
    
catch lasterr
    % this "catch" section executes in case of an error in the
    % "try" section above.  The error is captured in "lasterr". 
    % Importantly, it closes the onscreen window(s).
    
    Screen('CloseAll');
    
    % Save what you can
    if TestMode == 0    
        save([Params.Filename,'CRASH.mat'],...
             'Params', 'VAT', 'lasterr');    
    end
    
    
    % Restore the Keyboard
    olddisabledkeys = DisableKeysForKbCheck([]); 
    
    % Show the Cursor
    ShowCursor;
    
    rethrow(lasterr)
end % End Try - Catch
    
%% Clear the Buffers
    ShowCursor;
    clear all;
end % All Done, That's All He Wrote
