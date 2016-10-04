function [] = SPMTwoSampleT()
%% User Input
% You should ONLY (!!!!!!) need to edit this highlighted section of the
% script.

% User Input Part 1: Group specification
% What are the two groups you would like to submit to the two-sample
% t-test? What are the names of both groups and which subjects are in each
% group?

    Group(1).name = 'OA';
    Group(1).subjects = { 'o001' 'o002' 'o003' 'o004' 'o005' };

    Group(2).name = 'YA';
    Group(2).subjects = { 'y001' 'y002' 'y003' 'y004' 'y005' };

% User Input Part 2: Model Directory
% Where is this model on this computer system?
    Model.name      = 'Name_of_Model_hrf';
    Model.directory = fullfile('/path/to/analyses/directory', Model.name);


% User Input Part 3: SPM Job Manager Option
% Would you like to view the SPM parameters in the GUI? Or just run them?
    jobman_option = 'interactive';
    
% User Input Part 4: Contrast Information
% Which contrasts would you like to submit to the two sample t-tests? All
% of them? Only a sub-set of them?
    
    contrasts2run = 'all'; % [1:3 7];
    
% User Input Part 5: One Sample T-Test Contrasts
% Do you want the OneSample T-Test contrast of each group in the two-sample 
% t-test directory?
% Please note, in order for this to work you need to run Kyles One Sample
% T-Test script prior to running this one.
    OneSampleOption = 'No';

%% Gather Contrasts

clc
fprintf('Analysis: %s\n\n', Model.name)
display('Analysis Directory:')
display(Model.directory)
fprintf('\n')
display('Gathering contrasts files...')
fprintf('\n\n')
tic
Model = GatherCons(Group, Model, contrasts2run);
toc
fprintf('\n')
    
%% Run through SPM

spm('Defaults','FMRI')
spm_jobman('initcfg')
[~,col] = size(Model.TwoSampleTs);
for curTest = 1:col
    TwoSampleT_dir = strcat(Model.directory,filesep,Group(1).name,num2str(length(Group(1).subjects)),'_vs_',Group(2).name,num2str(length(Group(2).subjects)));
    curTest_dir    = strcat(TwoSampleT_dir,filesep,Model.TwoSampleTs(1,curTest).confiles{1}(end-7:end-4),'_',Model.TwoSampleTs(1,curTest).conname);
    if isdir(curTest_dir)
    else
        mkdir(curTest_dir)
    end        

    matlabbatch = setSPMparameters(Group,Model.TwoSampleTs(:,curTest),curTest_dir);
    if strcmp(jobman_option,'run')
        fprintf('Running SPM job for two-sample t-test of contrast %s ''%s''...\n',Model.TwoSampleTs(1,curTest).confiles{1}(end-7:end-4),Model.TwoSampleTs(1,curTest).conname)
    elseif strcmp(jobman_option,'interactive')
        fprintf('Displaying SPM job for two sample t-test of contrast %s ''%s''...\n',Model.TwoSampleTs(1,curTest).confiles{1}(end-7:end-4),Model.TwoSampleTs(1,curTest).conname)
    end
    spm_jobman(jobman_option,matlabbatch)
    if strcmp(jobman_option,'interactive')
        pause
    end
    save(strcat(curTest_dir,filesep,'Job.mat'),'matlabbatch')
    clear matlabbatch
    if strcmp(OneSampleOption,'Yes')
        fprintf('Copying One Sample T''s...\n')
        CopyOneSampleTs(Group,Model,curTest_dir);
    end
end

%% Subfunctions

    function matlabbatch = setSPMparameters(Group, CurTest, curTest_dir)
        
        matlabbatch{1}.spm.stats.factorial_design.dir = cellstr(curTest_dir);
        matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = CurTest(1,1).confiles;
        matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = CurTest(2,1).confiles;
        matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
        matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
        matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
        matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
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
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = strcat(Group(1).name,'_vs_',Group(2).name);
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [1 -1];
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = strcat(Group(2).name,'_vs_',Group(1).name);
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [-1 1];
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.delete = 1;

    end

    function Model = GatherCons(Group, Model, Contrasts2Run)
        
        % First thing we need to do is parse the Contrasts2Run
        if ischar(Contrasts2Run)
            if strcmp(Contrasts2Run,'all')
                disp('Submitting all available contrasts to two sample t-test...')
                fprintf('\n')
            else
                disp('If setting contrasts2run to a string, string must be ''all''')
                return
            end
        elseif isnumeric(Contrasts2Run)
            fprintf('Submitting contrast %d to a two-sample t-test...\n',Contrasts2Run)
            fprintf('\n')
        end
        
        for curGroup = 1:length(Group) % for each group...
            fprintf([Group(curGroup).name '\n'])
            
            for curSub = 1:length(Group(curGroup).subjects) % for this subject of group X...
                
                fprintf(['\n' Group(curGroup).subjects{curSub} '...\n'])
                
                % Step 1: Load this subjects SPM.mat file into the MATLAB workspace            
                SPM = [];
                curSub_id  = Group(curGroup).subjects{curSub};
                curSub_dir = strcat(Model.directory,filesep,curSub_id);
                load(fullfile(curSub_dir,'SPM.mat'))
                
                % Step 2: If the user sets the Contrasts2Run input to all,
                % create a vector counting from 1 number of contrasts in
                % this subject's SPM
                if ischar(Contrasts2Run)
                    Contrasts2Run = 1:length(SPM.xCon);
                end
                
                if curSub == 1 && curGroup == 1
                    Model.TwoSampleTs = struct('confiles', cell(length(Group),length(Contrasts2Run)), 'conname', cell(length(Group),length(Contrasts2Run)));
                end
                
                % Step 3: Set the counter, which keeps track of how many
                % two-sample t-tests we are running, to zero.
                count = 0;
                
                for curCon = 1:length(SPM.xCon)
                    if any(curCon == Contrasts2Run)
                        display([sprintf('Contrast %d, ',curCon) SPM.xCon(curCon).name])                        
                        count = count + 1;
                        if isempty(Model.TwoSampleTs(curGroup,count).confiles)
                            Model.TwoSampleTs(curGroup,count).confiles = cellstr( spm_select('FPList',curSub_dir,SPM.xCon(curCon).Vcon.fname) );
                        else
                            Model.TwoSampleTs(curGroup,count).confiles = vertcat(Model.TwoSampleTs(curGroup,count).confiles,...
                                                                    cellstr( spm_select('FPList',curSub_dir,SPM.xCon(curCon).Vcon.fname) ) );                            
                        end
                        if isempty(Model.TwoSampleTs(curGroup,count).conname)
                            Model.TwoSampleTs(curGroup,count).conname = SPM.xCon(curCon).name;
                        end
                    end
                    
                end
            end
            fprintf('\n')
        end
        fprintf('\n\n')
    end

    function CopyOneSampleTs(Group, Model, curTest_dir)
        SPM = [];
        load(fullfile(curTest_dir,'SPM.mat'))
        TwoSampleSPM = SPM;
        for cg = 1:length(Group)
            SPM = [];
            OneSampleT_dir = strcat(Model.directory,filesep,Group(1).name,num2str(length(Group(1).subjects)),filesep,Model.TwoSampleTs(1,curTest).confiles{1}(end-7:end-4),'_',Model.TwoSampleTs(1,curTest).conname);
            load(strcat(OneSampleT_dir,filesep,'SPM.mat'))
            OneSampleSPM = SPM;
            TwoSampleSPM.xCon(cg+2) = OneSampleSPM.xCon(1);
            TwoSampleSPM.xCon(cg+2).name = strcat(Group(cg).name,num2str(length(Group(cg).subjects)),'_',TwoSampleSPM.xCon(cg+2).name);
            if cg == 1
                TwoSampleSPM.xCon(cg+2).c = [1 0]';
            elseif cg == 2
                TwoSampleSPM.xCon(cg+2).c = [0 1]';
            end
            TwoSampleSPM.xCon(cg+2).Vcon.fname = sprintf('con_000%d.img',(cg+2));
            TwoSampleSPM.xCon(cg+2).Vcon.descrip = strcat(TwoSampleSPM.xCon(cg+2).Vcon.descrip,'Taken From ',Group(cg).name,num2str(length(Group(cg).subjects)));
            TwoSampleSPM.xCon(cg+2).Vspm.fname = sprintf('spmT_000%d.img',(cg+2));
            TwoSampleSPM.xCon(cg+2).Vspm.descrip = strcat(TwoSampleSPM.xCon(cg+2).Vcon.descrip,'Taken From ',Group(cg).name,num2str(length(Group(cg).subjects)));
            
            fprintf('\n')
            disp('Copying...')
            fprintf('\n')
            disp(fullfile(OneSampleT_dir,'con_0001.img'))
            disp('--->')
            disp(strcat('     ',curTest_dir,filesep,sprintf('con_000%d.img',(cg+2))))
            copyfile(fullfile(OneSampleT_dir, 'con_0001.img'), fullfile(curTest_dir, sprintf('con_000%d.img', (cg+2))))
            copyfile(fullfile(OneSampleT_dir, 'con_0001.hdr'), fullfile(curTest_dir, sprintf('con_000%d.hdr', (cg+2))))
            
            fprintf('\n')
            disp('Copying...')
            fprintf('\n')
            disp(fullfile(OneSampleT_dir, 'spmT_0001.img'))
            disp('--->')
            disp(strcat('     ',curTest_dir,filesep,sprintf('spmT_000%d.img',(cg+2))))
            copyfile(fullfile(OneSampleT_dir,'spmT_0001.img'), fullfile(curTest_dir, sprintf('spmT_000%d.img',(cg+2))))
            copyfile(fullfile(OneSampleT_dir,'spmT_0001.hdr'), fullfile(curTest_dir, sprintf('spmT_000%d.hdr',(cg+2))))                
        end
        SPM = []; %#ok<*NASGU>
        SPM = TwoSampleSPM;
        save(fullfile(curTest_dir, 'SPM.mat'), 'SPM')
    end

end