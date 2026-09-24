function extract_spike_times(cell_type,base_amp_nA,disc_amp_nA)
    
    load('cell_cnt.dat')
    
    cnt=1;
    for i=1:cell_cnt(cell_type)
        name=['Vm/' num2str(base_amp_nA) 'nA_' num2str(disc_amp_nA) 'nA/Vm_' num2str(cell_type) '_' num2str(i) '.dat'];
        a=load(name);
        data_soma(cnt).times = a(diff(a(:,2)>-20)==1,1)'; 
        cnt=cnt+1;
        clear a
    end
        

    for i=1:cell_cnt(cell_type)
        name=['Vm/' num2str(base_amp_nA) 'nA_' num2str(disc_amp_nA) 'nA/Vm_axon_' num2str(cell_type) '_' num2str(i) '.dat'];
        a=load(name);
    
        for j=1:length(a(1,:))-1
            data_axon(i).times{1,j} = a(diff(a(:,j+1)>-20)==1,1)'; 
        end
    
        clear a
    
    end
    
    % Convert nA to uA
    base_amp_uA = base_amp_nA / 1000;
    disc_amp_uA = disc_amp_nA / 1000;
    
    % Create folder names
    base_string = number_to_numeric_string(base_amp_uA);
    disc_string = number_to_word(disc_amp_uA);
    
    base_folder = ['Base_Amp_' base_string 'uA'];
    disc_folder = ['Discrimination_Threshold_Amp_' disc_string '_uA'];
    
    % Full output folder
    output_folder = fullfile('spktimes',base_folder, disc_folder);
    
    % Create output folder if it doesn't exist
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end

    % Save files
    name1 = ['data_soma' num2str(cell_type) '.mat'];
    name2 = ['data_axon' num2str(cell_type) '.mat'];

    save(fullfile(output_folder, name1), 'data_soma')
    save(fullfile(output_folder, name2), 'data_axon')

    clear data_soma data_axon name name1 name2

    % Write a done-flag, success or failure, as the very last action
    done_name = sprintf('flags/spk_times_done_%d_%d_%d.flag', base_amp_nA,disc_amp_nA,cell_type);
    fid = fopen(done_name, 'w');
    fprintf(fid, 'done\n');
    fclose(fid);

    %% Helper functions

    % Convert number to numeric folder format
    % Example: 3.5 -> '3point5'
    function str = number_to_numeric_string(x)
    
        str = num2str(x, '%.10g');
        str = strrep(str, '.', 'point');
    
    end
    
    
    % Convert number to word folder format
    % Example: 0.2 -> 'zeropointtwo'
    function str = number_to_word(x)
    
        str = num2str(x, '%.10g');
    
        parts = split(str, '.');
    
        digit_words = {'zero','one','two','three','four', ...
                       'five','six','seven','eight','nine'};
    
        % Integer part
        integer_part = parts{1};
        integer_string = '';
    
        for k = 1:length(integer_part)
            digit = str2double(integer_part(k));
            integer_string = [integer_string digit_words{digit+1}];
        end
    
        % Decimal part
        if length(parts) > 1
    
            decimal_part = parts{2};
            decimal_string = '';
    
            for k = 1:length(decimal_part)
                digit = str2double(decimal_part(k));
                decimal_string = [decimal_string digit_words{digit+1}];
            end
    
            str = [integer_string 'point' decimal_string];
    
        else
    
            str = integer_string;
    
        end
    
    end

end