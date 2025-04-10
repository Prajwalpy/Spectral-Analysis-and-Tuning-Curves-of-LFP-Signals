clc;
clear;
close all;

%% Load Data
load("LIPdata.mat");

%% Parameters
params.tapers   = [5 9];        
params.pad      = 2;            
params.Fs       = Fs;           
params.fpass    = [0 150];      
params.trialave = 1;            
params.err      = 0;            

movingwin = [0.250 0.025];      
win       = [1 2];          
pre_trigger_time = 0.5;         

% Tuning curve region parameters
t_start = -0.2;         % Start time for tuning region [s]
t_end   = 0.2;          % End time for tuning region [s]
f_low   = 40;           % Lower frequency bound [Hz]
f_high  = 100;          % Upper frequency bound [Hz]

%% Figure Setup
figure('Position', [100, 100, 1000, 800]);
avg_power = zeros(1, 8);  

% Define subplot mapping 
subplot_map = containers.Map([8, 1, 2, 7, 3, 6, 5, 4], [1, 2, 3, 4, 6, 7, 8, 9]);

%% Plot Each Target
for target_num = 1:8
    target_idx = target_num - 1;
    idx = targets == target_idx;
    E = targon(idx);
    [Slfp, tlfp_orig, flfp] = mtspecgramtrigc(dlfp(:,1), E, win, movingwin, params);
    
    % Adjust time axis relative to trigger
    tlfp = tlfp_orig - pre_trigger_time;
    
    % Subplot position the target
    subplot(3, 3, subplot_map(target_num));
    imagesc(tlfp, flfp, 10*log10(Slfp)');  
    axis xy;
    caxis([-45 -30]);
    ylim(params.fpass);
    xlim([tlfp(1) tlfp(end)]);
    title(['Target ' num2str(target_num)]);
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    ylabel(colorbar, 'Power (dB)');
    
    % Defining tuning region using logical indexing on the adjusted time and frequency axes
    time_mask = (tlfp >= t_start) & (tlfp <= t_end);
    freq_mask = (flfp >= f_low) & (flfp <= f_high);
    if any(time_mask) && any(freq_mask)
        t_min = min(tlfp(time_mask));
        t_max = max(tlfp(time_mask));
        f_min = min(flfp(freq_mask));
        f_max = max(flfp(freq_mask));
        rectangle('Position', [t_min, f_min, t_max-t_min, f_max-f_min],'EdgeColor', 'r', 'LineStyle', ':', 'LineWidth', 2);
    end
    
    % Computing average power within the tuning region using the original time axis
    t_start_calc = t_start + pre_trigger_time;
    t_end_calc   = t_end + pre_trigger_time;
    time_mask_calc = (tlfp_orig >= t_start_calc) & (tlfp_orig <= t_end_calc);
    freq_mask_calc = (flfp >= f_low) & (flfp <= f_high);
    avg_power(target_num) = mean(Slfp(time_mask_calc, freq_mask_calc), 'all');
end

%% Plot Tuning Curve 
subplot(3, 3, 5);
power_scale_factor = 1e5;
tuning_value = avg_power * power_scale_factor;
plot(1:8, tuning_value, 'ko:', 'LineWidth', 1.5, 'MarkerFaceColor', 'k', 'MarkerSize', 6);
hold on;
plot(1:8, tuning_value, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 6);
hold off;
xlabel('Target Number');
ylabel('Mean Power of LFP');
title('Tuning Curve');
xticks(1:8);
xlim([0.5 8.5]);
grid on;

% Add scaling factor annotation
yl = ylim;
xl = xlim;
text(xl(1)-0.1*diff(xl), yl(2), '\times10^{-5}', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', 'FontSize', 10);

%% Overall Figure Title
sgtitle('Spectrograms of LFP during reaching', 'FontSize', 14, 'FontWeight', 'bold');
