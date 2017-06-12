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
    Analysis.directory = fullfile('/path/to/analyses/directory', Analysis.name);
    
    % User Input Step 3: Options
    
    % Set the following jobman_option to 'interactive' to view in SPM parameters the GUI. 
    % Press any key into the command window to continue to next one sample t test.
    % Set the following jobman option to 'run' to skip the viewing of the
    % SPM parameters in the GUI and go directly to running of the one
    % sample t-tests
    
    jobman_option      = 'interactive'; % 'run' or 'interactive'.
    cons2run           = 'all'; % [1:3 7];
    deletecons         = 1;     % delete existing contrasts? 1 = yes, 0 = no

%% Setting Analysis specifics contrasts

    clc
    fprintf('Analysis: %s\n\n', Analysis.name)
    disp('Analysis Directory:')
    disp(Analysis.directory)
            
    % Inialize Number.OfContrasts to 0

    Number.OfContrasts = 0;

    % AllTrials- Example All Trials versus baseline for a Memory Study
    Number.OfContrasts = Number.OfContrasts + 1;
    Contrasts(Number.OfContrasts).names    = { 'AllTrials' }; % name of contrast
    Contrasts(Number.OfContrasts).positive = { 'HighHit' 'LowHit' 'AllMiss' 'AllFA' 'HiCR' 'LoCR' }; % TTs to be included in contrast (+)
    Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

    % HighHit_vs_LowHit- Contrasting Two Conditions in an Example a Memory Study
    Number.OfContrasts = Number.OfContrasts + 1;
    Contrasts(Number.OfContrasts).names    = { 'HighHit_vs_LowHit' }; % name of contrast
    Contrasts(Number.OfContrasts).positive = { 'HighHit' }; % TTs to be included in contrast (+)
    Contrasts(Number.OfContrasts).negative = { 'LowHit' }; % TTs to be included in contrast (-)            

    % AllFA_parampos- Example with a parametric modulator "Relatedness" using 1st Order Modulation using a positive contast wieght
    Number.OfContrasts = Number.OfContrasts + 1;
    Contrasts(Number.OfContrasts).names    = { 'AllFA_parampos' }; % name of contrast
    Contrasts(Number.OfContrasts).positive = { 'AllFAxRelatedness^1' }; % TTs to be included in contrast (+)
    Contrasts(Number.OfContrasts).negative = {}; % TTs to be included in contrast (-)

    % AllFA_parampos- Example with a parametric modulator "Relatedness" using 1st Order Modulation using a negative contast wieght
    Number.OfContrasts = Number.OfContrasts + 1;
    Contrasts(Number.OfContrasts).names    = { 'AllFA_paramneg' }; % name of contrast
    Contrasts(Number.OfContrasts).positive = {}; % TTs to be included in contrast (+)
    Contrasts(Number.OfContrasts).negative = { 'AllFAxRelatedness^1' }; % TTs to be included in contrast (-)

%% Routine
% Should not need to be edited

    % Set SPM Defaults

    spm('defaults','FMRI')
    spm_jobman('initcfg')
    Count.ProblemSubjs = 0;
    
    fprintf('\n')
    fprintf('Number of Contrasts Specified: %d \n\n', length(Contrasts))
    
    for indexS = 1:length(Subjects)
        
        % Build Contrast Vectors

            pathtoSPM = fullfile(Analysis.directory, Subjects{indexS}, 'SPM.mat');
            fprintf('Building Contrast Vectors...\n\n')
            Contrasts = BuildContrastVectors(Contrasts, pathtoSPM);
            
        % Run SPM Contrast Manager
        
            if strcmp(jobman_option,'interactive')
                fprintf('Displaying SPM Job for Subject %s ...\n\n', Subjects{indexS})
            elseif strcmp(jobman_option,'run')
                fprintf('Running SPM Job for Subject %s ...\n\n', Subjects{indexS})                
            end
            matlabbatch = SetContrastManagerParams(Contrasts, pathtoSPM, deletecons, cons2run);
            try
                spm_jobman(jobman_option, matlabbatch)
                if strcmp(jobman_option, 'interactive')
                    pause
                end
            catch error %#ok<NASGU>
                display(Subjects{indexS})
                Count.ProblemSubjs = Count.ProblemSubjs + 1;
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

    function matlabbatch = SetContrastManagerParams(Contrasts, pathtoSPM, delete, cons2run)
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

        if strcmp(cons2run,'all')
            k = 1:length(Contrasts);
        else
            k = cons2run;
        end
        
        matlabbatch{1}.spm.stats.con.spmmat = cellstr(pathtoSPM);
        count = 0;
        for curCon = k
            count = count + 1;
            fprintf('Contrast %d: %s\n', curCon, Contrasts(curCon).names{1})
            matlabbatch{1}.spm.stats.con.consess{count}.tcon.name    = Contrasts(curCon).names{1};
            matlabbatch{1}.spm.stats.con.consess{count}.tcon.convec  = Contrasts(curCon).vector;
            matlabbatch{1}.spm.stats.con.consess{count}.tcon.sessrep = 'none';
        end
        matlabbatch{1}.spm.stats.con.delete = delete;

    end

end
