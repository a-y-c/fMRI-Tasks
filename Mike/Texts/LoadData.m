function [ Task ] = LoadData 

% % LoadData *****************************************************
%
%	Description:
%   	Loads Data (sentences, pictures) to be used for each Task
%
%	Output: Task
% 	
%******************************************************************
%
% Written by Andrew Cho
% Last Modified 2012/05/08
%
%******************************************************************
%
% Used By:
%	StaglinPTB.m
% 	
%******************************************************************
Task.Sentence{1} = 'This';
Task.Sentence{2} = 'is a ';
Task.Sentence{3} = 'example';


Task.TotalBlocks = 5;
Task.TotalBlocks = counter/3;

% To Be Save as .mat (data) files for Faster 
save( 'Task_Data', 'Task' )


