function StaglinPTB(TestSubject)
% StaglinPTB(TestSubject) *****************************************
%
% 2012/09/13
% Program is Design for Simple 3Picture/Rest Application
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
% Last Modified 2012/10/11
%
%******************************************************************
%
% Dependencies:
%   Setup.m             -Ask Name/Subject
%   ////Paramters.m         -Sets Parameters of Experiment
%   Task_data.mat       -Data Information
%   Paradigm.m          -Runs the Experiment
%   InitiateKeys.m      -Setups Keys for Input
%
%******************************************************************


%%%%%%%%%
% SETUP %
%%%%%%%%%
% Run Setup, Add into Params Struct
Params = [];
Params = Setup(Params);

% Run Parameters, Add into Params Struct
Params = Parameters(Params);

 %% Establish Output Files
Params.LogDir = 'LOG'
dircheck = exist(Params.LogDir);
if dircheck ~= 7
    Params.LogDir = '';
end
Params.Filename  = [ Params.LogDir, '/', Params.ExperimentName, '_', ... 
             datestr(now,'yyyymmdd_HHMMSS'), '_Subject_', Params.Subject.Name];
% Backup Folders
Params.Data_DIR = ''; 
Params.Backup_Data_DIR = ''; 


% Store the Variables for all trials (VAT) 
VAT.StartTime       = '';
VAT.TimeStamps      = []; 
VAT.TSCodes         = {}; 
VAT.j               = 1;
VAT.Results         = {};

%% Activate Keyboard
KbName('UnifyKeyNames');
FlushEvents('keyDown');
Keys = InitiateKeys;


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
%% Wait for the Scan to begin
Text = 'Waiting for MRI scan to begin...';
DrawFormattedText(WSS, Text, 'center', 'center', 0 , 45);
Screen('Flip',WSS);
                    
%% Wait for TR Signal
while KbCheck(-1); end % clear keyboard queue
Scanning = 0;
while Scanning ~= 1
    [keyIsDown, TimePt, keyCode] = KbCheck(-1);
    if ( keyCode(Keys.TRKey1) | keyCode(Keys.TRKey2) ...
            | keyCode(Keys.TRKB) )
        Scanning = 1; disp('Scan Has Begun');
        VAT.StartTime = TimePt;
        VAT.TimeStamps(VAT.j) = TimePt;
        VAT.TSCodes{VAT.j} = 'Scan Start';
        VAT.j = VAT.j + 1;
    end
end

% Keep KbCheck for looking for the TR signals
olddisabledkeys = DisableKeysForKbCheck([KbName('T'),KbName('5')]); 


%%%%%%%%%%%%%%%%%%%
%% Run Experiment %
%%%%%%%%%%%%%%%%%%%
try % Start Try - Catch
    disp('Starting Experiment')
        
    % Running Experiment
    [ VAT  ] = Paradigm(1, Params, ScreenHandels, VAT);

   % End Event Capture
    VAT.TimeStamps(VAT.j) = GetSecs - VAT.StartTime;
    VAT.TScode{VAT.j} = 'Scan End';
    VAT.j = VAT.j + 1;

%%%%%%%%%%%%%%%%%%%%%%%     
%% Save The Raw Data %%
%%%%%%%%%%%%%%%%%%%%%%%
    if TestMode == 0
        % Vat.TimeStamp Remade for better read
        save([Params.Data_DIR,Params.Filename,'.mat'], ...
            'Params', 'VAT');

        %save([Params.Backup_Data_DIR,Params.Filename,'.mat'], ...
        %    'Params', 'VAT');

        %xlsVAT = [VAT.Results.TrialNumber; VAT.Results.Response; ...
        %    VAT.Results.CueType; VAT.Results.StimulusType; ...
        %    VAT.Results.Latency; VAT.Results.Time_Cue_Onset; ...
        %    VAT.Results.Time_Stim_Onset; VAT.Results.Time_to_Fix ];
        %
        %xlswrite([Params.Backup_Data_DIR,Params.Filename], ...
        %    xlsVAT);
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
    if Params.TestMode == 0    
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
    
%% Clear the Buffers
    ShowCursor;
    clear all;
end % All Done, That's All He Wrote
