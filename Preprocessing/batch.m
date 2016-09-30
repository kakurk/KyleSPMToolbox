% Template Preprocessing Batch Script
% Kyle: 9/18/2015

%% Define Study Specific Variables

% Functional Images
Func.path     = '/path/to/functional/images'; % path to the folder that contains the functional data
Func.wildcard = '^ep2bold\w*\.nii';           % wildcard for selecting raw functional images

% Anatomical Images
Anat.path     = '/path/to/anatomical/images'; % path to the folder that contains the anatomical data
Anat.wildcard = '^T1MPRage\w*\.nii';          % wildcard for selecting raw anatomical images

% Subjects
Subjects = { 'y001' 'y002' 'y003' 'y004' 'y005' ...
             'o001' 'o002' 'o003' 'o004' 'o005' };   % subject IDs
% Runs
Runs     = { 'run1' 'run2' 'run3' 'run4' };  % run names


%% Collect Paths to Each Functional Run

cd(Func.path) % make the functional folder the current directory
for subj = 1:length(Subjects)                           % for each subject...
    subj_path = [Func.path filesep Subjects{subj}];     % path to each subjects folder
    cd(subj_path)                                       % make subjects folders the current directory   
    for run = 1:length(Runs)                            % for each run...
        run_path = [subj_path filesep Runs{run}];       % path to each run folder
        cd(run_path)                                    % make the current directory the run folder
        core_cell_array{subj}{run} = cellstr(spm_select('ExtFPList',pwd,Func.wildcard,Inf)); %#ok<*SAGROW>
                                                                   % collect the full paths each frame
    end
end

%% Actually Run Each Subject Through Preprocessing Pipeline

nsub    = length(Subjects); % number of subjects
jobfile = {'/path/to/job/file/Job_File_Name.m'}; % Path to the .m file which houses the GUI settings. AKA a 'job' file
jobs    = repmat(jobfile, 1, nsub);     % initalizing jobs array
inputs  = cell(Number_Of_Inputs, nsub); % initalizing inputs array
for csub = 1:nsub
    inputs{1, csub} = core_cell_array{csub}{1}; % Realign: Estimate & Reslice: Session1 - cfg_files
    inputs{2, csub} = core_cell_array{csub}{2}; % Realign: Estimate & Reslice: Session2 - cfg_files
    inputs{3, csub} = core_cell_array{csub}{3}; % Realign: Estimate & Reslice: Session3 - cfg_files
    inputs{4, csub} = core_cell_array{csub}{4}; % Realign: Estimate & Reslice: Session4 - cfg_files
    inputs{5, csub} = cellstr(spm_select('ExtFPList',[Anat.path filesep Subjects{csub}],Anat.wildcard,1)); % Coreg: Estimate: Source Image - cfg_files
end
spm_figure('GetWin','Graphics');            % Tell SPM to bring up a SPM Graphics window. This ensures that the .ps files are always saved
cd('/path/to/psfiles/folder')               % Change the present working directory to where you would like to store the .ps files
spm('defaults', 'FMRI');                    % Set SPM fMRI defaults
spm_jobman('initcfg')
spm_jobman('serial', jobs, '', inputs{:});  % Run the jobs file 'serially' (in order) filling in inputs with the inputs array