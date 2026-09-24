This folder contains the FEM files, neuron coordinate generation scripts, and associated code to generate the 3D-interpolated potentials that will be coupled to the NEURON simulations in the next step.

FOLDER STRUCTURE

1. COMSOL_FEM/Reference_Depth/ : Reference depth condition. Contains COMSOL FEM files for different contact diameters used to solve for the extracellular potentials, as well as MATLAB script to format the 3D-interpolated potentials for coupling with the NEURON simulations.

2. COMSOL_FEM/Depth_down150um/ : Depth condition 150 um deeper than the reference depth. Contains COMSOL FEM files for different contact diameters used to solve for the extracellular potentials, as well as MATLAB script to format the 3D-interpolated potentials for coupling with the NEURON simulations.

3. COMSOL_FEM/Depth_up150um/ : Depth condition 150 um superficial to the reference depth. Contains COMSOL FEM files for different contact diameters used to solve for the extracellular potentials, as well as MATLAB script to format the 3D-interpolated potentials for coupling with the NEURON simulations.

4. COMSOL_FEM/Generate_Coordinates/ : Contains neuron coordinate files (within coords/) and MATLAB scripts used to generate neuronal component coordinates for different depth conditions, referenced to the COMSOL coordinate system for subsequent 3D interpolation of the potentials. Overview of the neuron coordinate files within coords/:-
a. coords/realx.dat, realy.dat, realz.dat - x,y,z coordinates (in microns) of cell bodies of neurons in the column.
b. coords/realang.dat - angle at which each neuron is rotated around its somatodendritic axis.
c. coords/cell_cnt.dat - number of neurons within each cell type. There are 25 different cell types and 6410 neurons in total.
NOTE: realx.dat, realy.dat, realz.dat, realang.dat can be generated as a different distribution of the coordinates and angles using the 'neuron_seeding.m' MATLAB script
d. coords/intx.dat, inty.dat, intz.dat - x,y,z coordinates of various compartments (soma, axon, dendrites) for each cell type
e. coords/soma_coord.dat - x,y,z coordinates of soma for each cell type
f. coords/x_axon.dat, y_axon.dat, z_axon.dat - x,y,z coordinates of various axonal compartments for each cell type

EXECUTION SEQUENCE

The following are the execution steps for the 'Reference_Depth' condition. The same sequence can be followed for the 'Depth_down150um' and 'Depth_up150um' conditions by substituting the 'Reference_Depth' folder with the corresponding depth condition folder name.

STEP 1. Run 'run_generate_comp_coordinates.q' under COMSOL_FEM/Generate_Coordinates/Reference_Depth/. This executes the MATLAB script 'generate_comp_coordinates.m' and generates the neuron component coordinate files for each cell type. NOTE: The SLURM submission settings in 'run_generate_comp_coordinates.q' should be modified to match the available local cluster resources. Expected output files: 'neuron_coordinates_{cell_type}.txt' for each of the 25 cell types.

STEP 2. Run 'combine_comp_coordinates.m' under COMSOL_FEM/Generate_Coordinates/Reference_Depth/. This combines the neuron coordinate files for the different cell types generated in the previous step into a single file. Expected output file: 'neuron_coordinates.txt'.

STEP 3. Move the generated 'neuron_coordinates.txt' file to COMSOL_FEM/Reference_Depth/.

STEP 4. Solve the COMSOL FEM models and export the interpolated potentials for each contact diameter. The following sequence is shown for the 5 um contact diameter:
a. Open the COMSOL model 'G1_contact_diameter_5um.mph' under COMSOL_FEM/Reference_Depth/.
b. Generate the mesh by selecting 'Build All' under 'Mesh 1'.
c. Solve the model by selecting 'Compute' under 'Study 1'.
d. After the study has completed, save the results by accessing 'Data 1' under 'Export' in 'Results'. In the 'Data 1' settings, under 'Output', specify the 'Filename' as './COMSOL_FEM/Reference_Depth/pot_G1_S1_5um.txt' and the 'Coordinate file' as './COMSOL_FEM/Reference_Depth/neuron_coordinates.txt'. Click 'Export' to interpolate the potentials at the neuron coordinates and save the interpolated potentials to the specified target location. Expected output file: 'pot_G1_S1_5um.txt'.

STEP 5. Run 'pot_comsol_Remove_NaN.m' under COMSOL_FEM/Generate_Coordinates/Reference_Depth/ after modifying 'filename1' to specify the corresponding interpolated potential file ('pot_G1_S1_{contact diameter}um'). This generates the final potential files to be used as inputs for the NEURON simulations. Expected output file: 'fem_pot_G1_S1_{contact diameter}um.dat'.