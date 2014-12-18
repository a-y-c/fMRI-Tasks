function StaglinPTB(TestSubject)
% StaglinPTB(TestSubject) *****************************************
%
% 2014/12
% Redesigned into FMRI Alcohol Implicit Test for April Thames
%
%******************************************************************
%
% Written by Cameron Rodriguez cameron.rodrigue@gmail.com
% Last Modified 2012/02/08
% Modded by Andrew Cho	andrew.cho.52@gmail.com
%
%******************************************************************
%
% Dependencies:
%   Paramters.m
%
%******************************************************************

%%%%%%%%%
% SETUP %
%%%%%%%%%
%% Who is the Subject ?
if nargin < 1
  TestSubject = input('Who is the Test Subject? Ex: JD ==> ', 's');
end

%% Test Mode?
if isempty(TestSubject)
    TestMode = 1;
    disp('***** Test mode enabled. No data saving. *****')   
else
    TestMode = 0;
end

%% Load in Paramters
Params = Parameters(TestMode, TestSubject);

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

%% Initialize the random stream
RandStream.setDefaultStream(...
                    RandStream('mt19937ar','seed',sum(100*clock)));

%%%%%%%%%%%%%%%%%
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

% Store the Variables for all trials (VAT) 
VAT.TimeStamps      = [];
VAT.ResponseChoice  = []; % 1 = Correct, 0 = Incorrect
VAT.ResponseTime    = [];
VAT.CorrectTime     = [];
VAT.BlockNum        = [];


%% Wait for the Scan to begin
Text = 'Waiting for MRI scan to begin...';
DrawFormattedText(WSS, Text, 'center', 'center', 0 , 45);
Screen('Flip',WSS);
                    
%% Wait for TR Signal
while KbCheck(-1); end % clear keyboard queue
Scanning = 0;
while Scanning ~= 1
    [keyIsDown, TimePt, keyCode] = KbCheck(-1);
    if ( keyCode(TRKey1) | keyCode(TRKey2) | keyCode(TRKB) )
        Scanning = 1; disp('Scan Has Begun');
    end
end

% Keep KbCheck for looking for the TR signals
olddisabledkeys = DisableKeysForKbCheck([KbName('T'),KbName('5')]); 


%%%%%%%%%%%%%%%%%%%
%% Run Experiment %
%%%%%%%%%%%%%%%%%%%
try % Start Try - Catch
    for TaskNum = 1:length(Params.Task) 
        
        % Run Task
        TrialVariables = Paradigm(TaskNum, Params, ScreenHandels);
     
        VAT.TimeStamps      = [VAT.TimeStamps, TrialVariables.TimeStamps ];
        VAT.ResponseChoice  = [VAT.ResponseChoice, TrialVariables.ResponseChoice]; 
        VAT.ResponseTime    = [VAT.ResponseTime, TrialVariables.ResponseTime];
        VAT.CorrectTime     = [VAT.CorrectTime, TrialVariables.CorrectTime];
        VAT.BlockNum        = [VAT.BlockNum, TrialVariables.BlockNum];

        % End Event Capture
         if TestMode == 0
             % Vat.TimeStamp Remade for better read
             Base = VAT.TimeStamps(1);
             VAT.TimeSec = [];
             for time = VAT.TimeStamps
                 VAT.TimeSec = [VAT.TimeSec, time - Base];
             end

             save([Params.Data_DIR, Params.Filename,'.mat'], ...
                 'Params', 'VAT');

             xlsVAT = [VAT.TimeStamps; VAT.ResponseChoice; ...
                 VAT.ResponseTime; VAT.CorrectTime;  VAT.BlockNum ];
             
             xlswrite([Params.Data_DIR, Params.Filename], ...
                 xlsVAT);

         end
     end

     %%%%%%%%%%
     % FINISH %
     %%%%%%%%%%
     Text = 'Waiting for All Clear [p]';
     DrawFormattedText(WSS, Text, 'center', 'center', 0 , 45);
     Screen('Flip',WSS);

     % Catch [p] key to move onto next stimulus
     KeyEscape = false;
     while ~KeyEscape
         WaitSecs(0.01);
         keyIsDown = 0;
         [keyIsDown, secs, keyCode] = KbCheck(-1);
         if ( keyIsDown == 1 ) & keyCode(OKKey)
             KeyEscape = true;
         end
     end %End Loop

     %% Clear the Buffers
     olddisabledkeys = DisableKeysForKbCheck([]);

    %% Do some clean up
    Screen('CloseAll'); % Close PTB windows
    ShowCursor;   


catch lasterr
    % this "catch" section executes in case of an error in the
    % "try" section above.  The error is captured in "lasterr". 
    % Importantly, it closes the onscreen window(s).
    
    Screen('CloseAll');
    % Save what you can
    if TestMode == 0    
        save([Params.Data_DIR,'CrashSave_',Params.Filename,'.mat'],...
             'Params', 'VAT', 'lasterr');
        save([Params.Backup_Data_DIR,'CrashSave_',Params.Filename,'.mat'], ...
             'Params', 'VAT', 'lasterr');      
    end
    
    % Restore the Keyboard
    olddisabledkeys = DisableKeysForKbCheck([]); 
    
    % Show the Cursor
    ShowCursor;
    rethrow(lasterr)
end % End Try - Catch
    
end % All Done, That's All He Wrote
