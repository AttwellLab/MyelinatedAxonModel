function activeChannel = Ford2015HighThresholdK_II()

activeChannel.channames =                           'High Threshold K+ II';
activeChannel.cond.value.ref =                      0.15*20;
activeChannel.cond.value.vec =                      [];
activeChannel.cond.units =                          {2, 'mS', 'cm', [1, -2]};
activeChannel.erev.value =                          -90;
activeChannel.erev.units =                          {1, 'mV', 1};
activeChannel.gates.temp =                          22;
activeChannel.gates.number =                        1;
activeChannel.gates.label =                         {'p'};
activeChannel.gates.numbereach =                    1;
activeChannel.gates.alpha.q10 =                     3;
activeChannel.gates.beta.q10 =                      3;
activeChannel.gates.alpha.equ =                     {'(1./(1+exp(-(V+23)/6))) ./ (5+(100*(1./((4*exp((V+60)/32))+(5*exp(-(V+60)/22))))))'};
activeChannel.gates.beta.equ =                      {'(1 - (1./(1+exp(-(V+23)/6)))) ./ (5+(100*(1./((4*exp((V+60)/32))+(5*exp(-(V+60)/22))))))'};