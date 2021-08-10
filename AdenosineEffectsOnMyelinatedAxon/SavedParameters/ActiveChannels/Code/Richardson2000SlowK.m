function activeChannel = Richardson2000SlowK()

activeChannel.channames =                           'Slow K+';
activeChannel.cond.value.ref =                      0.8;
activeChannel.cond.value.vec =                      [];
activeChannel.cond.units =                          {2, 'mS', 'mm', [1, -2]};
activeChannel.erev.value =                          -84;
activeChannel.erev.units =                          {1, 'mV', 1};
activeChannel.gates.temp =                          20;
activeChannel.gates.number =                        1;
activeChannel.gates.label =                         {'n'};
activeChannel.gates.numbereach =                    1;
activeChannel.gates.alpha.q10 =                     3;
activeChannel.gates.beta.q10 =                      3;
activeChannel.gates.alpha.equ =                     {'0.00122*(V+19.5)./(1-exp(-(V+19.5)./23.6))'};
activeChannel.gates.beta.equ =                      {'0.000739*(-(V+87.1))./(1-exp((V+87.1)./21.8))'};