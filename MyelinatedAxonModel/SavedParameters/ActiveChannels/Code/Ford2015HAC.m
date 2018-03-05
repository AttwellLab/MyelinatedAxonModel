function activeChannel = Ford2015HAC()

activeChannel.channames =                           'Hyperpolarization activated cation';
activeChannel.cond.value.ref =                      0.095;
activeChannel.cond.value.vec =                      [];
activeChannel.cond.units =                          {2, 'mS', 'cm', [1, -2]};
activeChannel.erev.value =                          -43;
activeChannel.erev.units =                          {1, 'mV', 1};
activeChannel.gates.temp =                          22;
activeChannel.gates.number =                        1;
activeChannel.gates.label =                         {'r'};
activeChannel.gates.numbereach =                    1;
activeChannel.gates.alpha.q10 =                     3;
activeChannel.gates.beta.q10 =                      3;
activeChannel.gates.alpha.equ =                     {'(1./(1+exp((V+76)/7))) ./ (25+((10^5)*(1./((237*exp((V+60)/12))+(17*exp(-(V+60)/14))))))'};
activeChannel.gates.beta.equ =                      {'(1 - (1./(1+exp((V+76)/7)))) ./ (25+((10^5)*(1./((237*exp((V+60)/12))+(17*exp(-(V+60)/14))))))'};