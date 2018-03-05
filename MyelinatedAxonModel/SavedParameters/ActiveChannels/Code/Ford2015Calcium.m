function activeChannel = Ford2015Calcium()

activeChannel.channames =                           'Calcium';
activeChannel.cond.value.ref =                      3;
activeChannel.cond.value.vec =                      [];
activeChannel.cond.units =                          {2, 'mS', 'cm', [1, -2]};
activeChannel.erev.value =                          43.5;
activeChannel.erev.units =                          {1, 'mV', 1};
activeChannel.gates.temp =                          24;
activeChannel.gates.number =                        1;
activeChannel.gates.label =                         {'s'};
activeChannel.gates.numbereach =                    2;
activeChannel.gates.alpha.q10 =                     3;
activeChannel.gates.beta.q10 =                      3;
activeChannel.gates.alpha.equ =                     {'1.78*exp(V/23.3)'};
activeChannel.gates.beta.equ =                      {'0.14*exp(-V/15)'};