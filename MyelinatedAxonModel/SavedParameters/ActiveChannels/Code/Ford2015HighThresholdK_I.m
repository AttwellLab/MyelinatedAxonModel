function activeChannel = Ford2015HighThresholdK_I()

activeChannel.channames =                           'High Threshold K+ I';
activeChannel.cond.value.ref =                      0.85*20;
activeChannel.cond.value.vec =                      [];
activeChannel.cond.units =                          {2, 'mS', 'cm', [1, -2]};
activeChannel.erev.value =                          -90;
activeChannel.erev.units =                          {1, 'mV', 1};
activeChannel.gates.temp =                          22;
activeChannel.gates.number =                        1;
activeChannel.gates.label =                         {'n'};
activeChannel.gates.numbereach =                    2;
activeChannel.gates.alpha.q10 =                     3;
activeChannel.gates.beta.q10 =                      3;
activeChannel.gates.alpha.equ =                     {'(1./sqrt(1+exp(-(V+15)/5))) ./ (0.7+(100*(1./((11*exp((V+60)/24))+(21*exp(-(V+60)/23))))))'};
activeChannel.gates.beta.equ =                      {'(1 - (1./sqrt(1+exp(-(V+15)/5)))) ./ (0.7+(100*(1./((11*exp((V+60)/24))+(21*exp(-(V+60)/23))))))'};