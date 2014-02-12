function StaglinPTB(TestSubject)
% StaglinPTB(TestSubject) *****************************************
%
% 2012/07/13
% Redesigned into FMRI_Language Test for Monika Polczynska
% New Outlook -> Cover Screen InBetween Scans
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

%%%%%%%%% ---------------------------------------------------------
% SETUP % ---------------------------------------------------------
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

%%%%%%%%%%%%%%%%%%%%
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



%%%%%%%%%%%%%%%%%%
%% Open Screens %
%%%%%%%%%%%%%%%%%
[ScreenHandels, Screen_Parameters, PPD_DPP] = Activate_Screens;
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
Escape = false;
while (~Escape)

    % Retrieve Scan Information from User Input
    [ TaskNumber ] = GetTaskNumber( WSS, RSS, Params.ScreenCenter ); 

    % If Quit Button was Hit
    if TaskNumber == 0
        %% Do some clean up
        Screen('CloseAll'); % Close PTB windows
        ShowCursor;   

        % CLEAR EVERYTHING
        clear all
        % Display All Clear Sign / Finish
        disp('ALL DONE')
        return
    end  

    %% Wait for the Scan to begin
    Text = 'Loading Task ...';
    DrawFormattedText(WSS, Text, 'center', 'center', 0 , 45);
    Screen('Flip',WSS);

    %% Fill in Parameters
    Params = Parameters(TestMode, TestSubject, TaskNumber, Params);
    % Load Data
    DataFile = [ 'Data_Task' num2str(TaskNumber) ];
    load(DataFile);
    if (TaskNumber == 1 )
        load( 'Data_Intro' );
    end
    
    % Clear Storage Variables
    VAT.TimeStamps = [];
    VAT.TimeCodes = [];
    VAT.KeyCodes = [];
    VAT.RT = [];

    % Delay for 1 Second
    WaitSecs(1);

%%%%%%%%%%%%%%
% BEGIN SCAN %
%%%%%%%%%%%%%%
%% Start Intro
    if ( TaskNumber == 1 )
        Text = 'Starting Intro ...';
        DrawFormattedText(WSS, Text, 'center', 'center', 0 , 45);
        Screen('Flip',WSS);

        % Delay for 2 Seconds
        WaitSecs(2); 
        % Show Intro
        IntroParadigm(Params, ScreenHandels, Intro);
    end
    
%%%%%%%%%%%%%%%%%%%
%% Run Experiment %
%%%%%%%%%%%%%%%%%%%
    try % Start Try - Catch

        %% Run Task
        disp(TaskNumber)
        switch TaskNumber
            case 1
                [VAT.TimeStamps  VAT.TimeCodes  VAT.KeyCodes VAT.RT] = ...
                    Task1Paradigm(Params, ScreenHandels, LTask)
            case 2
                [VAT.TimeStamps  VAT.TimeCodes  VAT.KeyCodes VAT.RT] = ...
                    Task2Paradigm(Params, ScreenHandels, LTask);
            case 3
                [VAT.TimeStamps  VAT.TimeCodes  VAT.KeyCodes VAT.RT] = ...
                    Task3Paradigm(Params, ScreenHandels, LTask);
            case 4
                [VAT.TimeStamps  VAT.TimeCodes  VAT.KeyCodes VAT.RT] = ...
                    Task4Paradigm(Params, ScreenHandels, LTask);
        end

        % Task End
        % Draw Fixation Point
        Screen('FillRect', WSS, 128, RSS);
        Screen('DrawDots', WSS, [0, 0], 10, ...
                255*[1 0 0 1], [RSS(3)/2 RSS(4)/2], 1);
        Screen('DrawingFinished', WSS); 
        Screen('Flip',WSS);
        
        
%%%%%%%%%%%%%       
% SAVE DATA % 
%%%%%%%%%%%%%

        % If Not in TestMode
        if TestMode == 0
            % Save Data
            save([Params.Data_DIR,Params.Filename,'.mat'], ...
                'Params', 'VAT');

            % Write Excel Format
            xlsVAT = [VAT.TimeStamps; VAT.TimeCodes; VAT.KeyCodes; VAT.RT];
            xlswrite([Params.Data_DIR,Params.Filename, '.csv'], ...
                xlsVAT);
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
   
%%%%%%%%%%%%%%%%%%
% FINISH/RESTART %
%%%%%%%%%%%%%%%%%%
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


end % End Escape Error
end % All Done, That's All she Wrote




%%%%%%%%%%%%%%%%%%
% Functions
%%%%%%%%%%%%%%%%%%

% GetCommand, Input Choices
function [ TaskNumber ] = GetTaskNumber(WSS, RSS, SCenter) 
    %% Set up the program, Ask for Task Number
    Escape = false;
    while (~Escape)
        MSG = 'Task Number? [1-4] or [Q]  ==> ';
        TaskNumber = GetEchoString(WSS, MSG, SCenter(1)/2, SCenter(2)/2);

        % Check if within range
        if isstrprop(TaskNumber, 'digit')  
            if  str2num(TaskNumber) > 4 || str2num(TaskNumber) < 1
                disp('Not within Range, Exiting')
            else
                TaskNumber = str2num(TaskNumber);
                Escape = true;
            end
        % If Exiting
        elseif (TaskNumber == 'q' || TaskNumber == 'Q')
            TaskNumber = 0;
            return 
        else
            disp('Not within Range, Exiting')
        end %End If isnumeric
    end  %End While Escape
end %End Function


% Code to be used to later on diable the MRI TR trigger Keys
% olddisabledkeys=DisableKeysForKbCheck([KbName('T'), KbName('5')])

% Code to be used to later on restore the MRI TR trigger Keys
% olddisabledkeys=DisableKeysForKbCheck([])

