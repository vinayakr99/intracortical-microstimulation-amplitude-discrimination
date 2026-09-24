This folder contains the NEURON simulation files and spike time extraction scripts for the cortical column model. The resultant spike time data will be used to compute neural activation measures and perform discrimination threshold estimation in the subsequent analysis.

FOLDER STRUCTURE

1. NEURON_Simulations/CommonFiles/: Contains the NEURON simulation files and spike time extraction scripts that are common to all depth conditions and contact diameters. These files serve as the base files for all simulations. 
For more details about the NEURON cortical column model, please refer to:
K. Kumaravelu, J. Sombeck, L. E. Miller, S. J. Bensmaia and W. M. Grill (2022) 
Stoney vs. Histed: Quantifying the spatial effects of intracortical microstimulation. 
Brain stimulation 

2. NEURON_Simulations/Reference_Depth/ : Reference depth condition. Contains the main scripts for running the NEURON simulations and spike time extraction. Separate folders are provided for each contact diameter.
Example:
NEURON_Simulations/Reference_Depth/CD_5um/

3. NEURON_Simulations/Depth_down150um/ : Depth condition 150 um deeper than the reference depth. Contains the main scripts for running the NEURON simulations and spike time extraction. Separate folders are provided for each contact diameter.

4. NEURON_Simulations/Depth_up150um/ : Depth condition 150 um superficial to the reference depth. Contains the main scripts for running the NEURON simulations and spike time extraction. Separate folders are provided for each contact diameter.

EXECUTION SEQUENCE

The following execution sequence is described for the 'Reference_Depth' condition. The same sequence should be followed for the 'Depth_down150um' and 'Depth_up150um' conditions by substituting the 'Reference_Depth' folder with the corresponding depth-condition folder name. NOTE: For all the SLURM submission scripts (run_all_stims.q, run_create_data_folders.q, run_model.q, run_extract_spike_times.q, verify_and_resubmit.q), the settings have to be modified to match the available local cluster resources.

STEP 1. Copy all files from NEURON_Simulations/CommonFiles/ to each of the contact diameter folders NEURON_Simulations/Reference_Depth/CD_{contact diameter}um/
For example, for a 5 um contact diameter:
NEURON_Simulations/Reference_Depth/CD_5um/

STEP 2. Move the previously generated 'fem_pot_G1_S1_{contact diameter}um.dat' into the corresponding contact diameter folders 'CD_{contact diameter}um' under NEURON_Simulations/Reference_Depth/
Move the previously generated FEM potential file 'fem_pot_G1_S1_{contact diameter}um.dat' into the corresponding contact diameter folders NEURON_Simulations/Reference_Depth/CD_{contact diameter}um/
For example, for a 5 um contact diameter:
NEURON_Simulations/Reference_Depth/CD_5um/fem_pot_G1_S1_5um.dat

STEP 3. Run the NEURON simulations for each contact diameter. The following sequence is shown for the 5 um contact diameter:

a. Within NEURON_Simulations/Reference_Depth/CD_5um/ , compile the mod files from /mechanisms using /opt/apps/rhel7/nrn-7.7/x86_64/bin/nrnivmodl. This should create a directory called /mechanisms/x86_64.

b. Submit the simulation job using 'sbatch run_all_stims.q' . This will run the cortical column model followed by spike time extraction for each of the stimulation amplitude conditions specified in the 'run_all_stims.q' file. These conditions include the base stimulation amplitude and the discrimination amplitude. 

c. At the end of the NEURON simulations, transmembrane potentials from the soma and axonal compartments of each neuron will be saved as .dat files. The files will be stored in directories corresponding to the different stimulation base amplitude and discrimination amplitude conditions under Vm/{base amplitude}nA_{disc amplitude}nA/
For example:
Vm/3000nA_500nA/
The transmembrane potential files follow the naming conventions 'Vm_{cell type}_{neuron ID}.dat' and 'Vm_axon_{cell type}_{neuron ID}.dat'
For example:
'Vm_10_446.dat' contains the transmembrane potential recorded from the soma of neuron 446 belonging to cell type 10 and 'Vm_axon_10_446.dat' contains the transmembrane potential recorded from the axonal compartments of the same neuron.

d. The spike time extraction scripts use the Vm and Vm_axon files generated in the previous step to extract spike times and save them as .mat files in directories corresponding to the different stimulation base amplitude and discrimination amplitude conditions under spktimes/Base_Amp_{base amplitude}uA/Discrimination_Threshold_Amp_{disc amplitude}_uA/
For example:
spktimes/Base_Amp_3uA/Discrimination_Threshold_Amp_zeropointfive_uA/
The spike time data are organized by cell type.
For example:
'data_soma23.mat' contains the spike times from the soma of all neurons belonging to cell type 23 and 'data_axon23.mat' contains the spike times from the axonal compartments of all neurons belonging to cell type 23.

STEP 4. The extracted spike time .mat files will be used in the subsequent analysis to compute neural activation measures and perform discrimination threshold estimation.
