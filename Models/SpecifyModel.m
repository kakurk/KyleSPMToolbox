function [] = SpecifyModel()
%% User Input
% You should ONLY (!!!!!!) need to edit this highlighted section of the
% script.

    % User Input Step 1: Directories
    
    % Please specify the name of the current analysis, the directory the
    % current analysis is in, and the directoy which houses the behavioral
    % data.
    
    Analysis.name             = 'Name_Of_Model_hrf';
    Analysis.directory        = fullfile('/path/to/analysis/directory', Analysis.name);
    Analysis.behav.directory  = '/path/to/behavrioal/data/directory';
    
    
    % User Input Step 2: Subjects
    
    % Please list the subjects to model in a 1 x N cell array.
    
    Subjects       = { 'y001' 'y002' 'y003' 'y004' 'y005' ...
                       'o001' 'o002' 'o003' 'o004' 'o005' };
    

    % User Input Step 3: Model Specifics
    
    % Each model is unique, with a different number of trial types, a
    % different behavioral excel sheet identifier, and whether or not there
    % are any parametric modulators. In this section, please specify the
    % following parameters for you model:
    % -Number of Trial Types
    % -Behavioral File Identifier
    % -Number of ParametricModulators
    
    % A note on switch..case. Switch..case is essenatially a more elagant
    % if...else statement. It evaluates the lines of code that when the
    % switch variable matches the case variable.
    
    switch Analysis.name

        % -------- Encoding Models ----------
        
        % Basic Model
        case 'AnalysisName1'
            Number.OfTrialTypes           = 4;
            Analysis.behav.FileIdentifier = '_ENCdm.xls';

        % -------- Retrieval Models ---------
        
        % Basic Model
        case 'SceneFM_Analysis_Example: SceneFM_ret_hrf'
            Number.OfTrialTypes           = 6;
            Analysis.behav.FileIdentifier = '_RET1.xls';
            
        % Parametric Models
        case 'AnalysisName3'
            Number.OfTrialTypes           = 1;
            Analysis.behav.FileIdentifier = '_RET1.xls';
            ParametricMods = 3;
            
        case 'MORF_Analysis_Example: Relatedness_hrf'
            Number.OfTrialTypes           = 7;
            Analysis.behav.FileIdentifier = '_ret.xls';
            ParametricMods                = 1;
    end

    %% Routine
    % In this highlighted section of code, you should NOT need to make any
    % edits unless specifically directed to do so. Look for the sections
    % that have a:
    % =================USER INPUT REQUIRED=================================
    
    clc
    fprintf('Model: %s\n\n', Analysis.name)
    fprintf('Model Directory: \n')
    disp(Analysis.directory)
    fprintf('\n')
    fprintf('Behavioral Data Directory: \n')
    disp(Analysis.behav.directory)
    fprintf('\n')
    
    for indexS = 1:length(Subjects)
        %% Build Path to this Subject's Behavioral Data
        % This section builds a path to the current subjects behavioral
        % file using the stract function.

        curSubj.name      = Subjects{indexS};
        curSubj.behavFile = fullfile(Analysis.behav.directory, 'ret', curSubj.name, [curSubj.name Analysis.behav.FileIdentifier]);

        %% Read in this Subject's Behavioral Data
        % This section of the code reads in the subjects behavioral data.
        
        fprintf('Reading in Subject %s ''s Behav Data ...\n\n\n\n',curSubj.name)
        [~,~,BehavData]   = xlsread(curSubj.behavFile, 'Sheet1');
        [Number.OfRows,~] = size(BehavData);

        %% Build path to this subjects analysis directory
        % This section builds a path to this subjects analysis directory,
        % and creates that directory if it does not already exist.
        
        curSubj.directory = strcat(Analysis.directory,filesep,curSubj.name);
        if isdir(curSubj.directory)
        else
            mkdir(curSubj.directory)
        end

        %% Initalize the counter cell array
        % ============USER INPUT REQUIRED==================================
        % The counter cell array will keep track of how many trials occur in
        % each trial type in each functional run

        Number.OfRuns = HowManyRuns(BehavData,3); % <---- Input which column keeps track of the current run in the behavioral data
        counter       = zeros(Number.OfRuns,Number.OfTrialTypes);

        %% Build the multiple conditions *.mat file for each subject
        
        fprintf('Sorting Behavioral Data...\n\n\n\n')
        
        for indexRun = 1:Number.OfRuns
            %% Initialize the names, onsets, durations, and pmods structure arrays
            % This section inilaized the names, onsets, and durations
            % structure arrays, which will be filled in with the
            % approrpiate information in a nested for loop.
            
            names     = cell(1,Number.OfTrialTypes); % initalizing TT names
            onsets    = cell(1,Number.OfTrialTypes); % initalizing TT onset vector
            durations = cell(1,Number.OfTrialTypes); % intializing TT durations vector
            
            % Only initialize the pmod structure array if this model
            % contains a parametric modulator
            
            if exist('ParametricMods','var')
                for indexP = 1:Number.OfTrialTypes
                    pmod(indexP).name  = cell(1,ParametricMods);
                    pmod(indexP).param = cell(1,ParametricMods);
                    pmod(indexP).poly  = cell(1,ParametricMods);
                end
            end
            
            for indexRow = 2:Number.OfRows
                %% Identify Relevant Variables from this Row
                
                Variables.trialRun  = BehavData{indexRow,3};

                %% Sort this trial into a "bin" or trial type
                % Sort the trial types one functional run at a time

                if indexRun == Variables.trialRun
                    
                    clc
                    fprintf('Sorting Run %d...\n\n',indexRun)                    
                    fprintf('Sorting Trial %d...\n\n',(indexRow-1))
                    
                    switch Analysis.name
                            
                        case 'MORF_Analysis_Example: Relatedness_hrf'
                            
                            Variables.rawonset    = BehavData{indexRow,11};
                            Variables.score       = BehavData{indexRow,6};
                            Variables.type        = BehavData{indexRow,10};
                            Variables.relatedness = BehavData{indexRow,15};
                            
                            
                            % Sort Trials into Trial Types
                            indexTT = 0;
                            
                            % Trial Type: HighHit
                            indexTT = indexTT+1;
                            if  Variables.type == 0 && Variables.score == 4
                                
                                counter(indexRun,indexTT) = counter(indexRun,indexTT)+1;
                                names{indexTT}                                = 'HighHit';
                                onsets{indexTT}(counter(indexRun,indexTT))    = Variables.rawonset/1000;
                                durations{indexTT}(counter(indexRun,indexTT)) = 0;
                                
                            end
                            
                            % Trial Type: LowHit
                            indexTT = indexTT+1;                            
                            if  Variables.type == 0 && Variables.score == 3
                                
                                counter(indexRun,indexTT) = counter(indexRun,indexTT)+1; 
                                names{indexTT}                                = 'LowHit';
                                onsets{indexTT}(counter(indexRun,indexTT))    = Variables.rawonset/1000;
                                durations{indexTT}(counter(indexRun,indexTT)) = 0;
                                
                            end
                            
                            % Trial Type: AllMiss
                            indexTT = indexTT+1;                            
                            if  Variables.type == 0 && (Variables.score == 2 || Variables.score == 1)
                                
                                counter(indexRun,indexTT) = counter(indexRun,indexTT)+1; 
                                names{indexTT}                                = 'AllMiss';
                                onsets{indexTT}(counter(indexRun,indexTT))    = Variables.rawonset/1000;
                                durations{indexTT}(counter(indexRun,indexTT)) = 0;
                                
                            end
                            
                            % Trial Type: AllFA
                            indexTT = indexTT+1;                            
                            if  (Variables.type == 1 || Variables.type == 2 || Variables.type == 3 || Variables.type == 4) ...
                                    && (Variables.score == 2 || Variables.score == 1)
                                
                                counter(indexRun,indexTT) = counter(indexRun,indexTT)+1;
                                names{indexTT}                                = 'AllFA';
                                onsets{indexTT}(counter(indexRun,indexTT))    = Variables.rawonset/1000;
                                durations{indexTT}(counter(indexRun,indexTT)) = 0;
                                
                                % Parametric Modulators for this Trial Type
                                indexPmod = 0;
                                
                                % Parametric Modulator 1
                                indexPmod = indexPmod + 1;
                                pmod(indexTT).name{indexPmod}  = 'Relatedness';
                                pmod(indexTT).param{indexPmod}(counter(indexRun,indexTT)) = Variables.relatedness;
                                pmod(indexTT).poly{indexPmod}  = 1;
                            
                            end
                            
                            % Trial Type: HiCR
                            indexTT = indexTT+1;
                            if (Variables.type == 1 || Variables.type == 2 || Variables.type == 3 || Variables.type == 4) ...
                                    && Variables.score == 4
                                
                                counter(indexRun,indexTT) = counter(indexRun,indexTT)+1;
                                names{indexTT}                                = 'HiCR';
                                onsets{indexTT}(counter(indexRun,indexTT))    = Variables.rawonset/1000;
                                durations{indexTT}(counter(indexRun,indexTT)) = 0;
                            
                                % Parametric Modulators for this Trial Type
                                indexPmod = 0;
                                
                                % Parametric Modulator 1
                                indexPmod = indexPmod + 1;
                                pmod(indexTT).name{indexPmod}  = 'Relatedness';
                                pmod(indexTT).param{indexPmod}(counter(indexRun,indexTT)) = Variables.relatedness;
                                pmod(indexTT).poly{indexPmod}  = 1;
                                
                            end
                            
                            % Trial Type: LoCR
                            indexTT = indexTT+1;
                            if (Variables.type == 1 || Variables.type == 2 || Variables.type == 3 || Variables.type == 4) ...
                                    && Variables.score == 3
                            
                                counter(indexRun,indexTT) = counter(indexRun,indexTT)+1;
                                names{indexTT}                                = 'LoCR';
                                onsets{indexTT}(counter(indexRun,indexTT))    = Variables.rawonset/1000;
                                durations{indexTT}(counter(indexRun,indexTT)) = 0;
                            
                                % Parametric Modulators for this Trial Type
                                indexPmod = 0;
                                
                                % Parametric Modulator 1
                                indexPmod = indexPmod + 1;
                                pmod(indexTT).name{indexPmod}  = 'Relatedness';
                                pmod(indexTT).param{indexPmod}(counter(indexRun,indexTT)) = Variables.relatedness;
                                pmod(indexTT).poly{indexPmod}  = 1;   
                                
                            end
                            
                            % Trial Type: NR
                            indexTT = indexTT+1;
                            if Variables.score == 99
                                
                                counter(indexRun,indexTT) = counter(indexRun,indexTT)+1;
                                names{indexTT}                                = 'NR';
                                onsets{indexTT}(counter(indexRun,indexTT))    = Variables.rawonset/1000;
                                durations{indexTT}(counter(indexRun,indexTT)) = 0;
                            
                            end
                            
                        case 'Retreival_Blocked_All3Parametric_hrf'
                            
                            Variables.rawonset = BehavData{indexRow,7};  % onset
                            Variables.TT       = BehavData{indexRow,9};  % trial type
                            Variables.allHH_bs = BehavData{indexRow,22}; % all High Hits Para Mod                         
                            Variables.incHH_bs = BehavData{indexRow,23}; % all inc High Hits Para Mod
                            Variables.intHH_bs = BehavData{indexRow,24}; % all int High Hits Para Mod
                            
                            % Sort Trials into Trial Types
                            indexTT = 0;
                            
                            % Trial Type: TaskBLK
                            
                            indexTT = indexTT+1;
                            if  Variables.TT == 6

                                counter(indexRun,indexTT) = counter(indexRun,indexTT)+1;
                                names{indexTT}                                = 'TaskBLK';
                                onsets{indexTT}(counter(indexRun,indexTT))    = Variables.rawonset/1000;
                                durations{indexTT}(counter(indexRun,indexTT)) = 30;
                                
                                % Parametric Modulators for this Trial Type
                                indexPmod = 0;
                                
                                % Parametric Modulator 1
                                indexPmod = indexPmod + 1;
                                pmod(indexTT).name{indexPmod}  = 'allHH_bs';
                                pmod(indexTT).param{indexPmod}(counter(indexRun,indexTT)) = Variables.allHH_bs;
                                pmod(indexTT).poly{indexPmod}(counter(indexRun,indexTT))  = 1;
                                
                                % Parametric Modulator 2
                                indexPmod = indexPmod + 1;                                
                                pmod(indexTT).name{indexPmod}  = 'incHH_bs';
                                pmod(indexTT).param{indexPmod}(counter(indexRun,indexTT)) = Variables.incHH_bs;
                                pmod(indexTT).poly{indexPmod}(counter(indexRun,indexTT))  = 1;
                                
                                % Parametric Modulator 3
                                indexPmod = indexPmod + 1;                                
                                pmod(indexTT).name{indexPmod}  = 'intHH_bs';
                                pmod(indexTT).param{indexPmod}(counter(indexRun,indexTT)) = Variables.intHH_bs;
                                pmod(indexTT).poly{indexPmod}(counter(indexRun,indexTT))  = 1;                            
                                
                            end
                            
                        case 'Retreival_Blocked_Just2Parametric_hrf'
                            
                            indexTT      = 0;
                            Variables.rawonset = BehavData{indexRow,7};
                            Variables.TT       = BehavData{indexRow,9};
                            Variables.incHH_bs = BehavData{indexRow,23};
                            Variables.intHH_bs = BehavData{indexRow,24};

                            % Sort Trials into Trial Types
                            indexTT = 0;
                            
                            % Trial Type: TaskBLK_inc
                            indexTT = indexTT+1;                            
                            if  Variables.TT == 6
                                
                                counter(indexRun,indexTT) = counter(indexRun,indexTT)+1;
                                names{indexTT}                                = 'TaskBLK';
                                onsets{indexTT}(counter(indexRun,indexTT))    = Variables.rawonset/1000;
                                durations{indexTT}(counter(indexRun,indexTT)) = 30;
                                
                                % ------- Parametric Modulators for this Trial Type --------- %
                                indexPmod = 0;
                                
                                % Parametric Modulator 1
                                indexPmod = indexPmod + 1;                                
                                pmod(indexTT).name{indexPmod}  = 'incHH_bs'; %#ok<*AGROW>
                                pmod(indexTT).param{indexPmod}(counter(indexRun,indexTT)) = Variables.incHH_bs;
                                pmod(indexTT).poly{indexPmod}(counter(indexRun,indexTT))  = 1;
                                
                                % Parametric Modulator 2
                                indexPmod = indexPmod + 1;                                
                                pmod(indexTT).name{indexPmod}  = 'intHH_bs';
                                pmod(indexTT).param{indexPmod}(counter(indexRun,indexTT)) = Variables.intHH_bs;
                                pmod(indexTT).poly{indexPmod}(counter(indexRun,indexTT))  = 1;   
                                
                            end
                            
                    end
                    fprintf('\n')
                    disp('Names:')
                    disp(names')
                    disp('Onsets:')
                    disp(onsets')
                    disp('Durations:')
                    disp(durations')
                    if exist('pmod','var')
                        disp('Parametic Modulators')
                        for indexPmod = 1:length(pmod)
                            disp(pmod(indexPmod))
                        end
                    end
                    fprintf('\n')
                    pause(.1)
                end
                
            end

            %% Check to see if all trial types occured in this run. If any did
            % not, remove them from the names/onsets/durations cell array
            
            fprintf('\nPruning Non-existant Trial Types...\n\n')
            if exist('pmod','var')
                [names,onsets,durations,pmod] = prune_nonexistent_trialtypes(names,onsets,durations,pmod); %#ok<*NASGU,*ASGLU>   
            else
                [names,onsets,durations] = prune_nonexistent_trialtypes(names,onsets,durations); %#ok<*NASGU,*ASGLU>
            end
            fprintf('\n')
            disp('Names:')
            disp(names')
            disp('Onsets:')
            disp(onsets')
            disp('Durations:')
            disp(durations')
            if exist('pmod','var')
                disp('Parametic Modulators')
                disp(pmod)
            end
            fprintf('\n')
            
            %% Save the Multiple Conditions *.mat file in this subjects' analysis
            % directory

            matfilename = fullfile(curSubj.directory, curSubj.name, ['Run', num2str(indexRun), '.mat']);
            fprintf('Saving Subject %s''s Run %d multiple conditions file...\n\n\n', curSubj.name, indexRun)
            pause(3)
            if exist('ParametricMods','var')
                save(matfilename,'names','onsets','durations','pmod');
            else
                save(matfilename,'names','onsets','durations');
            end

        end
    end
    
    disp('Finished!!')
    
    %% Sub Functions
    
    function NumOfRuns = HowManyRuns(BehavData,CurRunColumn)
        %%% Function to determine how many runs occur in this set of behav
        %%% data.
        [Number.OfRows,~] = size(BehavData); 
        NumOfRuns = 0;
        for j = 2:Number.OfRows
           NumOfRuns = max(NumOfRuns, BehavData{j,CurRunColumn});
        end
    end

    function [varargout] = prune_nonexistent_trialtypes(varargin)
        innames     = varargin{1};
        inonsets    = varargin{2};
        indurations = varargin{3};
        if nargin == 4
            inpmod = varargin{4};
        end
        
        ncount = 0;
        for n = 1:length(innames)
            if ~isempty(innames{n})
                ncount = ncount+1;
                outnames{ncount} = innames{n};
            end
        end

        ocount = 0;
        for o = 1:length(inonsets)
            if ~isempty(inonsets{o})
                ocount = ocount+1;
                outonsets{ocount} = inonsets{o};             
            end
        end

        dcount = 0;
        for d = 1:length(indurations)
            if ~isempty(indurations{d})
                dcount = dcount + 1;
                outdurations{dcount} = indurations{d};
            else
                pmod_ind = d;
            end
        end
        
        if nargin == 4
            pcount = 0;
            for p = 1:length(inpmod)
                if p ~= pmod_ind
                    pcount = pcount + 1;
                    outpmod(pcount) = inpmod(p);
                end
            end
        end
        
        varargout{1} = outnames;
        varargout{2} = outonsets;
        varargout{3} = outdurations;
        if nargin == 4
            varargout{4} = outpmod;
        end
    end

end