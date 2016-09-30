%%% gPPI Wrapper Script Template %%%

% Specify paths to relevant directories.
analysis_dir = 's:\nad12\STUDYNAME\analyses\ANALYSISNAME';  % where ever we are pulling from
gPPI_dir = 's:\nad12\STUDYNAME\analyses\GPPIFOLDERNAME';    % where ever we are outputting to
script_dir = 's:\nad12\STUDYNAME\scripts\gPPI\';            % where ever this script is located

% Specify all subjects to run
subjects = { '001' '002' '003' '004' '005' };

% Specify VOIs to run
VOI(1).Name = 'VOINAME';  % Arbitrary VOI Name
VOI(1).Peak = [42 37 23]; % x,y,z, in MNI space
VOI(1).Size = 8;          % diameter (mm)
VOI(2).Name = 'VOINAME';  % Arbitrary VOI Name
VOI(2).Peak = [42 37 23]; % x,y,z, in MNI space
VOI(2).Size = 8;          % diameter (mm)

addpath(script_dir) % add script directory to the MATLAB search path
for s=1:length(subjects) % for each subject...
    if isdir([gPPI_dir filesep subjects{s}])    % if this subject's gPPI directory already exists, skip this part
    else                                        % if the subject's gPPI directory does NOT exist
        mkdir([gPPI_dir filesep subjects{s}])   % create new gPPI specific directory
    end
    for v = 1:length(VOI)                       % for each VOI...
        parameters(subjects{s}, VOI(v).Name, VOI(v).Peak, VOI(v).Size, gPPI_dir, analysis_dir) % run the gPPI analysis
    end
end
cd(script_dir)                                  % return to the scripts diretory, where this script is held