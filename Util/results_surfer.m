function results_surfer()
% Surf a Statistical Parametric Map.
% Written by Kyle Kurkela, kyleakurkela@gmail.com

persistent t p

if ~isempty(t)
    
    % Find where the curser currently is
    F     = spm_figure('FindWin');
    spm_figure('Select', F);
    XYZ   = spm_results_ui('GetCoords');
    iM    = evalin('base', 'xSPM.iM');
    XYZmm = iM*[XYZ;ones(1,size(XYZ,2))];

    % extract data from this voxel across all first level files
    extracted_data = spm_get_data(t, XYZmm);

    % update
    figure(2);
    clf();
    figure(2);        
    g = gramm('x', cellstr(num2str(p)), 'y', extracted_data);
    g.stat_summary('geom', {'bar', 'black_errorbar'}, 'setylim', true);
    g.set_names('x', 'Group', 'y', 'Extracted Value');
    g.set_title('Summarized Extracted Values');
    g.draw();

    % return
    return    
    
end

% Select Files to Surf
[t, ~] = spm_select(Inf, 'image', 'Select First Level Files to Surf...');

% File Vector
[p, ~] = spm_input('Enter a vector specifying the group for each input image.', 0, 'e', [], size(t, 1));

% Find where the curser currently is
F = spm_figure('FindWin');
spm_figure('Select', F);
XYZ   = spm_results_ui('GetCoords');
iM    = evalin('base', 'xSPM.iM');
XYZmm = iM*[XYZ;ones(1,size(XYZ,2))];

% extract data from this voxel across all first level files
extracted_data = spm_get_data(t, XYZmm);

% plot
figure(2);
clf();
figure(2);
g = gramm('x', cellstr(num2str(p)), 'y', extracted_data);
g.stat_summary('geom', {'bar', 'black_errorbar'}, 'setylim', true);
g.set_names('x', 'Group', 'y', 'Extracted Value');
g.set_title('Summarized Extracted Values');
g.draw();

end