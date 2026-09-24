%% =========================================================================
%  Discrimination Threshold Analysis Across All Depths
%  Computes metric per layer, fits threshold_value to experimental data,
%  and plots metric values, disc thresholds, Weber fractions, senitivity

%  Figure Series 100: Reference Depth
%  Figure Series 200: Depth Down 150um
%  Figure Series 300: Depth Up 150um
%  Figure Series 400: All Depth Combined, Shaded region in Figures 400 and
%  401 represent the variation in disc thresholds between the 3 depths
% =========================================================================

clear; clc; close all;

%% ------------------------------------------------------------------------
%  File labels
% -------------------------------------------------------------------------
file_labels = {

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

depth_folders = {
    'Reference_Depth/'
    'Depth_down150um/'
    'Depth_up150um/'
};

depth_labels = {'Base (1362.5um)', 'Base +150um', 'Base -150um'};

tv_mode = 2; % 0: Determine tv using Depth 1 data only; apply that single tv across all depths
            % 1: Determine tv independently for each depth
            % 2: Determine a single tv by minimising SSE between mean model DT across depths and mean experimental DT across rats

%% =========================================================================
%  METRIC SELECTOR
%
%  1 : ΔN/N1
%  2 : ΔS/S1
%  3 : (ΔN/N1)×(ΔS/S1)
%  4 : ΔS_mean/S1_mean
%  5 : (ΔN/N1)×(ΔS_mean/S1_mean)
%  6 : ΔN/√N1
%  7 : ΔS_mean/√S1_mean
%  8 : (ΔN/√N1)×(ΔS_mean/√S1_mean)
%  9 : (ΔN/N1)×(ΔS_mean/√S1_mean)
% 10 : (ΔN/N1)×(ΔS_wmean/√S1_wmean)
% 11 : (ΔN/√N1)×(ΔS_wmean/√S1_wmean)
% 12 : |ΔD_mean|/D1_mean
% 13 : (ΔN/N1)×(|ΔD_mean|/D1_mean)
% 14 : ΔS/√S1
% =========================================================================
metric = 1;

%% -------------------------------------------------------------------------
%  Metric metadata
% -------------------------------------------------------------------------
metric_info = { ...
    1,  '\DeltaN/N_1',                                              '\DeltaN / N_1'; ...
    2,  '\DeltaS/S_1',                                              '\DeltaS / S_1'; ...
    3,  '(\DeltaN/N_1)\times(\DeltaS/S_1)',                         '(\DeltaN/N_1) \times (\DeltaS/S_1)'; ...
    4,  '\DeltaS_{mean}/S_{1,mean}',                                '\DeltaS_{mean} / S_{1,mean}'; ...
    5,  '(\DeltaN/N_1)\times(\DeltaS_{mean}/S_{1,mean})',           '(\DeltaN/N_1) \times (\DeltaS_{mean}/S_{1,mean})'; ...
    6,  '\DeltaN/\surdN_1',                                         '\DeltaN / \surdN_1'; ...
    7,  '\DeltaS_{mean}/\surdS_{1,mean}',                           '\DeltaS_{mean} / \surdS_{1,mean}'; ...
    8,  '(\DeltaN/\surdN_1)\times(\DeltaS_{mean}/\surdS_{1,mean})', '(\DeltaN/\surdN_1) \times (\DeltaS_{mean}/\surdS_{1,mean})'; ...
    9,  '(\DeltaN/N_1)\times(\DeltaS_{mean}/\surdS_{1,mean})',      '(\DeltaN/N_1) \times (\DeltaS_{mean}/\surdS_{1,mean})'; ...
    10, '(\DeltaN/N_1)\times(\DeltaS_{wt.mean}/\surdS_{1,wt.mean})',  '(\DeltaN/N_1) \times (\DeltaS_{wt.mean}/\surdS_{1,wt.mean}) '; ...
    11, '(\DeltaN/\surdN_1)\times(\DeltaS_{wt.mean}/\surdS_{1,wt.mean})', '(\DeltaN/\surdN_1) \times (\DeltaS_{wt.mean}/\surdS_{1,wt.mean}) '; ...
    12, '|\DeltaD_{mean}|/D_{1,mean}',                              '|\DeltaD_{mean}| / D_{1,mean}'; ...
    13, '(\DeltaN/N_1)\times(|\DeltaD_{mean}|/D_{1,mean})',         '(\DeltaN/N_1) \times (|\DeltaD_{mean}| / D_{1,mean})'; ...
    14,  '\DeltaS/\surdS_1',                                        '\DeltaS / \surdS_1'; ...
};

metric_ylabel = metric_info{metric, 2};
metric_title  = metric_info{metric, 3};

%% =========================================================================
num_files    = length(file_labels);
num_depths   = length(depth_folders);

%% -------------------------------------------------------------------------
%  Experimental discrimination thresholds
%  Rows = diameters [5, 10, 25, 50] um
%  Cols = RefAmp   [min, med, max]
% -------------------------------------------------------------------------
disc_thresh_exp = [0.848, 0.978, 1.26;
                   3.149, 4.123, 3.748;
                   3.96,  4.518, 7.318;
                   2.908, 4.78,  5.817];

%% -------------------------------------------------------------------------
%  Load cell counts for layer assignment
% -------------------------------------------------------------------------
load('Reference_Depth/coord_data/cell_cnt.dat')

%% =========================================================================
%  Plot Defaults
% =========================================================================
set(groot,'defaultFigureColor','w')
set(groot,'defaultAxesFontSize',15.5)
set(groot,'defaultAxesLabelFontSizeMultiplier',1.1)
set(groot,'defaultAxesTitleFontSizeMultiplier',1.2)
set(groot,'defaultTextFontSize',16)
set(groot,'defaultAxesLineWidth',1.8)
set(groot,'defaultAxesTickDir','out')
set(groot,'defaultAxesTickLength',[0.02 0.02])
set(groot,'defaultAxesBox','off')
set(groot,'defaultLineLineWidth',2)
set(groot,'defaultLineMarkerSize',10)
set(groot,'defaultLegendFontSize',17)
set(groot,'defaultLegendBox','off')
set(groot,'defaultAxesGridAlpha',0.05)
set(groot,'defaultFigureUnits','inches')
set(groot,'defaultFigurePosition',[1 1 6 5.5])

colors     = {[1 0 0], [0 0 1], [0 0.4 0]};
ref_labels = {'Min Ref Amp', 'Med Ref Amp', 'Max Ref Amp'};
dia_colors = {[0.49 0.18 0.56],[0.0 0.45 0.70],[0.87 0.49 0.0],[0.47 0.47 0.47]};

%% =========================================================================
%  Storage across depths:
%    DiscThreshold_all_depths  : num_diams x num_ref x num_layers x num_depths
%    tv_opt_all                : 1 x num_depths
% =========================================================================

% Pre-compute unique_diams and num_ref
Diameter_tmp = zeros(num_files,1);
BaseAmp_tmp  = zeros(num_files,1);
for i = 1:num_files
    fl = file_labels{i};
    d  = regexp(fl, 'Dia(\d+)um',         'tokens'); Diameter_tmp(i) = str2double(d{1});
    b  = regexp(fl, 'BaseAmp([\dp]+)uA',  'tokens'); BaseAmp_tmp(i)  = str2double(strrep(b{1}{1},'p','.'));
end
unique_diams = unique(Diameter_tmp);
num_diams    = length(unique_diams);
num_ref      = 3;

layers     = {'All', 'L23', 'L4', 'L5', 'L6'};
num_layers = length(layers);
L_fit      = 1;   % fit only against "All" layer

DiscThreshold_all_depths = NaN(num_diams, num_ref, num_layers, num_depths);
tv_opt_all               = NaN(1, num_depths);

%% =========================================================================
%  PRE-FIT tv BEFORE MAIN LOOP  (tv_mode == 0 or tv_mode == 2)
%
%  tv_mode == 0 : load Depth 1 only, fit tv on that data
%  tv_mode == 2 : load ALL depths, fit tv that minimises combined SSE
% =========================================================================
if tv_mode == 0 || tv_mode == 2

    % ------------------------------------------------------------------
    %  Determine which depths to load for pre-fitting
    % ------------------------------------------------------------------
    if tv_mode == 0
        prefit_depths = 1;
        fprintf('\n=========================================================\n');
        fprintf('  Pre-fitting tv using Depth 1: %s\n', depth_labels{1});
        fprintf('=========================================================\n');
    else
        prefit_depths = 1:num_depths;
        fprintf('\n=========================================================\n');
        fprintf('  Pre-fitting tv using ALL %d depths (combined SSE)\n', num_depths);
        fprintf('=========================================================\n');
    end

    % ------------------------------------------------------------------
    %  Load data for the relevant depths and store DeltaFrac per depth
    % ------------------------------------------------------------------
    Diameter_pre  = zeros(num_files, 1);
    BaseAmp_pre   = zeros(num_files, 1);
    DiscAmp_pre   = zeros(num_files, 1);

    % Cell arrays so we can accumulate across multiple depths
    DeltaFrac_pre = cell(num_depths, 1);

    for pdi = prefit_depths

        depth_folder_pre = depth_folders{pdi};
        DeltaFrac_tmp    = zeros(num_files, num_layers);

        for i = 1:num_files
            file_label = file_labels{i};
            base_path  = [depth_folder_pre 'activation_data_ConvexHull/' file_label];

            cellid_1 = load([base_path '_block1_soma_cell_id.dat']);
            cellid_2 = load([base_path '_block2_soma_cell_id.dat']);

            spike_counts_1 = load([base_path '_block1_soma_spike_counts.dat']);
            spike_counts_2 = load([base_path '_block2_soma_spike_counts.dat']);

            act_dist_1 = load([base_path '_block1_soma_dist.dat']);
            act_dist_2 = load([base_path '_block2_soma_dist.dat']);

            nbins       = 4;
            onset_shift = 0;
            spike_counts_1 = sum(spike_counts_1(:, end-(nbins-1):end),               2);
            spike_counts_2 = sum(spike_counts_2(:, onset_shift+1:onset_shift+nbins),  2);

            cellid_1   = cellid_1(:);
            cellid_2   = cellid_2(:);
            act_dist_1 = act_dist_1(:);
            act_dist_2 = act_dist_2(:);

            layer_spike_counts_1 = assign_distances_to_layers(spike_counts_1, cellid_1, cell_cnt);
            layer_spike_counts_2 = assign_distances_to_layers(spike_counts_2, cellid_2, cell_cnt);
            layer_act_dist_1     = assign_distances_to_layers(act_dist_1,     cellid_1, cell_cnt);
            layer_act_dist_2     = assign_distances_to_layers(act_dist_2,     cellid_2, cell_cnt);

            DeltaFrac_tmp(i,1) = compute_metric(metric, spike_counts_1, spike_counts_2, ...
                                                act_dist_1, act_dist_2);
            for L = 2:num_layers
                layer_name = layers{L};
                counts1 = layer_spike_counts_1.(layer_name);
                counts2 = layer_spike_counts_2.(layer_name);
                dists1  = layer_act_dist_1.(layer_name);
                dists2  = layer_act_dist_2.(layer_name);
                if isempty(counts1) && isempty(counts2)
                    DeltaFrac_tmp(i,L) = NaN;
                else
                    DeltaFrac_tmp(i,L) = compute_metric(metric, counts1, counts2, dists1, dists2);
                end
            end

            % Assign metadata (same across depths)
            if pdi == prefit_depths(1)
                d  = regexp(file_label, 'Dia(\d+)um',         'tokens'); Diameter_pre(i) = str2double(d{1});
                b  = regexp(file_label, 'BaseAmp([\dp]+)uA',  'tokens'); BaseAmp_pre(i)  = str2double(strrep(b{1}{1},'p','.'));
                da = regexp(file_label, 'DiscAmp_([\dp]+)uA', 'tokens'); DiscAmp_pre(i)  = str2double(strrep(da{1}{1},'p','.'));
            end
        end

        DeltaFrac_pre{pdi} = DeltaFrac_tmp;

    end  % end prefit depth loop

    % ------------------------------------------------------------------
    %  Build objective: sum of SSE across all pre-fit depths
    % ------------------------------------------------------------------
    % obj_fun_pre = @(tv) sum(cellfun( ...
    %     @(df) compute_threshold_error(tv, Diameter_pre, BaseAmp_pre, DiscAmp_pre, ...
    %                                   df, unique_diams, disc_thresh_exp), ...
    %     DeltaFrac_pre(prefit_depths) ));

    obj_fun_pre = @(tv) compute_threshold_error_mean_across_depths(tv, Diameter_pre, BaseAmp_pre, DiscAmp_pre, DeltaFrac_pre, prefit_depths, unique_diams, disc_thresh_exp);

    tv_grid  = linspace(1e-4, 10, 500);
    sse_grid = arrayfun(obj_fun_pre, tv_grid);
    [~, best_idx] = min(sse_grid);
    tv_init = tv_grid(best_idx);

    options = optimset('Display','iter','TolX',1e-8,'TolFun',1e-10,'MaxIter',5000);
    [tv_shared, fval_shared] = fminsearch(obj_fun_pre, tv_init, options);

    if tv_mode == 0
        fprintf('\n=== Pre-fit Result (Depth 1: %s) ===\n', depth_labels{1});
    else
        fprintf('\n=== Pre-fit Result (Combined across all %d depths) ===\n', num_depths);
    end
    fprintf('  Metric                  : %d - %s\n', metric, metric_title);
    fprintf('  Optimal threshold_value = %.6f\n', tv_shared);
    fprintf('  SSE (mean model vs. mean experiment)            = %.6f\n\n', fval_shared);
    fprintf('  This tv will be applied to ALL depths.\n\n');

else
    tv_shared = NaN;  % not used when tv_mode == 1
end

%% =========================================================================
%  MAIN LOOP OVER ALL DEPTHS
% =========================================================================
for depth_idx = 1:num_depths

    depth_folder = depth_folders{depth_idx};
    fprintf('\n=========================================================\n');
    fprintf('  Processing depth %d / %d : %s\n', depth_idx, num_depths, depth_folder);
    fprintf('=========================================================\n');

    % ------------------------------------------------------------------
    %  Initialize per-depth variables
    % ------------------------------------------------------------------
    Diameter  = zeros(num_files, 1);
    BaseAmp   = zeros(num_files, 1);
    DiscAmp   = zeros(num_files, 1);
    DeltaFrac = zeros(num_files, num_layers);

    % ------------------------------------------------------------------
    %  Inner loop: load data and compute DeltaFrac per layer
    % ------------------------------------------------------------------
    for i = 1:num_files

        file_label = file_labels{i};
        base_path  = [depth_folder 'activation_data_ConvexHull/' file_label];

        % --- Load cell IDs ---
        cellid_1 = load([base_path '_block1_soma_cell_id.dat']);
        cellid_2 = load([base_path '_block2_soma_cell_id.dat']);

        % --- Load spike counts ---
        spike_counts_1 = load([base_path '_block1_soma_spike_counts.dat']);
        spike_counts_2 = load([base_path '_block2_soma_spike_counts.dat']);

        % --- Load activation distances ---
        act_dist_1 = load([base_path '_block1_soma_dist.dat']);
        act_dist_2 = load([base_path '_block2_soma_dist.dat']);

        % --- Sum last/first nbins bins ---
        nbins       = 4;
        onset_shift = 0;
        spike_counts_1 = sum(spike_counts_1(:, end-(nbins-1):end),                2);
        spike_counts_2 = sum(spike_counts_2(:, onset_shift+1:onset_shift+nbins),   2);

        % --- Ensure column vectors ---
        cellid_1   = cellid_1(:);
        cellid_2   = cellid_2(:);
        act_dist_1 = act_dist_1(:);
        act_dist_2 = act_dist_2(:);

        % --- Assign to cortical layers ---
        layer_spike_counts_1 = assign_distances_to_layers(spike_counts_1, cellid_1, cell_cnt);
        layer_spike_counts_2 = assign_distances_to_layers(spike_counts_2, cellid_2, cell_cnt);
        layer_act_dist_1     = assign_distances_to_layers(act_dist_1,     cellid_1, cell_cnt);
        layer_act_dist_2     = assign_distances_to_layers(act_dist_2,     cellid_2, cell_cnt);

        % ---- ALL LAYERS ----
        DeltaFrac(i,1) = compute_metric(metric, spike_counts_1, spike_counts_2, ...
                                        act_dist_1, act_dist_2);

        % ---- INDIVIDUAL LAYERS ----
        for L = 2:num_layers
            layer_name = layers{L};
            counts1    = layer_spike_counts_1.(layer_name);
            counts2    = layer_spike_counts_2.(layer_name);
            dists1     = layer_act_dist_1.(layer_name);
            dists2     = layer_act_dist_2.(layer_name);

            if isempty(counts1) && isempty(counts2)
                DeltaFrac(i,L) = NaN;
            else
                DeltaFrac(i,L) = compute_metric(metric, counts1, counts2, dists1, dists2);
            end
        end

        % ---- Assign metadata ----
        d  = regexp(file_label, 'Dia(\d+)um',         'tokens'); Diameter(i) = str2double(d{1});
        b  = regexp(file_label, 'BaseAmp([\dp]+)uA',  'tokens'); BaseAmp(i)  = str2double(strrep(b{1}{1},'p','.'));
        da = regexp(file_label, 'DiscAmp_([\dp]+)uA', 'tokens'); DiscAmp(i)  = str2double(strrep(da{1}{1},'p','.'));

    end  % end file loop

    % ------------------------------------------------------------------
    %  Fit threshold_value (or reuse pre-fit value)
    % ------------------------------------------------------------------
    if tv_mode == 1
        % Fit independently for this depth
        obj_fun = @(tv) compute_threshold_error(tv, Diameter, BaseAmp, DiscAmp, ...
                            DeltaFrac, unique_diams, disc_thresh_exp);

        tv_grid  = linspace(1e-4, 10, 500);
        sse_grid = arrayfun(obj_fun, tv_grid);
        [~, best_idx] = min(sse_grid);
        tv_init = tv_grid(best_idx);

        options        = optimset('Display','iter','TolX',1e-8,'TolFun',1e-10,'MaxIter',5000);
        [tv_opt, fval] = fminsearch(obj_fun, tv_init, options);

        fprintf('\n=== Fitting Results  [Depth %d: %s] ===\n', depth_idx, depth_labels{depth_idx});
        fprintf('  Metric                  : %d - %s\n', metric, metric_title);
        fprintf('  Optimal threshold_value = %.6f\n', tv_opt);
        fprintf('  Residual SSE            = %.6f\n\n', fval);
    else
        % Reuse shared tv (fitted on Depth 1 alone, or combined across all depths)
        tv_opt = tv_shared;
        obj_fun_tmp = @(tv) compute_threshold_error(tv, Diameter, BaseAmp, DiscAmp, ...
                                DeltaFrac, unique_diams, disc_thresh_exp);
        fval = obj_fun_tmp(tv_opt);

        if tv_mode == 0
            mode_str = 'Applying Depth-1 tv';
        else
            mode_str = 'Applying combined-depths tv';
        end
        fprintf('\n=== %s  [Depth %d: %s] ===\n', mode_str, depth_idx, depth_labels{depth_idx});
        fprintf('  Metric                  : %d - %s\n', metric, metric_title);
        fprintf('  Shared threshold_value  = %.6f\n', tv_opt);
        fprintf('  SSE at this depth       = %.6f\n\n', fval);
    end

    tv_opt_all(depth_idx) = tv_opt;

    % ------------------------------------------------------------------
    %  Compute DiscThreshold with fitted tv_opt for this depth
    % ------------------------------------------------------------------
    DiscThreshold_fitted = compute_disc_threshold(tv_opt, Diameter, BaseAmp, ...
                               DiscAmp, DeltaFrac, unique_diams, num_layers);

    % Store for cumulative plots (L=1 = All, but store all layers)
    DiscThreshold_all_depths(:,:,:,depth_idx) = DiscThreshold_fitted;

    % ------------------------------------------------------------------
    %  Print comparison table
    % ------------------------------------------------------------------
    fprintf('  %-10s %-10s %-14s %-16s\n', 'Diameter','BaseAmp','Exp Thresh', ...
            sprintf('Model (tv=%.4f)', tv_opt));
    fprintf('  %s\n', repmat('-',1,55));
    for d = 1:num_diams
        dia       = unique_diams(d);
        base_vals = sort(unique(BaseAmp(Diameter == dia)));
        for b = 1:length(base_vals)
            if b > size(disc_thresh_exp,2), continue; end
            fprintf('  %-10d %-10.1f %-14.4f %-16.4f\n', ...
                dia, base_vals(b), disc_thresh_exp(d,b), DiscThreshold_fitted(d,b,L_fit));
        end
    end

    % ==================================================================
    %  PER-DEPTH FIGURE: Scatter Model vs Experimental  (All layer)
    % ==================================================================
    fig100_num = 100 + depth_idx;
    figure(fig100_num); clf; hold on;
    set(gcf,'Units','inches','Position',[1 1 6.5 5.5])

    lim_max = 0;
    for d = 1:num_diams
        dia       = unique_diams(d);
        base_vals = sort(unique(BaseAmp(Diameter == dia)));
        for b = 1:min(length(base_vals), size(disc_thresh_exp,2))
            lim_max = max(lim_max, ...
                max(disc_thresh_exp(d,b), DiscThreshold_fitted(d,b,L_fit)));
        end
    end
    lim_max = lim_max * 1.15;

    plot([0 lim_max],[0 lim_max],'k--','LineWidth',1.8,'HandleVisibility','off')

    all_exp    = [];
    all_fitted = [];

    for d = 1:num_diams
        dia       = unique_diams(d);
        base_vals = sort(unique(BaseAmp(Diameter == dia)));
        exp_d = [];  fit_d = [];

        for b = 1:min(length(base_vals), size(disc_thresh_exp,2))
            exp_d(end+1) = disc_thresh_exp(d,b);
            fit_d(end+1) = DiscThreshold_fitted(d,b,L_fit);
            all_exp(end+1)    = disc_thresh_exp(d,b);
            all_fitted(end+1) = DiscThreshold_fitted(d,b,L_fit);
        end

        plot(nan, nan, 'd', 'Color', dia_colors{d}, 'MarkerFaceColor','none', ...
            'MarkerSize',10,'LineWidth',2, ...
            'DisplayName', sprintf('%d \\mum', unique_diams(d)));
        scatter(exp_d, fit_d, 150, dia_colors{d}, 'd', ...
            'LineWidth',2.2,'HandleVisibility','off');
    end

    ss_res = sum((all_exp - all_fitted).^2);
    ss_tot = sum((all_exp - mean(all_exp)).^2);
    r2     = 1 - ss_res / ss_tot;
    rmse   = sqrt(mean((all_exp - all_fitted).^2));

    fprintf('\n=== Final Fit Quality [Depth %d] ===\n', depth_idx);
    fprintf('  R^2  = %.6f\n', r2);
    fprintf('  RMSE = %.6f uA\n', rmse);

    xlabel('Experimental Disc Threshold (\muA)')
    ylabel('Model Disc Threshold (\muA)')
    sgtitle(sprintf('Depth %d: %s  |  %s = %.3f', ...
        depth_idx-1, depth_labels{depth_idx}, metric_title, tv_opt), ...
        'FontSize',15,'FontWeight','bold');
    lgd = legend('Location','southeast','FontSize',15);
    axis equal
    xlim([0 lim_max]);  ylim([0 lim_max]);
    ax = gca; ax.XTick = ax.YTick;
    grid on
    text(0.05*lim_max, 0.92*lim_max, sprintf('R^2 = %.3f',  r2),   'FontSize',15)
    text(0.05*lim_max, 0.84*lim_max, sprintf('RMSE = %.3f \\muA', rmse), 'FontSize',15)

    % ==================================================================
    %  PER-DEPTH FIGURE: Disc Threshold vs Diameter (Layer All)
    % ==================================================================
    fig200_num = 200 + depth_idx;
    figure(fig200_num); clf;
    tiledlayout(1,1,'TileSpacing','compact','Padding','compact');
    nexttile; hold on;

    for b = 1:num_ref
        thresh_curve = NaN(num_diams,1);
        for d = 1:num_diams
            dia       = unique_diams(d);
            base_vals = sort(unique(BaseAmp(Diameter == dia)));
            if length(base_vals) >= b
                thresh_curve(d) = DiscThreshold_fitted(d,b,L_fit);
            end
        end
        plot(unique_diams, thresh_curve, '-o', ...
            'LineWidth',2.2,'MarkerSize',10,'Color',colors{b});
    end

    xlim([0 55])
    xlabel('Contact Diameter (\mum)')
    ylabel('Disc Threshold (\muA)')
    grid on
    lgd = legend(ref_labels,'Orientation','horizontal');
    lgd.Layout.Tile = 'south';
    sgtitle(sprintf('Depth %d: %s  |  %s = %.3f', ...
        depth_idx-1, depth_labels{depth_idx}, metric_title, tv_opt), ...
        'FontSize',15,'FontWeight','bold');

    % ==================================================================
    %  PER-DEPTH FIGURE: Weber Fraction vs Diameter (Layer All)
    % ==================================================================
    fig300_num = 300 + depth_idx;
    figure(fig300_num); clf;
    tiledlayout(1,1,'TileSpacing','compact','Padding','compact');
    nexttile; hold on;

    for b = 1:num_ref
        weber_curve = NaN(num_diams,1);
        for d = 1:num_diams
            dia       = unique_diams(d);
            base_vals = sort(unique(BaseAmp(Diameter == dia)));
            if length(base_vals) >= b
                weber_curve(d) = DiscThreshold_fitted(d,b,L_fit) / base_vals(b);
            end
        end
        plot(unique_diams, weber_curve, '-o', ...
            'LineWidth',2.2,'MarkerSize',10,'Color',colors{b});
    end

    ylim([0 1]);  xlim([0 55])
    xlabel('Contact Diameter (\mum)')
    ylabel('Weber Fraction')
    grid on
    lgd = legend(ref_labels,'Orientation','horizontal');
    lgd.Layout.Tile = 'south';
    sgtitle(sprintf('Depth %d: %s  |  %s = %.3f', ...
        depth_idx-1, depth_labels{depth_idx}, metric_title, tv_opt), ...
        'FontSize',15,'FontWeight','bold');

end  % end depth loop


%% =========================================================================
%  CUMULATIVE PLOT A: Disc Threshold vs Diameter  (mean ± std across depths)
% =========================================================================
% DiscThreshold_all_depths : num_diams x num_ref x num_layers x num_depths
% Use L_fit = 1 (All layers)

figure(400); clf;
tiledlayout(1,1,'TileSpacing','compact','Padding','compact');
nexttile; hold on;

for b = 1:num_ref

    thresh_depths = NaN(num_diams, num_depths);

    for depth_idx = 1:num_depths
        for d = 1:num_diams
            thresh_depths(d, depth_idx) = DiscThreshold_all_depths(d, b, L_fit, depth_idx);
        end
    end

    thresh_mean = mean(thresh_depths, 2, 'omitnan');
    thresh_std  = std( thresh_depths, 0, 2, 'omitnan');

    % Shaded error band
    x_fill = [unique_diams; flipud(unique_diams)];
    y_fill = [(thresh_mean - thresh_std); flipud(thresh_mean + thresh_std)];
    valid  = ~isnan(y_fill);
    if sum(valid) >= 3
        fill(x_fill(valid), y_fill(valid), colors{b}, ...
            'FaceAlpha', 0.18, 'EdgeColor', 'none', 'HandleVisibility','off');
    end

    % Mean line + markers
    plot(unique_diams, thresh_mean, '-o', ...
        'LineWidth', 2.2, 'MarkerSize', 9, 'Color', colors{b}, ...
        'DisplayName', ref_labels{b});

    % Error bars (std)
    errorbar(unique_diams, thresh_mean, thresh_std, ...
        'LineStyle','none','Color',colors{b},'LineWidth',1.8, ...
        'CapSize',8,'HandleVisibility','off');

end

xlim([0 55])
xlabel('Contact Diameter (\mum)')
ylabel('Disc Threshold (\muA)')
grid on
lgd = legend('Orientation','horizontal');
lgd.Layout.Tile = 'south';
% sgtitle(sprintf('Disc Threshold vs Diameter  |  Mean \\pm STD across %d depths\n%s', num_depths, metric_title), 'FontSize',15,'FontWeight','bold');

fprintf('\n=== Cumulative Disc Threshold (Mean ± STD across depths) ===\n');
fprintf('  tv per depth: '); fprintf('%.4f  ', tv_opt_all); fprintf('\n\n');


%% =========================================================================
%  CUMULATIVE PLOT B: Weber Fraction vs Diameter  (mean ± std across depths)
% =========================================================================

% For Weber fraction we need the base amplitude for each (d,b) combination.
Diameter_meta = zeros(num_files,1);
BaseAmp_meta  = zeros(num_files,1);
for i = 1:num_files
    fl = file_labels{i};
    d  = regexp(fl, 'Dia(\d+)um',         'tokens'); Diameter_meta(i) = str2double(d{1});
    b  = regexp(fl, 'BaseAmp([\dp]+)uA',  'tokens'); BaseAmp_meta(i)  = str2double(strrep(b{1}{1},'p','.'));
end

figure(401); clf;
tiledlayout(1,1,'TileSpacing','compact','Padding','compact');
nexttile; hold on;

for b = 1:num_ref

    weber_depths = NaN(num_diams, num_depths);

    for depth_idx = 1:num_depths
        for d = 1:num_diams
            dia       = unique_diams(d);
            base_vals = sort(unique(BaseAmp_meta(Diameter_meta == dia)));
            if length(base_vals) >= b
                base_b = base_vals(b);
                dt     = DiscThreshold_all_depths(d, b, L_fit, depth_idx);
                if ~isnan(dt) && base_b > 0
                    weber_depths(d, depth_idx) = dt / base_b;
                end
            end
        end
    end

    weber_mean = mean(weber_depths, 2, 'omitnan');
    weber_std  = std( weber_depths, 0, 2, 'omitnan');

    % Shaded error band
    x_fill = [unique_diams; flipud(unique_diams)];
    y_fill = [(weber_mean - weber_std); flipud(weber_mean + weber_std)];
    valid  = ~isnan(y_fill);
    if sum(valid) >= 3
        fill(x_fill(valid), y_fill(valid), colors{b}, ...
            'FaceAlpha', 0.18, 'EdgeColor', 'none', 'HandleVisibility','off');
    end

    % Mean line + markers
    plot(unique_diams, weber_mean, '-o', ...
        'LineWidth', 2.2, 'MarkerSize', 9, 'Color', colors{b}, ...
        'DisplayName', ref_labels{b});

    % Error bars (std)
    errorbar(unique_diams, weber_mean, weber_std, ...
        'LineStyle','none','Color',colors{b},'LineWidth',1.8, ...
        'CapSize',8,'HandleVisibility','off');

end

ylim([0 1]);  xlim([0 55])
xlabel('Contact Diameter (\mum)')
ylabel('Weber Fraction')
grid on
lgd = legend('Orientation','horizontal');
lgd.Layout.Tile = 'south';
% sgtitle(sprintf('Weber Fraction vs Diameter  |  Mean \\pm STD across %d depths\n%s', num_depths, metric_title), 'FontSize',15,'FontWeight','bold');


%% =========================================================================
%  CUMULATIVE PLOT C: Scatter Mean Model vs Experimental  (All layer)
% =========================================================================
figure(402); clf;
hold on;
set(gcf,'Units','inches','Position',[1 1 6.5 5.5])

lim_max = 0;
for d = 1:num_diams
    dia       = unique_diams(d);
    base_vals = sort(unique(BaseAmp(Diameter == dia)));
    for b = 1:min(length(base_vals), size(disc_thresh_exp,2))
        lim_max = max(lim_max, ...
            max(disc_thresh_exp(d,b), mean(DiscThreshold_all_depths(d, b, L_fit, :), 4))); 
    end
end
lim_max = lim_max * 1.15;

plot([0 lim_max],[0 lim_max],'k--','LineWidth',1.8,'HandleVisibility','off')

all_exp    = [];
all_fitted = [];

for d = 1:num_diams
    dia       = unique_diams(d);
    base_vals = sort(unique(BaseAmp(Diameter == dia)));
    exp_d = [];  fit_d = [];

    for b = 1:min(length(base_vals), size(disc_thresh_exp,2))
        exp_d(end+1) = disc_thresh_exp(d,b);
        fit_d(end+1) = mean(DiscThreshold_all_depths(d, b, L_fit, :), 4);
        all_exp(end+1)    = disc_thresh_exp(d,b);
        all_fitted(end+1) = mean(DiscThreshold_all_depths(d, b, L_fit, :), 4);
    end

    plot(nan, nan, 'd', 'Color', dia_colors{d}, 'MarkerFaceColor','none', ...
        'MarkerSize',10,'LineWidth',2, ...
        'DisplayName', sprintf('%d \\mum', unique_diams(d)));
    scatter(exp_d, fit_d, 150, dia_colors{d}, 'd', ...
        'LineWidth',2.2,'HandleVisibility','off');
end

ss_res = sum((all_exp - all_fitted).^2);
ss_tot = sum((all_exp - mean(all_exp)).^2);
r2     = 1 - ss_res / ss_tot;
rmse   = sqrt(mean((all_exp - all_fitted).^2));

fprintf('\n=== Final Fit Quality [Depth %d] ===\n', depth_idx);
fprintf('  R^2  = %.6f\n', r2);
fprintf('  RMSE = %.6f uA\n', rmse);

xlabel('Mean Experimental Disc Threshold (\muA)')
ylabel('Mean Model Disc Threshold (\muA)')
sgtitle(sprintf('%s = %.3f', metric_title, tv_opt),'FontSize',15,'FontWeight','bold');
lgd = legend('Location','southeast','FontSize',15);
axis equal
xlim([0 lim_max]);  ylim([0 lim_max]);
ax = gca; ax.XTick = ax.YTick;
grid on
text(0.05*lim_max, 0.92*lim_max, sprintf('R^2 = %.3f',  r2),   'FontSize',15)
text(0.05*lim_max, 0.84*lim_max, sprintf('RMSE = %.3f \\muA', rmse), 'FontSize',15)


%% =========================================================================
%  Save DT Data to Excel Sheet
% =========================================================================
save_DT_excel=0;

if save_DT_excel==1
    filename = sprintf('ModelDT_Metric%d.xlsx', metric);
    
    data = squeeze(DiscThreshold_all_depths(:, :, 1, :));
    num_depths = size(data, 3);
    sheet_labels = {'Depth0(Baseline)', 'Depth1(Down150um)', 'Depth2(Up150um)'};
    
    for k = 1:num_depths
        T = array2table(data(:, :, k), 'VariableNames', ref_labels);
        T = addvars(T, unique_diams, 'Before', 1, 'NewVariableNames', 'Contact Diameter (um)');
        
        % Clean sheet name
        sheet_name = matlab.lang.makeValidName(sheet_labels{k});
        sheet_name = sheet_name(1:min(end,31));
        
        writetable(T, filename, 'Sheet', sheet_name);
    end
end

%% =========================================================================
%  LOCAL FUNCTIONS
% =========================================================================

%% -------------------------------------------------------------------------
%  compute_metric
% -------------------------------------------------------------------------
function val = compute_metric(metric, raw1, raw2, dists1, dists2)

    N1 = length(raw1);
    N2 = length(raw2);
    dN = abs(N2 - N1);

    S1_total = sum(raw1);
    S2_total = sum(raw2);

    if N1 > 0, S1_mean = mean(raw1); else, S1_mean = 0; end
    if N2 > 0, S2_mean = mean(raw2); else, S2_mean = 0; end

    min_dist = 1e-6;
    if ~isempty(dists1) && N1 > 0
        w1       = 1 ./ max(dists1(:), min_dist);
        S1_wmean = sum(raw1(:) .* w1) / sum(w1);
    else
        S1_wmean = S1_mean;
    end
    if ~isempty(dists2) && N2 > 0
        w2       = 1 ./ max(dists2(:), min_dist);
        S2_wmean = sum(raw2(:) .* w2) / sum(w2);
    else
        S2_wmean = S2_mean;
    end

    if ~isempty(dists1) && N1 > 0, D1_mean = mean(dists1(:)); else, D1_mean = NaN; end
    if ~isempty(dists2) && N2 > 0, D2_mean = mean(dists2(:)); else, D2_mean = NaN; end

    switch metric
        case 1
            if N1 > 0,       val = dN / N1;
            else,            val = NaN; end
        case 2
            if S1_total > 0, val = abs(S2_total - S1_total) / S1_total;
            else,            val = NaN; end
        case 3
            if N1 > 0 && S1_total > 0
                val = (dN / N1) * (abs(S2_total - S1_total) / S1_total);
            else,            val = NaN; end
        case 4
            if S1_mean > 0,  val = abs(S2_mean - S1_mean) / S1_mean;
            else,            val = NaN; end
        case 5
            if N1 > 0 && S1_mean > 0
                val = (dN / N1) * (abs(S2_mean - S1_mean) / S1_mean);
            else,            val = NaN; end
        case 6
            if N1 > 0,       val = dN / sqrt(N1);
            else,            val = NaN; end
        case 7
            if S1_mean > 0,  val = abs(S2_mean - S1_mean) / sqrt(S1_mean);
            else,            val = NaN; end
        case 8
            if N1 > 0 && S1_mean > 0
                val = (dN / sqrt(N1)) * (abs(S2_mean - S1_mean) / sqrt(S1_mean));
            else,            val = NaN; end
        case 9
            if N1 > 0 && S1_mean > 0
                val = (dN / N1) * (abs(S2_mean - S1_mean) / sqrt(S1_mean));
            else,            val = NaN; end
        case 10
            if N1 > 0 && S1_wmean > 0
                val = (dN / N1) * (abs(S2_wmean - S1_wmean) / sqrt(S1_wmean));
            else,            val = NaN; end
        case 11
            if N1 > 0 && S1_wmean > 0
                val = (dN / sqrt(N1)) * (abs(S2_wmean - S1_wmean) / sqrt(S1_wmean));
            else,            val = NaN; end
        case 12
            if ~isnan(D1_mean) && D1_mean > 0
                val = abs(D2_mean - D1_mean) / D1_mean;
            else,            val = NaN; end
        case 13
            if N1 > 0 && ~isnan(D1_mean) && D1_mean > 0
                val = (dN / N1) * (abs(D2_mean - D1_mean) / D1_mean);
            else,            val = NaN; end
        case 14
            if S1_total > 0, val = abs(S2_total - S1_total) / sqrt(S1_total);
            else,            val = NaN; end               
        otherwise
            error('Unknown metric value: %d. Choose 1-14.', metric);
    end
end

%% -------------------------------------------------------------------------
%  compute_disc_threshold
% -------------------------------------------------------------------------
function DiscThresh = compute_disc_threshold(threshold_value, Diameter, BaseAmp, ...
                          DiscAmp, DeltaFrac, unique_diams, num_layers)

    num_diams  = length(unique_diams);
    num_ref    = 3;
    DiscThresh = NaN(num_diams, num_ref, num_layers);

    for L = 1:num_layers
        for d = 1:num_diams
            dia       = unique_diams(d);
            idx_dia   = Diameter == dia;
            base_vals = sort(unique(BaseAmp(idx_dia)));

            for b = 1:length(base_vals)
                idx        = idx_dia & BaseAmp == base_vals(b);
                disc_vals  = DiscAmp(idx);
                delta_vals = DeltaFrac(idx, L);

                if length(disc_vals) < 2, continue; end

                [delta_sorted, sort_idx] = sort(delta_vals);
                disc_sorted = disc_vals(sort_idx);

                [delta_sorted, ia] = unique(delta_sorted, 'stable');
                disc_sorted        = disc_sorted(ia);

                DiscThresh(d,b,L) = interp1(delta_sorted, disc_sorted, threshold_value, 'linear', 'extrap');
            end
        end
    end
end

%% -------------------------------------------------------------------------
%  compute_threshold_error
% -------------------------------------------------------------------------
function err = compute_threshold_error(threshold_value, Diameter, BaseAmp, DiscAmp, ...
                   DeltaFrac, unique_diams, disc_thresh_exp)

    num_layers = size(DeltaFrac, 2);
    DiscThresh = compute_disc_threshold(threshold_value, Diameter, BaseAmp, ...
                     DiscAmp, DeltaFrac, unique_diams, num_layers);

    num_diams = length(unique_diams);
    residuals = [];

    for d = 1:num_diams
        dia       = unique_diams(d);
        base_vals = sort(unique(BaseAmp(Diameter == dia)));
        for b = 1:length(base_vals)
            if b > size(disc_thresh_exp,2), continue; end
            exp_val = disc_thresh_exp(d,b);
            fit_val = DiscThresh(d,b,1);   % L=1 (All layers)
            if ~isnan(fit_val) && ~isnan(exp_val)
                residuals(end+1) = fit_val - exp_val; %#ok<AGROW>
            end
        end
    end

    err = sum(residuals .^ 2);
end

% New function for computing error of mean disc thresh across depths
function err = compute_threshold_error_mean_across_depths(threshold_value, Diameter, BaseAmp, DiscAmp, DeltaFrac_pre, prefit_depths, unique_diams, disc_thresh_exp)

    num_depths = length(prefit_depths);
    num_diams  = length(unique_diams);
    num_ref    = size(disc_thresh_exp,2);

    DT_all = NaN(num_diams, num_ref, num_depths); % stores DT for each depth for diameter x reference amplitude

    for k = 1:num_depths
        df = DeltaFrac_pre{prefit_depths(k)};
        DiscThresh = compute_disc_threshold(threshold_value, Diameter, BaseAmp, DiscAmp, df, unique_diams, size(df,2));

        DT_all(:,:,k) = DiscThresh(:,:,1);
    end

    DT_mean = mean(DT_all, 3, 'omitnan'); % average across depths

    residuals = DT_mean - disc_thresh_exp; % compute residual between mean model DT across depths and mean experimental DT across rats 
    err = sum(residuals(~isnan(residuals)).^2); % SSE
end



%% -------------------------------------------------------------------------
%  assign_distances_to_layers
% -------------------------------------------------------------------------
function layer_dists = assign_distances_to_layers(distances, cell_ids, cell_cnt)

    layer_dists = struct('L1',[],'L23',[],'L4',[],'L5',[],'L6',[]);
    cum_cell    = 0;

    for id = 1:25
        start_id = cum_cell + 1;
        end_id   = cum_cell + cell_cnt(id);
        mask     = (cell_ids >= start_id) & (cell_ids <= end_id);
        d        = distances(mask);

        if     id <= 5,  layer_dists.L1  = [layer_dists.L1;  d];
        elseif id <= 10, layer_dists.L23 = [layer_dists.L23; d];
        elseif id <= 15, layer_dists.L4  = [layer_dists.L4;  d];
        elseif id <= 20, layer_dists.L5  = [layer_dists.L5;  d];
        else,            layer_dists.L6  = [layer_dists.L6;  d];
        end

        cum_cell = end_id;
    end
end