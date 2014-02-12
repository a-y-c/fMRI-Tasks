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
% Dependencies:
%	SoundLoader.m 	
%					Loads Sound Files into Task
%	ImageLoader.m
%					Loads Images Files into Task
% Used By:
%	StaglinPTB.m
% 	
%******************************************************************
% SETTINGS
ImageDir = 'Data';
%******************************************************************


%%%%%%%%%%%
% DATA   ----------------------------------------------------------
%%%%%%%%%%%
fprintf('Loading Timing ...\n\n')

% Intro
Intro.Timing.Break = 1;
Intro.Timing.Response = 4;
Intro.Timing.Instr = 22;

%Task Blocks
Task{1}.BlocksTotal = 4;
Task{1}.Blocks = [ 1 2 3 4 ];

Task{2}.BlocksTotal = 4;
Task{2}.Blocks = [ 1 2 3 4 ];

Task{3}.BlocksTotal = 4;
Task{3}.Blocks = [ 1 2 3 4 ];

Task{4}.BlocksTotal = 4;
Task{4}.Blocks = [ 1 2 3 4 ];

%Timing for Task
%% Timing for Task1
Task{1}.Timing.Audio = 2;
Task{1}.Timing.Response = 2.9;
Task{1}.Timing.Instr = 11;
Task{1}.Timing.InstrBreak = 4;
Task{1}.Timing.BlockBreak = 20;
Task{1}.Timing.TaskTime = 5;

% Timing for Task2
Task{2}.Timing.Audio = 1.75;
Task{2}.Timing.Response = 3.15;
Task{2}.Timing.Instr = 10;
Task{2}.Timing.InstrBreak = 5;
Task{2}.Timing.BlockBreak = 20;
Task{2}.Timing.TaskTime = 5;

% Timing for Task3
Task{3}.Timing.Audio = 2.5;
Task{3}.Timing.Response = 2.4;
Task{3}.Timing.Instr = 11;
Task{3}.Timing.InstrBreak = 4;
Task{3}.Timing.BlockBreak = 20;
Task{3}.Timing.TaskTime = 5;

% Timing for Task4
Task{4}.Timing.Audio = 1.75;
Task{4}.Timing.Response = 3.15;
Task{4}.Timing.Instr = 11;
Task{4}.Timing.InstrBreak = 4;
Task{4}.Timing.BlockBreak = 20;
Task{4}.Timing.TaskTime = 5;

% Message
fprintf('Timing Loaded.\n\n')

%%%%%%%%%%%%%%%%
% Instructions  ----------------------------------------------------
%%%%%%%%%%%%%%%%
fprintf('Loading Instructions ...\n\n')

% Intro
Intro.Instr.Sentence = 'You are going to see two pictures: one on your left and one on your right.\n\n Press the button that is on the side of the picture that matches the sentence or words you hear.\n\n So if you see a picture of a horse on the left side and a picture of a dog on the right, and you hear the words "the dog", you''ll press the button on your right.';

CompInstr = 'You are going to see two pictures: one on your left and one on your right.\n\n Press the button that is on the side of the picture that matches the sentence you hear. ';
ProInstr = 'You are going to see two pictures.\n\n I''m going to tell you about the first picture.\n\n Then you silently finish the sentence about the second picture. ';

Task{1}.Instr.Sentence = CompInstr;
Task{2}.Instr.Sentence = ProInstr;
Task{3}.Instr.Sentence = CompInstr;
Task{4}.Instr.Sentence = CompInstr;

% Message
fprintf('Instructions Loaded.\n\n')

%%%%%%%%%%%%%%%%
%Image / Sound -------------------------------------------------------
%%%%%%%%%%%%%%%%
% ---------
% Task
% ---------
fprintf('Loading Task Images/Audios ...\n\n')

% Loop Through Task
for T = 1:4
    % Message
    fprintf(['\n    Loading Task ',  num2str(T),  ' ...\n\n'])
    % Per Blocks
    for B = 1:4
        % Task Directory
        TaskImageDir = [ ImageDir , '/Task' , num2str(T), ...
                            '/Images/', num2str(B) ];
        % Load Images
        [ Task{T}.Block{B}.Images , Task{T}.Block{B}.ImageNames, ...
            Task{T}.Block{B}.ImageSize ] =  ...
            ImageLoader(TaskImageDir);

        % Task Directory
        TaskSoundDir = [ ImageDir, '/Task' , num2str(T), ...
                        '/Audios/', num2str(B) ];
        % Load Sound
        [ Task{T}.Block{B}.Sounds, Task{T}.Block{B}.SoundsFreq, ...
            Task{T}.Block{B}.Channel ] = ...
            SoundLoader(TaskSoundDir);
    end %Block

% Load Intstructions Sound
IntroSoundDir = [ ImageDir, '/Task', num2str(T), '/Instr' ];
[ Task{T}.Instr.Sounds, Task{T}.Instr.SoundsFreq, ...
    Task{T}.Instr.Channel ] = ...
    SoundLoader(IntroSoundDir);
end %Task

    
% ---------
% Intro
% ---------
fprintf('\nLoading Intro Images/Audios ...\n\n')

% Load Intro Image
IntroImageDir = [ ImageDir, '/Intro/Images' ];
[ Intro.Images , Intro.ImageNames, Intro.ImageSize ] =  ... 
    ImageLoader(IntroImageDir);

% Load Intro Sound
IntroSoundDir = [ ImageDir, '/Intro/Audios' ];
[ Intro.Sounds, Intro.SoundsFreq, Intro.Channel ] = ... 
    SoundLoader(IntroSoundDir);

% Load Intro Intro Sound
IntroSoundDir = [ ImageDir, '/Intro/Instr' ];
[ Intro.Instr.Sounds, Intro.Instr.SoundsFreq, Intro.Instr.Channel ] = ... 
    SoundLoader(IntroSoundDir);

% Message
fprintf('\nTask+Intro Images Audios Loaded.\n\n')


%%%%%%%%%%%%%
% SENTENCES  ------------------------------------------------------
%%%%%%%%%%%%%
fprintf('Loading Sentences ...\n\n')

%Task1
Task{1}.Block{1}.Sentences = {	['The girl is pulling the boy.'] ...
                            	['The clown is pushing the boy.'] ...
				['The boy is kicking the girl.'] ...
				['The girl is washing the boy.'] ...
                          	};
Task{1}.Block{2}.Sentences = {  ['The clown is being pushed by the boy.'] ...
				['The girl is being pulled by the boy.'] ...
				['The boy is being kicked by the girl.'] ...
				['The girl is being washed by the boy. '] ...
                          	};
Task{1}.Block{3}.Sentences = {	['The dog is pulling the clown.'] ...
				['The girl is pushing the boy.'] ...
				['The dog is chasing the boy.'] ...
				['The boy is kicking the clown.'] ...
                          	};
Task{1}.Block{4}.Sentences = { 	['The girl is being pushed by the boy.'] ...
				['The dog is being pulled by the clown. '] ...
				['The boy is being kicked by the clown. '] ...
				['The dog is being chased by the boy.'] ...
                          	};

%Task2
Task{2}.Block{1}.Sentences = { 	['Which person is pushing the girl?'] ...
				['Which person is pulling the boy?'] ...
				['Which person is chasing the dog?'] ...
				['Which animal is chasing the boy?'] ...
                          };
Task{2}.Block{2}.Sentences = { 	['Which animal is the girl chasing?'] ...
				['Which person is the boy pushing?'] ...
				['Which animal is the cat chasing?'] ...
				['Which person is the clown chasing?'] ...
                          };

Task{2}.Block{3}.Sentences = { 	['Which person is pulling the girl?'] ...
				['Which animal is chasing the clown?'] ...
				['Which animal is chasing the mouse?'] ...
				['Which person is pushing the man?'] ...
                          };
Task{2}.Block{4}.Sentences = {	['Which animal is the dog chasing?'] ...
				['Which person is the boy pulling?'] ...
				['Which person is the boy chasing?'] ...
				['Which person is the girl pushing?'] ...
                          };


%Task3
Task{3}.Block{1}.Sentences = { 	...
            ['The clown who is hugging the girl is wearing yellow.'] ...
            ['The boy who is kicking the girl is wearing purple. '] ...
	    ['The boy who is pushing the girl is wearing red. '] ...
	    ['The girl who is chasing the boy is wearing blue.'] ...
                            };

Task{3}.Block{2}.Sentences = { ...
	    ['The boy who the girl is kicking is wearing purple. '] ...
	    ['The girl who the boy is chasing is wearing blue. '] ...
            ['The boy who the girl is pushing is wearing red. '] ...
	    ['The clown who the girl is hugging is wearing yellow. '] ...
                            };

Task{3}.Block{3}.Sentences = { ...
            ['The girl who is hugging the boy is wearing green. '] ...
            ['The boy who is kicking the clown is wearing brown. '] ...
	    ['The boy who is chasing the dog is wearing orange. '] ...
	    ['The girl who is pulling the boy is wearing pink. '] ...
                            };

Task{3}.Block{4}.Sentences = { ...
            ['The boy who the clown is kicking is wearing brown. '] ...
	    ['The girl who the boy is hugging is wearing green. '] ...
	    ['The girl who the boy is pulling is wearing pink. '] ...
	    ['The boy who the dog is chasing is wearing orange. '] ...
                          };


%Task4       
Task{4}.Block{1}.Sentences = {	['The girl opened the present.'] ...
                                ['The boy ascended the stairs.'] ...
                                ['The mother dressed the baby. '] ...
                                ['The boy poured the juice. '] ...
                            };
Task{4}.Block{2}.Sentences = {	['The boy ate his dinner.'] ...
                                ['The girl lit the candle.'] ...
                                ['The girl wrung out the shirt.'] ...
                                ['The man made a shirt.'] ...
                            };
Task{4}.Block{3}.Sentences = {	['Someone tied the shoe.'] ...
                                ['The boy washed his face.'] ...
                                ['The girl painted the picture.'] ...
                                ['The fireman extinguished the fire.'] ...
                            };
Task{4}.Block{4}.Sentences = {	['The girl fell.'] ...
                                ['The boy flung the frisbee.'] ...
                                ['The boy drew a picture.'] ...
                                ['The girl blew up the balloon.'] ...
                            };

% Message
fprintf('Sentences Loaded.\n\n')

%%%%%%%%%%%
% SAVE   --------------------------------------------------------------
%%%%%%%%%%%
fprintf('Saving ....\n\n')

% Save Task, Loop Through Task
for T = 1:4
    LTask = Task{T};
    save( ['Data_Task' num2str(T)], 'LTask');
end

% Save Intro
save('Data_Intro', 'Intro');

fprintf('Finished Loading.\n\n')

