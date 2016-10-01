function matlabbatch = wildcard_parameters12(runs, subjectid, wildcards, directories)
% wildcard_parameters12     a function for setting SPM preprocessing
%                           parameters, designed to work with 
%                           wilcard_preprocess. This pipeline is a custom 
%                           pipeline designed by me.
%                           Kyle Kurkela, kyleakurkela@gmail.com
%
%   matlabbatch = wildcard_parameters12(runs, subjectid, wildcard, directories)
% 
%
% See also: wildcard_preprocess, wildcard_parameters8


%% Defining Session Specific Parmeters
% In this section, the routine is defining SPM settings that are specific
% to each functional run. They include:
%
% 1.) The cell string of the volumes for that run
% 2.) The dependency from realighnment --> slicetiming
% 3.) The dependency from slicetiming --> normalization

%#ok<*AGROW>
for crun = 1:length(runs) % for each run entered into this function..
    
    crun_folder  = fullfile(directories.func, subjectid, runs{crun}); % path to the current run folder

    images{crun} = cellstr(spm_select('ExtFPList', crun_folder, wildcards.func, Inf)); % collect paths to ALL .nii images in this folder
        
    matlabbatch{2}.spm.temporal.st.scans{crun}(1) = cfg_dep(['Realign: Estimate & Reslice: Resliced Images (Sess ' num2str(crun) ')'], substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{crun}, '.','cfiles'));

    matlabbatch{5}.spm.spatial.normalise.write.subj.resample(crun) = cfg_dep(['Slice Timing: Slice Timing Corr. Images (Sess ' num2str(crun) ')'], substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{crun}, '.','files'));

end

matlabbatch{1}.spm.spatial.realign.estwrite.data = images; % Paths to all images to realign for this run


%% Defining Session Independent Parameters
% These parameters are run independent

% Run Independent Realightment Parameters
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep     = 4;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm    = 5;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm     = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp  = 2;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap    = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight  = '';
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which   = [0 1];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp  = 4;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap    = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask    = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix  = 'r';

% Run Independent Slicetiming Parameters
matlabbatch{2}.spm.temporal.st.nslices  = 48;
matlabbatch{2}.spm.temporal.st.tr       = 2.5;
matlabbatch{2}.spm.temporal.st.ta       = 2.5-(2.5/48);
matlabbatch{2}.spm.temporal.st.so       = [1:2:48 2:2:48];
matlabbatch{2}.spm.temporal.st.refslice = 47;
matlabbatch{2}.spm.temporal.st.prefix   = 'a';

% Run Independent Coregistration Parameters
matlabbatch{3}.spm.spatial.coreg.estwrite.ref(1) = cfg_dep;
matlabbatch{3}.spm.spatial.coreg.estwrite.ref(1).tname = 'Reference Image';
matlabbatch{3}.spm.spatial.coreg.estwrite.ref(1).tgt_spec{1}(1).name  = 'filter';
matlabbatch{3}.spm.spatial.coreg.estwrite.ref(1).tgt_spec{1}(1).value = 'image';
matlabbatch{3}.spm.spatial.coreg.estwrite.ref(1).tgt_spec{1}(2).name  = 'strtype';
matlabbatch{3}.spm.spatial.coreg.estwrite.ref(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.spm.spatial.coreg.estwrite.ref(1).sname = 'Realign: Estimate & Reslice: Mean Image';
matlabbatch{3}.spm.spatial.coreg.estwrite.ref(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.spatial.coreg.estwrite.ref(1).src_output   = substruct('.','rmean');

% Inputting Subject's Anatomical Information
anat_directory = fullfile(directories.anat, subjectid); % path to this subjects anatomical folder
matlabbatch{3}.spm.spatial.coreg.estimate.source = {spm_select('ExtFPList', anat_directory, wildcards.anat)}; % path to anatomical image

% More Run Independent Coregistartion Parameters
matlabbatch{3}.spm.spatial.coreg.estimate.ref(1) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
matlabbatch{3}.spm.spatial.coreg.estimate.other  = {''};
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.sep      = [4 2];
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.tol      = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.fwhm     = [7 7];

% Run Indepednet Segmentation Parameters

spm_segment_image = which('TPM.nii'); % find the TPM image on the MATLAB search path

matlabbatch{4}.spm.spatial.preproc.channel.vols(1)  = cfg_dep('Coregister: Estimate: Coregistered Images', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
matlabbatch{4}.spm.spatial.preproc.channel.biasreg  = 0.001;
matlabbatch{4}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{4}.spm.spatial.preproc.channel.write    = [0 0];
matlabbatch{4}.spm.spatial.preproc.tissue(1).tpm    = {[spm_segment_image ',1']};
matlabbatch{4}.spm.spatial.preproc.tissue(1).ngaus  = 1;
matlabbatch{4}.spm.spatial.preproc.tissue(1).native = [1 0];
matlabbatch{4}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{4}.spm.spatial.preproc.tissue(2).tpm    = {[spm_segment_image ',2']};
matlabbatch{4}.spm.spatial.preproc.tissue(2).ngaus  = 1;
matlabbatch{4}.spm.spatial.preproc.tissue(2).native = [1 0];
matlabbatch{4}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{4}.spm.spatial.preproc.tissue(3).tpm    = {[spm_segment_image ',3']};
matlabbatch{4}.spm.spatial.preproc.tissue(3).ngaus  = 2;
matlabbatch{4}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{4}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{4}.spm.spatial.preproc.tissue(4).tpm    = {[spm_segment_image ',4']};
matlabbatch{4}.spm.spatial.preproc.tissue(4).ngaus  = 3;
matlabbatch{4}.spm.spatial.preproc.tissue(4).native = [1 0];
matlabbatch{4}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{4}.spm.spatial.preproc.tissue(5).tpm    = {[spm_segment_image ',5']};
matlabbatch{4}.spm.spatial.preproc.tissue(5).ngaus  = 4;
matlabbatch{4}.spm.spatial.preproc.tissue(5).native = [1 0];
matlabbatch{4}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{4}.spm.spatial.preproc.tissue(6).tpm    = {[spm_segment_image ',6']};
matlabbatch{4}.spm.spatial.preproc.tissue(6).ngaus  = 2;
matlabbatch{4}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{4}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{4}.spm.spatial.preproc.warp.mrf         = 1;
matlabbatch{4}.spm.spatial.preproc.warp.cleanup     = 1;
matlabbatch{4}.spm.spatial.preproc.warp.reg         = [0 0.001 0.5 0.05 0.2];
matlabbatch{4}.spm.spatial.preproc.warp.affreg      = 'mni';
matlabbatch{4}.spm.spatial.preproc.warp.fwhm        = 0;
matlabbatch{4}.spm.spatial.preproc.warp.samp        = 3;
matlabbatch{4}.spm.spatial.preproc.warp.write       = [0 1];


% Run Indepenedent Normalization: Normalizaing the Functional Images
matlabbatch{5}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
matlabbatch{5}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{5}.spm.spatial.normalise.write.woptions.vox    = [2 2 2];
matlabbatch{5}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{5}.spm.spatial.normalise.write.woptions.prefix = 'w';

% Run Indepednent Smoothing Parameters
matlabbatch{6}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
matlabbatch{6}.spm.spatial.smooth.fwhm    = [6 6 6];
matlabbatch{6}.spm.spatial.smooth.dtype   = 0;
matlabbatch{6}.spm.spatial.smooth.im      = 0;
matlabbatch{6}.spm.spatial.smooth.prefix  = 's';

end