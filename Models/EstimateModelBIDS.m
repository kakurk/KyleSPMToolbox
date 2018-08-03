function [] = EstimateModel()
% EstimateModel     function for estimating a GLM specified using the
%                   SpecifyModel. Allows user to display the
%                   trial type onsets/durations in the SPM Batch GUI
%
% Assumes SpecifyModel.m has been run.
%
% See also:  SpecifyModel
%% User Input
% You should ONLY (!!!!!!) need to edit this highlighted section of the
% script.

% User Input Step 1: Analysis, Funcs, and Masks

% Please specify the name of the current analysis, the directory the
% current analysis is in, and the directoy which houses the behavioral
% data.
% 
% Each study is different, with a unique TR and a unique onset and
% duration unit. Please specify:
% -The units used (i.e., 'scans' or 'secs')
% -The TR or repetition time
Model.name    = 'Name_of_Model';
Model.dir     = fullfile('/path/to/models/directory/', Model.name);
Model.regexpr = '.*Run.*\.mat';
Model.units   = 'secs';
Model.TR      = 2;

% These three variables define the functional data. The directory where it
% is housed, a regular expression to be used to select the functional data,
% and the frames of the functional data you would like to select.
Func.dir      = '/path/to/functional/directory';
Func.regexpr  = '^swa.*\.nii';
Func.frames   = Inf;

% Every GLM has a series of counfound regressors used to control for things
% like motion. The following two variables specify where these confound
% files are and a regular expression used to grab them.
Confounds.dir      = '/path/to/confounds/directory';
Confounds.regexpr = '^rp_.*\.txt';

% These variables define an explicit mask to be used for the model. If you
% do NOT wish to specify an explicit mask, leave the on variable set to 
% false.
Mask.on             = false;
Mask.subjectspecifc = false;
Mask.dir            = 'path\to\mask\directory';
Mask.regexpr        = 'mask.nii';

% User Input Step 2: Subjects and Runs

% Please list the subjects to model in a 1 x N cell array.
Subjects = { 'y001' 'y002' 'y003' 'y004' 'y005' ...
             'o001' 'o002' 'o003' 'o004' 'o005' }';

% Please list the runs for the model in a 1 x N cell array. These refer to
% the labels given to the functional image subdirectories.
Runs = { 'run1' 'run2' 'run3' 'run4' };
    
% User Input Step 4: Options

% Set the following jobman_option to 'interactive' to view in SPM parameters the GUI. 
% Press any key into the command window to continue to next one sample t test.
% Set the following jobman option to 'run' to skip the viewing of the
% SPM parameters in the GUI and go directly to running of the one
% sample t-tests

show          = true; % false = input as multiple conditions file, true = input parameters for showing in GUI
jobman_option = 'interactive'; % 'interactive' = show in GUI, 'run' = run through SPM
    
%% Routine

clc
fprintf('Analysis: %s\n\n', Model.name)

fprintf('Gathering Data...\n\n')

for curSub = 1:length(Subjects)

    fprintf('\n')
    fprintf('Subject: %s\n\n', Subjects{curSub})    
    
    %% Mask
    
    % If we are using a mask, create a path to the mask
    if Mask.on
        if Mask.subjectspecific
            % Search for the masks. Give an error if none found.
            all_masks  = spm_select('FPListRec', Mask.dir, Mask.regexpr);
            errorMsg   = sprintf('No masks found in %s \n\nusing regexpr %s.', Mask.dir, Mask.regexpr);
            assert(~isempty(all_masks), errorMsg)
            all_masks  = cellstr(all_masks);
            
            % Grab just the current Subject's mask. Throw an error if this
            % process fails
            curSubMask = all_masks(contains(all_masks, Subjects{curSub}));
            if isempty(curSubMask)
                disp(curSubMask)
                error('Could not find subject %s ''s mask', Subjects{curSub})
            elseif length(curSubMask) > 1
                disp(curSubMask)
                error('Found multiple masks for subject %s', Subjects{curSub})
            end
            Model.mask = curSubMask;
        else
            Model.mask = spm_select('FPList', Mask.dir, Mask.regexpr);
        end
    end

    %% Multiple Condition
    
    % Find all of the multiple condition *.mat files.
    all_multi_conds = spm_select('FPList', Model.dir, Model.regexpr);
    errorMsg        = sprintf('Could not find any multiple condition files in directory %s\n\n using regular expression %s', Model.dir, Model.regexpr);
    assert(~isempty(all_multi_conds), errorMsg)
    all_multi_conds = cellstr(all_multi_conds); % char --> cellstr
    
    % Find the multiple condition *.mat files for the current subject
    cur_sub_multiconds = all_multi_conds(contains(all_multi_conds, Subjects{curSub}));
    errorMsg       = sprintf('Could not find any multiple condition files for Subject %s', Subjects{curSub});
    assert(~isempty(cur_sub_multiconds), errorMsg)
    
    %% Functional Images
    
    % Find all functional images
    all_func_images = spm_select('ExtFPListRec', Func.dir, Func.regexpr, Func.frames);
    errorMsg        = sprintf('Could not find any functional images in directory %s\n\n using regular expression %s', Func.dir, Func.regexpr);
    assert(~isempty(all_func_images), errorMsg)
    all_func_images = cellstr(all_func_images); % char --> cellstr
    
    % Find the functional images for the current subject
    cur_sub_func_images = all_func_images(contains(all_func_images, Subjects{curSub}));
    errorMsg            = sprintf('Could not find any functional images for Subject %s', Subjects{curSub});
    assert(~isempty(cur_sub_func_images), errorMsg)   

    %% Confounds
   
    % Find all confound files
    all_confound_files = spm_select('FPListRec', Confounds.dir, Confounds.regexpr);
    errorMsg           = sprintf('Could not find any confound files in directory %s\n\n using regular expression %s', Confounds.dir, Confounds.regexpr);
    assert(~isempty(all_confound_files), errorMsg)
    all_confound_files = cellstr(all_confound_files); % char --> cellstr
    
    % Find the confound files for the current subject
    cur_sub_confound_files = all_confound_files(contains(all_confound_files, Subjects{curSub}));
    errorMsg            = sprintf('Could not find any functional images for Subject %s', Subjects{curSub});
    assert(~isempty(cur_sub_confound_files), errorMsg)
    
    %% Finish Model Settings
    
    % Model Directory: directory containing this subject's model
    Model.directory = fullfile(Model.dir, Subjects{curSub});      
    
    for i = 1:length(Runs)

        % Find all of the BOLD images for this subject for this run.
        cur_run_func_images = cur_sub_func_images(contains(cur_sub_func_images, Runs{i}));
        errorMsg            = sprintf('Could not find any functional images for Subject %s Run %s', Subjects{curSub}, Runs{i});
        assert(~isempty(cur_run_func_images), errorMsg)
        
        Model.runs{i}.scans     = cur_run_func_images;
        
        % Find the Multi Cond file for this subject for this run.
        cur_run_multicond = cur_sub_multiconds(contains(cur_sub_multiconds, Runs{i}));
        errorMsg            = sprintf('Could not find any functional images for Subject %s Run %s', Subjects{curSub}, Runs{i});
        assert(~isempty(cur_run_multicond), errorMsg)        
        
        Model.runs{i}.multicond = cur_run_multicond;
        
        % Find the Confound file for this subject for this run.
        cur_run_confound_file = cur_sub_func_images(contains(cur_sub_func_images, Runs{i}));
        errorMsg            = sprintf('Could not find any functional images for Subject %s Run %s', Subjects{curSub}, Runs{i});
        assert(~isempty(cur_run_confound_file), errorMsg)        
        
        Model.runs{i}.motion    = cur_run_confound_file;

    end    

    %% Set and Save the SPM job

    matlabbatch = setModelparams();
    save(fullfile(Model.directory, 'job.mat'), 'matlabbatch')

    %% Run the SPM job

    if strcmp(jobman_option,'interactive')
        fprintf('\n')
        fprintf('Displaying SPM Job...\n')
        spm_jobman(jobman_option, matlabbatch)
        pause
    elseif strcmp(jobman_option,'run')
        try
            spm_jobman(jobman_option, matlabbatch)
        catch ER %#ok<*NASGU>
            disp(ER)
            fprintf('ERROR ON: %s', Subjects{curSub})
        end
    end

end

%% Sub Functions

function matlabbatch = setModelparams()
    % Function designed to set the SPM parameters necessary to run a first
    % level model. Takes in structure Model:
    % Model
    %   .directory
    %   .units
    %   .TR
    %   .runs (1 x # of runs)
    %       .scans
    %       .multicond
    %       .motion

    onsets    = [];
    durations = [];
    names     = [];
    pmod      = [];

    % Directory
    matlabbatch{1}.spm.stats.fmri_spec.dir = {Model.directory};

    % Model Parameters
    matlabbatch{1}.spm.stats.fmri_spec.timing.units   = Model.units;
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT      = Model.TR;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t  = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;

    % Session Specific
    for curRun = 1:length(Model.runs)
        matlabbatch{1}.spm.stats.fmri_spec.sess(curRun).scans = Model.runs{curRun}.scans; %#ok<*AGROW>
        if show == 0
            matlabbatch{1}.spm.stats.fmri_spec.sess(curRun).cond  = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
            matlabbatch{1}.spm.stats.fmri_spec.sess(curRun).multi = {Model.runs{curRun}.multicond};
        elseif show == 1
            load(Model.runs{curRun}.multicond)
            for curTrialType = 1:length(names)
                matlabbatch{1}.spm.stats.fmri_spec.sess(curRun).cond(curTrialType).name     = names{curTrialType};
                matlabbatch{1}.spm.stats.fmri_spec.sess(curRun).cond(curTrialType).onset    = onsets{curTrialType};
                matlabbatch{1}.spm.stats.fmri_spec.sess(curRun).cond(curTrialType).duration = durations{curTrialType};
                matlabbatch{1}.spm.stats.fmri_spec.sess(curRun).cond(curTrialType).tmod     = 0;
                if isempty(pmod)
                    matlabbatch{1}.spm.stats.fmri_spec.sess(curRun).cond(curTrialType).pmod = struct('name', {}, 'param', {}, 'poly', {});
                else
                    matlabbatch{1}.spm.stats.fmri_spec.sess(curRun).cond(curTrialType).pmod.name  = pmod(curTrialType).name{1};
                    matlabbatch{1}.spm.stats.fmri_spec.sess(curRun).cond(curTrialType).pmod.param = pmod(curTrialType).param{1};
                    matlabbatch{1}.spm.stats.fmri_spec.sess(curRun).cond(curTrialType).pmod.poly  = pmod(curTrialType).poly{1};
                end
            end
        end
        matlabbatch{1}.spm.stats.fmri_spec.sess(curRun).regress   = struct('name', {}, 'val', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(curRun).multi_reg = {Model.runs{curRun}.motion};
        matlabbatch{1}.spm.stats.fmri_spec.sess(curRun).hpf       = 128;
    end

    % Misc
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    if Model.on
        matlabbatch{1}.spm.stats.fmri_spec.mask = {Model.mask};
    else
        matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    end
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    % Estimation
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name  = 'filter';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name  = 'strtype';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).sname = 'fMRI model specification: SPM.mat File';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;


end
    
end