function matlabbatch=wildcard_parameters8(runs,subjectid,wildcards,directories)
%% Defining Session Specific Parmeters
 %#ok<*AGROW> 
 
for crun = 1:length(runs) % for each run entered into this function..
    
    crun_folder = fullfile(directories.func,subjectid,runs{crun}); % path to the current run folder
    
    images{crun} = cellstr(spm_select('ExtFPList',crun_folder,wildcards.func,Inf));% collect paths to ALL .nii images in this folder

    
    matlabbatch{1}.spm.spatial.realign.estwrite.data = images; % Paths to all images to realign for this run
    
    matlabbatch{2}.spm.temporal.st.scans{crun}(1) = cfg_dep;
    matlabbatch{2}.spm.temporal.st.scans{crun}(1).tname = 'Session';
    matlabbatch{2}.spm.temporal.st.scans{crun}(1).tgt_spec{1}(1).name = 'filter';
    matlabbatch{2}.spm.temporal.st.scans{crun}(1).tgt_spec{1}(1).value = 'image';
    matlabbatch{2}.spm.temporal.st.scans{crun}(1).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{2}.spm.temporal.st.scans{crun}(1).tgt_spec{1}(2).value = 'e';
    matlabbatch{2}.spm.temporal.st.scans{crun}(1).sname = ['Realign: Estimate & Reslice: Resliced Images (Sess ' num2str(crun) ')'];
    matlabbatch{2}.spm.temporal.st.scans{crun}(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{2}.spm.temporal.st.scans{crun}(1).src_output = substruct('.','sess', '()',{crun}, '.','rfiles');

    matlabbatch{5}.spm.spatial.normalise.write.subj.resample(crun) = cfg_dep;
    matlabbatch{5}.spm.spatial.normalise.write.subj.resample(crun).tname = 'Images to Write';
    matlabbatch{5}.spm.spatial.normalise.write.subj.resample(crun).tgt_spec{1}(1).name = 'filter';
    matlabbatch{5}.spm.spatial.normalise.write.subj.resample(crun).tgt_spec{1}(1).value = 'image';
    matlabbatch{5}.spm.spatial.normalise.write.subj.resample(crun).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{5}.spm.spatial.normalise.write.subj.resample(crun).tgt_spec{1}(2).value = 'e';
    matlabbatch{5}.spm.spatial.normalise.write.subj.resample(crun).sname = ['Slice Timing: Slice Timing Corr. Images (Sess ' num2str(crun) ')'];
    matlabbatch{5}.spm.spatial.normalise.write.subj.resample(crun).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{5}.spm.spatial.normalise.write.subj.resample(crun).src_output = substruct('()',{crun}, '.','files');

end

%% Defining Session Independent Parameters
% These parameters are run independent. They are set for all runs in GLAMM

% Run Independent Realightment Parameters
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep     = 4;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm    = 5;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm     = 0;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp  = 2;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap    = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight  = '';
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which   = [2 1];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp  = 4;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap    = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask    = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix  = 'r';

% Run Independent Slicetiming Parameters
matlabbatch{2}.spm.temporal.st.nslices  = 42;
matlabbatch{2}.spm.temporal.st.tr       = 2.5;
matlabbatch{2}.spm.temporal.st.ta       = 2.44047619047619;
matlabbatch{2}.spm.temporal.st.so       = [42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1];
matlabbatch{2}.spm.temporal.st.refslice = 21;
matlabbatch{2}.spm.temporal.st.prefix   = 'a';

% Run Independent Coregistration Parameters
matlabbatch{3}.spm.spatial.coreg.estwrite.ref(1) = cfg_dep;
matlabbatch{3}.spm.spatial.coreg.estwrite.ref(1).tname = 'Reference Image';
matlabbatch{3}.spm.spatial.coreg.estwrite.ref(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.spm.spatial.coreg.estwrite.ref(1).tgt_spec{1}(1).value = 'image';
matlabbatch{3}.spm.spatial.coreg.estwrite.ref(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.spm.spatial.coreg.estwrite.ref(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.spm.spatial.coreg.estwrite.ref(1).sname = 'Realign: Estimate & Reslice: Mean Image';
matlabbatch{3}.spm.spatial.coreg.estwrite.ref(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.spatial.coreg.estwrite.ref(1).src_output = substruct('.','rmean');

% Inputting Subject's Anatomical Information
anat_directory    = sprintf('/gpfs/group/s/sleic/nad12/GLAMM/anat/%s',subjectid); % path to this subjects anatomical folder
matlabbatch{3}.spm.spatial.coreg.estwrite.source = cellstr(spm_select('ExtFPList',anat_directory,wildcards.anat,Inf)); % path to anatomical image

% More Run Independent Coregistartion Parameters
matlabbatch{3}.spm.spatial.coreg.estwrite.other = {''};
matlabbatch{3}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{3}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{3}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{3}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{3}.spm.spatial.coreg.estwrite.roptions.interp = 1;
matlabbatch{3}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{3}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{3}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';

% Run Indepednet Segmentation Parameters
matlabbatch{4}.spm.spatial.preproc.data(1) = cfg_dep;
matlabbatch{4}.spm.spatial.preproc.data(1).tname = 'Data';
matlabbatch{4}.spm.spatial.preproc.data(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{4}.spm.spatial.preproc.data(1).tgt_spec{1}(1).value = 'image';
matlabbatch{4}.spm.spatial.preproc.data(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{4}.spm.spatial.preproc.data(1).tgt_spec{1}(2).value = 'e';
matlabbatch{4}.spm.spatial.preproc.data(1).sname = 'Coregister: Estimate & Reslice: Resliced Images';
matlabbatch{4}.spm.spatial.preproc.data(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{4}.spm.spatial.preproc.data(1).src_output = substruct('.','rfiles');
matlabbatch{4}.spm.spatial.preproc.output.GM = [0 0 0];
matlabbatch{4}.spm.spatial.preproc.output.WM = [0 0 0];
matlabbatch{4}.spm.spatial.preproc.output.CSF = [0 0 0];
matlabbatch{4}.spm.spatial.preproc.output.biascor = 1;
matlabbatch{4}.spm.spatial.preproc.output.cleanup = 0;
matlabbatch{4}.spm.spatial.preproc.opts.tpm = {
                                               '/usr/global/spm/8/tpm/grey.nii'
                                               '/usr/global/spm/8/tpm/white.nii'
                                               '/usr/global/spm/8/tpm/csf.nii'
                                               };
matlabbatch{4}.spm.spatial.preproc.opts.ngaus = [2
                                                 2
                                                 2
                                                 4];
matlabbatch{4}.spm.spatial.preproc.opts.regtype = 'mni';
matlabbatch{4}.spm.spatial.preproc.opts.warpreg = 1;
matlabbatch{4}.spm.spatial.preproc.opts.warpco = 25;
matlabbatch{4}.spm.spatial.preproc.opts.biasreg = 0.0001;
matlabbatch{4}.spm.spatial.preproc.opts.biasfwhm = 60;
matlabbatch{4}.spm.spatial.preproc.opts.samp = 3;
matlabbatch{4}.spm.spatial.preproc.opts.msk = {''};

% Run Indepenedent Normalization: Normalizaing the Functional Images
matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1) = cfg_dep;
matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).tname = 'Parameter File';
matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(2).value = 'e';
matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).sname = 'Segment: Norm Params Subj->MNI';
matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).src_output = substruct('()',{1}, '.','snfile', '()',{':'});
matlabbatch{5}.spm.spatial.normalise.write.roptions.preserve = 0;
matlabbatch{5}.spm.spatial.normalise.write.roptions.bb = [-78 -112 -50
                                                          78 76 85];
matlabbatch{5}.spm.spatial.normalise.write.roptions.vox = [2 2 2];
matlabbatch{5}.spm.spatial.normalise.write.roptions.interp = 1;
matlabbatch{5}.spm.spatial.normalise.write.roptions.wrap = [0 0 0];
matlabbatch{5}.spm.spatial.normalise.write.roptions.prefix = 'w';

% Run Independent Normalization: Normalizing the Anatomical Image
matlabbatch{6}.spm.spatial.normalise.write.subj.matname(1) = cfg_dep;
matlabbatch{6}.spm.spatial.normalise.write.subj.matname(1).tname = 'Parameter File';
matlabbatch{6}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{6}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{6}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{6}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(2).value = 'e';
matlabbatch{6}.spm.spatial.normalise.write.subj.matname(1).sname = 'Segment: Norm Params Subj->MNI';
matlabbatch{6}.spm.spatial.normalise.write.subj.matname(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.spm.spatial.normalise.write.subj.matname(1).src_output = substruct('()',{1}, '.','snfile', '()',{':'});
matlabbatch{6}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep;
matlabbatch{6}.spm.spatial.normalise.write.subj.resample(1).tname = 'Images to Write';
matlabbatch{6}.spm.spatial.normalise.write.subj.resample(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{6}.spm.spatial.normalise.write.subj.resample(1).tgt_spec{1}(1).value = 'image';
matlabbatch{6}.spm.spatial.normalise.write.subj.resample(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{6}.spm.spatial.normalise.write.subj.resample(1).tgt_spec{1}(2).value = 'e';
matlabbatch{6}.spm.spatial.normalise.write.subj.resample(1).sname = 'Coregister: Estimate & Reslice: Resliced Images';
matlabbatch{6}.spm.spatial.normalise.write.subj.resample(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.spm.spatial.normalise.write.subj.resample(1).src_output = substruct('.','rfiles');
matlabbatch{6}.spm.spatial.normalise.write.roptions.preserve = 0;
matlabbatch{6}.spm.spatial.normalise.write.roptions.bb = [-78 -112 -50
                                                          78 76 85];
matlabbatch{6}.spm.spatial.normalise.write.roptions.vox = [2 2 2];
matlabbatch{6}.spm.spatial.normalise.write.roptions.interp = 1;
matlabbatch{6}.spm.spatial.normalise.write.roptions.wrap = [0 0 0];
matlabbatch{6}.spm.spatial.normalise.write.roptions.prefix = 'w';

% Run Indepednent Smoothing Parameters
matlabbatch{7}.spm.spatial.smooth.data(1) = cfg_dep;
matlabbatch{7}.spm.spatial.smooth.data(1).tname = 'Images to Smooth';
matlabbatch{7}.spm.spatial.smooth.data(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{7}.spm.spatial.smooth.data(1).tgt_spec{1}(1).value = 'image';
matlabbatch{7}.spm.spatial.smooth.data(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{7}.spm.spatial.smooth.data(1).tgt_spec{1}(2).value = 'e';
matlabbatch{7}.spm.spatial.smooth.data(1).sname = 'Normalise: Write: Normalised Images (Subj 1)';
matlabbatch{7}.spm.spatial.smooth.data(1).src_exbranch = substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{7}.spm.spatial.smooth.data(1).src_output = substruct('()',{1}, '.','files');
matlabbatch{7}.spm.spatial.smooth.fwhm = [6 6 6];
matlabbatch{7}.spm.spatial.smooth.dtype = 0;
matlabbatch{7}.spm.spatial.smooth.im = 0;
matlabbatch{7}.spm.spatial.smooth.prefix = 's';
end