function StaglinPTB(TestSubject)
% St aglinPTB(TestSubject) *****************************************
%
% This program was written for a tutorial for Dr Bookhiemers Lab 
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
%
%******************************************************************
%
% see also: ExampleParadigmBlock, ExampleParadigmJitter, ...
%           Activate_Screens, RealTimeAnalysis 
%
%******************************************************************

%% TEST MODE ?

TestMode = 1;
if TestMode == 1
  disp('***** Test mode enabled. No data saving. *****')
end

%% Who is the Subject ?
if nargin < 1
  TestSubject = input('Who is the Test Subject? Ex: JD ==> ', 's');
end

if isempty(TestSubject)
    TestMode = 1;
    disp('***** Test mode enabled. No data saving. *****')   
end


Params.TestSubject = TestSubject;

%% Set up the program

% Description
Params.LabGroup = 'Rodriguez';
Params.ExperimentName = 'Test';
Params.ExperimentPurpose = 'To Show off the wonders of PTB';
Params.ExperimentTask = 'Execute Block and Jitter Designs';

% Design
Params.Design = 'Block'; % 'Jitter'; % 
    if strcmpi(Params.Design, 'Block') == 1
        DesignType = 0;
    elseif strcmpi(Params.Design, 'Jitter') == 1
        DesignType = 1;
    end
Params.TotalBlocks = 3;
switch DesignType
    case 0
        Params.BlockLenght = 10; % Block Durrantion in sec 
                                 % (May not be used)
        Params.BlockLenghtMax = 'N/A';
        Params.BlockLenghtMin = 'N/A';
        Params.ISILenght   = 5; % Inter-Stimulus interval in sec
        Params.ISIMax = 'N/A';
        Params.ISIMin = 'N/A';
    case 1
        Params.BlockLenght = 'N/A';
        Params.BlockLenghtMax = 30; % Max Block Durrantion (sec)
        Params.BlockLenghtMin =  5; % Min Block Durrantion (sec)
        Params.ISILenght = 10; % Inter-Jitter Block interval in sec
        Params.ISIMax = 5; % Max Inter-Stimulus interval (sec)
        Params.ISIMin = 1; % Min Inter-Stimulus interval (sec)
end
Params.DrawFixationPt = 1; % 1 = On, 0 = Off
Params.RTA = 1; %Real Time Analysis 1 = On, 0 = Off
Params.UseOneMonitor = 1; % Only use 1 monitor otherwise 
                          % use 2 if available and not in TestMode

% Hardware
Params.MonitorType = 'Projector'; % 'Goggles';
    if strcmpi(Params.Design, 'Projector') == 1
        MonitorType = 0;
    elseif strcmpi(Params.Design, 'Goggles') == 1
        MonitorType = 1;
    end
Params.EEG = 0; % using the EGI EEG system Simultainiouly? 
                % No = 0 or Yes = 1
Params.DAQ = 0; % using the Arduino DAQ? No = 0 or Yes = 1
Params.NetStationPort = 55513; % Net Station Port ID
Params.NetStationIP = '169.254.223.206'; % Net Station IP

%% Unpack The Param Struct to save on typing

DrawFixationPt = Params.DrawFixationPt; 
RTA = Params.RTA; 
UseOneMonitor = Params.UseOneMonitor; 
NumberOfBlocks = Params.TotalBlocks;
BlockLenght = Params.BlockLenght;
ISI = Params.ISILenght;
DAQ = Params.DAQ;
EEG = Params.EEG;

%% Constants

Constants.SSE = 0; % Location in deg of left screen center wrt the
                   % test subject's fixation
Constants.ESE = 0; % Location in deg of Right screen center wrt the
                   % Experimenter's fixation
Constants.XOffset = 0; % horizontal stimulus position 
                       % (-)left, (+)right
Constants.YOffset = 0; % vertical stimulus position
                       % (-)up, (+)down
Constants.Computer = Screen('Computer'); % Get The Computer ID
Constants.PTBVersion = Screen('Version'); % Get The PTB Version

Params.Constants = Constants;

%% Initialize SaveFile Variables

% Store the Variables for all trials (VAT) 
VAT.TimeStamps = [];
VAT.TScode     = [];
VAT.KeyCode    = [];
VAT.PresentationOrder = [];


% TScode | Event
Params.TScodeIDTable = {...
  ['   0 | EEG Recording Start'];...
  ['  -2 | EEG Recording End'];...
  ['   1 | Scan Begins (First TR recorded)'];...
  ['  -1 | Matlab Stops Recording Events'];...
  ['   2 | Subject Press Button For Experiment to Begin'];...
  ['   3 | Block Starts'];...
  ['   4 | Block Ends'];...
  ['   5 | Trial Text Displayed'];...
  ['   6 | Trial Image Displayed'];...
  ['   7 | Trial Fixation Point Displayed'];...
  ['   8 | Subject Responce'];...
  ['  10 | Movie Frame Displayed']};


%% Establish Output Files

filename  = [Params.LabGroup, '_Group_Experiment_', ...
             Params.ExperimentName, '_', ...
             datestr(now,'yyyymmdd_HHMMSS'), ...
             'Subject_', TestSubject];

switch Params.LabGroup
    case 'Rodriguez'
        if IsWin
            data_folder = ' ';
            backup_data_folder = ' ';
        else
            data_folder = '/Users/Cameron/Documents/MATLAB/Data/';
            backup_data_folder = ...
                '/Users/Cameron/Documents/MATLAB/BackupData/'; ...
                % A network drive would be ideal
        end
    case 'Cohen'
        if IsWin
            data_folder = ' ';
            backup_data_folder = ' ';
        else
            data_folder = ' ';
            backup_data_folder = ' ';
        end
    case 'Bookheimer'
        if IsWin
            data_folder = ' ';
            backup_data_folder = ' ';
        else
            data_folder = ' ';
            backup_data_folder = ' ';
        end    
end         
SaveFolder.data_folder = data_folder;
SaveFolder.backup_data_folder = backup_data_folder; 
SaveFolder.filename = filename;

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

RandStream.setDefaultStream(...
                    RandStream('mt19937ar','seed',sum(100*clock)));

%% Initialize the DAQ
    
if DAQ == 1
    DIO = arduino('/dev/tty.usbmodem621');
    for i = 2:19
        DIO.pinMode(i,'output'); DIO.digitalWrite(i,0)
    end
else
    DIO = [];
end
    
%% Activate/Check the EEG capture
if EEG == 1
    NS_Code(1) = {'BLSt'}; % Baseline Start
    NS_Duration(1) = 15;
     
    NS_Code(2) = {'BLEn'}; % Baseline End
    NS_Duration(2) = 0;
     
    NS_Code(3) = {'TrSt'}; % Trial Start
    NS_Duration(3) = 0;
     
    NS_Code(4) = {'TrEn'}; % Trial End
    NS_Duration(4) = 0;
    
    Params.NScode = NS_Code;
    Params.NSduration = NS_Duration;

    NSPT = Params.NetStationPort; % Done for formatting
    NSIP = Params.NetStationIP; % Done for formatting
    [status, error] = NetStation('Connect', NSIP, NSPT);
    
    if status ~= 0 % Kill Program
        disp(error); return;
    end

    NetStation('Synchronize'); NetStation('StartRecording');
    VAT.TimeStamps = [VAT.TimeStamps, GetSecs];
    VAT.TScode     = [VAT.TScode, 0];
    VAT.KeyCode    = [VAT.KeyCode, -1];
end
% doc NetStation  
%% Open Screens

    [ScreenHandels, Screen_Parameters, PPD_DPP] = ...
        Activate_Screens(Constants, Params);
    WES = ScreenHandels.WES; % Window Handel Right Screen
    RES = ScreenHandels.RES; % Window Rectangle Right Screen
    WSS = ScreenHandels.WSS; % Window Handel Left Screen
    RSS = ScreenHandels.RSS; % Window Rectangle Left Screen
    
    Params.Screen_Parameters = Screen_Parameters;
    Params.PPD_DPP = PPD_DPP;

%% Set up the Intertrial Interval

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

%% Wait For Key Press

Text = 'Press Any Key To Begin';
DrawFormattedText(WSS, Text, 'center', 'center', 0 , 45);
Screen('Flip',WSS);
% doc KbCheck
while KbCheck(-1); end % clear keyboard queue
while ~KbCheck(-1); end % wait for a key press
    VAT.TimeStamps = [VAT.TimeStamps, GetSecs];
    VAT.TScode     = [VAT.TScode, 2];
while KbCheck(-1); end % clear keyboard queue

%% Run Experiment

try % Start Try - Catch
      
    %% Run The Display loop
    
    switch DesignType
        case 0
            disp('BLOCK DESIGN')
            for i = 1:NumberOfBlocks
                Screen('FillRect', WSS, 128, RSS);
                Screen('DrawDots', WSS, [0, 0], 10, ...
                        255*[1 0 0 1], [RSS(3)/2 RSS(4)/2], 1);
                Screen('DrawingFinished', WSS); 
                Screen('Flip',WSS);
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
                
%                 TrialVariables = ...
%                     ExampleParadigmBlock(i, Params, ScreenHandels);
                
                TrialVariables = ...
                    ExampleParadigm(i, Params, ScreenHandels);
                
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
        

    %% Stop Recording & Disconnnect the Netstation
    
    if EEG == 1
        WaitSecs(2); % for some padding of the EEG data
        NetStation('StopRecording');
        NetStation('Disconnect');
        VAT.TimeStamps = [VAT.TimeStamps, GetSecs];
        VAT.TScode     = [VAT.TScode, -2];
        VAT.KeyCode    = [VAT.KeyCode,-1];
    end
   
%% Save The Raw Data

    % Settings.NS_Code = NS_Code;
    % Settings.NS_Duration = NS_Duration;
    % Settings.DaqSettings = [];        

   % End Event Capture
    VAT.TimeStamps = [VAT.TimeStamps, GetSecs];
    VAT.TScode     = [VAT.TScode, -1];
    VAT.KeyCode    = [VAT.KeyCode,-1];
    if TestMode == 0
        save([data_folder,filename,'.mat'], ...
            'Params', 'VAT');
        save([backup_data_folder,filename,'.mat'], ...
            'Params', 'VAT');
    end

%% All Done Time For Fun

    DrawFormattedText(WSS, 'ALL DONE TIME FOR FUN!!!', ...
                      'center', 'center', 0 , 45);
    Screen('Flip',WSS);
    WaitSecs(2);

%% Do some clean up
    
    Screen('CloseAll'); % Close PTB windows
    ShowCursor;   
    if DAQ == 1 % Close the DAQ if open
        delete(DIO);
    end
        
%% Run Some Quick Stats % Analysis
    
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
        save([data_folder,'CrashSave_',filename,'.mat'],...
             'Params', 'VAT', 'lasterr');
        save([backup_data_folder,'CrashSave_',filename,'.mat'], ...
             'Params', 'VAT', 'lasterr');      
    end
    
    % Stop Recording & Close the EEG 
    if EEG == 1
        WaitSecs(2); % for some padding of the EEG data
        NetStation('StopRecording');
        NetStation('Disconnect');
        VAT.TimeStamps = [VAT.TimeStamps, GetSecs];
        VAT.TScode     = [VAT.TScode, -2];
        VAT.KeyCode    = [VAT.KeyCode,-1];
    end
    
    % Restore the Keyboard
    olddisabledkeys = DisableKeysForKbCheck([]); 
    
    % Show the Cursor
    ShowCursor;
    
    % Close the DAQ if open
    if DAQ == 1 
        delete(DIO);
    end
    
    rethrow(lasterr)
end % End Try - Catch
    
%% Clear the Buffers
    ShowCursor;
    if DAQ == 1
        delete(DIO);
    end
    clear all;
end % All Done, That's All He Wrote

%% Subfunctions

% None
