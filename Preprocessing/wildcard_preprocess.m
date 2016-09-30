function wildcard_preprocess()

    %%% GLAMM 'Wildcard' Preprocessing Routine

    %%% This script is designed to batch multiple subjects through a preprocessing
    %%% pipeline designed to collect ALL AVAIABLE FUNCTIONAL RUNS USING WILDCARDS,
    %%% and PREPROCESSING THEM ALLTOGETHER, realightning the images to the first
    %%% image of the first run of the first collected functional run (caps added for empahsis).

    %%% Assumes each subject has a high resolution anatomical in its 'anat' folder.
    %%% If this is not the case this script will error out.

    %%% Written by Kyle Kurkela, kyleakurkela@gmail.com 7/20/2015
    %%% Updated 9/10/2015
    %%% Updated Again, 5/2/2016

    %% User Input

    % User Input Step 1: The subjects array
    % List the subjects to preprocess in a cell array
    subjects = { '001' '002' '003' '004' '005' '006' '007' '008' '009' '010' }; % List of Subject IDs to batch through
    
    % User Input Step 2: The Flag
    % Set the flag to 1 to look at the parameters interactively in the GUI
    % and 2 to actually run the parameters through SPM 12
    flag     = 2;
    
    
    % User Input 3: Wildcards
    % Please specify a regular expression (google regular expressions) that
    % will select only the the raw image functional series and the raw
    % anatomical image respectively.
    regularexpr.func = '^run\w*\.nii';
    regularexpr.anat = '^T1\w*\.nii';
    wildcards.runs   = 'run*';

    
    % User Input 4: Directories
    % Please secify the paths to the directories that hold the functional
    % images and anatomic images respectively
    directories.func    = 'path\to\func\directory';
    directories.anat    = 'path\to\anat\directory';
    directories.psfiles = 'path\to\psfiles\directory';
    
    %% Routine
    
    spm('defaults', 'FMRI'); % load SPM default options
    spm_jobman('initcfg')    % Configure the SPM jobman

    for csub = 1:length(subjects) % for each subject...
        subject_funcfolder = strcat(directories.func,subjects{csub}); % create the path to this subjects' functional folder
        
        runs               = CollectFolderNames(subject_funcfolder,wildcards.runs); % using Kyle's function "CollectFolderNames" located in the GLAMM scripts folder, 
                                                                            % collect all directories that are 'something 1'
        
        matlabbatch        = wildcard_parameters12(runs,subjects{csub},regularexpr,directories); % using Kyle's "wilcard_parameters" subfuncion which is located in the same directory as this script,
                                                                                 % set the preprocessing parameters for this routine
                                                                                 
        anat_directory = strcat(directories.anat,subjects{csub}); % path to this subjects anatomical folder
        inputs{1} = {spm_select('ExtFPList',anat_directory,regularexpr.anat,Inf)};
        
        if flag == 1
            spm_jobman('interactive',matlabbatch)
            pause
        elseif flag == 2
            spm_figure('GetWin','Graphics'); % configure spm graphics window. Ensures a .ps file is saved during preprocessing
            cd(directories.psfiles)     % make psfiles the working directory. Ensures .ps file is saved in this directory
            tic % Start timer
            spm_jobman('run',matlabbatch,inputs{:}); % run preprocessing
            timing{csub} = toc; %#ok<*AGROW> % End timer
            disp(timing{csub})
            % Rename the ps file from "spm_CurrentDate.ps" to "GLAMM_SubjectID.ps"
            temp = date;
            date_rearranged = [temp(end-3:end) temp(4:6) temp(1:2)];
            movefile(['spm_' date_rearranged '.ps'],sprintf('%s.ps',subjects{csub}))
        end

    end
    
    %% Sub Functions
    
    function foldernamecellarray = CollectFolderNames(folder,wildcard)
        % Function designed for collecting folder names within a directory 'folder' 
        % using a specified wildcard 'wildcard'. Folder names are returned in a 
        % cell array for easier scripting. Kyle A Kurkela, kyleakurkela@gmail.com
        % 2/10/2016.

        present_dir=pwd;

        cd(folder)
        kyle=dir(wildcard);
        count = 0;
        for k = 1:length(kyle)
            if strcmp(kyle(k).name,'..') || strcmp(kyle(k).name,'.')
            else
                count=count+1;
                foldernamecellarray{count} = kyle(k).name; %#ok<AGROW>
            end
        end
        cd(present_dir)
    end

end