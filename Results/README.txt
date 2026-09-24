This folder contains the data analysis scripts to compute higher-level measures of neural activation from the spike time data, followed by discrimination threshold fitting of the model-derived activation data to the experimental data using different neural activation metrics.

FOLDER STRUCTURE

1. Results/Reference_Depth/ : Reference depth condition. Contains the script for computing higher-level measures of neural activation, including activation distances, activated cell IDs, and spike counts. The folder also contains the scripts used to estimate discrimination thresholds by fitting the model-derived activation data to the experimental data using different neural activation metrics and to generate the corresponding results figures.

2. Results/Depth_down150um/ : Depth condition 150 um deeper than the reference depth. Contains the script for computing higher-level measures of neural activation, including activation distances, activated cell IDs, and spike counts. The folder also contains the scripts used to estimate discrimination thresholds by fitting the model-derived activation data to the experimental data using different neural activation metrics and to generate the corresponding results figures.

3. Results/Depth_up150um/ : Depth condition 150 um superficial to the reference depth. Contains the script for computing higher-level measures of neural activation, including activation distances, activated cell IDs, and spike counts. The folder also contains the scripts used to estimate discrimination thresholds by fitting the model-derived activation data to the experimental data using different neural activation metrics and to generate the corresponding results figures.

Overview of the folders and files within each of the above folders:-
a. coords/ - contains the coordinates of the neuron cell bodies and components, and also the cell count. For more details, please refer to the FOLDER STRUCTURE section in NEURON_Simulations/README.txt
b. Convex_Hull_Pipeline/ - contains instructions and the script to specify and generate coordinates for the region enclosed by the electrode array, used for subsequent removal of neurons intersecting the electrode shank using the Convex Hull algorithm.
c. electrode_array_xyz.mat, in_hull.m - MATLAB files associated with the neuron removal approach using Convex Hull algorithm
d. CD_{contact diameter}um/ - Folders to store the spike time data for the different contact diameters.
e. soma_analysis_ConvexHull.m - MATLAB script to compute higher-level neural activation measures from the spike time data.
f. activation_data_ConvexHull/ - Folder containing the final processed neural activation measures data files.
g. disc_thresh_fit_multi_metrics.m - MATLAB script to estimate discrimination thresholds and to generate the corresponding results figures.

EXECUTION SEQUENCE

The following execution sequence is described for the 'Reference_Depth' condition. The same sequence should be followed for the 'Depth_down150um' and 'Depth_up150um' conditions by substituting the 'Reference_Depth' folder with the corresponding depth-condition folder name.

STEP 1. Move all previously generated spike time data files from: NEURON_Simulations/Reference_Depth/CD_{contact diameter}um/spktimes/ to: Results/Reference_Depth/CD_{contact diameter}um/spktimes/
For example, for a 5 um contact diameter: 
Move all folders within: NEURON_Simulations/Reference_Depth/CD_5um/spktimes/ to: Results/Reference_Depth/CD_5um/spktimes/

STEP 2. Within Results/Reference_Depth/ , run: 'run_soma_analysis_ConvexHull.q' . 
This executes the MATLAB script 'soma_analysis_ConvexHull.m' to compute and save the neural activation measures as .dat files into Results/Reference_Depth/activation_data_ConvexHull/ . 
NOTE: The SLURM submission setting should be modified to match the available local cluster resources.
Expected output files follow the naming convention: 'Dia{contact diameter}um_BaseAmp{base amplitude}uA_DiscAmp_{discrimination amplitude}uA_block{stimulation block number}_soma_{neural activation measure}.dat
Example: 
'Dia5um_BaseAmp3uA_DiscAmp_0p5uA_block1_soma_dist.dat' represents the activated soma distances during stimulation block 1 for a contact diameter of 5 um, a stimulation base amplitude of 3 uA, and a discrimination amplitude of 0.5 uA.

STEP 3. After all of the neural activation measures have been generated, run: 'disc_thresh_fit_multi_metrics.m' within Results/Reference_Depth/ .
This script computes neural metric values for each cortical layer, fits the model-derived discrimination thresholds to the experimental data, and generates plots of:
-neural metric values
-Discrimination thresholds
-Weber fractions
-Fit quality
-Sensitivity 
Within the script, 'metric' variable can be changed to evaluate based on various neural metrics described in 'METRIC SELECTOR' section.
Example: 
'metric = 1' will evaluate based on the fractional change in recruited cell count ΔN/N1
The results for the paper figures can be reproduced using the figures generated by this script as follows:
- Paper Figure 6 and Figure S4: MATLAB Figure 100, using the appropriate neural metric.
- Paper Figure 8: MATLAB Figures 102 and 103, using the appropriate neural metric.
- Paper Figure S3: MATLAB Figure 101, using the appropriate neural metric.
- Paper Figure S7: MATLAB Figure 11, using the appropriate neural metric.
- Paper Figure S8: MATLAB Figure 12, using the appropriate neural metric.

The following step fits the model derived discrimination thresholds values across all three depths to the experimental data. STEP 4 should be run only after STEP 1 and STEP 2 have been completed for all three depth conditions.

STEP 4. From the Results/ directory, run: 'disc_thresh_fit_multi_metrics_AllDepth.m'
This script computes neural metric values across all cortical layers and all three depth conditions, fits the model-derived discrimination threshold values across all depths to the experimental data, and generates plots of:
- Discrimination thresholds
- Weber fractions
- Fit quality
The results are shown separately for each depth condition as well as for the mean across all three depths.
Within the script, 'metric' variable can be changed to evaluate based on various neural metrics described in 'METRIC SELECTOR'.
Example: 
'metric = 1' will evaluate based on the fractional change in recruited cell count ΔN/N1
The results for the paper figures can be reproduced using the figures generated by this script as follows:
- Paper Figure 7: MATLAB Figure 400, using the appropriate neural metric.
- Paper Figure S5: MATLAB Figure 402, using the appropriate neural metric.