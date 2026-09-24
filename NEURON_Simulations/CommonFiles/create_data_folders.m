
function create_data_folders(base_amp_nA,disc_amp_nA)

    % Create amp subfolders for Vm
    folderName1 = ['Vm/' num2str(base_amp_nA) 'nA_' num2str(disc_amp_nA) 'nA'];
    if ~exist(folderName1, 'dir')
        mkdir(folderName1);
    end

    pause(2);

    % Write a done-flag, success or failure, as the very last action
    done_name = sprintf('flags/create_folder_done_%d_%d.flag', base_amp_nA,disc_amp_nA);
    fid = fopen(done_name, 'w');
    fprintf(fid, 'done\n');
    fclose(fid);

end

