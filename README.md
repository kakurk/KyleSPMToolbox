My personal, custom batch scritps for automating preprocessing and analysis of fMRI data using [Statistical Paramteric Mapping](http://www.fil.ion.ucl.ac.uk/spm/)

### ANOVAs
Scripts designed to perform second level ANOVA's on first-level SPM GLMs.  

`FullFactorial.m` --> using SPM's FullFactorial module. See SPM documentation for more detail.  
`FlexibleFactorial.m` --> using SPM's FlexibleFactorial module. See SPM documentation for more detail.  

### BatchTransfer
Script for automating data transfer from a remote computer.  

`batch_transfer.sh` --> bash script template for automating data transfer from a remote computer (usually the imaging center where the data is collected).  

### Contrasts
Scripts for running contrasts on a GLM built in SPM.  

`SPMContrasts.m` --> Batch scripts for running a user-defined set of contrasts comparing trial-types (i.e., conditions). Instead of having to manually set the proper contrast wieghts, you can simply input the trial-type(s) you would like to compare.  

`BuildContrastVectors.m` --> custom function design to properly weigh contrast vectors based on trial type availability in the inputted GLM. This is particularly important for memory studies, where trial types are determined by participant's behavioral performance. For example, often times participants will NOT have have False Alarms, No Response, or Miss trials depending on the experiment.  

### Models
Scripts for modeling fMRI data using SPM.  

`SpecifyModel.m` --> Script for writing out (i.e., 'Specifying') which trial onsets belong in which conditions based on a series of user-defined `if ` statements. I like to think of this as 'sorting' the trials into the various experimental conditions.  

`EstimateModel.m` --> Script for actually specifying and estimating a first-level GLM in SPM. Imports experimental design from the `SpecifyModel.m` script.  

### Preprocessing
Scripts for preprocessing fMRI data using SPM.  

`wilcard_preprocess.m` --> batch/wrapper scripts designed to flexibily grab all functional runs from an fMRI study (for example, handles the case where one participants has less runs then other participants) and creates a custom made preprocessing pipeline (defined in the scripts below).  

`wildcard_parameters8.m` --> custom preprocessing pipeline designed to work with SPM8  

`wildcard_parameters12.m` --> custom preprocessing pipeline designed to work with SPM12  

`ashburner_fix_parameters.m` --> custom preprocessing pipeline designed to incorporate a 'fix' to get the pipeline to better normalize functional images to match the templates  

### TTests
Scripts for running second level t-tests on first-level SPM GLMs.  

`SPMOneSampleT.m` --> batch script for running one sample t-tests on all (or a subset of) contrasts that are defined at the first-level.  

`SPMTwoSampleT.m` --> batch script for running two sample t-tests (comparing two groups of subjects, i.e. YAs vs OAs) on all (or a subset of) contrasts defined at the first-level.  

### gPPI
Scripts for running a generalized psychphysiological (gPPI) analysis in SPM. See Donald McLaren [paper](https://www.ncbi.nlm.nih.gov/pubmed/22484411) and [toolbox website](https://www.nitrc.org/projects/gppi) for more information.  

`wrapper.m` --> script that 'wraps' over the parameters script below. Runs a specific gPPI analysis (the parameters to which are set below) over a number of subjects and Regions of Interest (ROIs).  

`parameters.m` --> script that defines the parameters for the gPPI analysis. See script and Donald McClaren's documentation for more information.  
