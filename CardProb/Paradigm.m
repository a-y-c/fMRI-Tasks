function [ VAT ] = ParadigmJitter(BlockNumber, Params, ...
        ScreenHandels, VAT)
% VAT = ...
% ParadigmJitter(BlockNumber, Params, ScreenHandels, VAT)
%
%******************************************************************
%   INPUT:
%       BlockNumber = Block Number
%       VAT ->
%               .StartTime      = Time Start
%               .TimeStamp[]    = Time Log of Events
%               .TSCode{}       = Name of Events
%               .j              = Global Counter
%               .Results{}      = Result Struct 
%   
%******************************************************************
%
%
% Written by Cameron Rodriguez
%   2012/02/08
% Refractor by Andrew Cho
%   2012/08/23
%
%******************************************************************
%   DEPENDENCIES:
%       InitiateKeys.m
%
%   DEPENDENT BY:
%       StaglingPTB.m
%
%******************************************************************

%%%%%%%%%%%%%
% CONSTANTS %
%%%%%%%%%%%%%
%% Activate Keyboard
KbName('UnifyKeyNames');
FlushEvents('keyDown');
Keys = InitiateKeys;

% Keep KbCheck for looking for the TR signals
olddisabledkeys = DisableKeysForKbCheck([KbName('T'),KbName('5')]); 
    
%% Unpack Stucts
WES = ScreenHandels.WES;   % Window Handel Experimenter
RES = ScreenHandels.RES;   % Window Rectangle Experimenter
ifiE = ScreenHandels.ifiE; % interframe interval Experimenter
WSS = ScreenHandels.WSS;   % Window Handel Subject
RSS = ScreenHandels.RSS;   % Window Rectangle Subject
ifiS = ScreenHandels.ifiS; % interframe interval Subject


%%%%%%%%%
% SETUP %
%%%%%%%%%
%% Set Initial Variable
VAT.TimeStamps(VAT.j) = GetSecs - VAT.StartTime;
VAT.TimeCodes{VAT.j} =  [ 'Block Start ', BlockNumber ]; 
VAT.j = VAT.j + 1;
%disp([ 'Block Start ', BlockNumber ]);

ONE = ones(1, Params.TotalCue1);
TWO = repmat(2, 1, Params.TotalCue2);
THREE = repmat(3, 1, Params.TotalCue3);
FOUR = repmat(4, 1, Params.TotalCue4);
FIVE = repmat(5, 1, Params.TotalCue5);

% Presentation Order (Randomized)
ix = randperm(Params.TotalTrials);
UnorderedTrialSet = [ ONE, TWO, THREE, FOUR, FIVE ];
Params.TrialSet = UnorderedTrialSet(ix);
RunningTotal = Params.StartingMoney;

%%%%%%%%%%%%%%
% EXPERIMENT %
%%%%%%%%%%%%%%
% Loop Through Each Trial
for i = 1:Params.TotalTrials
    disp(['Trial: ' num2str(i)])
    
    CueText = Params.Cue{Params.TrialSet(i)};
    CueWeight = Params.Cue{Params.TrialSet(i)};
    [ CueNumber, HighOrLow ] = CalcProb(Params.Card, CueWeight);

    % Draw Inital Cue  // VAT.j = -7
    MSG = Params.MSG.InitialCue;
    [ VAT ] = DrawCard(WSS, Params.ScreenSize, ...
        Params.Card.Ratio, Params.Card.Size, ...
        CueText, Params.Card.Background, MSG, 1, VAT);
    WaitSecs(Params.Timing.Cue);

    % Fixation Point // VAT.j = -6 
    MSG = Params.MSG.Fixation;
    [ VAT ] = DrawFixationPt(WSS, RSS, MSG, VAT); 
    WaitSecs(Params.Timing.ITI1);

    % Draw Question Cue  // VAT.j = -5 
    MSG = Params.MSG.QuestionCue;
    [ VAT ] = DrawCard(WSS, Params.ScreenSize, ...
        Params.Card.Ratio, Params.Card.Size, ...
        Params.CueQuestion, Params.Card.Background, ...
        MSG, 1, VAT);

    % Wait for Response // VAT.j = -4
    MSG = Params.MSG.RecordInput;
    [ VAT, RT, Response ] = GetKeyPressWithTimeOut( Keys, ...
        MSG, VAT, Params.Timing.Guess);
    WaitSecs(Params.Timing.Guess - RT);

    % Draw OutCome Cue // VAT.j = -3 
    MSG = Params.MSG.OutComeCue;
    [ VAT ] = DrawCard(WSS, Params.ScreenSize, ...
        Params.Card.Ratio, Params.Card.Size, ...
        num2str(CueNumber), Params.Card.Background, MSG, 0, VAT);
    WaitSecs(Params.Timing.Outcome);

    % Draw Reward/Punishment // VAT.j = -2 
    [ DisplayInfo, RunningTotal ] = CalcFeedback ( ...
            Params.Feedback, Response, ...
            HighOrLow, RunningTotal);
    MSG = Params.MSG.Feedback;
    [ VAT ] = DrawFeed(WSS, Params.ScreenSize, ...
        Params.Feedback, DisplayInfo, MSG, VAT );
    WaitSecs(Params.Timing.Feedback);

    % Fixation Point // VAT.j = -1
    MSG = Params.MSG.Fixation;
    [ VAT ] = DrawFixationPt(WSS, RSS, MSG, VAT); 
    WaitSecs(Params.Timing.ITI2);


    %% Save Data
    VAT.Results{i}.Cue = CueText;
    VAT.REsults{i}.CueNumber = Params.TrialSet(i);
    VAT.Results{i}.CueProbability = CueWeight;
    VAT.Results{i}.CueRange = HighOrLow;
    VAT.Results{i}.CueNumber = CueNumber;
    VAT.Results{i}.CueOnset = VAT.TimeStamps(VAT.j - 7);
    VAT.Results{i}.Response = Response;
    VAT.Results{i}.Correct = DisplayInfo.Text;
    VAT.Results{i}.ResponseTime = RT;
    %VAT.Results{i}.

% End Loop 
end

Screen('Close'); % Close the Open Textures

VAT.TimeStamps(VAT.j) = GetSecs - VAT.StartTime;
VAT.TimeCodes{VAT.j} =  [ 'Block End', BlockNumber ]; 
VAT.j = VAT.j + 1;
%disp([ 'Block Start ', BlockNumber ]);

end



%%%%%%%%%%%%%
% FUNCTIONS %
%%%%%%%%%%%%%
%% Draw Fixation Point
    %IN -> Screen, Screen, Display MSG, LOG 
    %OUT -> LOG
function [ VAT ] = DrawFixationPt(WSS, RSS, MSG, VAT)
    Screen('FillRect', WSS, 128, RSS);
    Screen('DrawDots', WSS, [0, 0], 10, 255*[1 0 0 1], ... 
           [RSS(3)/2 RSS(4)/2], 1); 
    Screen('DrawingFinished', WSS);

    % Record Timing
    VAT.TimeStamps(VAT.j) = Screen('Flip',WSS) - VAT.StartTime;
    VAT.TSCodes{VAT.j} = MSG;
    VAT.j = VAT.j + 1; % Advance Counter
end

% Draw / Display Text            
    %IN -> Screen, Card Stuff, Display MSG, LOG
    %OUT -> LOG
function [ VAT ] = DrawCard(WSS, ScreenSize, ...
            CardRatio, CardSize, CueText, Color, MSG, Flip, VAT)
    
    % Calculate Location of Image
    CardX1 = ScreenSize(1)/2 - ...
        (ScreenSize(1)/2*CardSize);
    CardX2 = ScreenSize(1)/2 + ...
        (ScreenSize(1)/2*CardSize); 
    CardY1 = ScreenSize(2)/2 - ...
        (ScreenSize(2)/2*CardRatio*CardSize); 
    CardY2 = ScreenSize(2)/2 + ...
        (ScreenSize(2)/2*CardRatio*CardSize); 

    Dest = [ CardX1 CardY1 CardX2 CardY2 ]; 
    
    % Display Image Screen
    Screen('FillRect', WSS, Color, Dest);

    % Display Text
    DrawFormattedText(WSS, CueText, 'center', 'center', 0, 45);
    
    % Record Timing
    if Flip == 1
        VAT.TimeStamps(VAT.j) = Screen('Flip',WSS) - VAT.StartTime;
    else
        VAT.TimeStamps(VAT.j) = Screen('Flip',WSS, [], 1) ...
                - VAT.StartTime;
    end
    VAT.TSCodes{VAT.j} = MSG;
    VAT.j = VAT.j + 1; % Advance Counter
end

%% Record Key Press
    %IN -> Accept KEYS, MSG, LOG, MAX
    %OUT -> Log,  Response Time
function [VAT, RT, Response] = ...
    GetKeyPressWithTimeOut(Keys, MSG, VAT, maxTime)

    baseTime = GetSecs;
    gotgood = false;
    
    while ~gotgood
        % while no key is pressed, wait a bit, then check again
        if( GetSecs-baseTime > maxTime )
            secs = baseTime + maxTime;
            RT = maxTime;
            Response = '0'; % Capitalized
            break;
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

    % Format Output to be Read. Only Button Box
    if keyCode(Keys.KB1) || keyCode(Keys.BB1)
        Response = '1';
    elseif keyCode(Keys.KB2) || keyCode(Keys.BB2)
        Response = '2';
    elseif keyCode(Keys.KB3) || keyCode(Keys.BB3)
        Response = '3';
    elseif keyCode(Keys.KB4) || keyCode(Keys.BB4)
        Response = '4';
    else
        Response = '0';
    end

    VAT.TimeStamps(VAT.j) = secs - VAT.StartTime;
    disp(['Response: ' Response])
    VAT.TSCodes{VAT.j} = MSG;
    VAT.j = VAT.j + 1; % Advance Counter
end

%% Calculate Probability of Card High Low
    %IN -> Card Information (High Low), Weight
    %OUT -> Range of either High Low
function [CueNumber, Ans] = CalcProb(Card, Weight)
    % Generate a Random Number between 1 - 100
    randnum = randi([1,100]);
    
    % High
    if Weight > randnum
        randpos = randi([1, Card.HighLength]);
        CueNumber = Card.High(randpos);
        Ans = 'high';
    % Low
    else 
        randpos = randi([1, Card.LowLength]);
        CueNumber = Card.Low(randpos);
        Ans = 'low';
    end
end

%% Draw Punishment Reward Feedback
    %IN -> Screen, Screen, Feedback, Log, Counter
    %OUT -> Log 
function [ VAT ] = DrawFeed(WSS, ScreenSize, ...
    Feedback, DisplayInfo, MSG, VAT)
    
    % Calculate in Money Format
    XT1 = ScreenSize(1) * Feedback.PosH;
    YT1 = ScreenSize(2)/2 - ScreenSize(2) * ... 
        Feedback.PosSpace;

    XT2 = ScreenSize(1) * Feedback.PosH;
    YT2 = ScreenSize(2)/2 + ScreenSize(2) * ... 
        Feedback.PosSpace;

    % Draw/ Display Text 
    DrawFormattedText(WSS, DisplayInfo.Text, XT1, YT1, ...
             DisplayInfo.Color , 45);   
    DrawFormattedText(WSS, DisplayInfo.Total, XT2, YT2, ...
             DisplayInfo.Color , 45);   

    % Flip, Don't Erase Buffer
    VAT.TimeStamps(VAT.j) = Screen('Flip', WSS, [], 1) ... 
        - VAT.StartTime;
    VAT.TSCodes{VAT.j} = MSG;
    VAT.j = VAT.j + 1; % Advance Counter

end

%% Calculate Feedback to Display
    %IN -> Feedback, Response, Check, Total
    %OUT -> Total, Output
function [ DisplayInfo, RunningTotal ] = CalcFeedback...
        (Feedback, Response, HighOrLow, RunningTotal)  

    % If Probabilitiy is High
    if strcmpi(HighOrLow, 'high')
        if Response == '3' || Response == '4'
            RunningTotal = RunningTotal + Feedback.RewardMoney;
            DisplayInfo.Total = num2str(RunningTotal, '%.2f');
            DisplayInfo.Text = Feedback.RewardText; 
            DisplayInfo.Color = Feedback.RewardColor;
       else
            RunningTotal = RunningTotal - Feedback.PunishMoney;
            DisplayInfo.Total = num2str(RunningTotal, '%.2f');
            DisplayInfo.Text = Feedback.PunishText; 
            DisplayInfo.Color = Feedback.PunishColor;
        end
    % If Probability is Low
    else
        if Response == '1' || Response == '2'
            RunningTotal = RunningTotal + Feedback.RewardMoney;
            DisplayInfo.Total = num2str(RunningTotal, '%.2f');
            DisplayInfo.Text = Feedback.RewardText; 
            DisplayInfo.Color = Feedback.RewardColor;
       else
            RunningTotal = RunningTotal - Feedback.PunishMoney; 
            DisplayInfo.Total = num2str(RunningTotal, '%.2f');
            DisplayInfo.Text = Feedback.PunishText; 
            DisplayInfo.Color = Feedback.PunishColor;
        end
    end
end 











