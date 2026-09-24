%% =========================================================================
%  Discrimination Threshold Analysis
%  Computes metric per layer, fits threshold_value to experimental data,
%  and plots metric values, disc thresholds, Weber fractions, senitivity

% Figures 1-5: Metric Values vs Disc Amp; each figure considers neural activations from a particular layer
% Figures 11, 12: Model Derived Disc Thresh vs Diameter for different layers
% Figures 100-103: Fit quality, error sensitivity,  disc thresholds, weber fractions determined using activations from all layers
% =========================================================================

clear; clc; close all;

%% -------------------------------------------------------------------------
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

%% =========================================================================
%  METRIC SELECTOR
%  Set 'metric' to one of the following values:
%
%  1 : ΔN/N1                                – fractional change in recruited cell count
%  2 : ΔS/S1                                – fractional change in total spike count
%  3 : (ΔN/N1)×(ΔS/S1)                     – product of recruitment and total spike fractions
%  4 : ΔS_mean/S1_mean                      – fractional change in mean per-cell spike rate
%  5 : (ΔN/N1)×(ΔS_mean/S1_mean)           – product of recruitment and mean rate fraction
%  6 : ΔN/√N1                               – Poisson d′ (recruitment normalised by noise)
%  7 : ΔS_mean/√S1_mean                     – Poisson d′ for mean per-cell spike rate
%  8 : (ΔN/√N1)×(ΔS_mean/√S1_mean)         – Poisson d′ × mean rate Poisson d′
%  9 : (ΔN/N1)×(ΔS_mean/√S1_mean)          – recruitment fraction × mean rate Poisson d′
% 10 : (ΔN/N1)×(ΔS_wmean/√S1_wmean)        – metric 9 with 1/d weighted S_mean
% 11 : (ΔN/√N1)×(ΔS_wmean/√S1_wmean)       – metric 8 with 1/d weighted S_mean
% 12 : |ΔD_mean|/D1_mean                    – fractional change in mean activation distance
% 13 : (ΔN/N1)×(|ΔD_mean|/D1_mean)         – recruitment fraction × distance change fraction
% =========================================================================
metric = 1;

%% -------------------------------------------------------------------------
%  Metric metadata  (label, y-axis string, title string)
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
};

metric_ylabel = metric_info{metric, 2};
metric_title  = metric_info{metric, 3};

%% =========================================================================
num_files = length(file_labels);

%% -------------------------------------------------------------------------
%  Experimental discrimination thresholds
%  Rows = diameters [5, 10, 25, 50] um
%  Cols = BaseAmp   [min, med, max]
% -------------------------------------------------------------------------
disc_thresh_exp = [0.848, 0.978, 1.26;
                   3.149, 4.123, 3.748;
                   3.96,  4.518, 7.318;
                   2.908, 4.78,  5.817];

%% -------------------------------------------------------------------------
%  Load cell counts for layer assignment
% -------------------------------------------------------------------------
load('coord_data/cell_cnt.dat')   % loads variable cell_cnt (25 entries)

%% -------------------------------------------------------------------------
%  Initialize variables
% -------------------------------------------------------------------------
Diameter = zeros(num_files, 1);
BaseAmp  = zeros(num_files, 1);
DiscAmp  = zeros(num_files, 1);

layers     = {'All', 'L23', 'L4', 'L5', 'L6'};  % L1 excluded
num_layers = length(layers);

DeltaFrac = zeros(num_files, num_layers);

%% -------------------------------------------------------------------------
%  Main loop: load data and compute DeltaFrac per layer
% -------------------------------------------------------------------------
for i = 1:num_files

    file_label = file_labels{i};

    % --- Load cell IDs ---
    cellid_1 = load(['activation_data_ConvexHull/' file_label '_block1_soma_cell_id.dat']);
    cellid_2 = load(['activation_data_ConvexHull/' file_label '_block2_soma_cell_id.dat']);

    % --- Load spike counts ---
    spike_counts_1 = load(['activation_data_ConvexHull/' file_label '_block1_soma_spike_counts.dat']);
    spike_counts_2 = load(['activation_data_ConvexHull/' file_label '_block2_soma_spike_counts.dat']);

    % --- Load activation distances ---
    act_dist_1 = load(['activation_data_ConvexHull/' file_label '_block1_soma_dist.dat']);
    act_dist_2 = load(['activation_data_ConvexHull/' file_label '_block2_soma_dist.dat']);

    % --- Sum last/first nbins bins across each trial ---
    nbins       = 4;   % 25 ms bins → 100 ms window
    onset_shift = 0;   % bins after transition onset to start looking
    spike_counts_1 = sum(spike_counts_1(:, end-(nbins-1):end),                      2);
    spike_counts_2 = sum(spike_counts_2(:, onset_shift+1:onset_shift+(nbins)),       2);

    % --- Ensure column vectors ---
    cellid_1   = cellid_1(:);
    cellid_2   = cellid_2(:);
    act_dist_1 = act_dist_1(:);
    act_dist_2 = act_dist_2(:);

    % --- Assign spikes to cortical layers ---
    layer_spike_counts_1 = assign_distances_to_layers(spike_counts_1, cellid_1, cell_cnt);
    layer_spike_counts_2 = assign_distances_to_layers(spike_counts_2, cellid_2, cell_cnt);

    % --- Assign activation distances to cortical layers ---
    layer_act_dist_1 = assign_distances_to_layers(act_dist_1, cellid_1, cell_cnt);
    layer_act_dist_2 = assign_distances_to_layers(act_dist_2, cellid_2, cell_cnt);

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

    % ---- Parse metadata from filename ----
    d  = regexp(file_label, 'Dia(\d+)um',         'tokens'); Diameter(i) = str2double(d{1});
    b  = regexp(file_label, 'BaseAmp([\dp]+)uA',  'tokens'); BaseAmp(i)  = str2double(strrep(b{1}{1}, 'p', '.'));
    da = regexp(file_label, 'DiscAmp_([\dp]+)uA', 'tokens'); DiscAmp(i)  = str2double(strrep(da{1}{1},'p', '.'));

end

unique_diams = unique(Diameter);
num_diams    = length(unique_diams);
num_ref      = 3;

%% =========================================================================
%  FIT threshold_value TO EXPERIMENTAL DATA
% =========================================================================
L_fit = 1;   % fit only against "All" layer

obj_fun = @(tv) compute_threshold_error(tv, Diameter, BaseAmp, DiscAmp, ...
                    DeltaFrac, unique_diams, disc_thresh_exp);

tv_grid  = linspace(1e-4, 2, 1000);
sse_grid = arrayfun(obj_fun, tv_grid);
[~, best_idx] = min(sse_grid);
tv_init = tv_grid(best_idx);

options        = optimset('Display','iter','TolX',1e-8,'TolFun',1e-10,'MaxIter',5000);
[tv_opt, fval] = fminsearch(obj_fun, tv_init, options);

fprintf('\n=== Fitting Results ===\n');
fprintf('Metric                  : %d - %s\n', metric, metric_title);
fprintf('Optimal threshold_value = %.6f\n', tv_opt);
fprintf('Residual SSE            = %.6f\n\n', fval);

%% -------------------------------------------------------------------------
%  Compute DiscThreshold with fitted threshold_value
% -------------------------------------------------------------------------
DiscThreshold_fitted = compute_disc_threshold(tv_opt, Diameter, BaseAmp, ...
                           DiscAmp, DeltaFrac, unique_diams, num_layers);

%% -------------------------------------------------------------------------
%  Print comparison table
% -------------------------------------------------------------------------
fprintf('%-10s %-10s %-14s %-16s\n', 'Diameter','BaseAmp','Exp Thresh', ...
        sprintf('Model (tv=%.4f)', tv_opt));
fprintf('%s\n', repmat('-',1,55));

for d = 1:num_diams
    dia       = unique_diams(d);
    base_vals = sort(unique(BaseAmp(Diameter == dia)));
    for b = 1:length(base_vals)
        if b > size(disc_thresh_exp,2), continue; end
        fprintf('%-10d %-10.1f %-14.4f %-16.4f\n', ...
            dia, base_vals(b), disc_thresh_exp(d,b), DiscThreshold_fitted(d,b,L_fit));
    end
end

%% =========================================================================
%  PLOTS
% =========================================================================

colors     = {[1 0 0], [0 0 1], [0 0.4 0]};
ref_labels = {'Min Ref Amp', 'Med Ref Amp', 'Max Ref Amp'};

% ================= Publication Plot Defaults =================
set(groot,'defaultFigureColor','w')

% Fonts
set(groot,'defaultAxesFontSize',15.5)
set(groot,'defaultAxesLabelFontSizeMultiplier',1.1)
set(groot,'defaultAxesTitleFontSizeMultiplier',1.2)
set(groot,'defaultTextFontSize',16)

% Axes style
set(groot,'defaultAxesLineWidth',1.8)
set(groot,'defaultAxesTickDir','out')
set(groot,'defaultAxesTickLength',[0.02 0.02])
set(groot,'defaultAxesBox','off')

% Lines and markers
set(groot,'defaultLineLineWidth',2)
set(groot,'defaultLineMarkerSize',10)

% Legend
set(groot,'defaultLegendFontSize',17)
set(groot,'defaultLegendBox','off')

% Grid appearance
set(groot,'defaultAxesGridAlpha',0.05)

% Figure size for publication
set(groot,'defaultFigureUnits','inches')
set(groot,'defaultFigurePosition',[1 1 6 5.5])

%% --- Figures 1-5: DeltaFrac vs DiscAmp per layer ---
for L = 1:num_layers
    figure(L); clf;
    set(gcf,'Units','inches','Position',[1 1 8 8])
    tiledlayout(2,2,'TileSpacing','compact','Padding','compact');

    for d = 1:num_diams
        nexttile; hold on;
        dia       = unique_diams(d);
        idx_dia   = Diameter == dia;
        base_vals = sort(unique(BaseAmp(idx_dia)));

        for b = 1:length(base_vals)
            idx = idx_dia & BaseAmp == base_vals(b);
            [disc_sorted, sort_idx] = sort(DiscAmp(idx));
            Delta_sorted = DeltaFrac(idx, L);
            Delta_sorted = Delta_sorted(sort_idx);

            plot(disc_sorted, Delta_sorted, '-o', ...
                'LineWidth', 2.2, 'Color', colors{b});
        end

        yline(tv_opt, 'k--', sprintf('tv=%.3f', tv_opt), 'FontSize',14, ...
              'LineWidth', 2.2, 'LabelVerticalAlignment', 'bottom');

        ylim([0 1]);
        xlabel('Disc Amplitude (\muA)', 'FontSize', 15);
        ylabel(metric_ylabel,           'FontSize', 15);
        title(['Diameter = ' num2str(dia) ' \mum'],'FontSize',15);
        grid on
        ax = gca;
        ax.FontSize = 14;  % tick labels and axis labels
    end

    lgd = legend(ref_labels,'Orientation','horizontal');
    lgd.Layout.Tile = 'south';

    sgtitle(['Layer: ' layers{L} ' - ' metric_title ' vs Disc Amplitude'],'FontSize',17,'FontWeight','bold');
end

%% --- Figure 11: Disc Threshold vs Diameter ---
figure(11); clf;
set(gcf,'Units','inches','Position',[1 1 8 7])
tiledlayout(2,3,'TileSpacing','compact','Padding','compact');

for L = 1:num_layers
    nexttile; hold on;

    for b = 1:num_ref
        thresh_curve = NaN(num_diams,1);

        for d = 1:num_diams
            dia       = unique_diams(d);
            base_vals = sort(unique(BaseAmp(Diameter == dia)));

            if length(base_vals) >= b
                thresh_curve(d) = DiscThreshold_fitted(d, b, L);
            end
        end

        plot(unique_diams, thresh_curve, '-o', ...
            'LineWidth',2.2,'MarkerSize',10,'Color',colors{b});
    end

    xlabel('Contact Diameter (\mum)', 'FontSize', 14);
    ylabel('Disc Threshold (\muA)', 'FontSize', 14);
    title(['Layer: ' layers{L}], 'FontSize', 15);
    grid on
    ax = gca;
    ax.FontSize = 13;  % tick labels and axis labels
end

lgd = legend(ref_labels,'Orientation','horizontal', 'FontSize', 15);
lgd.Layout.Tile = 'south';

sgtitle(sprintf('%s = %.3f',metric_title, tv_opt), 'FontSize', 16, 'FontWeight', 'bold');

%% --- Figure 12: Weber Fraction vs Diameter ---
figure(12); clf;
set(gcf,'Units','inches','Position',[1 1 8 7])
tiledlayout(2,3,'TileSpacing','compact','Padding','compact');

for L = 1:num_layers
    nexttile; hold on;

    for b = 1:num_ref
        weber_curve = NaN(num_diams,1);

        for d = 1:num_diams
            dia       = unique_diams(d);
            base_vals = sort(unique(BaseAmp(Diameter == dia)));

            if length(base_vals) >= b
                weber_curve(d) = DiscThreshold_fitted(d,b,L) / base_vals(b);
            end
        end

        plot(unique_diams, weber_curve, '-o', ...
            'LineWidth',2.2,'MarkerSize',9,'Color',colors{b});
    end

    ylim([0 1])
    xlim([0 55])

    xlabel('Contact Diameter (\mum)', 'FontSize', 14);
    ylabel('Weber Fraction', 'FontSize', 14);
    title(['Layer: ' layers{L}], 'FontSize', 15);
    grid on
    ax = gca;
    ax.FontSize = 13;  % tick labels and axis labels
end

lgd = legend(ref_labels,'Orientation','horizontal', 'FontSize', 15);
lgd.Layout.Tile = 'south';

sgtitle(sprintf('%s = %.3f',metric_title, tv_opt), 'FontSize', 16, 'FontWeight', 'bold');

%% --- Figure 100: Scatter - Model vs Experimental ---
figure(100); clf; hold on;
set(gcf,'Units','inches','Position',[1 1 6.5 5.5])

dia_colors = {[0.49 0.18 0.56],[0.0 0.45 0.70],[0.87 0.49 0.0],[0.47 0.47 0.47]};

lim_max = 0;
for d = 1:num_diams
    dia       = unique_diams(d);
    base_vals = sort(unique(BaseAmp(Diameter == dia)));

    for b = 1:min(length(base_vals), size(disc_thresh_exp,2))
        lim_max = max(lim_max, ...
            max(disc_thresh_exp(d,b),DiscThreshold_fitted(d,b,L_fit)));
    end
end

lim_max = lim_max * 1.15;

plot([0 lim_max],[0 lim_max],'k--','LineWidth',1.8,'HandleVisibility','off')

all_exp = [];
all_fitted = [];

for d = 1:num_diams
    dia       = unique_diams(d);
    base_vals = sort(unique(BaseAmp(Diameter == dia)));

    exp_d = [];
    fit_d = [];

    for b = 1:min(length(base_vals), size(disc_thresh_exp,2))

        exp_d(end+1) = disc_thresh_exp(d,b);
        fit_d(end+1) = DiscThreshold_fitted(d,b,L_fit);

        all_exp(end+1) = disc_thresh_exp(d,b);
        all_fitted(end+1) = DiscThreshold_fitted(d,b,L_fit);

    end

    % Dummy plot for legend (markers scale properly)
    plot(nan, nan, 'd', ...
        'Color',           dia_colors{d}, ...
        'MarkerFaceColor', 'none', ...        % unfilled, like your scatter
        'MarkerSize',      10, ...            % controls legend marker size
        'LineWidth',       2, ...
        'DisplayName',     sprintf('%d \\mum', unique_diams(d)));

    % Real scatter — hidden from legend
    scatter(exp_d, fit_d, 150, dia_colors{d}, 'd', ...
        'LineWidth',        2.2, ...
        'HandleVisibility', 'off');

end

ss_res = sum((all_exp - all_fitted).^2);
ss_tot = sum((all_exp - mean(all_exp)).^2);
r2     = 1 - ss_res / ss_tot;

rmse   = sqrt(mean((all_exp - all_fitted).^2));

fprintf('\n=== Final Fit Quality (All Layer) ===\n');
fprintf('  Metric                  : %d - %s\n', metric, metric_title);
fprintf('  Optimal threshold_value : %.6f\n', tv_opt);
fprintf('  SSE                     : %.6f\n', fval);
fprintf('  RMSE                    : %.6f uA\n', rmse);
fprintf('  R^2                     : %.6f\n\n', r2);

fprintf('  %-10s %-10s %-14s %-14s %-12s\n', ...
    'Diameter','BaseAmp','Exp (uA)','Model (uA)','Error (uA)');
fprintf('  %s\n', repmat('-',1,60));

for d = 1:num_diams
    dia       = unique_diams(d);
    base_vals = sort(unique(BaseAmp(Diameter == dia)));

    for b = 1:min(length(base_vals), size(disc_thresh_exp,2))

        exp_v = disc_thresh_exp(d,b);
        fit_v = DiscThreshold_fitted(d,b,L_fit);

        fprintf('  %-10d %-10.1f %-14.4f %-14.4f %-12.4f\n', ...
            dia, base_vals(b), exp_v, fit_v, fit_v-exp_v);

    end
end

xlabel('Experimental Disc Threshold (\muA)')
ylabel('Model Disc Threshold (\muA)')

title(sprintf('%s = %.3f', ...
    metric_title, tv_opt),'FontSize',16)

lgd = legend('Location','southeast','FontSize',16.5);

axis equal
xlim([0 lim_max])
ylim([0 lim_max])
ax = gca;
ax.XTick = ax.YTick;

grid on

text(0.05*lim_max,0.92*lim_max,sprintf('R^2 = %.3f',r2),'FontSize',15)
text(0.05*lim_max,0.84*lim_max,sprintf('RMSE = %.3f \\muA',rmse),'FontSize',15)

%% --- Figure 101: SSE landscape ---
figure(101); clf;

semilogy(tv_grid, sse_grid,'b-','LineWidth',2.5); hold on
xline(tv_opt,'r--','LineWidth',2.5)

xlabel('Threshold Value')
ylabel('SSE')

title(sprintf('SSE vs Threshold Value  |  %s',metric_title))

legend({'SSE curve',sprintf('Optimum = %.4f',tv_opt)},'Location','best')

grid on

%% --- Figure 102: Disc Threshold vs Diameter - Layer All ---
figure(102); clf;
tiledlayout(1,1,'TileSpacing','compact','Padding','compact');

for L = 1:1

    nexttile; hold on;

    for b = 1:num_ref

        thresh_curve = NaN(num_diams,1);

        for d = 1:num_diams

            dia       = unique_diams(d);
            base_vals = sort(unique(BaseAmp(Diameter == dia)));

            if length(base_vals) >= b
                thresh_curve(d) = DiscThreshold_fitted(d,b,L);
            end
        end

        plot(unique_diams, thresh_curve,'-o', ...
            'LineWidth',2.2,'MarkerSize',10,'Color',colors{b});
    end

    xlim([0 55])

    xlabel('Contact Diameter (\mum)')
    ylabel('Disc Threshold (\muA)')

    %title(['Layer: ' layers{L}])

    grid on
end

lgd = legend(ref_labels,'Orientation','horizontal');
lgd.Layout.Tile = 'south';

sgtitle(sprintf('%s = %.3f', metric_title, tv_opt), 'FontSize',16.5,'FontWeight', 'bold');

%% --- Figure 103: Weber Fraction vs Diameter - Layer All ---
figure(103); clf;
tiledlayout(1,1,'TileSpacing','compact','Padding','compact');

for L = 1:1

    nexttile; hold on;

    for b = 1:num_ref

        weber_curve = NaN(num_diams,1);

        for d = 1:num_diams

            dia       = unique_diams(d);
            base_vals = sort(unique(BaseAmp(Diameter == dia)));

            if length(base_vals) >= b
                weber_curve(d) = DiscThreshold_fitted(d,b,L) / base_vals(b);
            end
        end

        plot(unique_diams,weber_curve,'-o', ...
            'LineWidth',2.2,'MarkerSize',10,'Color',colors{b});
    end

    ylim([0 1])
    xlim([0 55])

    xlabel('Contact Diameter (\mum)')
    ylabel('Weber Fraction')

    %title(['Layer: ' layers{L}])

    grid on
end

lgd = legend(ref_labels,'Orientation','horizontal');
lgd.Layout.Tile = 'south';

sgtitle(sprintf('%s = %.3f', metric_title, tv_opt), 'FontSize',16.5,'FontWeight', 'bold');

%% Experimental Figures

plot_experimental=0;
if plot_experimental==1

    %--- Figure 200: Disc Threshold vs Diameter ---
    figure(200); clf;
    tiledlayout(1,1,'TileSpacing','compact','Padding','compact');
    
    for L = 1:1
    
        nexttile; hold on;
    
        for b = 1:num_ref
    
            thresh_curve = NaN(num_diams,1);
    
            for d = 1:num_diams
    
                dia       = unique_diams(d);
                base_vals = sort(unique(BaseAmp(Diameter == dia)));
    
                if length(base_vals) >= b
                    thresh_curve(d) = disc_thresh_exp(d,b);
                end
            end
    
            plot(unique_diams, thresh_curve,'-o', ...
                'LineWidth',2.2,'MarkerSize',10,'Color',colors{b});
        end
    
        xlim([0 55])
    
        xlabel('Contact Diameter (\mum)')
        ylabel('Disc Threshold (\muA)')
    
        %title(['Layer: ' layers{L}])
    
        grid on
    end
    
    lgd = legend(ref_labels,'Orientation','horizontal');
    lgd.Layout.Tile = 'south';
    
    sgtitle('Experimental Data', 'FontSize',16.5,'FontWeight', 'bold');
    
    % --- Figure 201: Weber Fraction vs Diameter ---
    figure(201); clf;
    tiledlayout(1,1,'TileSpacing','compact','Padding','compact');
    
    for L = 1:1
    
        nexttile; hold on;
    
        for b = 1:num_ref
    
            weber_curve = NaN(num_diams,1);
    
            for d = 1:num_diams
    
                dia       = unique_diams(d);
                base_vals = sort(unique(BaseAmp(Diameter == dia)));
    
                if length(base_vals) >= b
                    weber_curve(d) = disc_thresh_exp(d,b) / base_vals(b);
                end
            end
    
            plot(unique_diams,weber_curve,'-o', ...
                'LineWidth',2.2,'MarkerSize',10,'Color',colors{b});
        end
    
        ylim([0 1])
        xlim([0 55])
    
        xlabel('Contact Diameter (\mum)')
        ylabel('Weber Fraction')
    
        %title(['Layer: ' layers{L}])
    
        grid on
    end
    
    lgd = legend(ref_labels,'Orientation','horizontal');
    lgd.Layout.Tile = 'south';
    
    sgtitle('Experimental Data', 'FontSize',16.5,'FontWeight', 'bold');
    
end
%% =========================================================================
%  LOCAL FUNCTIONS
% =========================================================================

%% -------------------------------------------------------------------------
%  compute_metric
%
%  raw1/raw2   : spike counts per activated neuron (unpadded)
%  dists1/dists2 : soma-to-electrode distances, same order as raw1/raw2
%
%  For metrics that don't use distance, dists1/dists2 can be empty.
% -------------------------------------------------------------------------
function val = compute_metric(metric, raw1, raw2, dists1, dists2)

    % --- Basic quantities ---
    N1 = length(raw1);
    N2 = length(raw2);
    dN = abs(N2 - N1);

    S1_total = sum(raw1);
    S2_total = sum(raw2);

    if N1 > 0, S1_mean = mean(raw1); else, S1_mean = 0; end
    if N2 > 0, S2_mean = mean(raw2); else, S2_mean = 0; end

    % --- 1/d weighted mean spike rate ---
    % Guard against zero distances (electrode at soma) by clamping min dist
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

    % --- Mean activation distance ---
    if ~isempty(dists1) && N1 > 0, D1_mean = mean(dists1(:)); else, D1_mean = NaN; end
    if ~isempty(dists2) && N2 > 0, D2_mean = mean(dists2(:)); else, D2_mean = NaN; end

    switch metric
        case 1  % ΔN/N1
            if N1 > 0,       val = dN / N1;
            else,            val = NaN; end

        case 2  % ΔS_total/S1_total
            if S1_total > 0, val = abs(S2_total - S1_total) / S1_total;
            else,            val = NaN; end

        case 3  % (ΔN/N1) × (ΔS_total/S1_total)
            if N1 > 0 && S1_total > 0
                val = (dN / N1) * (abs(S2_total - S1_total) / S1_total);
            else,            val = NaN; end

        case 4  % ΔS_mean/S1_mean
            if S1_mean > 0,  val = abs(S2_mean - S1_mean) / S1_mean;
            else,            val = NaN; end

        case 5  % (ΔN/N1) × (ΔS_mean/S1_mean)
            if N1 > 0 && S1_mean > 0
                val = (dN / N1) * (abs(S2_mean - S1_mean) / S1_mean);
            else,            val = NaN; end

        case 6  % ΔN/√N1
            if N1 > 0,       val = dN / sqrt(N1);
            else,            val = NaN; end

        case 7  % ΔS_mean/√S1_mean
            if S1_mean > 0,  val = abs(S2_mean - S1_mean) / sqrt(S1_mean);
            else,            val = NaN; end

        case 8  % (ΔN/√N1) × (ΔS_mean/√S1_mean)
            if N1 > 0 && S1_mean > 0
                val = (dN / sqrt(N1)) * (abs(S2_mean - S1_mean) / sqrt(S1_mean));
            else,            val = NaN; end

        case 9  % (ΔN/N1) × (ΔS_mean/√S1_mean)
            if N1 > 0 && S1_mean > 0
                val = (dN / N1) * (abs(S2_mean - S1_mean) / sqrt(S1_mean));
            else,            val = NaN; end

        case 10  % (ΔN/N1) × (ΔS_wmean/√S1_wmean)   [1/d weighted S_mean]
            if N1 > 0 && S1_wmean > 0
                val = (dN / N1) * (abs(S2_wmean - S1_wmean) / sqrt(S1_wmean));
            else,            val = NaN; end

        case 11  % (ΔN/√N1) × (ΔS_wmean/√S1_wmean)  [1/d weighted S_mean]
            if N1 > 0 && S1_wmean > 0
                val = (dN / sqrt(N1)) * (abs(S2_wmean - S1_wmean) / sqrt(S1_wmean));
            else,            val = NaN; end

        case 12  % |ΔD_mean|/D1_mean
            if ~isnan(D1_mean) && D1_mean > 0
                val = abs(D2_mean - D1_mean) / D1_mean;
            else,            val = NaN; end

        case 13  % (ΔN/N1) × (|ΔD_mean|/D1_mean)
            if N1 > 0 && ~isnan(D1_mean) && D1_mean > 0
                val = (dN / N1) * (abs(D2_mean - D1_mean) / D1_mean);
            else,            val = NaN; end

        otherwise
            error('Unknown metric value: %d. Choose 1-13.', metric);
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
            fit_val = DiscThresh(d,b,1);   % always L=1 (All layers)
            if ~isnan(fit_val) && ~isnan(exp_val)
                residuals(end+1) = fit_val - exp_val; %#ok<AGROW>
            end
        end
    end

    err = sum(residuals .^ 2);
end

%% -------------------------------------------------------------------------
%  assign_distances_to_layers
% -------------------------------------------------------------------------
function layer_dists = assign_distances_to_layers(distances, cell_ids, cell_cnt)

    layer_dists = struct('L1',[],'L23',[],'L4',[],'L5',[],'L6',[]);
    cum_cell = 0;

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