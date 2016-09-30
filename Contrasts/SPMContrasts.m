function [] = SPMContrasts()
%% User Input
% You should ONLY (!!!!!!) need to edit this highlighted section of the
% script.

    % User Input Step 1: Subjects
    
    % Please list the subjects to model in a 1 x N cell array.

    Subjects = { 'y001' 'y002' 'y003' 'y004' 'y005' ...
                 'o001' 'o002' 'o003' 'o004' 'o005' };

    % User Input Step 2: Directories
    
    % Please specify the name of the current analysis, the directory the
    % current analysis is in.
             
    Analysis.name      = 'Name_Of_Model_hrf'; % name of analysis to run.             
    Analysis.directory = strcat('/path/to/analyses/directory',filesep,Analysis.name);
    
    % User Input Step 3: Options
    
    % Set the following jobman_option to 'interactive' to view in SPM parameters the GUI. 
    % Press any key into the command window to continue to next one sample t test.
    % Set the following jobman option to 'run' to skip the viewing of the
    % SPM parameters in the GUI and go directly to running of the one
    % sample t-tests
    
    jobman_option      = 'interactive'; % 'run' or 'interactive'.

%% Setting Analysis specifics contrasts

    clc
    fprintf('Analysis: %s\n\n',Analysis.name)
    disp('Analysis Directory:')
    disp(Analysis.directory)

    switch Analysis.name

        case 'Relatedness_hrf'
            
        % Inialize Number.OfContrasts
            
            Number.OfContrasts = 0;

            % AllTrials
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllTrials' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' 'LowHit' 'AllMiss' 'AllFA' 'HiCR' 'LoCR' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

            % AllTrials_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllTrials_parampos' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' 'LowHit' 'AllMiss' 'AllFAxRelatedness^1' 'HiCRxRelatedness^1' 'LoCRxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)
            
            % AllTrials_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllTrials_paramneg' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = {}; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HighHit' 'LowHit' 'AllMiss' 'AllFAxRelatedness^1' 'HiCRxRelatedness^1' 'LoCRxRelatedness^1' }; % TTs to be included in contrast (-)
            
            % AllHit
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllHit' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' 'LowHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

%             % AllHit_parampos
%             Number.OfContrasts = Number.OfContrasts+1;
%             Contrasts(Number.OfContrasts).names    = { 'AllHit_parampos' }; % name of contrast
%             Contrasts(Number.OfContrasts).positive = { 'HighHit' 'LowHit' }; % TTs to be included in contrast (+)
%             Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)
%             
%             % AllHit_paramneg
%             Number.OfContrasts = Number.OfContrasts+1;
%             Contrasts(Number.OfContrasts).names    = { 'AllHit_paramneg' }; % name of contrast
%             Contrasts(Number.OfContrasts).positive = {}; % TTs to be included in contrast (+)
%             Contrasts(Number.OfContrasts).negative = { 'HighHit' 'LowHit' }; % TTs to be included in contrast (-)            
            
            % HighHit
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HighHit' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)        

%             % HighHit_parampos
%             Number.OfContrasts = Number.OfContrasts+1;
%             Contrasts(Number.OfContrasts).names    = { 'HighHit_parampos' }; % name of contrast
%             Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
%             Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)   
%             
%             % HighHit_paramneg
%             Number.OfContrasts = Number.OfContrasts+1;
%             Contrasts(Number.OfContrasts).names    = { 'HighHit_paramneg' }; % name of contrast
%             Contrasts(Number.OfContrasts).positive = {}; % TTs to be included in contrast (+)
%             Contrasts(Number.OfContrasts).negative = { 'HighHit' }; % TTs to be included in contrast (-)               

            % LowHit
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'LowHit' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'LowHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)
            
%             % LoHit_parampos
%             Number.OfContrasts = Number.OfContrasts+1;
%             Contrasts(Number.OfContrasts).names    = { 'LowHit' }; % name of contrast
%             Contrasts(Number.OfContrasts).positive = { 'LowHit' }; % TTs to be included in contrast (+)
%             Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)
%             
%             % LoHit_paramneg
%             Number.OfContrasts = Number.OfContrasts+1;
%             Contrasts(Number.OfContrasts).names    = { 'LowHit' }; % name of contrast
%             Contrasts(Number.OfContrasts).positive = {}; % TTs to be included in contrast (+)
%             Contrasts(Number.OfContrasts).negative = { 'LowHit' }; % TTs to be included in contrast (-)

            % AllOthers
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllOthers' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'LowHit' 'AllMiss' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)
            
%             % AllOthers_parampos
%             Number.OfContrasts = Number.OfContrasts+1;
%             Contrasts(Number.OfContrasts).names    = { 'AllOthers' }; % name of contrast
%             Contrasts(Number.OfContrasts).positive = { 'LowHit' 'AllMiss' }; % TTs to be included in contrast (+)
%             Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)
%             
%             % AllOthers_paramneg
%             Number.OfContrasts = Number.OfContrasts+1;
%             Contrasts(Number.OfContrasts).names    = { 'AllOthers' }; % name of contrast
%             Contrasts(Number.OfContrasts).positive = {}; % TTs to be included in contrast (+)
%             Contrasts(Number.OfContrasts).negative = { 'LowHit' 'AllMiss' }; % TTs to be included in contrast (-)            

            % AllMiss
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllMiss' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'AllMiss' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)
            
%             % AllMiss_parampos
%             Number.OfContrasts = Number.OfContrasts+1;
%             Contrasts(Number.OfContrasts).names    = { 'AllMiss' }; % name of contrast
%             Contrasts(Number.OfContrasts).positive = { 'AllMiss' }; % TTs to be included in contrast (+)
%             Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)      
%             
%             % AllMiss_paramneg
%             Number.OfContrasts = Number.OfContrasts+1;
%             Contrasts(Number.OfContrasts).names    = { 'AllMiss' }; % name of contrast
%             Contrasts(Number.OfContrasts).positive = {}; % TTs to be included in contrast (+)
%             Contrasts(Number.OfContrasts).negative = { 'AllMiss' }; % TTs to be included in contrast (-)   
            
            % AllFA
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllFA' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'AllFA' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)
            
            % AllFA_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllFA_parampos' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'AllFAxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)      
            
            % AllFA_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllFA_paramneg' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = {}; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'AllFAxRelatedness^1' }; % TTs to be included in contrast (-)   
            
            % AllCR
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllCR' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HiCR' 'LoCR' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)
            
            % AllCR_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllCR_parampos' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HiCRxRelatedness^1' 'LoCRxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)      
            
            % AllCR_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllCR_paramneg' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = {}; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HiCRxRelatedness^1' 'LoCRxRelatedness^1' }; % TTs to be included in contrast (-)
            
            % HiCR
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HiCR' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HiCR' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)
            
            % HiCR_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HiCR_parampos' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HiCRxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)      
            
            % HiCR_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HiCR_paramneg' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = {}; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HiCRxRelatedness^1' }; % TTs to be included in contrast (-)    
            
            % LoCR
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'LoCR' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'LoCR' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)
            
            % LoCR_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'LoCR_parampos' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'LoCRxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)      
            
            % LoCR_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'LoCR_paramneg' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = {}; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'LoCRxRelatedness^1' }; % TTs to be included in contrast (-)          
            
            % AllHit_vs_AllMiss
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllHit_vs_AllMiss' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' 'LowHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'AllMiss' }; % TTs to be included in contrast (-)
            
%             % AllHit_vs_AllMiss_parampos
%             Number.OfContrasts = Number.OfContrasts+1;
%             Contrasts(Number.OfContrasts).names    = { 'AllHit_vs_AllMiss_parampos' }; % name of contrast
%             Contrasts(Number.OfContrasts).positive = { 'HighHit' 'LowHit' }; % TTs to be included in contrast (+)
%             Contrasts(Number.OfContrasts).negative = { 'AllMiss' }; % TTs to be included in contrast (-)      
%             
%             % AllHit_vs_AllMiss_paramneg
%             Number.OfContrasts = Number.OfContrasts+1;
%             Contrasts(Number.OfContrasts).names    = { 'AllHit_vs_AllMiss_paramneg' }; % name of contrast
%             Contrasts(Number.OfContrasts).positive = { 'AllMiss' }; % TTs to be included in contrast (+)
%             Contrasts(Number.OfContrasts).negative = { 'HighHit' 'LowHit' }; % TTs to be included in contrast (-)    
            
            % HighHit_vs_LoHit
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_LoHit' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'LowHit' }; % TTs to be included in contrast (-)
            
%             % HighHit_vs_LoHit_parampos
%             Number.OfContrasts = Number.OfContrasts+1;
%             Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_LoHit_parampos' }; % name of contrast
%             Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
%             Contrasts(Number.OfContrasts).negative = { 'LowHit' }; % TTs to be included in contrast (-)      
% 
%             % HighHit_vs_LoHit_paramneg
%             Number.OfContrasts = Number.OfContrasts+1;
%             Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_LoHit_paramneg' }; % name of contrast
%             Contrasts(Number.OfContrasts).positive = { 'LowHit' }; % TTs to be included in contrast (+)
%             Contrasts(Number.OfContrasts).negative = { 'HighHit' }; % TTs to be included in contrast (-)       
            
            % HighHit_vs_AllOther
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_AllOther' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'AllMiss' 'LoHit' }; % TTs to be included in contrast (-)
            
%             % HighHit_vs_AllOther_parampos
%             Number.OfContrasts = Number.OfContrasts+1;
%             Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_AllOther_parampos' }; % name of contrast
%             Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
%             Contrasts(Number.OfContrasts).negative = { 'AllMiss' 'LoHit' }; % TTs to be included in contrast (-)      
%             
%             % HighHit_vs_AllOther_paramneg
%             Number.OfContrasts = Number.OfContrasts+1;
%             Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_AllOther_paramneg' }; % name of contrast
%             Contrasts(Number.OfContrasts).positive = { 'AllMiss' 'LoHit' }; % TTs to be included in contrast (+)
%             Contrasts(Number.OfContrasts).negative = { 'HighHit' }; % TTs to be included in contrast (-)    
            
            % HighHit_vs_AllMiss
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_AllMiss' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'AllMiss' }; % TTs to be included in contrast (-)      
            
%             % HighHit_vs_AllMiss_parampos
%             Number.OfContrasts = Number.OfContrasts+1;
%             Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_AllMiss_parampos' }; % name of contrast
%             Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
%             Contrasts(Number.OfContrasts).negative = { 'AllMiss' }; % TTs to be included in contrast (-)    
%             
%             % HighHit_vs_AllMiss_paramneg
%             Number.OfContrasts = Number.OfContrasts+1;
%             Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_AllMiss_paramneg' }; % name of contrast
%             Contrasts(Number.OfContrasts).positive = { 'AllMiss' }; % TTs to be included in contrast (+)
%             Contrasts(Number.OfContrasts).negative = { 'HighHit' }; % TTs to be included in contrast (-)  
            
            % AllHit_vs_AllCR
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllHit_vs_AllCR' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' 'LowHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HiCR' 'LoCR' }; % TTs to be included in contrast (-)
            
            % AllHit_vs_AllCR_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllHit_vs_AllCR_parampos' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' 'LowHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HiCRxRelatedness^1' 'LoCRxRelatedness^1' }; % TTs to be included in contrast (-)  
            
            % AllHit_vs_AllCR_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllHit_vs_AllCR_paramneg' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HiCRxRelatedness^1' 'LoCRxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HighHit' 'LowHit' }; % TTs to be included in contrast (-)  
            
            % HighHit_vs_AllCR
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_AllCR' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HiCR' 'LoCR' }; % TTs to be included in contrast (-)
            
            % HighHit_vs_AllCR_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_AllCR_parampos' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HiCRxRelatedness^1' 'LoCRxRelatedness^1' }; % TTs to be included in contrast (-)      
            
            % HighHit_vs_AllCR_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_AllCR_paramneg' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HiCRxRelatedness^1' 'LoCRxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HighHit' }; % TTs to be included in contrast (-)
            
            % HighHit_vs_HiCR
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_HiCR' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HiCR' }; % TTs to be included in contrast (-)
            
            % HighHit_vs_HiCR_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_HiCR_parampos' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HiCRxRelatedness^1' }; % TTs to be included in contrast (-)      
            
            % HighHit_vs_HiCR_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_HiCR_paramneg' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HiCRxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HighHit' }; % TTs to be included in contrast (-)    
            
            % HighHit_vs_LoCR
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_LoCR' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'LoCR' }; % TTs to be included in contrast (-)
            
            % HighHit_vs_LoCR_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_LoCR_parampos' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'LoCRxRelatedness^1' }; % TTs to be included in contrast (-)      
            
            % HighHit_vs_LoCR_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_LoCR_paramneg' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'LoCRxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HighHit' }; % TTs to be included in contrast (-) 
            
            % AllHit_vs_AllFA
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllHit_vs_AllFA' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' 'LowHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'AllFA' }; % TTs to be included in contrast (-)
            
            % AllHit_vs_AllFA_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllHit_vs_AllFA_parampos' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' 'LowHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'AllFAxRelatedness^1' }; % TTs to be included in contrast (-)      
            
            % AllHit_vs_AllFA_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllHit_vs_AllFA_paramneg' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'AllFAxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HighHit' 'LowHit' }; % TTs to be included in contrast (-)             
            
            % HighHit_vs_AllFA
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_AllFA' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'AllFA' }; % TTs to be included in contrast (-)
            
            % HighHit_vs_AllFA_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_AllFA_parampos' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'AllFAxRelatedness^1' }; % TTs to be included in contrast (-)      
            
            % HighHit_vs_AllFA_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_AllFA_paramneg' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'AllFAxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HighHit' }; % TTs to be included in contrast (-)  
            
            % AllFA_vs_HighHit
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllFA_vs_HighHit' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'AllFA' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HighHit' }; % TTs to be included in contrast (-)
            
            % AllFA_vs_HighHit_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllFA_vs_HighHit_parampos' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'AllFAxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HighHit' }; % TTs to be included in contrast (-)      
            
            % AllFA_vs_HighHit_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllFA_vs_HighHit_paramneg' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'AllFAxRelatedness^1' }; % TTs to be included in contrast (-)    
            
            % AllFA_vs_AllCR
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllFA_vs_AllCR' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'AllFA' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HiCR' 'LoCR' }; % TTs to be included in contrast (-)
            
            % AllFA_vs_AllCR_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllFA_vs_AllCR_parampos' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'AllFAxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HiCRxRelatedness^1' 'LoCRxRelatedness^1' }; % TTs to be included in contrast (-)      
            
            % AllFA_vs_AllCR_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllFA_vs_AllCR_paramneg' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HiCRxRelatedness^1' 'LoCRxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'AllFAxRelatedness^1' }; % TTs to be included in contrast (-)             

            % AllFA_vs_HiCR
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllFA_vs_HiCR' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'AllFA' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HiCR' }; % TTs to be included in contrast (-)
            
            % AllFA_vs_HiCR_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllFA_vs_HiCR_parampos' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'AllFAxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HiCRxRelatedness^1' }; % TTs to be included in contrast (-)      
            
            % AllFA_vs_HiCR_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllFA_vs_HiCR_paramneg' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HiCRxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'AllFAxRelatedness^1' }; % TTs to be included in contrast (-)  
            
            % AllFA_vs_LoCR
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllFA_vs_LoCR' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'AllFA' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'LowCR' }; % TTs to be included in contrast (-)
            
            % AllFA_vs_LoCR_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllFA_vs_LoCR_parampos' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'AllFAxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'LoCRxRelatedness^1' }; % TTs to be included in contrast (-)      
            
            % AllFA_vs_LoCR_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllFA_vs_LoCR_paramneg' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'LoCRxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'AllFAxRelatedness^1' }; % TTs to be included in contrast (-)     
            
            % AllCR_vs_HighHit
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllCR_vs_HighHit' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HiCR' 'LoCR' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HighHit' }; % TTs to be included in contrast (-)
            
            % AllCR_vs_HighHit_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllCR_vs_HighHit_parampos' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HiCRxRelatedness^1' 'LoCRxRelatedness^1'}; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HighHit' }; % TTs to be included in contrast (-)      
            
            % AllCR_vs_HighHit_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllCR_vs_HighHit_paramneg' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HiCRxRelatedness^1' 'LoCRxRelatedness^1' }; % TTs to be included in contrast (-)      
            
            % HiCR_vs_HighHit
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HiCR_vs_HighHit' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HiCR' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HighHit' }; % TTs to be included in contrast (-)
            
            % HiCR_vs_HighHit_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HiCR_vs_HighHit_parampos' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HiCRxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HighHit' }; % TTs to be included in contrast (-)      
            
            % HiCR_vs_HighHit_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HiCR_vs_HighHit_paramneg' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HightHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HiCRxRelatedness^1' }; % TTs to be included in contrast (-)  
            
            % LoCR_vs_HighHit
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'LoCR_vs_HighHit' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'LoCR' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HighHit' }; % TTs to be included in contrast (-)
            
            % LoCR_vs_HighHit_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'LoCR_vs_HighHit_parampos' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'LoCRxRelatedness^1' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HighHit' }; % TTs to be included in contrast (-)      
            
            % LoCR_vs_HighHit_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'LoCR_vs_HighHit_paramneg' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'LoCRxRelatedness^1' }; % TTs to be included in contrast (-)             
            
            % AllFA_vs_AllHit
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllFA_vs_AllHit' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'AllFA' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'HighHit' 'LowHit' }; % TTs to be included in contrast (-)             
            
        case 'Encoding_ER_Expanded_hrf'
            
            Number.OfContrasts = 0;

        % All Trials

            % All Trials
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = {'AllTrials'}; % name of contrast
            Contrasts(Number.OfContrasts).positive = {'HDm_inc' 'LDm_inc' 'AllMissDm_inc' 'HDm_int' 'LDm_int' 'AllMissDm_int'}; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

        % Incidental

            % HDm_inc
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HDm_inc' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HDm_inc' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

            % LDm_inc
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'LDm_inc' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'LDm_inc' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

            % AllMissDm_inc
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllMissDm_inc' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'AllMissDm_inc' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

        % Intentional Contrasts

            % HDm_int
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HDm_int' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HDm_int' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

            % LDm_int
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'LDm_int' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'LDm_int' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

            % AllMissDm_int
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllMissDm_int' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'AllMissDm_int' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

        case 'Encoding_Mixed_hrf'

            Number.OfContrasts = 0;
            
        % All Trials

            % All Trials
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = {'AllTrials'}; % name of contrast
            Contrasts(Number.OfContrasts).positive = {'HDm_inc' 'LDm_inc' 'AllMissDm_inc' 'HDm_int' 'LDm_int' 'AllMissDm_int'}; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

        % Incidental

            % HDm_inc
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HDm_inc' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HDm_inc' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

            % LDm_inc
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'LDm_inc' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'LDm_inc' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

            % AllMissDm_inc
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllMissDm_inc' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'AllMissDm_inc' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

        % Intentional Contrasts

            % HDm_int
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HDm_int' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HDm_int' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

            % LDm_int
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'LDm_int' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'LDm_int' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

            % AllMissDm_int
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'AllMissDm_int' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'AllMissDm_int' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

         % TaskBLK Contrasts
            
            % TaskBLK_inc
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'TaskBLK_inc' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'TaskBLK_inc' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

            % TaskBLK_int
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'TaskBLK_int' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'TaskBLK_int' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

        case 'Retreival_Blocked_Just2Parametric_hrf'

            Number.OfContrasts = 0;

            % TaskBlock
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = {'TaskBLK'}; % name of contrast
            Contrasts(Number.OfContrasts).positive = {'TaskBLK*'}; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

            % TaskBlock_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = {'TaskBLK_incHH_parampos'}; % name of contrast
            Contrasts(Number.OfContrasts).positive = {'TaskBLKxincHH_bs^1'}; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

            % TaskBlock_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = {'TaskBLK_incHH_paramneg'}; % name of contrast
            Contrasts(Number.OfContrasts).positive = {}; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {'TaskBLKxincHH_bs^1'}; % TTs to be included in contrast (-)

            % TaskBlock_parampos
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = {'TaskBLK_intHH_parampos'}; % name of contrast
            Contrasts(Number.OfContrasts).positive = {'TaskBLKxintHH_bs^1'}; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

            % TaskBlock_paramneg
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = {'TaskBLK_intHH_paramneg'}; % name of contrast
            Contrasts(Number.OfContrasts).positive = {}; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {'TaskBLKxintHH_bs^1'}; % TTs to be included in contrast (-)             

        case 'Retreival_ER_Collapsed_hrf'
            
            Number.OfContrasts = 0;
            
        % Incidental Contrasts
            
            % Hits_inc vs Miss_inc
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'Hits_inc_vs_Miss_inc' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'Hits_inc' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'Miss_inc' }; % TTs to be included in contrast (-)

        % Intentional Contrasts

            % Hits_int vs Miss_int
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'Hits_int_vs_Miss_int' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'Hits_int' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = { 'Miss_int' }; % TTs to be included in contrast (-)

        case 'Retreival_ER_Expanded_hrf'

            Number.OfContrasts = 0;

        % All Trials

            % All Trials
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = {'AllTrials'}; % name of contrast
            Contrasts(Number.OfContrasts).positive = {'HighHit_inc' 'LowHit_inc' 'Miss_inc' 'HighHit_int' 'LowHit_int' 'Miss_int' 'HighCR' 'LowCR' 'FA'}; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

        % Incidental

            % HighHit_inc
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HighHit_inc' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit_inc' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

            % LowHit_inc
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'LowHit_inc' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'LowHit_inc' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

            % Miss_inc
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'Miss_inc' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'Miss_inc' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)    


        % Intentional Contrasts

            % HighHit_int
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'HighHit_int' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighHit_int' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

            % LowHit_int
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'LowHit_int' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'LowHit_int' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

            % Miss_int
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'Miss_int' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'Miss_int' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)      

        % Lure Contrasts

            % CR
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'CR' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'HighCR' 'LowCR' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

            % FA
            Number.OfContrasts = Number.OfContrasts+1;
            Contrasts(Number.OfContrasts).names    = { 'FA' }; % name of contrast
            Contrasts(Number.OfContrasts).positive = { 'FA' }; % TTs to be included in contrast (+)
            Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

    end

%% Routine
% Should not need to be edited

    % Set SPM Defaults

    spm('defaults','FMRI')
    spm_jobman('initcfg')
    Count.ProblemSubjs = 0;
    
    fprintf('\n')
    fprintf('Number of Contrasts Specified: %d \n\n',length(Contrasts))
    
    for indexS = 1:length(Subjects)
        % Build Contrast Vectors

            pathtoSPM = strcat(Analysis.directory,filesep,Subjects{indexS},filesep,'SPM.mat');
            fprintf('Building Contrast Vectors...\n\n')
            Contrasts = BuildContrastVectors(Contrasts,pathtoSPM);
            
        % Run SPM Contrast Manager
            if strcmp(jobman_option,'interactive')
                fprintf('Displaying SPM Job for Subject %s ...\n\n',Subjects{indexS})
            elseif strcmp(jobman_option,'run')
                fprintf('Running SPM Job for Subject %s ...\n\n',Subjects{indexS})                
            end
            matlabbatch = SetContrastManagerParams(Contrasts,pathtoSPM,1);
            try
                spm_jobman(jobman_option,matlabbatch)
                if strcmp(jobman_option,'interactive')
                    pause
                end
            catch error %#ok<NASGU>
                display(Subjects{indexS})
                Count.ProblemSubjs=Count.ProblemSubjs+1;
                pause
                problem_subjects{Count.ProblemSubjs} = Subjects{indexS}; %#ok<*AGROW>
            end
        fprintf('\n')
    end
    if exist('problem_subjects','var')    
        fprintf('There was a problem running the contrasts for these subjects:\n\n')
        disp(problem_subjects)
    end

%% Sub Functions

    function matlabbatch = SetContrastManagerParams(Contrasts,pathtoSPM,delete)
        % Function for setting the contrast manager parameters for the SPM job
        % manager. Takes in:
        %
        % Contrasts:
        %   .names = {'Contrast Name'}
        %   .positive = { 'Trial' 'Types' 'Included' }
        %   .negative = { 'Trial' 'Types' 'Included' }
        %   .vector = [0 0 .33 .33 0 0 0]
        %
        % pathtoSPM = 's:\nad12\Hybridwords\Analyses\SPM8\EPI_Masked\Encoding_ER_hrf\subjectID\SPM.mat'
        % 
        % delete = 1; 1 = delete existing contrasts, 0 = keep existing contrasts

        matlabbatch{1}.spm.stats.con.spmmat = cellstr(pathtoSPM);
        for curCon = 1:length(Contrasts)
            fprintf('Contrast %d: %s\n',curCon,Contrasts(curCon).names{1})
            matlabbatch{1}.spm.stats.con.consess{curCon}.tcon.name = Contrasts(curCon).names{1};
            matlabbatch{1}.spm.stats.con.consess{curCon}.tcon.convec = Contrasts(curCon).vector;
        end
        matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
        matlabbatch{1}.spm.stats.con.delete = delete;

    end

end
