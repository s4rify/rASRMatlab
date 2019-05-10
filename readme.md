# Riemannian Artifact Subspace Reconstruction Matlab Toolbox

This repository contains code for an EEGLAB [0] plugin which can be used to correct EEG artifacts using Riemannian geometry.
The method is an adaptation of the original ASR method published by Mullen et al. [1].
For details of its workings, please refer to Blum et al. [3].
The rASR toolbox uses the Manopt toolbox for computations involving manifolds and Riemannian geometry, please note that in the current
implementation an adapted nonlinear_eigenspace function is used and included in the rASR toolbox, while the rest of manopt is used from the toolbox
which must be in the Matlab path. This is only a temporary solution and will be coded more sustainably soon.

## Usage
To use the rASR cleaning, simply call this plugin like the original ASR plugin after adding it to the Matlab path:

```matlab
addpath('rASRfolder/', '-begin');    
% call clean_rawdata
EEG = clean_rawdata(EEG, arg_flatline, arg_highpass, arg_channel, arg_noisy, arg_burst, arg_window);
```

The rASR folder can also be put directly into the EEGLAB folder: eeglab/plugins/rASR/, this is where EEGLAB looks for the functions to clean the data. 

The function will show a message in the command window of Matlab, informing that the cleaning is done with Riemannian geometry now.

## Dependencies
The Riemannian geometry functions are implemented in the Manopt toolbox [2] which needs to be in Matlab's path as well.

## Support
Please drop me a mail if you have any questions, fork this work to improve it or open an issue in this repository if you have any problems.

## Paper and Analysis Code
The analysis code  can be found in the folder analysis_scripts_frontiers. Please note the readme file in there. Data will be linked shortly.

# References
[0] https://sccn.ucsd.edu/eeglab/index.php <br/>
[1] https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4710679/ <br/>
[2] https://www.manopt.org/index.html <br/>
[3] https://www.frontiersin.org/articles/10.3389/fnhum.2019.00141/full?&utm_source=Email_to_authors_&utm_medium=Email&utm_content=T1_11.5e1_author&utm_campaign=Email_publication&field=&journalName=Frontiers_in_Human_Neuroscience&id=421678

# TODO
add license file.