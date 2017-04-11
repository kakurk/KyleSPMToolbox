function [] = SpecifyModel()
% SpecifyModel      function designed to build multiple conditions files
%                   for later use with SPM's matlabbatch system
%
%   This function takes no input. All relevenat variables are defined 
%   within the body of this function.
%
%   See also EstimateModel.m

%% 
%==========================================================================
%                           User Input
%==========================================================================

% User Input Step 1: Directories

% Please specify the name of the current analysis, the directory the
% current analysis is in, and the directoy which houses the behavioral
% data.

Analysis.name             = 'Name_Of_Model_hrf';
Analysis.directory        = fullfile('/path/to/analysis/directory', Analysis.name);
Analysis.behav.directory  = '/path/to/behavioral/data/directory';


% User Input Step 2: Subjects

% Please list the subjects to model in a 1 x N cell array.

Subjects       = { 'y001' 'y002' 'y003' 'y004' 'y005' ...
                   'o001' 'o002' 'o003' 'o004' 'o005' };


% User Input Step 3: Model Specifics

% Each model is unique, with a different number of trial types, a
% different behavioral excel sheet identifier, and whether or not there
% are any parametric modulators. In this section, please specify the
% following variables for you model:
% - Number of Trial Types (i.e., regressors)
% - Behavioral File Regular Expression
% - Number of Parametric Modulators

Number.OfTrialTypes           = 4;
Analysis.behav.regexp         = '.*_ENCdm.xls';
ParametricMods                = 0;

%% Routine

% Clean up and print update to the command window

clc
fprintf('Model: %s\n\n', Analysis.name)
fprintf('Model Directory: \n')
disp(Analysis.directory)
fprintf('\n')
fprintf('Behavioral Data Directory: \n')
disp(Analysis.behav.directory)
fprintf('\n')

% for each subject...

for indexS = 1:length(Subjects)
    
    %-- Build Path to this Subject's Behavioral Data
    % This section builds a path to the current subjects behavioral
    % file using spm_select's recursive function. See spm_select for more
    % details

    curSubj.name      = Subjects{indexS};
    curSubj.behavdir  = spm_select('FPListRec', Analysis.behav.directory, 'dir', ['.*' curSubj.name '.*']);
    curSubj.behavFile = spm_select('FPListRec', curSubj.behavdir, Analysis.behav.regexp);


    %-- Read in this Subject's Behavioral Data
    % This section of the code reads in the subjects behavioral data using
    % the readtable command. See readtable for more details

    fprintf('Reading in Subject %s ''s Behav Data ...\n\n\n\n', curSubj.name)
    BehavData     = readtable(curSubj.behavFile);
    Number.OfRows = height(BehavData);

    %-- Build path to this subjects analysis directory
    % This section builds a path to this subjects analysis directory,
    % and creates that directory if it does not already exist.

    curSubj.directory = fullfile(Analysis.directory, curSubj.name);
    if isdir(curSubj.directory)
    else
        mkdir(curSubj.directory)
    end

    %-- Initalize the counter cell array
    % The counter cell array will keep track of how many trials occur in
    % each trial type in each functional run

    Number.OfRuns = max(unique(BehavData.Run));
    counter       = zeros(Number.OfRuns, Number.OfTrialTypes);

    %-- Build the multiple conditions *.mat file for each run

    fprintf('Sorting Behavioral Data...\n\n\n\n')

    for curRun = 1:Number.OfRuns
        
        %-- Initialize the names, onsets, durations, and pmods structure arrays
        % This section inilaized the names, onsets, and durations
        % structure arrays, which will be filled in with the
        % approrpiate information in a nested for loop.

        names     = cell(1, Number.OfTrialTypes); % initalizing TT names
        onsets    = cell(1, Number.OfTrialTypes); % initalizing TT onset vector
        durations = cell(1, Number.OfTrialTypes); % intializing TT durations vector

        % Only initialize the pmod structure array if this model
        % contains (a) parametric modulator(s)

        if ParametricMods > 0
            for indexP = 1:Number.OfTrialTypes
                pmod(indexP).name  = cell(1,ParametricMods);
                pmod(indexP).param = cell(1,ParametricMods);
                pmod(indexP).poly  = cell(1,ParametricMods);
            end
        end

        %-- for each trial...
        
        for curTrial = 1:Number.OfRows
            
            % Sort this trial into a "bin" or trial type
            % Sort the trial types one functional run at a time

            % if the current trial is a part of the current run...
            if curRun == BehavData.Run(curTrial);

                %--clean up the command window and update the user
                clc
                fprintf('Sorting Run %d...\n\n', curRun)                    
                fprintf('Sorting Trial %d...\n\n', (curTrial-1))

                %--record variable values for this trial
                
                rawonset    = BehavData.rawonset(curTrial);    % trial onset time
                score       = BehavData.score(curTrial);       % score
                type        = BehavData.type(curTrial);        % type
                relatedness = BehavData.relatedness(curTrial); % relatedness para mod

                %--Sort Trials into Trial Type Bins
                
                % Initalize the Trial Type index, which simply keeps track
                % of which trial type number we are on
                indexTT = 0;

                % Trial Type: HighHit
                indexTT = indexTT+1;
                if  type == 0 && score == 4

                    counter(curRun,indexTT)                     = counter(curRun,indexTT)+1;
                    names{indexTT}                              = 'HighHit';
                    onsets{indexTT}(counter(curRun,indexTT))    = rawonset/1000;
                    durations{indexTT}(counter(curRun,indexTT)) = 0;

                end

                % Trial Type: LowHit
                indexTT = indexTT+1;                            
                if  type == 0 && score == 3

                    counter(curRun,indexTT) = counter(curRun,indexTT)+1; 
                    names{indexTT}                              = 'LowHit';
                    onsets{indexTT}(counter(curRun,indexTT))    = rawonset/1000;
                    durations{indexTT}(counter(curRun,indexTT)) = 0;

                end

                % Trial Type: AllMiss
                indexTT = indexTT+1;                            
                if  type == 0 && (score == 2 || score == 1)

                    counter(curRun,indexTT) = counter(curRun,indexTT)+1; 
                    names{indexTT}                              = 'AllMiss';
                    onsets{indexTT}(counter(curRun,indexTT))    = rawonset/1000;
                    durations{indexTT}(counter(curRun,indexTT)) = 0;

                end

                % Trial Type: AllFA
                indexTT = indexTT+1;                            
                if  (type == 1 || type == 2 || type == 3 || type == 4) ...
                        && (score == 2 || score == 1)

                    counter(curRun,indexTT) = counter(curRun,indexTT)+1;
                    names{indexTT}                              = 'AllFA';
                    onsets{indexTT}(counter(curRun,indexTT))    = rawonset/1000;
                    durations{indexTT}(counter(curRun,indexTT)) = 0;

                    % Parametric Modulators for this Trial Type
                    indexPmod = 0;

                    % Parametric Modulator 1
                    indexPmod = indexPmod + 1;
                    pmod(indexTT).name{indexPmod}  = 'Relatedness';
                    pmod(indexTT).param{indexPmod}(counter(curRun,indexTT)) = relatedness;
                    pmod(indexTT).poly{indexPmod}  = 1;

                end

                % Trial Type: HiCR
                indexTT = indexTT+1;
                if (type == 1 || type == 2 || type == 3 || type == 4) ...
                        && score == 4

                    counter(curRun,indexTT) = counter(curRun,indexTT)+1;
                    names{indexTT}                              = 'HiCR';
                    onsets{indexTT}(counter(curRun,indexTT))    = rawonset/1000;
                    durations{indexTT}(counter(curRun,indexTT)) = 0;

                    % Parametric Modulators for this Trial Type
                    indexPmod = 0;

                    % Parametric Modulator 1
                    indexPmod = indexPmod + 1;
                    pmod(indexTT).name{indexPmod}  = 'Relatedness';
                    pmod(indexTT).param{indexPmod}(counter(curRun,indexTT)) = relatedness;
                    pmod(indexTT).poly{indexPmod}  = 1;

                end

                % Trial Type: LoCR
                indexTT = indexTT+1;
                if (type == 1 || type == 2 || type == 3 || type == 4) ...
                        && score == 3

                    counter(curRun,indexTT) = counter(curRun,indexTT)+1;
                    names{indexTT}                              = 'LoCR';
                    onsets{indexTT}(counter(curRun,indexTT))    = rawonset/1000;
                    durations{indexTT}(counter(curRun,indexTT)) = 0;

                    % Parametric Modulators for this Trial Type
                    indexPmod = 0;

                    % Parametric Modulator 1
                    indexPmod = indexPmod + 1;
                    pmod(indexTT).name{indexPmod}  = 'Relatedness';
                    pmod(indexTT).param{indexPmod}(counter(curRun,indexTT)) = relatedness;
                    pmod(indexTT).poly{indexPmod}  = 1;   

                end

                % Trial Type: NR
                indexTT = indexTT+1;
                if score == 99

                    counter(curRun,indexTT) = counter(curRun,indexTT)+1;
                    names{indexTT}                              = 'NR';
                    onsets{indexTT}(counter(curRun,indexTT))    = rawonset/1000;
                    durations{indexTT}(counter(curRun,indexTT)) = 0;

                end
                
                %-- Update the user on the sorting process
                % Display the Names, Onsets, Durations, and Pmod structure
                % arrays with a brief pause in between so the user can
                % interactively see trials being sorted
                
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

        %-- Prune Missing Trial Types
        % Check to see if all trial types occured in this run. If any did
        % not, remove them from the names/onsets/durations/pmod strucure
        % arrays

        fprintf('\nPruning Non-existant Trial Types...\n\n')
        if exist('pmod', 'var')
            [names, onsets, durations, pmod] = prune_nonexistent_trialtypes(names, onsets, durations, pmod);
        else
            [names, onsets, durations]       = prune_nonexistent_trialtypes(names, onsets, durations);
        end
        
        %-- User Update Post Pruning
        % Update the user with what the pruned Names, Onsets, Durations,
        % and Pmod structure arrays after pruning
        
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

        %-- Save the Multiple Conditions *.mat file
        % Save the names, onsets, durations, and pmod variables in a .mat
        % file to be uploaded back into MATLAB/SPM at a later date for
        % model estimation

        matfilename = fullfile(curSubj.directory, ['Run', num2str(curRun), '_multiple_conditions.mat']);
        fprintf('Saving Subject %s''s Run %d multiple conditions file...\n\n\n', curSubj.name, curRun)
        pause(3)
        if ParametricMods ~= 0
            save(matfilename, 'names', 'onsets', 'durations', 'pmod');
        else
            save(matfilename, 'names', 'onsets', 'durations');
        end

    end
end

disp('All Finished!!')
    
%% 
%==========================================================================
%				Sub Functions
%==========================================================================    

function [varargout] = prune_nonexistent_trialtypes(varargin)
% prune_noexistent_trialtypes   function that removes empty fields of
%                               a set of names/onsets/durations/pmod
%                               structures
%
%   varargin{1} = in_names = a "names" structure to be used with SPM's
%                            matlabbatch system
%
%   varargin{2} = in_onsets = an "onsets" structure to be used with
%                             SPM's matlabbatch system
%
%   varargin{3} = in_durations = a "durations" structure to be used
%                                with SPM's matlabbatch system
%
%   varargin{4} = in_pmod = a "pmod" structure to be used with SPM's
%                           matlabbatch system
%
%   varargout{1} = out_names = a "names" structure array with the empty
%                              fields removed
%
%   varargout{2} = out_onsets = an "onsets" structure to be used with
%                             SPM's matlabbatch system
%
%   varargout{3} = out_durations = a "durations" structure to be used
%                                with SPM's matlabbatch system
%
%   varargout{4} = out_pmod = a "pmod" structure to be used with SPM's
%                           matlabbatch system
%
%   See also: spm_jobman 

    in_names     = varargin{1};
    in_onsets    = varargin{2};
    in_durations = varargin{3};
    if nargin == 4
        in_pmod = varargin{4};
    end

    ncount = 0;
    for n = 1:length(in_names)
        if ~isempty(in_names{n})
            ncount = ncount+1;
            outnames{ncount} = in_names{n};
        end
    end

    ocount = 0;
    for o = 1:length(in_onsets)
        if ~isempty(in_onsets{o})
            ocount = ocount+1;
            outonsets{ocount} = in_onsets{o};             
        end
    end

    dcount = 0;
    for d = 1:length(in_durations)
        if ~isempty(in_durations{d})
            dcount = dcount + 1;
            outdurations{dcount} = in_durations{d};
        else
            pmod_ind = d;
        end
    end

    if nargin == 4
        pcount = 0;
        for p = 1:length(in_pmod)
            if p ~= pmod_ind
                pcount = pcount + 1;
                outpmod(pcount) = in_pmod(p);
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