# Riemannian Artifact Subspace Reconstruction Matlab Toolbox

This repository contains code for an EEGLAB [0] plugin which can be used to correct EEG artifacts using Riemannian geometry.
The method is an adaptation of the original ASR method published by Mullen et al. [1].
For details of its workings, please refer to Blum et al. (2018, currently in preparation, will be linked here shortly).


## Usage
To use the rASR cleaning, simply call this plugin like the original ASR plugin after adding it to the Matlab path:

```matlab
addpath('rASRfolder/', '-begin');    
% call clean_rawdata
EEG = clean_rawdata(EEG, arg_flatline, arg_highpass, arg_channel, arg_noisy, arg_burst, arg_window);
```

The rASR folder can also be put directly into the EEGLAB folder: eeglab/plugins/rASR/, this is where EEGLAB looks for the functions to clean the data. 

The function will show a meesage in the command window of Matlab, informing that the cleaning is done with Riemannian geometry now.

## Dependencies
The Riemannian geometry functions are implemented in the Manopt toolbox [2] which needs to be in Matlab's path as well.

[0] https://sccn.ucsd.edu/eeglab/index.php
[1] https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4710679/
[2] https://www.manopt.org/index.html
