clear all

all_coords = [];

% Loop through all 25 cell types
for cell_type = 1:25
    
    filename = ['neuron_coordinates_' num2str(cell_type) '.txt'];
    
    if exist(filename, 'file')
        coords = load(filename);
        all_coords = [all_coords; coords];   % Append rows
    else
        warning(['File not found: ' filename])
    end
    
end

% Save combined file
save('neuron_coordinates.txt', 'all_coords', '-ascii');