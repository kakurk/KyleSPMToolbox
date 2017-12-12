function [formatted_table, g] = conbars(subjects, rois, contrasts, summaryfunction)
% conbars  function for performing ROI analyses using SPM and gramm.
%   
%   Function for performing ROI analyses using SPM and gramm. SPM and gramm
%   MUST be on the MATLAB search path. ROIs MUST be in the same image space
%   as the contrast images. Tested with MATLAB 2015a.
%
%   subjects = cell string of full paths to estimated SPM.mat files for
%              each subject. E.g., 
%   {'~/myawsomemodel/sub-s001/SPM.mat' '~/myawsomemodel/sub-s002/SPM.mat'}
%   
%   rois = cell string of full paths to roi images. E.g., 
%   {'~/rois/amy_roi.nii' '~/rois/hipp_roi.nii'}
%
%   contrasts = cell string of contrast names that the user wishes to
%               analyze. E.g., {'Negative-Trials' 'Neutral-Trials'}
%
%   summaryfunction = a function handle for summarizing across the roi.
%                     E.g., @mean, @median, @max
%
%   formatted_table = a tidyverse formatted MATLAB table for
%                     analysis/visualziation in another software package
%
%   g = gramm object for the default visual created in this function
%
%   Written by Kyle Kurkela, kyleakurkela@gmail.com, 12/12/2017
%
% See also: 
%% defensive programming
% alert user to problems before they occur

%%% outside software

    % spm must be on the searchpath
    assert(~isempty(which('spm.m')), 'spm must be on the matlab search path')
    
    % gramm must be on the searchpath
    assert(~isempty(which('gramm.m')), 'gramm must be on the matlab search path')

%%% `subjects` assertions

    % `subjects` must be a cell string of valid full paths to SPM.mat files
    assert(iscellstr(subjects), '`subjects` must be a a cell string')
    assert(all(cellfun(@exist, subjects, repmat({'file'}, size(subjects, 1), 1))), 'at least one of `subjects` is not a file on this system')

%%% `rois` assertions

    % `rois` must be a cell string of valid full paths to roi images
    assert(iscellstr(rois), '`rois` must be a cell string')
    assert(all(cellfun(@exist, rois, repmat({'file'}, size(rois, 1), 1))), 'at least one of `rois` is not a file on this system')
    
%%% `contrasts` assertions

    % `contrasts` must be a cell string
    assert(iscellstr(contrasts), 'contrasts must be a vector or a cell string')

%%% `summaryfunction` assertions

    % summaryfunction must be a function handle
    assert(isa(summaryfunction, 'function_handle'), 'summaryfunction must be a valid summary function handle (ex: @mean, @median, @max, @min)')

%% routine

% vol ROI(s)
V = spm_vol(rois);

% initialize count
i             = 0;

for s = 1:length(subjects)

    % load this subject's SPM.mat
    SPM = [];
    load(subjects{s})

    % grab all specified contrasts from this subject IF they exist
    filt = ismember({SPM.xCon.name}, contrasts);
    cons_for_this_subject = SPM.xCon(filt);

    % for each identified contrast...
    for c = 1:length(cons_for_this_subject)

        i = i + 1;
        con_file{i, 1}           = fullfile(SPM.swd, cons_for_this_subject(c).Vcon.fname); %#ok<*AGROW>
        con_name{i, 1}           = cons_for_this_subject(c).name;
        [~, subject_id{i, 1}, ~] = fileparts(fileparts(subjects{s}));

    end

end

%%% initalize

% extract just the file name (minus the full path, minus the ext) and
% format it in tidyverse format
[~, roi_name, ~] = cellfun(@fileparts, rois, 'UniformOutput', false);
roi_name         = repelem(roi_name, length(con_file));

% repeat con_file, con_name, and subject_id for each ROI
con_file         = repmat(con_file, length(V), 1);
con_name         = repmat(con_name, length(V), 1);
subject_id       = repmat(subject_id, length(V), 1);

% blank summary_value
summary_value    = [];

%%% for each ROI...

for v = 1:length(V)
    
    % create and print current roi name
    [~, cur_roi_name, ~] = fileparts(rois{v});
    fprintf('\nROI: %s ...\n\n', cur_roi_name)
       
    %%% visualize ROI
        
    % display the spm canonical single_subj_T1 image. only need to do so
    % the first time
    if v == 1
        spm_image('Display', fullfile(spm('dir'), 'canonical', 'single_subj_T1.nii'))
    end

    % update user
    fprintf('\nDrawing ROI ...\n\n')
    
    %%% overlay ROI
    
    % red, yellow, green, cyan, blue, purple
    colormap = [1 0 0;1 1 0;0 1 0;0 1 1;0 0 1;1 0 1];
    
    % overlay
    spm_orthviews('AddColouredImage', 1, V{v}.fname, colormap(v,:));
    spm_orthviews('AddContext',1);
    spm_orthviews('Redraw');
    
    % read in current ROI
    [R, XYZmm] = spm_read_vols(V{v});
    
    % inclusive mask (i.e., only look at where the image is == 1)
    XYZmm = XYZmm(:, R == 1);
    
    % convert mm coordinates --> vox coordinates
    XYZ = V{v}.mat\[XYZmm;ones(1,size(XYZmm,2))];
    
    % extract data across all con_files for this roi
    filt           = strcmp(roi_name, cur_roi_name);
    extracted_data = spm_get_data(con_file(filt), XYZ);

    % summarize across voxels (e.g., take the mean across the voxels in 
    % this roi) using the summaryfunction
    summary_value  = vertcat(summary_value, summaryfunction(extracted_data, 2));
    
end

% formatted_table is a tidyverse formatted table for optional stats /
% visualization using R's tidyverse
formatted_table = table(roi_name, con_name, subject_id, con_file);
formatted_table.summary_value = summary_value;

%%% Visualize!!
% Note, this visual uses gramm, a MATLAB data visualization package akin to
% ggplot2. See https://github.com/piermorel/gramm

% new figure
figure;

% create gramm class
g = gramm('x', formatted_table.con_name,...
          'y', formatted_table.summary_value,...
          'color', formatted_table.roi_name);

% facet by ROI
g.facet_grid([], formatted_table.roi_name);

% barplot
g.stat_summary('type', 'sem', ...
               'geom', 'bar',...
               'setylim', true);

% error_bars
g.stat_summary('type', 'sem', ...
               'geom', 'black_errorbar',...
               'setylim', true);

% custom color map
g.set_color_options('map', [1 0 0;1 1 0;0 1 0;0 1 1;0 0 1;1 0 1]);

% labels
g.set_names('x','Contrast', 'y', 'Summary Value', 'color', 'ROI', 'column', 'ROI');
g.set_title('ROI Analyses');

% draw plot
g.draw();

end