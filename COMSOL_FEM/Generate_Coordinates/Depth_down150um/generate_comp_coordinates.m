function generate_comp_coordinates(cell_type)

    % Reference coordinates of all cells (6410 total)
    load('../coords/realx.dat')
    load('../coords/realy.dat')
    load('../coords/realz.dat')
    
    load('../coords/realang.dat')
    
    load('../coords/cell_cnt.dat')
    
    % COMSOL point current source center
    ELECx6=-150;
    ELECy6=3462.5;
    ELECz6=-49.5;
    
    % offsets to match NEURON coordinates with COMSOL distribution C6 (reference)
    xoffset=ELECx6-200;
    yoffset=3950;
    zoffset=ELECz6-200;
    
    cnt=1;
    
    % Looping the particular cell type (out of 25 total)
    id=cell_type
    
    % Cell id of each cell of the specific cell type
    cell_id=1:cell_cnt(id);
    
    % Coordinates of each component (axon/dendrite compartments)
    intx=load(['../coords/intx_' num2str(id) '.dat']);
    inty=load(['../coords/inty_' num2str(id) '.dat']);
    intz=load(['../coords/intz_' num2str(id) '.dat']);
    
    % Loop through each cell of the particular cell type
    for k=1:cell_cnt(id)
        
        % Rotation adjusted reference coordinates for the particular cell
        net_ad_x1a=(((realx(sum(cell_cnt(1:id))-cell_cnt(id)+k ))*cos(realang(sum(cell_cnt(1:id))-cell_cnt(id)+k )))-((realz(sum(cell_cnt(1:id))-cell_cnt(id)+k ))*sin(realang(sum(cell_cnt(1:id))-cell_cnt(id)+k ))))-(realx(sum(cell_cnt(1:id))-cell_cnt(id)+k ));
        net_ad_y1a=(realy(sum(cell_cnt(1:id))-cell_cnt(id)+k ))-(realy(sum(cell_cnt(1:id))-cell_cnt(id)+k ));
        net_ad_z1a=(((realx(sum(cell_cnt(1:id))-cell_cnt(id)+k ))*sin(realang(sum(cell_cnt(1:id))-cell_cnt(id)+k )))+((realz(sum(cell_cnt(1:id))-cell_cnt(id)+k ))*cos(realang(sum(cell_cnt(1:id))-cell_cnt(id)+k ))))-(realz(sum(cell_cnt(1:id))-cell_cnt(id)+k ));
    
        % Loop through each component (axon/dendrite?) of the particular cell
        for i=1:length(intx)
        % for j=1:nseg(i)
            
            % Rotation adjusted coordinates of the particular component with reference to the coordinates of the cell 
            x1a=(((realx(sum(cell_cnt(1:id))-cell_cnt(id)+k )+intx(i))*cos(realang(sum(cell_cnt(1:id))-cell_cnt(id)+k )))-((realz(sum(cell_cnt(1:id))-cell_cnt(id)+k )+intz(i))*sin(realang(sum(cell_cnt(1:id))-cell_cnt(id)+k ))));
            y1a=(realy(sum(cell_cnt(1:id))-cell_cnt(id)+k )+inty(i));
            z1a=(((realx(sum(cell_cnt(1:id))-cell_cnt(id)+k )+intx(i))*sin(realang(sum(cell_cnt(1:id))-cell_cnt(id)+k )))+((realz(sum(cell_cnt(1:id))-cell_cnt(id)+k )+intz(i))*cos(realang(sum(cell_cnt(1:id))-cell_cnt(id)+k ))));
            
            % Final coordinates of the particular component
            x_final_a=(x1a-net_ad_x1a) + xoffset;
            y_final_a=yoffset - (y1a-net_ad_y1a);
            z_final_a=(z1a-net_ad_z1a) + zoffset;
    
            % Store the final coordinates    
            final_coords(cnt,:)=[y_final_a,x_final_a,z_final_a];
    
            cnt = cnt+1;
    
        end
    end
    
    clear intx inty intz cell_id  
    
    %save final coordinates
    name1=['neuron_coordinates_' num2str(cell_type) '.txt'];
    save(name1, 'final_coords', '-ascii')
    
    clear final_coords    

end
