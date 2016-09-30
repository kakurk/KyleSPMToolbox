function [] = SPMOneSampleT()
%% User Input
% You should ONLY (!!!!!!) need to edit this highlighted section of the
% script.

    % User Input Step 1: Specfiy Groups
    % Which subjects are in which experimental groups? Specify below.
    
    Group(1).name = 'AllSubjs';
    Group(1).subjects = { 'y001' 'y002' 'y003' 'y004' 'y005' ...
                          'o001' 'o002' 'o003' 'o004' 'o005' };

    Group(1).name = 'OA';
    Group(1).subjects = { 'o001' 'o002' 'o003' 'o004' 'o005' };

    Group(2).name = 'YA';
    Group(2).subjects = { 'y001' 'y002' 'y003' 'y004' 'y005' };
    
	% User Input Step 2: Specify the analysis directory
    % Where is the analysis directory on this machine?
    Model.name      = 'Name_of_Model_hrf';
    Model.directory = strcat('/path/to/analyses/directory',filesep,Model.name);
    
    % User Input Step 3: Jobmanager option
    % Set the following jobman_option to 'interactive' to view in SPM parameters the GUI. 
    % Press any key into the command window to continue to next one sample t test.
    % Set the following jobman option to 'run' to skip the viewing of the
    % SPM parameters in the GUI and go directly to running of the one
    % sample t-tests
    jobman_option = 'interactive';
    
    % User Input Step 4: Contrasts to Run
    % Which contrasts would you like to do the One Sample T-Tests on? All
    % of them? Only a subset of them? Specify below.
    
%     contrasts2run = [1:3 7];
    contrasts2run = 'all';
    
    
%% Initalize Model Information
% Do not edit!!

    if length(Group) > 1
        allSubjects = horzcat(Group(1).subjects,Group(2).subjects);
    else
        allSubjects = Group(1).subjects;
    end
    
    clc
    fprintf('Analysis: %s\n\n',Model.name)
    fprintf('Analysis Directory:\n')
    disp(Model.directory)
    fprintf('\n\n')
    disp('Checking number of contrasts...')
    tic
    numCons = checkexistingcons(allSubjects,Model.directory);
    fprintf('Total Number of Contrasts = %d ...\n\n',numCons)
    fprintf('\n')
    toc
    fprintf('\n')
    if isnumeric(contrasts2run)
        numCons = length(contrasts2run);
    else
        contrasts2run = 1:numCons;
    end
    fprintf('\n')
    fprintf('Submitting contrast %d to a one-sample t-test\n',contrasts2run)
    fprintf('\n')
    for g = 1:length(Group)
        for k = 1:numCons
            Model.OneSampleTs(g,k)    = struct('confiles', '','conname', '');
        end
    end

%% Gather Contrasts
% Do not edit!!

    disp('Gathering contrasts files...')
    tic
    Model = GatherCons(Group,Model,contrasts2run);
    toc
    fprintf('\n')
    
%% Run through SPM
% Do not edit!!

    spm('Defaults','FMRI')
    spm_jobman('initcfg')
    
    for g = 1:length(Group)
        for curTest = 1:length(Model.OneSampleTs)
            matlabbatch = setSPMparameters(Group(g),Model.OneSampleTs(g,curTest),Model);
            
            if strcmp(jobman_option,'run')
                fprintf('Running SPM job for group %s contrast ''%s''...\n\n',Group(g).name,Model.OneSampleTs(g,curTest).conname)
            elseif strcmp(jobman_option,'interactive')
                 fprintf('Displaying SPM job for group %s contrast ''%s''...\n\n',Group(g).name,Model.OneSampleTs(g,curTest).conname)
            end
            spm_jobman(jobman_option,matlabbatch)
            if strcmp(jobman_option,'interactive')
                pause
            end
        end
    end

%% Subfunctions

    function matlabbatch = setSPMparameters(Group,CurTest,Model)

        groupOneSampleT_dir   = strcat(Model.directory,filesep,Group.name,num2str(length(Group.subjects)));
        curTestOneSampleT_dir = strcat(groupOneSampleT_dir,filesep,CurTest.confiles{1}(end-7:end-4),'_',CurTest.conname);
        if isdir(curTestOneSampleT_dir)
        else
            mkdir(curTestOneSampleT_dir)
        end
        
        matlabbatch{1}.spm.stats.factorial_design.dir = cellstr(curTestOneSampleT_dir);
        matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = CurTest.confiles;
        matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
        matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
        matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
        matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
        matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
        matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
        matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

        % Model Estimation

        matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
        matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
        matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
        matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
        matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
        matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
        matlabbatch{2}.spm.stats.fmri_est.spmmat(1).sname = 'Factorial design specification: SPM.mat File';
        matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
        matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
        matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

        % Contrast Manager

        matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep;
        matlabbatch{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
        matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
        matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
        matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
        matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
        matlabbatch{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
        matlabbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
        matlabbatch{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = CurTest.conname;
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = 1;
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = ['Inverse_' CurTest.conname];
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = -1;
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.delete = 1;

    end

    function MaxNumberOfCons = checkexistingcons(allSubjects,directory)
        MaxNumberOfCons = 0;
        SPM = [];
        for s = 1:length(allSubjects)
            load(strcat(directory,filesep,allSubjects{s},filesep,'SPM.mat'))
            MaxNumberOfCons = max(MaxNumberOfCons,length(SPM.xCon));
        end
    end

    function [Model] = GatherCons(Group,Model,contrasts2run)
        fprintf('\n')
        for curGroup = 1:length(Group)
            disp(Group(curGroup).name)
            fprintf('\n')
            for curSub = 1:length(Group(curGroup).subjects)
                disp(Group(curGroup).subjects{curSub})
                fprintf('\n')
                count = 0;
                SPM = [];                
                curSub_id  = Group(curGroup).subjects{curSub};
                curSub_dir = strcat(Model.directory,filesep,curSub_id);
                load(strcat(curSub_dir,filesep,'SPM.mat'))
                for curCon = 1:length(SPM.xCon)
                    if any(curCon == contrasts2run)
                        count = count + 1;
                        fprintf('Contrast %s ''%s'' \n',SPM.xCon(curCon).Vcon.fname(end-7:end-4),SPM.xCon(curCon).name)
                        if isempty(Model.OneSampleTs(curGroup,count).confiles)
                            Model.OneSampleTs(curGroup,count).confiles = cellstr( spm_select('FPList',curSub_dir,SPM.xCon(count).Vcon.fname) );
                        else
                            Model.OneSampleTs(curGroup,count).confiles = vertcat(Model.OneSampleTs(curGroup,count).confiles,...
                                                                    cellstr( spm_select('FPList',curSub_dir,SPM.xCon(count).Vcon.fname) ) );                            
                        end
                        if isempty(Model.OneSampleTs(curGroup,count).conname)
                            Model.OneSampleTs(curGroup,count).conname = SPM.xCon(count).name;
                        end
                    end
                end
                fprintf('\n')
            end
           fprintf('\n') 
        end
    end

end