function FlexibleFactorial()
% Function for running a flexible factorial ANOVA in SPM.
% Written by Kyle Kurkela, kyleakurkela@gmail.com

%% Initalize Counter Variables 

    Number.OfFacts     = 0;
    Number.OfGroups    = 0;
    Number.OfContrasts = 0;
    Number.OfEffects   = 0;
    Number.OfSubjs     = 0;

%% Current Analysis and Subjects

    % Analysis name
    jobman_option = 'interactive'; % 'run' or 'interactive'

    % Between Subjects Factors
    % Specify your subject groups as cell strings

    Number.OfGroups = Number.OfGroups+1;
    Groups{Number.OfGroups}.name = 'OA';
    Groups{Number.OfGroups}.ids  = { 'o001' 'o002' 'o003' 'o004' 'o005' };

    Number.OfGroups = Number.OfGroups+1;
    Groups{Number.OfGroups}.name = 'YA';
    Groups{Number.OfGroups}.ids  = { 'y001' 'y002' 'y003' 'y004' 'y005' };

    % Calculate the total number of subjects from the cellstrings entered above
    for k = 1:length(Groups)
       Number.OfSubjs = Number.OfSubjs + length(Groups{k}.ids);
    end
    
    % This Analysis' directory
    ANOVA.analysis  = 'Name_Of_Model';
    ANOVA.directory = fullfile('Path/To/Analysis/Directory', ANOVA.analysis);

%% ANOVA Factors
% Create the between subjects factors 'Subjects' which will be used for all
% analyses

    Number.OfFacts = Number.OfFacts+1;
    ANOVA.factors(Number.OfFacts).name     = 'Subjects';
    ANOVA.factors(Number.OfFacts).levels   = Number.OfSubjs;
    ANOVA.factors(Number.OfFacts).type     = 'between';
    ANOVA.factors(Number.OfFacts).dep      = 0;
    ANOVA.factors(Number.OfFacts).variance = 0;

    Number.OfFacts = Number.OfFacts+1;
    ANOVA.factors(Number.OfFacts).name     = 'Group';
    ANOVA.factors(Number.OfFacts).levels   = Number.OfGroups;
    ANOVA.factors(Number.OfFacts).type     = 'between';
    ANOVA.factors(Number.OfFacts).dep      = 0;
    ANOVA.factors(Number.OfFacts).variance = 0;

%% Within Subjects Factors
% These will changes from model to model, hence switch...case

    switch ANOVA.analysis

        case 'Name_Of_Model'

            % First Repeated Measure

            Number.OfFacts = Number.OfFacts+1;
            ANOVA.factors(Number.OfFacts).name     = 'Name_Of_First_Repeated_Measure (INC/INT)';
            ANOVA.factors(Number.OfFacts).levels   = 2;
            ANOVA.factors(Number.OfFacts).type     = 'within';
            ANOVA.factors(Number.OfFacts).dep      = 1;
            ANOVA.factors(Number.OfFacts).variance = 1;

            % Second Repeated Measure

            Number.OfFacts = Number.OfFacts+1;
            ANOVA.factors(Number.OfFacts).name     = 'Name_Of_First_Repeated_Measure (HDm/LDn/allMissDm)';
            ANOVA.factors(Number.OfFacts).levels   = 3;
            ANOVA.factors(Number.OfFacts).type     = 'within';
            ANOVA.factors(Number.OfFacts).dep      = 1;
            ANOVA.factors(Number.OfFacts).variance = 1;

             % Corresponding Contrasts

            Number.OfContrasts = Number.OfContrasts + 1;
            Contrasts(Number.OfContrasts).name      = 'HDm_inc';
            Contrasts(Number.OfContrasts).image     = 'con_0002.img';
            Contrasts(Number.OfContrasts).FactLevel = [1 1];

            Number.OfContrasts = Number.OfContrasts + 1;
            Contrasts(Number.OfContrasts).name      = 'LDm_inc';
            Contrasts(Number.OfContrasts).image     = 'con_0003.img';
            Contrasts(Number.OfContrasts).FactLevel = [1 2];

            Number.OfContrasts = Number.OfContrasts + 1;
            Contrasts(Number.OfContrasts).name      = 'allMissDm_inc';
            Contrasts(Number.OfContrasts).image     = 'con_0004.img';
            Contrasts(Number.OfContrasts).FactLevel = [1 3];

            Number.OfContrasts = Number.OfContrasts + 1;
            Contrasts(Number.OfContrasts).name      = 'HDm_int';
            Contrasts(Number.OfContrasts).image     = 'con_0005.img';
            Contrasts(Number.OfContrasts).FactLevel = [2 1];

            Number.OfContrasts = Number.OfContrasts + 1;
            Contrasts(Number.OfContrasts).name      = 'LDm_int';
            Contrasts(Number.OfContrasts).image     = 'con_0006.img';
            Contrasts(Number.OfContrasts).FactLevel = [2 2];

            Number.OfContrasts = Number.OfContrasts + 1;
            Contrasts(Number.OfContrasts).name      = 'allMissDm_int';
            Contrasts(Number.OfContrasts).image     = 'con_0007.img';
            Contrasts(Number.OfContrasts).FactLevel = [2 3];

    end

%% Specify Effects to Model

    % Main Effect of Subjects
    Number.OfEffects = Number.OfEffects + 1;
    ANOVA.effects(Number.OfEffects).type = 'fmain';
    ANOVA.effects(Number.OfEffects).vec  = 1;

    % Two Way Interaction of Age Group and Encoding Condition
    Number.OfEffects = Number.OfEffects + 1;
    ANOVA.effects(Number.OfEffects).type = 'inter';
    ANOVA.effects(Number.OfEffects).vec  = [2 
                                            3];
                                   
%% Routine                                   

    ANOVA = gathercontrasts(ANOVA, Groups, Contrasts, Number);
    
    % Set Parameters

    matlabbatch = setFlexFactParams(ANOVA);

    % Run Model

    spm('Defaults','FMRI')
    spm_jobman('initcfg')
    spm_jobman(jobman_option, matlabbatch)

%% Subfunctions
    
    function ANOVA = gathercontrasts(ANOVA,Groups,Contrasts,Number)
        % Gather Contrasts and Create the Factor Matrix
        
        % Inialize the scans and factor matrices, speeds up the code
        % How big are these matrices going to be? There will be a row for each
        % observation, or Number.OfSubjs * levels of repeated measure 1 * levels of
        % repeated measure 2 ... * levels of repeated measure N.
        
        Number.OfRepeatedMeasuresLevels = 1; % initalize a variable to calculate the number of repeated measures levels

        % Loop through all of the ANOVA factors, find the 'within' subjects ones,
        % keep a running count of the number of levels. Note we do NOT want: 
        % levels of repeated measure 1 + levels of repeated measure 2 + ... levels
        % of repeated measure N. We want: levels of repeated measure 1 * levels of 
        % repeated measure 2 * ... levels of repeated measure N.

        for indexF = 1:length(ANOVA.factors)
            if strcmp(ANOVA.factors(indexF).type,'within')        
                Number.OfRepeatedMeasuresLevels = Number.OfRepeatedMeasuresLevels * ANOVA.factors(indexF).levels;
            end
        end

        DesignMatrixLength = Number.OfSubjs*Number.OfRepeatedMeasuresLevels;
        ANOVA.scans = cell(DesignMatrixLength,1);
        ANOVA.factmatrix = ones(DesignMatrixLength,Number.OfFacts+1); % note that there is an extra column in this matrix, a column of 1s, per SPM's designations

        % Gather the Contrasts and Build the Factor Matrix

        Count.Subjs = 0; % initalize a counter to keep track of number of Subjects we have gone through
        Count.Scans = 0; % initalize a counter to keep track of number of Scans we have gone through
        for indexG = 1:Number.OfGroups
            for indexS = 1:length(Groups{indexG}.ids)
                Count.Subjs = Count.Subjs+1; % advance the Subject counter
                tmp_dir = strcat(ANOVA.directory,filesep,Groups{indexG}.ids{indexS}); % this subjects directory
                for indexC = 1:Number.OfContrasts
                   Count.Scans = Count.Scans+1; % advance the scan counter
                   ANOVA.factmatrix(Count.Scans,2) = Count.Subjs;
                   ANOVA.factmatrix(Count.Scans,3) = indexG;
                   ANOVA.factmatrix(Count.Scans,4:end) = Contrasts(indexC).FactLevel(:)';
                   if Count.Scans == 1
                        ANOVA.scans = cellstr(spm_select('FPList', tmp_dir, Contrasts(indexC).image));
                   else
                        ANOVA.scans = vertcat(ANOVA.scans,cellstr(spm_select('FPList', tmp_dir, Contrasts(indexC).image)));
                   end
                   fprintf('Adding %s: %s''s %s contrast: %s... \n',Groups{indexG}.name,Groups{indexG}.ids{indexS},Contrasts(indexC).name,Contrasts(indexC).image)
                end
            end
        end

        clc
    end    
    
    function matlabbatch = setFlexFactParams(ANOVA)
        % Function that takes in the structure array ANOVA:
        % ANOVA
        %  .directory = 's:\nad12\Hybridwords\Analyses\SPM8\EPI_Masked\Encoding_ER_hrf\ANOVA';
        %  .factors = a 1 x number of factors structure array:
        %           .name = 'subjects'
        %           .dept =
        %           .variance =
        %  .scans = number of subjects x 1 cell string of paths to contrast images
        %           from the first level. Needs to match your factor matrix.
        %  .factmatrix = "The first column should be all 1s. The next 3 columns correspond to your factors. 
        %                 The second column should index subjects, the third whatever your first entered 
        %                 condition is, and the fourth column indexes your second condition. So if I had 
        %                 4 subjects, then a group factor, then a within-subject condition with 2 levels, 
        %                 the full matrix would look like this:
        %                   1 1 1 1
        %                   1 1 1 2
        %                   1 2 1 1
        %                   1 2 1 2
        %                   1 3 2 1
        %                   1 3 2 2
        %                   1 4 2 1
        %                   1 4 2 2
        %                 This needs to match with the order that you selected your images in as well, 
        %                 as each line of this corresponds to the image at that index in your image list." -SPM Listserv
        %   .effects = a 1 x number of effects structure array:
        %            .type = 'fmain' for main effect and 'inter' for interaction 
        %            .vec = a vector corresponding to factor numbers.

        % Create Analysis Directory, if it doesn't already exist

        if isdir(strcat(ANOVA.directory,filesep,'ANOVA'))
        else
            mkdir(strcat(ANOVA.directory,filesep,'ANOVA'))
        end

        % Specify the Flexible Factorial Model

        % Directory
        matlabbatch{1}.spm.stats.factorial_design.dir = cellstr(strcat(ANOVA.directory,filesep,'ANOVA'));

        % Factors
        for curFactor = 1:length(ANOVA.factors)
            matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(curFactor).name = ANOVA.factors(curFactor).name;
            matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(curFactor).dept = ANOVA.factors(curFactor).dep;
            matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(curFactor).variance = ANOVA.factors(curFactor).variance;
            matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(curFactor).gmsca = 0;
            matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(curFactor).ancova = 0;
        end

        % Scans and Factor Specification Matrix
        matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.specall.scans = ANOVA.scans;
        matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.specall.imatrix = ANOVA.factmatrix;

        % Effects

        % Main Effects
        for curEffect = 1:length(ANOVA.effects)
            matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{curEffect}.(ANOVA.effects(curEffect).type).fnum = ANOVA.effects(curEffect).vec;
        end

        % Covariates, masking, and global corrections
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

    end

end
