function [] = parameters(subject,VOI_name,VOI_XYZ,VOI_size,gPPI_dir,analysis_dir)
%% Create a VOI mask
% Go to this subjects gPPI directory. If the mask exists, move on. If the
% masks does not exist, create it.

cd([gPPI_dir filesep subject])           % Change present working directory to this subjects gPPI dir
if exist([VOI_name '_mask.nii'], 'file') % if there is already a VOI image for this person, move on
else                                     % if not...
    create_sphere_image('SPM.mat',VOI_XYZ,{VOI_name},VOI_size) % create sphere around seed and save it in this subjects gPPI dir
end

%% Load first level univariate parameters and remove 'Run#_' from the beginning of regressor names
% In order to avoid a concatenation bug, go to this subject's
% first level analysis directory and edit his/her first level SPM
% parameters file ('SPM.mat') by removing "Run#_" from the front of
% regressor names. For example, if the first level model has
% "Run1_TRIALTYPE" and "Run2_TRIALTYPE". See WIKI for further explanation.

first_level_dir = [analysis_dir filesep subject];                       % Path to subjects GLM analysis dir                                                    % Go to the this subject's first level directory
load(fullfile(first_level_dir,'SPM.mat'))                               % Load this subject's SPM parameters
for k = 1:length(SPM.Sess) %#ok<NODEF>                                  % for each Session...
    for u = 1:length(SPM.Sess(k).U)                                     % for each Trial Type in Session k...
        if strcmp(SPM.Sess(k).U(u).name{1}(1:3),'Run')                  % If this regressor has "Run" as the first 3 characters...
            SPM.Sess(k).U(u).name{1} = SPM.Sess(k).U(u).name{1}(6:end); % Remove the first 5 characters of the regressor's name
            disp(SPM.Sess(k).U(u).name{1})                              % Display the changeed regressor name in the MATLAB Command Window
        else
        end
    end
end
save('SPM.mat','SPM') % Save the SPM parameters loaded above to a file called "SPM.mat" in this subject's first level analysis directory.
                      % Note this overwrites the SPM.mat file which already exists

%% Setting the gPPI Parameters

%%% For more details on the parameters below and what they mean, go to the
%%% gPPI website and download the guide: http://www.nitrc.org/projects/gppi

P.subject       = subject; % A string with the subjects id
P.directory     = first_level_dir; % path to the first level GLM directory
P.VOI           = [gPPI_dir filesep subject filesep VOI_name '_mask.nii']; % path to the ROI image, created above
P.Region        = VOI_name; % string, basename of output folder
P.Estimate      = 1; % Yes, estimate this gPPI model
P.contrast      = 0; % contrast to adjust for. Default is zero for no adjustment
P.extract       = 'eig'; % method for ROI extraction. Default is eigenvariate
P.Tasks         = ['0' {'TASKNAME1' 'TASKNAME2'}]; % Specify the tasks for this analysis. Think of these as trial types. Zero means "does not have to occur in every session"
P.Weights       = []; % Weights for each task. If you want to weight one more than another. Default is not to weight when left blank
P.maskdir       = [gPPI_dir filesep subject]; % Where should we save the masks?
P.equalroi      = 1; % When 1, All ROI's must be of equal size. When 0, all ROIs do not have to be of equal size
P.FLmask        = 0; % restrict the ROI's by the first level mask. This is useful when ROI is close to the edge of the brain
P.VOI2          = {}; % specifiy a second ROI. Only used for "physiophysiological interaction"
P.analysis      = 'psy'; % for "psychophysiological interaction"
P.method        = 'cond'; % "cond" for gPPI and "trad" for traditional PPI
P.CompContrasts = 1; % 1 to estimate contrasts
P.Weighted      = 0; % Weight tasks by number of trials. Default is 0 for do not weight
P.outdir        = [gPPI_dir filesep subject]; % Output directory
P.ConcatR       = 1; % Tells gPPI toolbox to concatenate runs

P.Contrasts(1).left      = {'TASKNAME1'}; % left side or positive side of contrast
P.Contrasts(1).right     = {'TASKNAME2'}; % right side or negative side of contrast
P.Contrasts(1).STAT      = 'T'; % T contrast
P.Contrasts(1).Weighted  = 0; % Wieghting contrasts by trials. Deafult is 0 for do not weight
P.Contrasts(1).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(1).name      = 'NAMEOFCONTRAST1'; % Name of this contrast

P.Contrasts(2).left      = {'TASKNAME2'}; % left side or positive side of contrast
P.Contrasts(2).right     = {'TASKNAME1'}; % right side or negative side of contrast
P.Contrasts(2).STAT      = 'T'; % T contrast
P.Contrasts(2).Weighted  = 0; % Wieghting contrasts by trials
P.Contrasts(2).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(2).name      = 'NAMEOFCONTRAST2'; % Name of this contrast

P.Contrasts(3).left      = {'TASKNAME1'};
P.Contrasts(3).right     = {'none'}; % right side or negative side of contrast
P.Contrasts(3).STAT      = 'T'; % T contrast
P.Contrasts(3).Weighted  = 0; % Wieghting contrasts by trials
P.Contrasts(3).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(3).name      = 'NAMEOFCONRAST3'; % Name of this contrast

P.Contrasts(4).left      = {'TASKNAME2'}; % left side or positive side of contrast
P.Contrasts(4).right     = {'none'}; % right side or negative side of contrast
P.Contrasts(4).STAT      = 'T'; % T contrast
P.Contrasts(4).Weighted  = 0; % Wieghting contrasts by trials
P.Contrasts(4).MinEvents = 1; % min number of event need to compute this contrast
P.Contrasts(4).name      = 'NAMEOFCONTRAST4'; % Name of this contrast

%%% Below are parameters for gPPI. All set to zero for do not use. See website
%%% for more details on what they do.
P.FSFAST           = 0;
P.peerservevarcorr = 0;
P.wb               = 0;
P.zipfiles         = 0;
P.rWLS             = 0;

%% Actually Run PPI
PPPI(P)