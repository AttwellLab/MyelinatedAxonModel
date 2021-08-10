function relativeScale = fromsimunits(desiredUnits)

% Possible units
% s - seconds; m - meters; A - amperes; V - volts; S - siemens; F - farads;
% O - ohms; C - coulombs
units =                 {'s','m','A','V','S','F','O','C'};
% Corresponding scale of the units which will be used for the simulations
scale =                 {'m','m','u','m','m','u','k','n'};

% Possible scales to use
cal1 =                  {'G','M','k',' ','d','c','m','u','n','p','f'};
% Numerical value of the scale relative to base
cal2 =                  10.^[9, 6, 3, 0, -1, -2, -3, -6, -9, -12, -15];


relativeScale = zeros(1, desiredUnits{1});
for i = 1 : desiredUnits{1}
    absoluteScaleDesired = cal2(strcmp(cal1, desiredUnits{i+1}(1)));
    absoluteScaleStrSimulation  = scale(strcmp(units, desiredUnits{i+1}(2)));
    absoluteScaleSimulation = cal2(strcmp(cal1, absoluteScaleStrSimulation));
    relativeScale(i) = absoluteScaleSimulation / absoluteScaleDesired;
end
relativeScale = prod(relativeScale .^ desiredUnits{end});