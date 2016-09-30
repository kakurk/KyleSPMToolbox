function [] = FullFactorial()
%% Initalize Counter Variables 
% These are counter variables, used to keep track of the number of
% groups/contrasts/effects/factors that the user specifies in the body of
% this script. Do NOT edit.

    Number.OfFacts    = 0;
    Number.OfGroups   = 0;
    Number.OfCons     = 0;
    Number.OfSubjs    = 0;

%% User Input 1: Subjects
   
    % SPM Job Manager Option
    jobman_option = 'interactive'; % 'run' or 'interactive'
    
    % First specify your different subject groups as cell strings

    Number.OfGroups = Number.OfGroups+1;
    Groups(Number.OfGroups).name = 'OA';
    Groups(Number.OfGroups).ids = { '60o422','61o388','61o427','61o429','62o432','63o395',...
                               '63o397','63o413','64o405','65o425','65o426','68o334',...
                               '68o416','69o418','70o421','70o434','71o153','71o424',...
                               '75o264','75o372','76o407','77o417','81o346' }; % '32930cfl' '33343vsn' '33055eaj'

    Number.OfGroups = Number.OfGroups+1;
    Groups(Number.OfGroups).name = 'YA';
    Groups(Number.OfGroups).ids = { '19y2159' '19y2184' '20y2161' '20y2162' '21y2108' '21y2115' ...
                               '21y2122' '21y2136' '21y2153' '21y2160' '21y2197' '22y2189' ...
                               '22y2195' '22y2196' '23y2107' '25y2164' '25y2176' '25y2177' ...
                               '26y2175' '27y2163' '28y2152' '28y2178' '30y2174' '31y2150' ...
                               '31y2165' };

    % Analysis name
    ANOVA.analysis = 'Relatedness_hrf';
    % This Analysis' directory
    ANOVA.directory = strcat('s:\nad12\MORF\Analysis_ret',filesep,ANOVA.analysis);

%% Routine 1: Number of Subjects
% Calculate the total number of subjects from the cellstrings entered above

    for k = 1:length(Groups)
       Number.OfSubjs = Number.OfSubjs + length(Groups(k).ids);
    end

%% User Input 2: Factors

% Create the between subjects factor 'Age Group'

    Number.OfFacts = Number.OfFacts+1;
    ANOVA.factors(Number.OfFacts).name     = 'Age Group';
    ANOVA.factors(Number.OfFacts).levels   = Number.OfGroups;
    ANOVA.factors(Number.OfFacts).type     = 'between';

% Within Subjects Factors

    % First Repeated Measure

    Number.OfFacts = Number.OfFacts+1;
    ANOVA.factors(Number.OfFacts).name = 'Encoding Condition (Incidental/Intentional)';
    ANOVA.factors(Number.OfFacts).levels = 2;
    ANOVA.factors(Number.OfFacts).type = 'within';

    % Second Repeated Measure

    Number.OfFacts = Number.OfFacts+1;
    ANOVA.factors(Number.OfFacts).name   = 'Subsequent Memory (HighDM/LowDM/MissDM)';
    ANOVA.factors(Number.OfFacts).levels = 3;
    ANOVA.factors(Number.OfFacts).type   = 'within';

    % Contrasts corresponding to within subjects factor levels

    Number.OfCons = Number.OfCons + 1;
    Contrasts(Number.OfCons).name      = 'HDm_inc';
    Contrasts(Number.OfCons).image     = 'con_0002.img';
    Contrasts(Number.OfCons).FactLevel = [1 1];

    Number.OfCons = Number.OfCons + 1;
    Contrasts(Number.OfCons).name      = 'LDm_inc';
    Contrasts(Number.OfCons).image     = 'con_0003.img';
    Contrasts(Number.OfCons).FactLevel = [1 2];

    Number.OfCons = Number.OfCons + 1;
    Contrasts(Number.OfCons).name      = 'allMissDm_inc';
    Contrasts(Number.OfCons).image     = 'con_0004.img';
    Contrasts(Number.OfCons).FactLevel = [1 3];

    Number.OfCons = Number.OfCons + 1;
    Contrasts(Number.OfCons).name      = 'HDm_int';
    Contrasts(Number.OfCons).image     = 'con_0005.img';
    Contrasts(Number.OfCons).FactLevel = [2 1];

    Number.OfCons = Number.OfCons + 1;
    Contrasts(Number.OfCons).name      = 'LDm_int';
    Contrasts(Number.OfCons).image     = 'con_0006.img';
    Contrasts(Number.OfCons).FactLevel = [2 2];

    Number.OfCons = Number.OfCons + 1;
    Contrasts(Number.OfCons).name      = 'allMissDm_int';
    Contrasts(Number.OfCons).image     = 'con_0007.img';
    Contrasts(Number.OfCons).FactLevel = [2 3];

%% Gather Contrasts

    ANOVA = gathercontrasts(ANOVA,Groups,Contrasts,Number);
    
%% Set Parameters

    matlabbatch = setFullFactParams(ANOVA);

%% Run Model

    spm('Defaults','FMRI')
    spm_jobman('initcfg')
    spm_jobman(jobman_option,matlabbatch)

%% Sub Functions

    function ANOVA = gathercontrasts(ANOVA,Groups,Contrasts,Number)
    % Gather Contrasts and create the Factor Matrix
    %
    % Inialize the scans and factor matrices, speeds up the code
    % How big are these matrices going to be? There will be a row for each
    % observation, or Number.OfSubjs * levels of repeated measure 1 * levels of
    % repeated measure 2 ... * levels of repeated measure N.
        
        Count.FactorLevels = 1;
        for indexK = 1:length(ANOVA.factors)
            Count.FactorLevels = Count.FactorLevels * ANOVA.factors(indexK).levels;
        end
        
        ANOVA.scans      = cell(Count.FactorLevels,1); % scans for each cell of the ANOVA
        ANOVA.factmatrix = ones(Count.FactorLevels,Number.OfFacts); % maps the scans to the factors
        
        % Gather the Contrasts and Build the Factor Matrix

            Count.Scans = 0;
            
            for indexG = 1:Number.OfGroups
                for indexC = 1:Number.OfCons
                    Count.Scans = Count.Scans+1;
                    ANOVA.factmatrix(Count.Scans,1) = indexG;
                    ANOVA.factmatrix(Count.Scans,2:end) = Contrasts(indexC).FactLevel;
                    for indexS = 1:length(Groups(indexG).ids)
                       tmp_dir = strcat(ANOVA.directory,filesep,Groups(indexG).ids{indexS});                       
                       ANOVA.scans{Count.Scans} = vertcat(ANOVA.scans{Count.Scans},cellstr(spm_select('FPList', tmp_dir, Contrasts(indexC).image)));
                       fprintf('Adding %s: %s''s %s contrast: %s... \n',Groups(indexG).name,Groups(indexG).ids{indexS},Contrasts(indexC).name,Contrasts(indexC).image)
                    end
                end
            end
    end

    function matlabbatch = setFullFactParams(ANOVA)
        % Function that takes in the structure array ANOVA, with the fields:
        %  .directory = 's:\nad12\Hybridwords\Analyses\SPM8\EPI_Masked\Encoding_ER_hrf\ANOVA';
        %  .factors = a 1 x number of factors structure array:
        %           .name = 'subjects'
        %           .dept =
        %           .variance =
        %   .cells = a 1 x number of cells structure array:
        %           .IDvector = [1 2]
        %           .scans = cell array of strings of the full paths to the con_*.imgs

        % Does ANOVA directory exist? If not, create it.

        if isdir(ANOVA.directory)
        else
            mkdir(ANOVA.directory)
        end

        % Set ANOVA Directory

        matlabbatch{1}.spm.stats.factorial_design.dir = cellstr(strcat(ANOVA.directory,filesep,'ANOVA'));

        % Set Factor Specific Parameters

        for curfactor = 1:length(ANOVA.factors)

            matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(curfactor).name = ANOVA.factors(curfactor).name; %#ok<*AGROW>
            matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(curfactor).levels = ANOVA.factors(curfactor).levels;
            if strcmp(ANOVA.factors(curfactor).type,'within')
                matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(curfactor).dept = 1;
                matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(curfactor).variance = 1;
            elseif strcmp(ANOVA.factors(curfactor).type,'between')
                matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(curfactor).dept = 0;
                matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(curfactor).variance = 1;
            end
            matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(curfactor).gmsca = 0;
            matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(curfactor).ancova = 0;

        end

        % Set ANOVA cells

        for curcell = 1:length(ANOVA.scans)
            matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(curcell).levels = ANOVA.factmatrix(curcell,:);
            matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(curcell).scans = ANOVA.scans{curcell};
        end

        % Set Covariates, masks, and global calculations
        % Keep as defaults, for now.

        matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
        matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
        matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
        matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
        matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
        matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
        matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

        % Model Estimation.
        % Dependent on model specification module above. The Full Factorial
        % Model will automatically calculate the F-Tests necessary for main 
        % effects, all 2-way interactions as well as the T-Tests necessary for
        % the positive effects of the Main Effects and interactions.

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