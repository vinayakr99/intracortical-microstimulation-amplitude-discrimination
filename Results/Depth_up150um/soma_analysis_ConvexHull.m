function soma_analysis_ConvexHull(folder_idx)
%clear all
%for folder_idx = 54:54
    folders = {

        'CD_5um/Base_Amp_3uA/Discrimination_Threshold_Amp_zeropointtwo_uA'
        'CD_5um/Base_Amp_3uA/Discrimination_Threshold_Amp_zeropointfour_uA'
        'CD_5um/Base_Amp_3uA/Discrimination_Threshold_Amp_zeropointfive_uA'
        'CD_5um/Base_Amp_3uA/Discrimination_Threshold_Amp_zeropointseven_uA'
        'CD_5um/Base_Amp_3uA/Discrimination_Threshold_Amp_onepointtwo_uA'
        'CD_5um/Base_Amp_3point5uA/Discrimination_Threshold_Amp_zeropointtwo_uA'
        'CD_5um/Base_Amp_3point5uA/Discrimination_Threshold_Amp_zeropointfive_uA'
        'CD_5um/Base_Amp_3point5uA/Discrimination_Threshold_Amp_zeropointnine_uA'
        'CD_5um/Base_Amp_3point5uA/Discrimination_Threshold_Amp_onepointfive_uA'
        'CD_5um/Base_Amp_4uA/Discrimination_Threshold_Amp_zeropointtwo_uA'
        'CD_5um/Base_Amp_4uA/Discrimination_Threshold_Amp_zeropointsix_uA'
        'CD_5um/Base_Amp_4uA/Discrimination_Threshold_Amp_onepointone_uA'
        'CD_5um/Base_Amp_4uA/Discrimination_Threshold_Amp_onepointeight_uA'

        'CD_10um/Base_Amp_10uA/Discrimination_Threshold_Amp_one_uA'
        'CD_10um/Base_Amp_10uA/Discrimination_Threshold_Amp_onepointeight_uA'
        'CD_10um/Base_Amp_10uA/Discrimination_Threshold_Amp_twopointtwo_uA'
        'CD_10um/Base_Amp_10uA/Discrimination_Threshold_Amp_twopointeight_uA'
        'CD_10um/Base_Amp_10uA/Discrimination_Threshold_Amp_four_uA'
        'CD_10um/Base_Amp_12point5uA/Discrimination_Threshold_Amp_one_uA'
        'CD_10um/Base_Amp_12point5uA/Discrimination_Threshold_Amp_twopointtwo_uA'
        'CD_10um/Base_Amp_12point5uA/Discrimination_Threshold_Amp_threepointfive_uA'
        'CD_10um/Base_Amp_12point5uA/Discrimination_Threshold_Amp_five_uA'
        'CD_10um/Base_Amp_15uA/Discrimination_Threshold_Amp_one_uA'
        'CD_10um/Base_Amp_15uA/Discrimination_Threshold_Amp_twopointseven_uA'
        'CD_10um/Base_Amp_15uA/Discrimination_Threshold_Amp_fourpointtwo_uA'
        'CD_10um/Base_Amp_15uA/Discrimination_Threshold_Amp_six_uA'

        'CD_25um/Base_Amp_10uA/Discrimination_Threshold_Amp_one_uA'
        'CD_25um/Base_Amp_10uA/Discrimination_Threshold_Amp_two_uA'
        'CD_25um/Base_Amp_10uA/Discrimination_Threshold_Amp_twopointfive_uA'
        'CD_25um/Base_Amp_10uA/Discrimination_Threshold_Amp_threepointone_uA'
        'CD_25um/Base_Amp_10uA/Discrimination_Threshold_Amp_fourpointfive_uA'
        'CD_25um/Base_Amp_15uA/Discrimination_Threshold_Amp_one_uA'
        'CD_25um/Base_Amp_15uA/Discrimination_Threshold_Amp_twopointsix_uA'
        'CD_25um/Base_Amp_15uA/Discrimination_Threshold_Amp_fourpointtwo_uA'
        'CD_25um/Base_Amp_15uA/Discrimination_Threshold_Amp_six_uA'
        'CD_25um/Base_Amp_20uA/Discrimination_Threshold_Amp_one_uA'
        'CD_25um/Base_Amp_20uA/Discrimination_Threshold_Amp_threepointfive_uA'
        'CD_25um/Base_Amp_20uA/Discrimination_Threshold_Amp_fivepointeight_uA'
        'CD_25um/Base_Amp_20uA/Discrimination_Threshold_Amp_eight_uA'
        'CD_25um/Base_Amp_20uA/Discrimination_Threshold_Amp_ten_uA'

        'CD_50um/Base_Amp_10uA/Discrimination_Threshold_Amp_one_uA'
        'CD_50um/Base_Amp_10uA/Discrimination_Threshold_Amp_two_uA'
        'CD_50um/Base_Amp_10uA/Discrimination_Threshold_Amp_twopointsix_uA'
        'CD_50um/Base_Amp_10uA/Discrimination_Threshold_Amp_threepointone_uA'
        'CD_50um/Base_Amp_10uA/Discrimination_Threshold_Amp_fourpointfive_uA'
        'CD_50um/Base_Amp_15uA/Discrimination_Threshold_Amp_one_uA'
        'CD_50um/Base_Amp_15uA/Discrimination_Threshold_Amp_twopointsix_uA'
        'CD_50um/Base_Amp_15uA/Discrimination_Threshold_Amp_fourpointtwo_uA'
        'CD_50um/Base_Amp_15uA/Discrimination_Threshold_Amp_six_uA'
        'CD_50um/Base_Amp_20uA/Discrimination_Threshold_Amp_one_uA'
        'CD_50um/Base_Amp_20uA/Discrimination_Threshold_Amp_threepointfive_uA'
        'CD_50um/Base_Amp_20uA/Discrimination_Threshold_Amp_fivepointeight_uA'
        'CD_50um/Base_Amp_20uA/Discrimination_Threshold_Amp_eight_uA'
        'CD_50um/Base_Amp_20uA/Discrimination_Threshold_Amp_ten_uA'
    
    };
    
    folder_labels = {
    
        'Dia5um_BaseAmp3uA_DiscAmp_0p2uA'
        'Dia5um_BaseAmp3uA_DiscAmp_0p4uA'
        'Dia5um_BaseAmp3uA_DiscAmp_0p5uA'
        'Dia5um_BaseAmp3uA_DiscAmp_0p7uA'
        'Dia5um_BaseAmp3uA_DiscAmp_1p2uA'
        'Dia5um_BaseAmp3p5uA_DiscAmp_0p2uA'
        'Dia5um_BaseAmp3p5uA_DiscAmp_0p5uA'
        'Dia5um_BaseAmp3p5uA_DiscAmp_0p9uA'
        'Dia5um_BaseAmp3p5uA_DiscAmp_1p5uA'      
        'Dia5um_BaseAmp4uA_DiscAmp_0p2uA'
        'Dia5um_BaseAmp4uA_DiscAmp_0p6uA'
        'Dia5um_BaseAmp4uA_DiscAmp_1p1uA'
        'Dia5um_BaseAmp4uA_DiscAmp_1p8uA'
        
        'Dia10um_BaseAmp10uA_DiscAmp_1uA'
        'Dia10um_BaseAmp10uA_DiscAmp_1p8uA'
        'Dia10um_BaseAmp10uA_DiscAmp_2p2uA'
        'Dia10um_BaseAmp10uA_DiscAmp_2p8uA'
        'Dia10um_BaseAmp10uA_DiscAmp_4uA'        
        'Dia10um_BaseAmp12p5uA_DiscAmp_1uA'
        'Dia10um_BaseAmp12p5uA_DiscAmp_2p2uA'
        'Dia10um_BaseAmp12p5uA_DiscAmp_3p5uA'
        'Dia10um_BaseAmp12p5uA_DiscAmp_5uA'        
        'Dia10um_BaseAmp15uA_DiscAmp_1uA'
        'Dia10um_BaseAmp15uA_DiscAmp_2p7uA'
        'Dia10um_BaseAmp15uA_DiscAmp_4p2uA'
        'Dia10um_BaseAmp15uA_DiscAmp_6uA'
        
        'Dia25um_BaseAmp10uA_DiscAmp_1uA'
        'Dia25um_BaseAmp10uA_DiscAmp_2uA'
        'Dia25um_BaseAmp10uA_DiscAmp_2p5uA'
        'Dia25um_BaseAmp10uA_DiscAmp_3p1uA'
        'Dia25um_BaseAmp10uA_DiscAmp_4p5uA'      
        'Dia25um_BaseAmp15uA_DiscAmp_1uA'
        'Dia25um_BaseAmp15uA_DiscAmp_2p6uA'
        'Dia25um_BaseAmp15uA_DiscAmp_4p2uA'
        'Dia25um_BaseAmp15uA_DiscAmp_6uA'        
        'Dia25um_BaseAmp20uA_DiscAmp_1uA'
        'Dia25um_BaseAmp20uA_DiscAmp_3p5uA'
        'Dia25um_BaseAmp20uA_DiscAmp_5p8uA'
        'Dia25um_BaseAmp20uA_DiscAmp_8uA'
        'Dia25um_BaseAmp20uA_DiscAmp_10uA'
        
        'Dia50um_BaseAmp10uA_DiscAmp_1uA'
        'Dia50um_BaseAmp10uA_DiscAmp_2uA'
        'Dia50um_BaseAmp10uA_DiscAmp_2p6uA'
        'Dia50um_BaseAmp10uA_DiscAmp_3p1uA'
        'Dia50um_BaseAmp10uA_DiscAmp_4p5uA'        
        'Dia50um_BaseAmp15uA_DiscAmp_1uA'
        'Dia50um_BaseAmp15uA_DiscAmp_2p6uA'
        'Dia50um_BaseAmp15uA_DiscAmp_4p2uA'
        'Dia50um_BaseAmp15uA_DiscAmp_6uA'        
        'Dia50um_BaseAmp20uA_DiscAmp_1uA'
        'Dia50um_BaseAmp20uA_DiscAmp_3p5uA'
        'Dia50um_BaseAmp20uA_DiscAmp_5p8uA'
        'Dia50um_BaseAmp20uA_DiscAmp_8uA'
        'Dia50um_BaseAmp20uA_DiscAmp_10uA'

    };
    
    folder = folders{folder_idx};
    folder_label = folder_labels{folder_idx};

    % Obtain diameter from folder label
    d  = regexp(folder_label, 'Dia(\d+)um','tokens'); 
    dia = str2double(d{1});
    if dia==5
        dia_idx = 1;
    elseif dia==10
        dia_idx = 2;
    elseif dia==25
        dia_idx = 3;
    elseif dia==50
        dia_idx = 4;
    end
    
    load('coord_data/realx.dat')
    load('coord_data/realy.dat')
    load('coord_data/realz.dat')
    
    load('coord_data/realang.dat')
    
    load('coord_data/cell_cnt.dat')

    load('electrode_array_xyz.mat') % Electrode array region coordinates for Convex Hull intersection check in eliminate
    
    cnt_cnt_1=1; % For block 1 (first 325ms)
    cnt_cnt_2=1; % For block 2 (second 325ms)
    
    for id=1:25
    
        intx=load(['coord_data/intx_' num2str(id) '.dat']);
        inty=load(['coord_data/inty_' num2str(id) '.dat']);
        intz=load(['coord_data/intz_' num2str(id) '.dat']);
        
        soma_coord=load(['coord_data/soma_coord_' num2str(id) '.dat']);
        
        data_soma_1 = load([folder '/data_soma' num2str(id) '.mat']);  % For block 1 (first 325ms)
        data_soma_2 = load([folder '/data_soma' num2str(id) '.mat']);  % For block 2 (second 325ms)  
        
        cell_id=1:cell_cnt(id);
        
        % FEM electrode contact center coordinates referenced to NEURON coordinates
        elec_x=200;
        elec_y=(3950-3162.5);
        elec_z=200;
        
        t_block = 525; % Time of switch from Block 1 -> Block 2
        
        eli_a=[];
        eliminate=[];
        
        cnt=1;
        for k=1:cell_cnt(id)
            
            net_ad_x1a=(((realx(sum(cell_cnt(1:id))-cell_cnt(id)+k ))*cos(realang(sum(cell_cnt(1:id))-cell_cnt(id)+k )))-((realz(sum(cell_cnt(1:id))-cell_cnt(id)+k ))*sin(realang(sum(cell_cnt(1:id))-cell_cnt(id)+k ))))-(realx(sum(cell_cnt(1:id))-cell_cnt(id)+k ));
            net_ad_y1a=(realy(sum(cell_cnt(1:id))-cell_cnt(id)+k ))-(realy(sum(cell_cnt(1:id))-cell_cnt(id)+k ));
            net_ad_z1a=(((realx(sum(cell_cnt(1:id))-cell_cnt(id)+k ))*sin(realang(sum(cell_cnt(1:id))-cell_cnt(id)+k )))+((realz(sum(cell_cnt(1:id))-cell_cnt(id)+k ))*cos(realang(sum(cell_cnt(1:id))-cell_cnt(id)+k ))))-(realz(sum(cell_cnt(1:id))-cell_cnt(id)+k ));
            
            axon_check = 0; % Don't check axonal comp intersection to save computational resources, only check soma
            if axon_check==1
                for i=1:length(intx)
                % for j=1:nseg(i)
                    
                    x1a=(((realx(sum(cell_cnt(1:id))-cell_cnt(id)+k )+intx(i))*cos(realang(sum(cell_cnt(1:id))-cell_cnt(id)+k )))-((realz(sum(cell_cnt(1:id))-cell_cnt(id)+k )+intz(i))*sin(realang(sum(cell_cnt(1:id))-cell_cnt(id)+k ))));
                    y1a=(realy(sum(cell_cnt(1:id))-cell_cnt(id)+k )+inty(i));
                    z1a=(((realx(sum(cell_cnt(1:id))-cell_cnt(id)+k )+intx(i))*sin(realang(sum(cell_cnt(1:id))-cell_cnt(id)+k )))+((realz(sum(cell_cnt(1:id))-cell_cnt(id)+k )+intz(i))*cos(realang(sum(cell_cnt(1:id))-cell_cnt(id)+k ))));
                
                    x_final_a=x1a-net_ad_x1a;
                    y_final_a=y1a-net_ad_y1a;
                    z_final_a=z1a-net_ad_z1a;
                
                    % Check if component inside electrode array shank regions
                    for shank = 1:4  % shank
                            in1(shank) = inhull([x_final_a z_final_a y_final_a], electrode_array_xyz{dia_idx,shank});
                    end
                
                    % Tag this cell id (k) if intersecting
                    for shank=1:length(in1)    
                        if in1(shank)==1 
                            eli_a(cnt)=k;
                            cnt=cnt+1;
                        end
                    end
            
                    clear in1
            
                end
            else
                % Check if soma inside electrode array shank regions
                soma_x = soma_coord(1)+realx(sum(cell_cnt(1:id))-cell_cnt(id)+k);
                soma_y = soma_coord(2)+realy(sum(cell_cnt(1:id))-cell_cnt(id)+k);
                soma_z = soma_coord(3)+realz(sum(cell_cnt(1:id))-cell_cnt(id)+k);
                for shank = 1:4  % shank
                        in1(shank) = inhull([soma_x soma_z soma_y], electrode_array_xyz{dia_idx,shank});
                end
            
                % Tag this cell id (k) if intersecting
                for shank=1:length(in1)    
                    if in1(shank)==1 
                        eli_a(cnt)=k;
                        cnt=cnt+1;
                    end
                end
        
                clear in1 soma_x soma_y soma_z
            end
                
            % end
        end
        
        if ~isempty(eli_a)
        
        eliminate=unique(eli_a);
        
        end
        
        
        for i=1:cell_cnt(id)
        %Block 1    
        if ~isempty(data_soma_1.data_soma(i).times)
        if data_soma_1.data_soma(i).times >= t_block
            data_soma_1.data_soma(i).times=[];
        end
        end
        %Block 2
        if ~isempty(data_soma_2.data_soma(i).times)
        if data_soma_2.data_soma(i).times < t_block
            data_soma_2.data_soma(i).times=[];
        end
        end
        end
        
        real_cell_id_1=[]; % Block 1
        real_cell_id_2=[]; % Block 2
        
        cnt_1=1; %Block 1
        cnt_2=1; %Block 2
        
        for i=1:cell_cnt(id)
        %Block 1
        if ~isempty(data_soma_1.data_soma(i).times)
            dta_1(cnt_1)=sort(data_soma_1.data_soma(i).times(1))-200;  % First spike time
    
            spike_times_1 = data_soma_1.data_soma(i).times - 200;% Align spike times to stimulus onset
            bin_edges = 0:25:325;   % Bin edges (13 bins of 25 ms)
            spike_counts_1(cnt_1,:) = histcounts(spike_times_1, bin_edges); % Count spikes in each bin
    
            real_cell_id_1(cnt_1)=cell_id(i); % Activated cell id
            cnt_1=cnt_1+1;
        end
        %Block 2
        if ~isempty(data_soma_2.data_soma(i).times)
            dta_2(cnt_2)=sort(data_soma_2.data_soma(i).times(1))-200; % First spike time

            spike_times_2 = data_soma_2.data_soma(i).times - (200+325);% Align spike times to stimulus onset
            bin_edges = 0:25:325;   % Bin edges (13 bins of 25 ms)
            spike_counts_2(cnt_2,:) = histcounts(spike_times_2, bin_edges); % Count spikes in each bin

            real_cell_id_2(cnt_2)=cell_id(i); 
            cnt_2=cnt_2+1;
        end
        end
        
        %Block 1
        if ~isempty(real_cell_id_1)
        
        %Remove eliminated cells
        ind_find_1=[];
        cmbt_1=1;
        if ~isempty(eliminate)
            for i=1:length(eliminate)
                if ~isempty(find(real_cell_id_1==eliminate(i), 1)) 
            ind_find_1(cmbt_1)=find(real_cell_id_1==eliminate(i));
            cmbt_1=cmbt_1+1;
            end
            end
            real_cell_id_1(ind_find_1)=[];
            dta_1(ind_find_1)=[];
            spike_counts_1(ind_find_1,:)=[];
            
        end
        
        %Get final coordinates and cell id
        for pri=1:length(dta_1)
            dta_final_1(cnt_cnt_1)=dta_1(pri);
            spike_counts_final_1(cnt_cnt_1,:)=spike_counts_1(pri,:);
            real_cell_id_final_1(cnt_cnt_1)=sum(cell_cnt(1:id))-cell_cnt(id)+real_cell_id_1(pri);
            x_coord_1(cnt_cnt_1)=soma_coord(1)+realx(sum(cell_cnt(1:id))-cell_cnt(id)+real_cell_id_1(pri));
            y_coord_1(cnt_cnt_1)=soma_coord(2)+realy(sum(cell_cnt(1:id))-cell_cnt(id)+real_cell_id_1(pri));
            z_coord_1(cnt_cnt_1)=soma_coord(3)+realz(sum(cell_cnt(1:id))-cell_cnt(id)+real_cell_id_1(pri));
            cnt_cnt_1=cnt_cnt_1+1;
        
        end
        
        end
        
        %Block 2
        if ~isempty(real_cell_id_2)
        
        %Remove eliminated cells
        ind_find_2=[];
        cmbt_2=1;
        if ~isempty(eliminate)
            for i=1:length(eliminate)
                if ~isempty(find(real_cell_id_2==eliminate(i), 1)) 
            ind_find_2(cmbt_2)=find(real_cell_id_2==eliminate(i));
            cmbt_2=cmbt_2+1;
            end
            end
            real_cell_id_2(ind_find_2)=[];
            dta_2(ind_find_2)=[];
            spike_counts_2(ind_find_2,:)=[];
            
        end
        
        %Get final coordinates and cell id
        for pri=1:length(dta_2)
            dta_final_2(cnt_cnt_2)=dta_2(pri);
            spike_counts_final_2(cnt_cnt_2,:)=spike_counts_2(pri,:);
            real_cell_id_final_2(cnt_cnt_2)=sum(cell_cnt(1:id))-cell_cnt(id)+real_cell_id_2(pri);
            x_coord_2(cnt_cnt_2)=soma_coord(1)+realx(sum(cell_cnt(1:id))-cell_cnt(id)+real_cell_id_2(pri));
            y_coord_2(cnt_cnt_2)=soma_coord(2)+realy(sum(cell_cnt(1:id))-cell_cnt(id)+real_cell_id_2(pri));
            z_coord_2(cnt_cnt_2)=soma_coord(3)+realz(sum(cell_cnt(1:id))-cell_cnt(id)+real_cell_id_2(pri));
            cnt_cnt_2=cnt_cnt_2+1;
        
        end
        
        end
        
        clear dta_1 spike_counts_1 real_cell_id_1 ind_find_1 dta_2 spike_counts_2 real_cell_id_2 ind_find_2 cell_id data_soma_1 data_soma_2 eliminate eli_a rdist_a x_final_a y_final_a z_final_a x1a y1a z1a net_ad_x1a net_ad_y1a net_ad_z1a intx inty intz soma_coord 
    
    end
    
    %Block 1 distance calc
    adf_1=unique(real_cell_id_final_1);
    tru_id_1=1:length(realx);
    tru_id_1(adf_1)=[];
    
    x_c_1=realx(adf_1);
    y_c_1=realy(adf_1);
    z_c_1=realz(adf_1);
    xyz_coords_1 = [x_c_1(:), y_c_1(:), z_c_1(:)];
     
    dist_1=sqrt(((x_c_1-elec_x).^2)+((y_c_1-elec_y).^2)+((z_c_1-elec_z).^2));
    
    %Block 2 distance calc
    adf_2=unique(real_cell_id_final_2);
    tru_id_2=1:length(realx);
    tru_id_2(adf_2)=[];
    
    x_c_2=realx(adf_2);
    y_c_2=realy(adf_2);
    z_c_2=realz(adf_2);
    xyz_coords_2 = [x_c_2(:), y_c_2(:), z_c_2(:)];
     
    dist_2=sqrt(((x_c_2-elec_x).^2)+((y_c_2-elec_y).^2)+((z_c_2-elec_z).^2));
    
    
    % Save Data ===============================================================
    
    output_folder = 'activation_data_ConvexHull';
    
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end
    
    %save activation distances
    name11 = fullfile(output_folder,[folder_label '_block1_soma_dist.dat']);
    name12 = fullfile(output_folder,[folder_label '_block2_soma_dist.dat']);
    save(name11, 'dist_1', '-ascii')
    save(name12, 'dist_2', '-ascii')
    
    %save activation coords
    name21 = fullfile(output_folder,[folder_label '_block1_soma_xyz.dat']);
    name22 = fullfile(output_folder,[folder_label '_block2_soma_xyz.dat']);
    save(name21, 'xyz_coords_1', '-ascii')
    save(name22, 'xyz_coords_2', '-ascii')
    
    %save activation cell ids
    name31 = fullfile(output_folder,[folder_label '_block1_soma_cell_id.dat']);
    name32 = fullfile(output_folder,[folder_label '_block2_soma_cell_id.dat']);
    save(name31, 'real_cell_id_final_1', '-ascii')
    save(name32, 'real_cell_id_final_2', '-ascii')

    %save activation spike times
    name41 = fullfile(output_folder,[folder_label '_block1_soma_spike_counts.dat']);
    name42 = fullfile(output_folder,[folder_label '_block2_soma_spike_counts.dat']);
    save(name41, 'spike_counts_final_1', '-ascii')
    save(name42, 'spike_counts_final_2', '-ascii')

end
