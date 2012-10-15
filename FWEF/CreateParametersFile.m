function Params = CreateParametersFile
%******************************************************************
%
% Written by Cameron Rodriguez
% Last Modified 01/30/2011
%
%******************************************************************
%
% see also:
%
%******************************************************************

%%

OK = 0; %Get into the loop

while OK == 0
    %% Get the Parameters
    
    Params.LabGroup = input('What lab group is this for? Ex: Cohen ==> ', 's');
    TryAgain = 1;
    while TryAgain == 1
        switch Params.LabGroup
            case 'Rodriguez'
                TryAgain = 0;
            case 'Cohen'
                TryAgain = 0;
            case 'Bookheimer'
                TryAgain = 0;
            otherwise
                disp('LAB GROUP NOT FOUND')
                disp('Current Register Lab Groups are: Rodriguez, Cohen, & Bookheimer')
                Params.LabGroup = input('What lab group is this for? Ex: Cohen ==> ', 's');
                TryAgain = 1;
        end
    end
    
    if nargin < 1
        Params.ExperimentName = input('What is the Experiment Name? No Spaces! ==> ', 's');
    else
        Params.ExperimentName = ExperimentName;
    end
    
    Params.ExperimentPurpose = input('What is the Experiment Purpose? Ex: Retinotropy ==> ', 's');
    Params.ExperimentTask = input('What is the Experiment Task? Ex: Expanding Rings ==> ', 's');
    
    Params.Design = input('What Type of Experiment Design is it? Block = 0 or Jitter = 1 ==> ');
    TryAgain = 1;
    while TryAgain == 1
        switch Params.Design
            case 0
                Params.BlockNumber = input('How many blocks are there? ==> ');
                Params.BlockLenght = input('How long are the blocks in seconds? ==> ');
                Params.ISILenght = input('How long are the inter stimulus intervals in seconds? ==> ');
                TryAgain = 0;
            case 1
                Params.BlockNumber = input('How many blocks are there? ==> ');
                Params.BlockLenghtMax = input('What is the MAXIMUM Blocks lenght in seconds? ==> ');
                Params.BlockLenghtMin = input('What is the MINIMUM Blocks lenght in seconds? ==> ');
                Params.ISIMax = input('What is the MAXIMUM Inter-stimulus interval in seconds? ==> ');
                Params.ISIMin = input('What is the MINIMUM Inter-stimulus interval in seconds? ==> ');
                TryAgain = 0;
            otherwise
                disp('Try Again')
                Params.Design = input('What Type of Experiment Design is it? Block = 0 or Jitter = 1 ==> ');
                TryAgain = 1;
        end
    end
    
    Params.MonitorType = input('Which display device are you going to use? Projector = 0 or Goggles = 1 ==> ');
    
    Params.EEG = input('Are you using the EGI EEG system Simultainiouly? No = 0 or Yes = 1 ==> ');
    if Params.EEG == 1
        Params.DAQ = input('Are you using the Arduino DAQ? No = 0 or Yes = 1 ==> ');
    else
        Params.DAQ = 0;
    end
    
    disp(Params)
    OK = input('Are These Correct? No = 0 or Yes = 1 ==> ');
end
      
switch Params.LabGroup
    case 'Rodriguez'
        if IsWin
            data_folder = 'C:\Documents and Settings\Cohen\';
            backup_data_folder = '\\Vn3\share\Cohen\BackupData\';
        else
            data_folder = '/Users/Cameron/Documents/MATLAB/Data/';
            backup_data_folder = '/Users/Cameron/Documents/MATLAB/BackupData/';
        end
    case 'Cohen'
        if IsWin
            data_folder = 'C:\Documents and Settings\Cohen\';
            backup_data_folder = '\\Vn3\share\Cohen\BackupData\';
        else
            data_folder = '/Users/Cohen/Data/';
            backup_data_folder = '/Users/Cohen/BackupData/';
        end
    case 'Bookheimer'
        if IsWin
            data_folder = 'C:\Documents and Settings\Bookheimer\';
            backup_data_folder = '\\Vn3\share\Bookheimer\BackupData\';
        else
            data_folder = '/Users/Bookheimer/Data/';
            backup_data_folder = '/Users/Bookheimer/BackupData/';
        end
end            
    
    fname = Params.ExperimentName;
    fnameBU = [Params.ExperimentName,'_', datestr(now,'yyyymmdd_HHMMSS')];
    file = [data_folder,fname,'.mat'];
    fileBU = [backup_data_folder,fnameBU,'.mat'];
    save(file, 'Params')
    save(fileBU, 'Params')

end
