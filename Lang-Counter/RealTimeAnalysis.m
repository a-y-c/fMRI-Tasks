function RealTimeAnalysis(VAT, Params)
% RealTimeAnalysis(VAT, Params)
%
% This program was written to give a quick peek at the data 
% recorded from the display computer.  This can be used to make
% sure everything is recording properly
%
%******************************************************************
%
% Written by Cameron Rodriguez
% Last Modified 2012/02/05
%
%******************************************************************
%
% see also: StaglinPTB, ExampleParadigmJitter, ...
%           ExampleParadigmJitter, Activate_Screens
%
%******************************************************************

%% Unpack the Structures

TimeStamps = VAT.TimeStamps;
TScode = VAT.TScode;
KeyCode = VAT.KeyCode;

EEG = Params.EEG;

MRStInds = find(TScode == 1);
MRStInd = min(MRStInds);
MREndInds = numel(TScode);
MREndInd = max(MREndInds);

if EEG == 1
    EEGStInds = find(TScode==0);
    EEGStInd = min(EEGStInds);
    EEGEndInds = find(TScode==100,1);
    EEGEndInd = max(EEGEndInds);
else
    EEGStInds = []; EEGStInd = [];
    EEGEndInds = []; EEGEndInd = [];
end

%% Look at the Time Stamps and Codes recorded

% Time from the Start on the MRI clock
TimeFromStartMRI = TimeStamps-TimeStamps(MRStInd); 
if EEG == 1 % Time from the Start on the EEG clock
    TimeFromStartEEG = TimeStamps-TimeStamps(EEGStInd); 
    disp('Assuming a sampling rate for the EEG of 250Hz');
    SamplesFromStart = 250*TimeFromStart;
    EEGTimeLength = TimeStamps(EEGEndInd)-TimeStamps(EEGStInd);
end

BlockStInds =  find(TScode == 3);
BlockEndInds = find(TScode == 4);

MRTimeLength = TimeStamps(MREndInd)-TimeStamps(MRStInd);

disp('***********************************************************')
disp('***********************************************************')

disp('The Display Computers Data File Contains:')
disp(' ')
disp(['   ', num2str(numel(EEGStInds)),...
      ' Netstation Record Start Point(s)'])
disp(['   ', num2str(numel(EEGEndInds)),...
      ' Netstation Record End Point(s)'])

disp(['   ', num2str(numel(BlockStInds)),' Block Start Point(s)'])
disp(['   ', num2str(numel(BlockEndInds)),' Block End Point(s)'])
disp(' ')
disp('***********************************************************')
disp(' ')
disp(['MRI Scan Time Length: ', ...
      num2str(MRTimeLength), ' sec'] )
if EEG == 1
disp(['EEG Time Record Time Length: ', ...
      num2str(EEGTimeLength),' sec'])
end
disp(' ')
disp('***********************************************************')
disp('***********************************************************')


if EEG == 1 % EEG Component to the Data
    
figure(50)
     % Plot Time From MRI Start Versus the Time Stamp Index
    subplot(4,1,1)
        plot(TimeFromStartMRI); 
        xlabel('Time Stamp #');
        ylabel('Time From First Recieve TR Pulse (Sec)');
        axis 'tight'
    % Plot Time From EEG Start Versus the Time Stamp Index
    subplot(4,1,2) 
        plot(TimeFromStartEEG); 
        xlabel('Time Stamp ');
        ylabel('Time From EEG Start (Sec)');
        axis 'tight'
    % Plot EEG Samples From Recording Start Versus
    % the Time Stamp Code Index
    subplot(4,1,3)
        plot(SamplesFromStart); 
        xlabel('Time Stamp Index');
        ylabel('Samples From Start');
        axis 'tight'
    % Plot Event Codes Versus the Time Stamp Index
    subplot(4,1,4)
        plot(TScode);
        ylabel('Event Code');
        xlabel('Time Stamp Index');
        axis 'tight'
        
else % No EEG Component to the Data
    
    figure(50)
    % Plot Time From MRI Start Versus the Time Stamp Index
    subplot(2,1,1)
        plot(TimeFromStartMRI); 
        xlabel('Time Stamp #');
        ylabel('Time From First Recieved TR Pulse (Sec)');
        axis 'tight'

    % Plot Event Codes Versus the Time Stamp Index
    subplot(2,1,2)
        plot(TScode);
        ylabel('Event Code');
        xlabel('Time Stamp Index');
        axis 'tight'
        
end
