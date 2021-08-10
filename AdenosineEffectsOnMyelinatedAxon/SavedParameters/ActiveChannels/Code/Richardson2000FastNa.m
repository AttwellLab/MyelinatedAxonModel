function activeChannel = Richardson2000FastNa()

activeChannel.channames =                           'Fast Na+';
activeChannel.cond.value.ref =                      30;
activeChannel.cond.value.vec =                      [];
activeChannel.cond.units =                          {2, 'mS', 'mm', [1, -2]};
activeChannel.erev.value =                          50;
activeChannel.erev.units =                          {1, 'mV', 1};
activeChannel.gates.temp =                          20;
activeChannel.gates.number =                        2;
activeChannel.gates.label =                         {'m', 'h'};
activeChannel.gates.numbereach =                    [3, 1];
activeChannel.gates.alpha.q10 =                     [2.2, 2.9];
activeChannel.gates.beta.q10 =                      [2.2, 2.9];
activeChannel.gates.alpha.equ =                     {'1.86*(V+25.4)./(1-exp(-(V+25.4)./10.3))', ...
                                                         '0.0336*(-(V+118))./(1-exp((V+118)./11))'};
activeChannel.gates.beta.equ =                      {'0.086*(-(V+29.7))./(1-exp((V+29.7)./9.16))', ...
                                                         '2.3./(1+exp(-(V+35.8)./13.4))'};