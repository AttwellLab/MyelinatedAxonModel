function activeChannel = Ctrl_Ih()

activeChannel.channames =                           'Ctrl_Ih';
activeChannel.cond.value.ref =                      23;
activeChannel.cond.value.vec =                      [];
activeChannel.cond.units =                          {2, 'mS', 'cm', [1, -2]};
activeChannel.erev.value =                          -23;
activeChannel.erev.units =                          {1, 'mV', 1};
activeChannel.gates.temp =                          35;
activeChannel.gates.number =                        1;
activeChannel.gates.label =                         {'r'};
activeChannel.gates.numbereach =                    1;
activeChannel.gates.alpha.q10 =                     3;
activeChannel.gates.beta.q10 =                      3;
activeChannel.gates.alpha.equ =                     {'(0.007*exp(-(V+103.5)/19))'};
activeChannel.gates.beta.equ =                      {'(0.007*exp((V+103.5)/22))'};