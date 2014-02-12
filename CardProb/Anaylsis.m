function [ Results ] = Anaylsis( Params, VAT )
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
%   OUPUT:
%       Results ->
%               .CueOne{i}, [CueTwo, CueThree, CueFour, CueFive ]->
%                   AmountCorrect   = Total Correct up to {i} 
%                   Total           = Total Display up to {i} 
%                   ACC             = Accuracy up to {i}
%                   OutCome         = Current Choice (Reward/Punish)
%               .CueOneTPC [CueTwo, CueThree, CueFour, CueFive ]->
%                   FirstAmountCorrect   = Total Correct first third
%                   FirstTotal           = Total 1/3
%                   FirstACC             = Accuracy up to first third
%                   SecondAmountCorrect   = Total Correct two-thirds
%                   SecondTotal           = Total 1/3 - 2/3
%                   SecondACC             = Accuracy 
%                   ThirdAmountCorrect   = Total Correct final third
%                   ThirdTotal           = Total 2/3 - 1 
%                   ThirdACC            = Accuracy 
%
%******************************************************************
%
% Written by Andrew Cho
%   2012/08/23
%
%******************************************************************
%   DEPENDENCIES:
%
%   DEPENDENT BY:
%       StaglingPTB.m
%
%******************************************************************

% Cue One
CueOne.AmountCorrect = 0;
CueOne.Total = 0;
Results.CueOne = {};
% Cue Two
CueTwo.AmountCorrect = 0;
CueTwo.Total = 0;
Results.CueTwo = {};
% Cue Three
CueThree.AmountCorrect = 0;
CueThree.Total = 0;
Results.CueThree = {};
% Cue Four
CueFour.AmountCorrect = 0;
CueFour.Total = 0;
Results.CueFour = {};
% Cue Five
CueFive.AmountCorrect  = 0;
CueFive.Total = 0;
Results.CueFive = {};

% Loop THrough All the Data
for i = 1:Params.TotalTrials
    %% Calculate Indivdual Trials
    if VAT.Results{i}.CueIdentity == 1
       [ CueOne OUT ] = Accuracy( CueOne, ...
                VAT.Results{i}.OutCome, Params.Feedback );
        Results.CueOne{CueOne.Total} = OUT;
       
    elseif VAT.Results{i}.CueIdentity == 2
       [ CueTwo OUT ] = Accuracy( CueTwo, ...
                VAT.Results{i}.OutCome, Params.Feedback ); 
        Results.CueTwo{CueTwo.Total} = OUT;

    elseif VAT.Results{i}.CueIdentity == 3
       [ CueThree OUT ] = Accuracy( CueThree, ...
                VAT.Results{i}.OutCome, Params.Feedback ); 
        Results.CueThree{CueThree.Total} = OUT;

    elseif VAT.Results{i}.CueIdentity == 4
       [ CueFour OUT ] = Accuracy( CueFour, ...
                VAT.Results{i}.OutCome, Params.Feedback ); 
        Results.CueFour{CueFour.Total} = OUT;

    else
       [ CueFive OUT ] = Accuracy( CueFive, ...
                VAT.Results{i}.OutCome, Params.Feedback ); 
        Results.CueFive{CueFive.Total} = OUT;

    end
end 

    % Calculate Early/Middle/Late Periods
    Results.CueOneTPC = SplitThirdsACC( Results.CueOne );
    Results.CueTwoTPC = SplitThirdsACC( Results.CueTwo );
    Results.CueThreeTPC= SplitThirdsACC( Results.CueThree );
    Results.CueFourTPC = SplitThirdsACC( Results.CueFour );
    Results.CueFiveTPC = SplitThirdsACC( Results.CueFive );
end

% Accuracy Calculations (Total, Correct)
    %IN -> Cue Info, Correct/Incorrect, Feedback Info
    %OUT -> Cue Info, Accuracy
function [ Cue Results ] = Accuracy(Cue, Choice, Feedback)

    % Add to Total Cue so Far
    Cue.Total = Cue.Total + 1;
    Results.Total= Cue.Total;

    % IF Correct, Add Amount and Caculate ACC
    if strcmpi(Choice, Feedback.RewardText)
        Cue.AmountCorrect = Cue.AmountCorrect + 1;

        % Record Results
        Results.ACC = Cue.AmountCorrect / Cue.Total; 
        Results.AmountCorrect = Cue.AmountCorrect;
    % IF Incorrect, Just Caculate ACC
    else
        % Record Results
        Results.ACC = Cue.AmountCorrect / Cue.Total; 
        Results.AmountCorrect = Cue.AmountCorrect;
    end

    % Record Outcome Results
    Results.OutCome = Choice;
end

% Accuracy Calculation for Thirds
    %IN ->
    %OUT ->
function [ Results ] = SplitThirdsACC( Cue )
    Length1 = ceil(length(Cue)/3);
    Length2 = ceil(length(Cue)*2/3);
    Length3 = length(Cue);

    %First Third
    Results.FirstACC = Cue{Length1}.AmountCorrect/(Length1);
    Results.FirstAmountCorrect = Cue{Length1}.AmountCorrect;
    Results.FirstTotal = [1 , Length1];

    %Second Thirds
    AmountC = Cue{Length2}.AmountCorrect - ...
            Cue{Length1}.AmountCorrect;
    Results.SecondACC = AmountC / (Length2-Length1); 
    Results.SecondAmountCorrect = AmountC;
    Results.SecondTotal = [Length1, Length2];

    %Third Thirds
    AmountC = Cue{Length3}.AmountCorrect - ...
            Cue{Length2}.AmountCorrect;
    Results.ThirdACC = AmountC / (Length3-Length2); 
    Results.ThirdAmountCorrect = AmountC;
    Results.ThirdTotal = [Length2, Length3];
end
