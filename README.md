# SC20-artifact
SC20 artifact contains scripts and softwares to reproduce our results.
System prerequisites:
    (1) python3.*
    (2) matplotlib
    (3) gcc/gfortran 4.8.5

========================
=== Get Started
========================
The script by default uses slurm job scheduler; if the system the 
script is running on has different job scheduler, you need to modify the 
job scripts in reults/*/*.job accordingly. If slurm job scheduler is used, 
but job partition name is different, please modify the "BDW_PARTITION" and
"KNL_PARTITION" to the correct partition name.

After all jobs are finished, please make sure python3 and matplotlib library is 
present in order to produce the corresponding figures.

Installing modules, submitting jobs and generate figures are easy. Simply execute
the following three command one by one.

- compile all required modules (may take XX hours):
    sh install-modules.sh

- submit jobs:
    sh submit-jobs.sh

- draw figures (execute after all jobs complete):
    sh draw-figs.sh

If you need to reproduce results one by one, you can enter results/* to submit
job and draw figures individually.
