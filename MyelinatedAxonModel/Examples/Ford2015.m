function Ford2015()
% Replicate the values and figures from:
%   Ford M.C., Alexandrova O., Cossell L., Stange-Marten A., Sinclair J.,
%   Kopp-Scheinpflug C., Pecka M., Attwell D., Grothe B. (2015)
%   'Tuning of Ranvier node and internode properties in myelinated axons to
%   adjust action potential timing.' Nat. Comm. 6: 8073
%
%   Will likely take several hours to run all the simulations.


% Which parts of manuscript to replicate.
replicateCVValues =             true;
replicateFigure5 =              true;
replicateGBClatCalyxValues =    true;
replicateFigure6AGBClat =       true;
replicateFigure6AGBCmed =       true;
replicateFigure6BGBClat =       true;
replicateFigure6BGBCmed =       true;



if replicateCVValues
    
    fprintf('---------------------------------------------------------\n');
    fprintf('------------- FORD ET AL. 2015 CV VALUES ----------------\n\n');
    
    % Directory of this file
    thisDirectory = fileparts(mfilename('fullpath'));
    
    % Choose a location to save simulation results.
    saveDirectory = fullfile(thisDirectory, 'Ford2015Results');
    if ~isdir(saveDirectory)
        mkdir(saveDirectory)
    end
    
    % GBClat simulations.
    axon = Ford2015GBClat();
    fprintf('Running model 1/4, GBClat\n')
    [mp, il, t] = Model(axon, fullfile(saveDirectory, 'Ford2015GBClatCV.mat'), false);
    [velGBClat, rorGBClat, apAmpGBClat, apHalfWidthGBClat] = APWaveformProperties(mp, il, t, axon.elec.pas.vrest.value, [71, 90]);
    
    % GBCmed simulations.
    axon = Ford2015GBCmed();
    fprintf('Running model 2/4, GBCmed\n')
    [mp, il, t] = Model(axon, fullfile(saveDirectory, 'Ford2015GBCmedCV.mat'), false);
    [velGBCmed, rorGBCmed, apAmpGBCmed, apHalfWidthGBCmed] = APWaveformProperties(mp, il, t, axon.elec.pas.vrest.value, [71, 90]);
    
    % SBC simulations.
    axon = Ford2015SBC();
    fprintf('Running model 3/4, SBC\n')
    [mp, il, t] = Model(axon, fullfile(saveDirectory, 'Ford2015SBCCV.mat'), false);
    velSBC = velocities(mp, il, t(2)-t(1), [71, 90]);
    
    % GBClat with longer internode (match GBCmed)
    axon = Ford2015GBClat();
    axon = UpdateInternodeLength(axon, (99.6 * 3.0622) - axon.node.geo.length.value.ref);
    fprintf('Running model 4/4, GBClat (long internode)\n')
    [mp, il, t] = Model(axon, fullfile(saveDirectory, 'Ford2015SBCCV.mat'), false);
    [velGBCLong, rorGBCLong, apAmpGBCLong, apHalfWidthGBCLong] = APWaveformProperties(mp, il, t, axon.elec.pas.vrest.value, [71, 90]);
    
    % Print the results.
    fprintf('\n\nCV RESULTS\n')
    fprintf('----------\n\n')
    fprintf('GBClat CV:         %.2f m/s\n', velGBClat);
    fprintf('GBCmed CV:         %.2f m/s\n', velGBCmed);
    fprintf('SBC CV:            %.2f m/s\n', velSBC);
    fprintf('GBClat (99.6 L/d): %.2f m/s\n', velGBCLong);
    
    fprintf('\n\nAP waveform:\n')
    fprintf(' GBClat\n')
    fprintf('   Rate-of-rise:   %.0f V/s\n', rorGBClat)
    fprintf('   Half width:     %.2f ms\n', apHalfWidthGBClat)
    fprintf('   Amplitude:      %.0f mV\n', apAmpGBClat)
    fprintf(' GBCmed\n')
    fprintf('   Rate-of-rise:   %.0f V/s\n', rorGBCmed)
    fprintf('   Half width:     %.2f ms\n', apHalfWidthGBCmed)
    fprintf('   Amplitude:      %.1f mV\n', apAmpGBCmed)
    fprintf(' GBClat (99.6 L/d)\n')
    fprintf('   Rate-of-rise:   %.0f V/s\n', rorGBCLong)
    fprintf('   Half width:     %.2f ms\n', apHalfWidthGBCLong)
    fprintf('   Amplitude:      %.1f mV\n', apAmpGBCLong)
end


% Run this at a finer temporal resolution to get smoother plots (dt = 0.1us
% resolution) (though that will take about 10 times longer)
if replicateFigure5
    
    fprintf('\n\n---------------------------------------------------------\n');
    fprintf('------------- FORD ET AL. 2015 FIGURE 5 -----------------\n\n');
    
    fprintf('Time remaining is only for models for figure 5\n');
    
    % Vary length/inner diameter ratio from 1 to 150.
    LdRatio                     = 1:150;
    
    % Variables to monitor progress of the simulations
    t1                          = tic;
    nSimulationsDone            = 0;
    
    % Initialize storage vectors
    cvGBClat                    = nan(1, length(LdRatio));
    cvGBCmed                    = nan(1, length(LdRatio));
    cvSBC                       = nan(1, length(LdRatio));
    rorGBClat                   = nan(1, length(LdRatio));
    rorGBCmed                   = nan(1, length(LdRatio));
    rorSBC                      = nan(1, length(LdRatio));
    apAmpGBClat                 = nan(1, length(LdRatio));
    apAmpGBCmed                 = nan(1, length(LdRatio));
    apAmpSBC                    = nan(1, length(LdRatio));
    apHalfWidthGBClat           = nan(1, length(LdRatio));
    apHalfWidthGBCmed           = nan(1, length(LdRatio));
    apHalfWidthSBC              = nan(1, length(LdRatio));
    
    
    % GBClat simulations.
    axon                        = Ford2015GBClat();
    
    for ldIdx = 1 : length(LdRatio)
        
        nSimulationsDone = nSimulationsDone + 1;
        fprintf('Figure 5, GBClat, (L/d ratio=%i): Running model %i/%i...', LdRatio(ldIdx), nSimulationsDone, 3*length(LdRatio))
        
        axon = UpdateInternodeLength(axon, (LdRatio(ldIdx) * 3.0622) - axon.node.geo.length.value.ref);
        [mp, il, t] = Model(axon, [], false);
        [cvGBClat(ldIdx), rorGBClat(ldIdx), apAmpGBClat(ldIdx), apHalfWidthGBClat(ldIdx)] = ...
            APWaveformProperties(mp, il, t, axon.elec.pas.vrest.value, [71, 90]);
        
        fprintf('~%.f min remaining\n', (toc(t1)/nSimulationsDone/60) * (3 * length(LdRatio) - nSimulationsDone));
    end
    
    
    % GBCmed simulations.
    axon = Ford2015GBCmed();
    
    for ldIdx = 1 : length(LdRatio)
        
        nSimulationsDone = nSimulationsDone + 1;
        fprintf('Figure 5, GBCmed, (L/d ratio=%i): Running model %i/%i...', LdRatio(ldIdx), nSimulationsDone, 3*length(LdRatio))
        
        axon = UpdateInternodeLength(axon, (LdRatio(ldIdx) * 2.4055) - axon.node.geo.length.value.ref);
        [mp, il, t] = Model(axon, [], false);
        [cvGBCmed(ldIdx), rorGBCmed(ldIdx), apAmpGBCmed(ldIdx), apHalfWidthGBCmed(ldIdx)] = ...
            APWaveformProperties(mp, il, t, axon.elec.pas.vrest.value, [71, 90]);
        
        fprintf('~%.f min remaining\n', (toc(t1)/nSimulationsDone/60) * (3 * length(LdRatio) - nSimulationsDone));
    end
    
    % SBC simulations.
    axon = Ford2015SBC();
    
    for ldIdx = 1 : length(LdRatio)
        
        nSimulationsDone = nSimulationsDone + 1;
        fprintf('Figure 5, SBC, (L/d ratio=%i): Running model %i/%i...', LdRatio(ldIdx), nSimulationsDone, 3*length(LdRatio))
        
        axon = UpdateInternodeLength(axon, (LdRatio(ldIdx) * 1.35) - axon.node.geo.length.value.ref);
        [mp, il, t] = Model(axon, [], false);
        [cvSBC(ldIdx), rorSBC(ldIdx), apAmpSBC(ldIdx), apHalfWidthSBC(ldIdx)] = ...
            APWaveformProperties(mp, il, t, axon.elec.pas.vrest.value, [71, 90]);
        
        fprintf('~%.f min remaining\n', (toc(t1)/nSimulationsDone/60) * (3 * length(LdRatio) - nSimulationsDone));
    end
    
    
    % Figure5A
    figure, hold on
    plot(LdRatio, cvGBClat, 'b', 'LineWidth', 3)
    plot(LdRatio, cvGBCmed, 'Color', [135, 206, 250]/255, 'LineWidth', 3)
    plot(LdRatio, cvSBC, 'r', 'LineWidth', 3)
    set(gca, 'XLim', [0, 150], 'XTick', 0:25:150, ...
        'YLim', [0, 14], 'YTick', 0:2:14)
    axis square, box off
    xlabel('L/d ratio')
    ylabel('CV (ms^{-1})')
    
    
    % Figure5B
    figure, hold on
    plot(LdRatio, rorGBClat, 'b', 'LineWidth', 3)
    plot(LdRatio, rorGBCmed, 'Color', [135, 206, 250]/255, 'LineWidth', 3)
    set(gca, 'XLim', [0, 150], 'XTick', 0:25:150, ...
        'YLim', [0, 5000], 'YTick', 0:1000:5000)
    axis square, box off
    xlabel('L/d ratio')
    ylabel('Max rate-of-rise (V/s)')
    
    
    % Figure5C
    figure, hold on
    plot(LdRatio, 1e3*apHalfWidthGBClat, 'b', 'LineWidth', 3)
    plot(LdRatio, 1e3*apHalfWidthGBCmed, 'Color', [135, 206, 250]/255, 'LineWidth', 3)
    set(gca, 'XLim', [0, 150], 'XTick', 0:25:150, ...
        'YLim', [250, 550], 'YTick', 250:50:550)
    axis square, box off
    xlabel('L/d ratio')
    ylabel('AP half-width (\mus)')
    
    
    % Figure5D
    figure, hold on
    plot(LdRatio, apAmpGBClat, 'b', 'LineWidth', 3)
    plot(LdRatio, apAmpGBCmed, 'Color', [135, 206, 250]/255, 'LineWidth', 3)
    set(gca, 'XLim', [0, 150], 'XTick', 0:25:150, ...
        'YLim', [70, 130], 'YTick', 70:10:130)
    axis square, box off
    xlabel('L/d ratio')
    ylabel('AP amplitude (mV)')
end





if replicateGBClatCalyxValues || replicateFigure6AGBClat
    
    fprintf('\n---------------------------------------------------------\n');
    fprintf('----------- FORD ET AL. 2015 FIGURE 6A GBClat -----------\n\n');
    
    % GBClat axon with calyx at terminal
    axon                                        = Ford2015GBClatWithCalyx();
    
    % Gradation parameters at the terminal of the axon.
    terminalInternodeLengths                    = [166.0016, 148.5450, 128.4624, 101.4536, 70.6526, 53.4710] - axon.node.geo.length.value.ref;
    terminalInternodeDiameters                  = [3.2179, 3.2798, 3.1704, 3.3415, 3.6218, 3.4373];
    terminalNodeDiameters                       = [1.8780, 2.1779, 1.9549, 2.2634, 2.1907, 2.2286];
    
    % Run model without gradations first.
    [mpNotGraded, ~, t]                         = Model(axon, [], false);
    ampGBClatNotGraded                          = max(mpNotGraded(:, end)) - axon.elec.pas.vrest.value;
    rorGBClatNotGraded                          = max(diff(mpNotGraded(:, end)))/(t(2)-t(1));
    
    % Include gradation of internode length.
    axon                                        = UpdateInternodeLength(axon, terminalInternodeLengths, 45:50);
    [mpILGraded, ~, t]                          = Model(axon, [], false);
    ampGBClatILGraded                           = max(mpILGraded(:, end)) - axon.elec.pas.vrest.value;
    rorGBClatILGraded                           = max(diff(mpILGraded(:, end)))/(t(2)-t(1));
    
    % Reset the axon, and include gradation of internode diameter.
    axon                                        = Ford2015GBClatWithCalyx();
    axon                                        = UpdateInternodeSegmentDiameter(axon, terminalInternodeDiameters, 45:50);
    axon.myel.geo.numlamellae.value.vec(:)      = 31;
    mpIDGraded                                  = Model(axon, [], false);
    
    % Reset the axon and include gradations of nodes.
    axon                                        = Ford2015GBClatWithCalyx();
    axon.node.seg.geo.diam.value.vec(45:50, :)  = repmat(terminalNodeDiameters', 1, axon.geo.nnodeseg);
    mpNDGraded                                  = Model(axon, [], false);
    
    % Reset the axon and include all gradations.
    axon                                        = Ford2015GBClatWithCalyx();
    axon                                        = UpdateInternodeLength(axon, terminalInternodeLengths, 45:50);
    axon                                        = UpdateInternodeSegmentDiameter(axon, terminalInternodeDiameters, 45:50);
    axon.myel.geo.numlamellae.value.vec(:)      = 31;
    axon.node.seg.geo.diam.value.vec(45:50, :)  = repmat(terminalNodeDiameters', 1, axon.geo.nnodeseg);
    [mpAllGraded, ~, t]                         = Model(axon, [], false);
    ampGBClatAllGraded                          = max(mpAllGraded(:, end)) - axon.elec.pas.vrest.value;
    rorGBClatAllGraded                          = max(diff(mpAllGraded(:, end)))/(t(2)-t(1));
    
    
    fprintf('GBClat calyx:\n');
    fprintf('  No gradations:\n');
    fprintf('     AP amplitude:      %.1f mV\n', ampGBClatNotGraded)
    fprintf('     AP rate-of-rise:   %.1f mV\n', rorGBClatNotGraded)
    fprintf('  Internode length gradations:\n');
    fprintf('     AP amplitude:      %.1f mV\n', ampGBClatILGraded)
    fprintf('     AP rate-of-rise:   %.1f mV\n', rorGBClatILGraded)
    fprintf('  All gradations:\n');
    fprintf('     AP amplitude:      %.1f mV\n', ampGBClatAllGraded)
    fprintf('     AP rate-of-rise:   %.1f mV\n', rorGBClatAllGraded)
    
    % Waveforms need to be shifted to account for different length axons
    difference_in_length                        = sum(6 * (axon.intn.geo.length.value.vec(44)+axon.node.geo.length.value.ref)) - ...
                                                    sum(terminalInternodeLengths + axon.node.geo.length.value.ref);
    time_taken_in_short_nodes                   = difference_in_length / (velGBClat*1e3); %ms
    time_steps                                  = round(time_taken_in_short_nodes/(t(2)-t(1)));
    
    
    % Figure 6A, GBClat
    figure, hold on
    tVec = (0:size(mpNotGraded, 1)-time_steps-1)*(t(2)-t(1));
    plot(tVec, mpNotGraded(time_steps+1:end, end), 'Color', 'b', 'LineWidth', 3)
    plot(tVec, mpNDGraded(time_steps+1:end, end), 'Color', [0, 128, 0]/255, 'LineWidth', 3)
    plot(tVec, mpIDGraded(time_steps+1:end, end), 'Color', 'r', 'LineWidth', 3)
    plot(tVec, mpILGraded(1:end-time_steps, end), 'Color', [135, 206, 250]/255, 'LineWidth', 3)
    plot(tVec, mpAllGraded(1:end-time_steps, end), 'Color', 'm', 'LineWidth', 3)
    set(gca, 'XLim', [0.7, 4], 'XTick', 1:4, 'YLim', [-80, -20], 'YTick', -80:10:-20);
    axis square, box off
    xlabel('Time, ms')
    ylabel('Voltage, mV')
    title('Figure 6A, GBClat')
    legend({'No gradation', 'Node diameter', 'Internode diameter', 'Internode length', 'All graded'})
    axis square
end






if replicateFigure6AGBCmed
    
    fprintf('\n---------------------------------------------------------\n');
    fprintf('----------- FORD ET AL. 2015 FIGURE 6A GBCmed -----------\n\n');
    
    %  GBCmed axon with calyx at terminal
    axon                                        = Ford2015GBCmedWithCalyx();
    
    % Gradation parameters at the terminal of the axon.
    terminalInternodeLengths                    = [221.1572, 174.7356, 149.5174, 102.3925, 73.7239, 36.8896] - axon.node.geo.length.value.ref;
    terminalInternodeDiameters                  = [2.53, 2.1944, 2.3781, 2.3069, 2.4736, 2.3756];
    terminalNodeDiameters                       = [1.5212, 1.6132, 1.3883, 1.5727, 1.6631, 1.9450];
    
    % Run model without gradations first.
    [mpNotGraded, ~, t]                         = Model(axon, [], false);
    
    % Include gradation of internode length.
    axon                                        = UpdateInternodeLength(axon, terminalInternodeLengths, 45:50);
    mpILGraded                                  = Model(axon, [], false);
    
    % Reset the axon, and include gradation of internode diameter.
    axon                                        = Ford2015GBCmedWithCalyx();
    axon                                        = UpdateInternodeSegmentDiameter(axon, terminalInternodeDiameters, 45:50);
    axon.myel.geo.numlamellae.value.vec(:)      = 26;
    mpIDGraded                                  = Model(axon, [], false);
    
    % Reset the axon and include gradations of nodes.
    axon                                        = Ford2015GBCmedWithCalyx();
    axon.node.seg.geo.diam.value.vec(45:50, :)  = repmat(terminalNodeDiameters', 1, axon.geo.nnodeseg);
    mpNDGraded                                  = Model(axon, [], false);
    
    % Reset the axon and include all gradations.
    axon                                        = Ford2015GBCmedWithCalyx();
    axon                                        = UpdateInternodeLength(axon, terminalInternodeLengths, 45:50);
    axon                                        = UpdateInternodeSegmentDiameter(axon, terminalInternodeDiameters, 45:50);
    axon.myel.geo.numlamellae.value.vec(:)      = 26;
    axon.node.seg.geo.diam.value.vec(45:50, :)  = repmat(terminalNodeDiameters', 1, axon.geo.nnodeseg);
    [mpAllGraded, ~, t]                         = Model(axon, [], false);
    
     % Waveforms need to be shifted to account for different length axons
    difference_in_length                        = sum(6 * (axon.intn.geo.length.value.vec(44)+axon.node.geo.length.value.ref)) - ...
                                                    sum(terminalInternodeLengths + axon.node.geo.length.value.ref);
    time_taken_in_short_nodes                   = difference_in_length / (velGBCmed*1e3); %ms
    time_steps                                  = round(time_taken_in_short_nodes/(t(2)-t(1)));
    
    % Figure 6A, GBCmed
    figure, hold on
    tVec = (0:size(mpNotGraded, 1)-time_steps-1)*(t(2)-t(1));
    plot(tVec, mpNotGraded(time_steps+1:end, end), 'Color', 'b', 'LineWidth', 3)
    plot(tVec, mpNDGraded(time_steps+1:end, end), 'Color', [0, 128, 0]/255, 'LineWidth', 3)
    plot(tVec, mpIDGraded(time_steps+1:end, end), 'Color', 'r', 'LineWidth', 3)
    plot(tVec, mpILGraded(1:end-time_steps, end), 'Color', [135, 206, 250]/255, 'LineWidth', 3)
    plot(tVec, mpAllGraded(1:end-time_steps, end), 'Color', 'm', 'LineWidth', 3)
    set(gca, 'XLim', [0.7, 4], 'XTick', 1:4, 'YLim', [-80, -20], 'YTick', -80:10:-20);
    axis square, box off
    xlabel('Time, ms')
    ylabel('Voltage, mV')
    title('Figure 6A, GBCmed')
    legend({'No gradation', 'Node diameter', 'Internode diameter', 'Internode length', 'All graded'})
    axis square
end




if replicateFigure6BGBClat
    
    
    fprintf('\n---------------------------------------------------------\n');
    fprintf('----------- FORD ET AL. 2015 FIGURE 6B GBClat -----------\n\n');
    
    fprintf('Time remaining is for models for figure 6B, GBClat only\n');
    
    axon                                            = Ford2015GBClatWithCalyx();
    calyxDiameters                                  = 0.1:0.2:15;
    
    % Gradation parameters at the terminal of the axon.
    terminalInternodeLengths                        = [166.0016, 148.5450, 128.4624, 101.4536, 70.6526, 53.4710] - axon.node.geo.length.value.ref;
    terminalInternodeDiameters                      = [3.2179, 3.2798, 3.1704, 3.3415, 3.6218, 3.4373];
    terminalNodeDiameters                           = [1.8780, 2.1779, 1.9549, 2.2634, 2.1907, 2.2286];
    
    % Printing of progress
    totalNSimulations                               = 5 * length(calyxDiameters);
    
    % Run model without gradations first.
    maxDepolarizationNoGradations                   = nan(1, length(calyxDiameters));
    t1                                              = tic;
    
    for i = 1 : length(calyxDiameters)
        
        nSimulationsDone                            = i;
        fprintf('Figure 6B, GBClat, Calyx diam %.2f um, no gradations: Model %i of %i, ', ...
            calyxDiameters(i)/(5^(2/3)), nSimulationsDone, totalNSimulations)
        
        axon.node.seg.geo.diam.value.vec(51, 12:end)    = calyxDiameters(i);
        axon.node.seg.geo.length.value.vec(51, 12:end)  = 1700/(50*pi*calyxDiameters(i));
        mp                                              = Model(axon, [], false);
        maxDepolarizationNoGradations(i)                = max(mp(:, end));
        
        fprintf('~%.f min remaining\n', (toc(t1)/nSimulationsDone/60) * (5 * length(calyxDiameters) - nSimulationsDone));
    end
    
    
    
    % Include gradation of internode length.
    maxDepolarizationILGraded                       = nan(1, length(calyxDiameters));
    axon                                            = UpdateInternodeLength(axon, terminalInternodeLengths, 45:50);
    for i = 1 : length(calyxDiameters)
        nSimulationsDone                            = length(calyxDiameters) + i;
        fprintf('Figure 6B, GBClat, Calyx diam %.2f um, internode length graded: Model %i of %i, ', ...
            calyxDiameters(i)/(5^(2/3)), nSimulationsDone, totalNSimulations)
        
        axon.node.seg.geo.diam.value.vec(51, 12:end)    = calyxDiameters(i);
        axon.node.seg.geo.length.value.vec(51, 12:end)  = 1700/(50*pi*calyxDiameters(i));
        mp                                              = Model(axon, [], false);
        maxDepolarizationILGraded(i)                    = max(mp(:, end));
        
        fprintf('~%.f min remaining\n', (toc(t1)/nSimulationsDone/60) * (5 * length(calyxDiameters) - nSimulationsDone));
    end
    
    
    
    % Reset the axon, and include gradation of internode diameter.
    axon                                            = Ford2015GBClatWithCalyx();
    axon                                            = UpdateInternodeSegmentDiameter(axon, terminalInternodeDiameters, 45:50);
    axon.myel.geo.numlamellae.value.vec(:)          = 31;
    
    maxDepolarizationIDGraded                       = nan(1, length(calyxDiameters));
    for i = 1 : length(calyxDiameters)
        nSimulationsDone                            = 2 * length(calyxDiameters) + i;
        fprintf('Figure 6B, GBClat, Calyx diam %.2f um, internode diameter graded: Model %i of %i, ', ...
            calyxDiameters(i)/(5^(2/3)), nSimulationsDone, totalNSimulations)
        
        axon.node.seg.geo.diam.value.vec(51, 12:end)    = calyxDiameters(i);
        axon.node.seg.geo.length.value.vec(51, 12:end)  = 1700/(50*pi*calyxDiameters(i));
        mp                                              = Model(axon, [], false);
        maxDepolarizationIDGraded(i)                    = max(mp(:, end));
        
        fprintf('~%.f min remaining\n', (toc(t1)/nSimulationsDone/60) * (5 * length(calyxDiameters) - nSimulationsDone));
    end
    
    
    % Reset the axon and include gradations of nodes.
    axon                                            = Ford2015GBClatWithCalyx();
    axon.node.seg.geo.diam.value.vec(45:50, :)      = repmat(terminalNodeDiameters', 1, axon.geo.nnodeseg);
    
    maxDepolarizationNDGraded                       = nan(1, length(calyxDiameters));
    for i = 1 : length(calyxDiameters)
        nSimulationsDone                            = 3*length(calyxDiameters) + i;
        fprintf('Figure 6B, GBClat, Calyx diam %.2f um, node diameter graded: Model %i of %i, ', ...
            calyxDiameters(i)/(5^(2/3)), nSimulationsDone, totalNSimulations)
        
        axon.node.seg.geo.diam.value.vec(51, 12:end)    = calyxDiameters(i);
        axon.node.seg.geo.length.value.vec(51, 12:end)  = 1700/(50*pi*calyxDiameters(i));
        mp                                              = Model(axon, [], false);
        maxDepolarizationNDGraded(i)                    = max(mp(:, end));
        
        fprintf('~%.f min remaining\n', (toc(t1)/nSimulationsDone/60) * (5 * length(calyxDiameters) - nSimulationsDone));
    end
    
    
    
    % Reset the axon and include all gradations.
    axon                                            = Ford2015GBClatWithCalyx();
    axon                                            = UpdateInternodeLength(axon, terminalInternodeLengths, 45:50);
    axon                                            = UpdateInternodeSegmentDiameter(axon, terminalInternodeDiameters, 45:50);
    axon.myel.geo.numlamellae.value.vec(:)          = 31;
    axon.node.seg.geo.diam.value.vec(45:50, :)      = repmat(terminalNodeDiameters', 1, axon.geo.nnodeseg);
    
    maxDepolarizationAllGraded                      = nan(1, length(calyxDiameters));
    for i = 1 : length(calyxDiameters)
        nSimulationsDone                            = 4 * length(calyxDiameters) + i;
        fprintf('Figure 6B, GBClat, Calyx diam %.2f um, all graded: Model %i of %i, ', ...
            calyxDiameters(i)/(5^(2/3)), nSimulationsDone, totalNSimulations)
        
        axon.node.seg.geo.diam.value.vec(51, 12:end)    = calyxDiameters(i);
        axon.node.seg.geo.length.value.vec(51, 12:end)  = 1700/(50*pi*calyxDiameters(i));
        mp                                              = Model(axon, [], false);
        maxDepolarizationAllGraded(i)                   = max(mp(:, end));
        
        fprintf('~%.f min remaining\n', (toc(t1)/nSimulationsDone/60) * (5 * length(calyxDiameters) - nSimulationsDone));
    end
    
    % Figure 6B, GBClat
    figure, hold on
    % Division by 5^(2/3) to give process diameter (see methods of manuscript).
    plot(calyxDiameters/(5^(2/3)), maxDepolarizationNoGradations - axon.elec.pas.vrest.value, 'Color', 'b', 'LineWidth', 3)
    plot(calyxDiameters/(5^(2/3)), maxDepolarizationNDGraded - axon.elec.pas.vrest.value, 'Color', [0, 128, 0]/255, 'LineWidth', 3)
    plot(calyxDiameters/(5^(2/3)), maxDepolarizationIDGraded - axon.elec.pas.vrest.value, 'Color', 'r', 'LineWidth', 3)
    plot(calyxDiameters/(5^(2/3)), maxDepolarizationILGraded - axon.elec.pas.vrest.value, 'Color', [135, 206, 250]/255, 'LineWidth', 3)
    plot(calyxDiameters/(5^(2/3)), maxDepolarizationAllGraded - axon.elec.pas.vrest.value, 'Color', 'm', 'LineWidth', 3)
    set(gca, 'XLim', [0, 15/(5^(2/3))], 'XTick', 0:5, ...
        'YLim', [0, 60], 'YTick', 0:10:60)
    xlabel('Calyx process diameter (\mum)')
    ylabel('Max depolarization (mV)')
    title('Figure 6B, GBClat')
    legend({'No gradation', 'Node diameter', 'Internode diameter', 'Internode length', 'All graded'})
    axis square
end





if replicateFigure6BGBCmed
    
    fprintf('\n---------------------------------------------------------\n');
    fprintf('----------- FORD ET AL. 2015 FIGURE 6B GBCmed -----------\n\n');
    
    fprintf('Time remaining is for models for figure 6B, GBCmed only\n');
    
    % Re-initialize axon parameters.
    axon                                            = Ford2015GBCmedWithCalyx();
    
    % Calyx diameters.
    calyxDiameters                                  = 0.1:0.2:15;
    
    % Gradation parameters at the terminal of the axon.
    terminalInternodeLengths                        = [221.1572, 174.7356, 149.5174, 102.3925, 73.7239, 36.8896] - axon.node.geo.length.value.ref;
    terminalInternodeDiameters                      = [2.53, 2.1944, 2.3781, 2.3069, 2.4736, 2.3756];
    terminalNodeDiameters                           = [1.5212, 1.6132, 1.3883, 1.5727, 1.6631, 1.9450];
    
    % Printing of progress
    totalNSimulations                               = 5 * length(calyxDiameters);
    
    % Run model without gradations first.
    maxDepolarizationNoGradations                   = nan(1, length(calyxDiameters));
    t1                                              = tic;
    
    for i = 1 : length(calyxDiameters)
        nSimulationsDone                            = i;
        fprintf('Figure 6B, GBCmed, Calyx diam %.2f um, no gradation: Model %i of %i, ', ...
            calyxDiameters(i)/(5^(2/3)), nSimulationsDone, totalNSimulations)
        
        axon.node.seg.geo.diam.value.vec(51, 12:end)    = calyxDiameters(i);
        axon.node.seg.geo.length.value.vec(51, 12:end)  = 1250/(50*pi*calyxDiameters(i));
        mp                                              = Model(axon, [], false);
        maxDepolarizationNoGradations(i)                = max(mp(:, end));
        
        fprintf('~%.f min remaining\n', (toc(t1)/nSimulationsDone/60) * (5 * length(calyxDiameters) - nSimulationsDone));
    end
    
    
    
    % Include gradation of internode length.
    axon                                            = UpdateInternodeLength(axon, terminalInternodeLengths, 45:50);
    maxDepolarizationILGraded                       = nan(1, length(calyxDiameters));
    
    for i = 1 : length(calyxDiameters)
        nSimulationsDone                            = length(calyxDiameters) + i;
        fprintf('Figure 6B, GBCmed, Calyx diam %.2f um, internode length graded: Model %i of %i, ', ...
            calyxDiameters(i)/(5^(2/3)), nSimulationsDone, totalNSimulations)
        
        axon.node.seg.geo.diam.value.vec(51, 12:end)    = calyxDiameters(i);
        axon.node.seg.geo.length.value.vec(51, 12:end)  = 1250/(50*pi*calyxDiameters(i));
        mp                                          = Model(axon, [], false);
        maxDepolarizationILGraded(i)                = max(mp(:, end));
        
        fprintf('~%.f min remaining\n', (toc(t1)/nSimulationsDone/60) * (5 * length(calyxDiameters) - nSimulationsDone));
    end
    
    
    
    % Reset the axon, and include gradation of internode diameter.
    axon                                            = Ford2015GBCmedWithCalyx();
    axon                                            = UpdateInternodeSegmentDiameter(axon, terminalInternodeDiameters, 45:50);
    axon.myel.geo.numlamellae.value.vec(:)          = 26;
    
    maxDepolarizationIDGraded                       = nan(1, length(calyxDiameters));
    for i = 1 : length(calyxDiameters)
        nSimulationsDone                            = 2*length(calyxDiameters) + i;
        fprintf('Figure 6B, GBCmed, Calyx diam %.2f um, internode diameter graded: Model %i of %i, ', ...
            calyxDiameters(i)/(5^(2/3)), nSimulationsDone, totalNSimulations)
        
        axon.node.seg.geo.diam.value.vec(51, 12:end)    = calyxDiameters(i);
        axon.node.seg.geo.length.value.vec(51, 12:end)  = 1250/(50*pi*calyxDiameters(i));
        mp                                              = Model(axon, [], false);
        maxDepolarizationIDGraded(i)                    = max(mp(:, end));
        
        fprintf('~%.f min remaining\n', (toc(t1)/nSimulationsDone/60) * (5 * length(calyxDiameters) - nSimulationsDone));
    end
    
    
    % Reset the axon and include gradations of nodes.
    axon                                            = Ford2015GBCmedWithCalyx();
    axon.node.seg.geo.diam.value.vec(45:50, :)      = repmat(terminalNodeDiameters', 1, axon.geo.nnodeseg);
    
    maxDepolarizationNDGraded                       = nan(1, length(calyxDiameters));
    for i = 1 : length(calyxDiameters)
        nSimulationsDone                            = 3*length(calyxDiameters) + i;
        fprintf('Figure 6B, GBCmed, Calyx diam %.2f um, node diameter graded: Model %i of %i, ', ...
            calyxDiameters(i)/(5^(2/3)), nSimulationsDone, totalNSimulations)
        
        axon.node.seg.geo.diam.value.vec(51, 12:end)    = calyxDiameters(i);
        axon.node.seg.geo.length.value.vec(51, 12:end)  = 1250/(50*pi*calyxDiameters(i));
        mp                                              = Model(axon, [], false);
        maxDepolarizationNDGraded(i)                    = max(mp(:, end));
        
        fprintf('~%.f min remaining\n', (toc(t1)/nSimulationsDone/60) * (5 * length(calyxDiameters) - nSimulationsDone));
    end
    
    
    
    % Reset the axon and include all gradations.
    axon                                            = Ford2015GBCmedWithCalyx();
    axon                                            = UpdateInternodeLength(axon, terminalInternodeLengths, 45:50);
    axon                                            = UpdateInternodeSegmentDiameter(axon, terminalInternodeDiameters, 45:50);
    axon.myel.geo.numlamellae.value.vec(:)          = 26;
    axon.node.seg.geo.diam.value.vec(45:50, :)      = repmat(terminalNodeDiameters', 1, axon.geo.nnodeseg);
    
    maxDepolarizationAllGraded                      = nan(1, length(calyxDiameters));
    for i = 1 : length(calyxDiameters)
        nSimulationsDone                            = 4*length(calyxDiameters) + i;
        fprintf('Figure 6B, GBCmed, Calyx diam %.2f um, all graded: Model %i of %i, ', ...
            calyxDiameters(i)/(5^(2/3)), nSimulationsDone, totalNSimulations)
        
        axon.node.seg.geo.diam.value.vec(51, 12:end)    = calyxDiameters(i);
        axon.node.seg.geo.length.value.vec(51, 12:end)  = 1250/(50*pi*calyxDiameters(i));
        mp                                              = Model(axon, [], false);
        maxDepolarizationAllGraded(i)                   = max(mp(:, end));
        
        fprintf('~%.f min remaining\n', (toc(t1)/nSimulationsDone/60) * (5 * length(calyxDiameters) - nSimulationsDone));
    end
    
    % Figure 6B, GBCmed
    figure, hold on
    % Division by 5^(2/3) to give process diameter (see methods of
    % manuscript).
    plot(calyxDiameters/(5^(2/3)), maxDepolarizationNoGradations - axon.elec.pas.vrest.value, 'Color', 'b', 'LineWidth', 3)
    plot(calyxDiameters/(5^(2/3)), maxDepolarizationNDGraded - axon.elec.pas.vrest.value, 'Color', [0, 128, 0]/255, 'LineWidth', 3)
    plot(calyxDiameters/(5^(2/3)), maxDepolarizationIDGraded - axon.elec.pas.vrest.value, 'Color', 'r', 'LineWidth', 3)
    plot(calyxDiameters/(5^(2/3)), maxDepolarizationILGraded - axon.elec.pas.vrest.value, 'Color', [135, 206, 250]/255, 'LineWidth', 3)
    plot(calyxDiameters/(5^(2/3)), maxDepolarizationAllGraded - axon.elec.pas.vrest.value, 'Color', 'm', 'LineWidth', 3)
    set(gca, 'XLim', [0, 15/(5^(2/3))], 'XTick', 0:5, ...
        'YLim', [0, 60], 'YTick', 0:10:60)
    xlabel('Calyx process diameter (\mum)')
    ylabel('Max depolarization (mV)')
    title('Figure 6B, GBCmed')
    legend({'No gradation', 'Node diameter', 'Internode diameter', 'Internode length', 'All graded'})
    axis square
end



function [vel, ror, amp, hw] = APWaveformProperties(mp, il, t, vrest, bnds)

vel = velocities(mp, il, t(2)-t(1), bnds);
ror = max(diff(mp(:, bnds(1)))/(t(2)-t(1)));
amp = max(mp(:, bnds(1))) - vrest;

ap_half_amplitude = vrest + amp/2;
hw = (find(mp(:, bnds(1)) > ap_half_amplitude, 1, 'last') - find(mp(:, bnds(1)) > ap_half_amplitude, 1)) * (t(2)-t(1));
    