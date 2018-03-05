function Bakiri2011()
% Replicate the conduction velocity values and figures from:
%   Bakiri Y., Karadottir R., Cossell L., Attwell D. (2011)
%   'Morphological and electrical properties of oligodendrocytes in the
%   white matter of the corpus callosum and cerebellum.' J. Phyiol. 589.3
%   p559-573.

fprintf('\n\n---------------------------------------------------------\n');
fprintf('----------------- BAKIRI ET AL. 2011  -------------------\n\n');

fprintf('Should take about 5 minutes to run all models.\n')

conductance = [0.01, 0.1, 1, 2, 5, 10, 20, 50, 100, 200, 500];
totalModelsToRun = 7 + 2*length(conductance);

%% Cerebellum
% Create the parameters of the cerebellum axon.
axon = Bakiri2011Cerebellum();

% Run the model.
fprintf('Running cerebellar axon model (1/%i)\n', totalModelsToRun)
[mp, il, t] = Model(axon, [], false);

% Calculate the velocity between the 6th and 13th node.
velCerebellum = velocities(mp, il, t(2)-t(1), [6, 13]);



%% Corpus callosum
% Create the parameters of the corpus callosum axon.
axon = Bakiri2011CorpusCallosum();

% Run the model.
fprintf('Running corpus callosum axon model (2/%i)\n', totalModelsToRun)
[mp, il, t] = Model(axon, [], false);

% Calculate the velocity between the 6th and 13th node.
velCorpusOri = velocities(mp, il, t(2)-t(1), [6, 13]);



% Replicate figure 5C
figure
plot(t, mp(:, 4:14), 'k', 'LineWidth', 2)
set(gca, 'XLim', [0, 2.2], 'YLim', [-100, 40], ...
    'XTick', 0:0.5:2, 'YTick', -100:20:40, 'TickDir', 'out')
box off
xlabel('Time (ms)')
ylabel('Axon voltage (mV)')
title('Figure 5C')



%% Corpus callosum, 'infinite' conductance myelin
% Create the parameters of the corpus callosum axon.
axon = Bakiri2011CorpusCallosum();

axon.sim.tmax.value = 10;
axon.stim.amp.value = 5;

% Myelin membrane conductance.
axon.myel.elec.pas.cond.value = 1e10;
axon.myel.elec.pas.cond.units = {2, 'pS', 'um', [1, -2]};

% Run the model.
fprintf('Running corpus callosum model with "infinite" conductance myelin sheath (3/%i)\n', totalModelsToRun)
[mp, il, t] = Model(axon, [], false);

% Calculate the velocity between the 6th and 13th node.
velCorpusInfGMyelin = velocities(mp, il, t(2)-t(1), [6, 13]);




%% Corpus callosum, recompute with different myelin conductance
axon = Bakiri2011CorpusCallosum();

axon.myel.elec.pas.cond.value = 0.553;
axon.myel.elec.pas.cond.units = {2, 'mS', 'cm', [1, -2]};

% Run the model.
fprintf('Running corpus callosum model with 0.553mS/cm^2 myelin membrane conductance (4/%i)\n', totalModelsToRun)
[mp, il, t] = Model(axon, [], false);

% Calculate the velocity between the 6th and 13th node.
velCorpus = velocities(mp, il, t(2)-t(1), [6, 13]);



%% Corpus callosum, larger diameter axon
axon = Bakiri2011CorpusCallosum();

axon.myel.elec.pas.cond.value = 0.553;
axon.myel.elec.pas.cond.units = {2, 'mS', 'cm', [1, -2]};

axon.stim.amp.value = 5;

axon.node.seg.geo.diam.value.vec(:) = 0.72;
axon.intn.seg.geo.diam.value.vec(:) = 0.72;

% Run the model.
fprintf('Running corpus callosum model with 0.72um diameter axon (5/%i)\n', totalModelsToRun)
[mp, il, t] = Model(axon, [], false);

% Calculate the velocity between the 6th and 13th node.
velCorpusLargeDAxon = velocities(mp, il, t(2)-t(1), [6, 13]);



%% Corpus callosum, more lamellae
axon = Bakiri2011CorpusCallosum();

axon.myel.elec.pas.cond.value = 0.553;
axon.myel.elec.pas.cond.units = {2, 'mS', 'cm', [1, -2]};

axon.myel.geo.numlamellae.value.vec(:) = 10;

% Run the model.
fprintf('Running corpus callosum model with 10 myelin wraps (6/%i)\n', totalModelsToRun)
[mp, il, t] = Model(axon, [], false);

% Calculate the velocity between the 6th and 13th node.
velCorpus10Lamellae = velocities(mp, il, t(2)-t(1), [6, 13]);



%% Corpus callosum, longer internode
axon = Bakiri2011CorpusCallosum();

axon.myel.elec.pas.cond.value = 0.553;
axon.myel.elec.pas.cond.units = {2, 'mS', 'cm', [1, -2]};

axon = UpdateInternodeLength(axon, 106.14);

% Run the model.
fprintf('Running corpus callosum model with 106.1um long internode (7/%i)\n', totalModelsToRun)
[mp, il, t] = Model(axon, [], false);

% Calculate the velocity between the 6th and 13th node.
velCorpusLongInternode = velocities(mp, il, t(2)-t(1), [6, 13]);





%% Figure 5D
% Myelin membrane conductance
vel = nan(1, length(conductance));
axon = Bakiri2011CorpusCallosum();
for i = 1 : length(conductance)
    fprintf('Running corpus callosum, myelin membrane conductance %.3f pS/um2 (%i/%i)\n', conductance(i), 7+i, totalModelsToRun);
    % Myelin membrane conductance.
    axon.myel.elec.pas.cond.value = conductance(i);
    axon.myel.elec.pas.cond.units = {2, 'pS', 'um', [1, -2]};
    % Run the model.
    [mp, il, t] = Model(axon, [], false);
    % Calculate the velocity between the 6th and 13th node.
    vel(i) = velocities(mp, il, t(2)-t(1), [6, 13]);
end

figure
plot(conductance, vel, 'k', 'LineWidth', 2)
set(gca, 'YLim', [0, 2], 'YTick', [0, 1, 2], 'XScale', 'log', 'XTick', [0.01, 0.1, 1, 10, 100, 1000], ...
    'XTickLabel', {'0.01', '0.1', '1', '10', '100', '1000'}, 'FontSize', 14)
box off
xlabel('Oligodendrocyte membrane specific conductance (pS/\mum^2)', 'FontSize', 14)
ylabel('Conduction velocity (m/s)', 'FontSize', 14)
title('Figure 5D, Corpus Callosum')




%% Figure 5E
% Myelin membrane conductance
vel = nan(1, length(conductance));
axon = Bakiri2011Cerebellum();
for i = 1 : length(conductance)
    
    fprintf('Running cerebellum, myelin membrane conductance %.3f pS/um2 (%i/%i)\n', conductance(i), 7+length(conductance)+i, totalModelsToRun);
    
    % Myelin membrane conductance.
    axon.myel.elec.pas.cond.value = conductance(i);
    axon.myel.elec.pas.cond.units = {2, 'pS', 'um', [1, -2]};
    
    if conductance(i) > 10
        axon.stim.amp.value = 5;
    end
    
    % Run the model.
    [mp, il, t] = Model(axon, [], false);
    
    % Calculate the velocity between the 6th and 13th node.
    vel(i) = velocities(mp, il, t(2)-t(1), [6, 13]);
end

figure
plot(conductance, vel, 'k', 'LineWidth', 2)
set(gca, 'YLim', [0, 4], 'YTick', 0:4, 'XScale', 'log', 'XTick', [0.01, 0.1, 1, 10, 100, 1000], ...
    'XTickLabel', {'0.01', '0.1', '1', '10', '100', '1000'}, 'FontSize', 14)
box off
xlabel('Oligodendrocyte membrane specific conductance (pS/\mum^2)', 'FontSize', 14)
ylabel('Conduction velocity (m/s)', 'FontSize', 14)
title('Figure 5E, Cerebellum')






% Print results
fprintf('\n\nRESULTS\n')
fprintf('-------\n\n')
fprintf('Cerebellum axon CV: %.1f m/s\n', velCerebellum);
fprintf('Corpus callosum axon CV: %.1f m/s\n', velCorpusOri);
fprintf('Corpus callosum axon, high conductance myelin, CV: %.2f m/s\n', velCorpusInfGMyelin);
fprintf('Corpus callosum axon, increased diameter, CV: %.2f m/s\n', velCorpusLargeDAxon);
fprintf('  CV increased by a factor of %.2f\n', velCorpusLargeDAxon/velCorpus);
fprintf('Corpus callosum axon, 10 lamellae, CV: %.2f m/s\n', velCorpus10Lamellae);
fprintf('  CV increased by a factor of %.2f\n', velCorpus10Lamellae/velCorpus);
fprintf('Corpus callosum axon, increased internode length, CV: %.2f m/s\n', velCorpusLongInternode);
fprintf('  CV decreased by a factor of %.2f\n', velCorpus/velCorpusLongInternode);
fprintf('Figures printed')
