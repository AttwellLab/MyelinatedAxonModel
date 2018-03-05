function activeChannel = Ford2015FastNa()

activeChannel.channames =                           'Fast Na+';
activeChannel.cond.value.ref =                      5.88;
activeChannel.cond.value.vec =                      [];
activeChannel.cond.units =                          {2, 'mS', 'mm', [1, -2]};
activeChannel.erev.value =                          55;
activeChannel.erev.units =                          {1, 'mV', 1};
activeChannel.gates.temp =                          37;
activeChannel.gates.number =                        2;
activeChannel.gates.label =                         {'m', 'h'};
activeChannel.gates.numbereach =                    [2, 1];
activeChannel.gates.alpha.q10 =                     [3, 3];
activeChannel.gates.beta.q10 =                      [3, 3];
activeChannel.gates.alpha.equ =                     {'5.196152422706632*0.36*(V+49)./(1-exp(-(V+49)./3))', ...
                                                         '(5.196152422706632*2.4./(1+exp((V+68)./3)))+(31.622776601683793*0.8./(1+exp(V+61.3)))'};
activeChannel.gates.beta.equ =                      {'(-0.4*5.196152422706632*(V+58))./(1-exp((V+58)./20))', ...
                                                         '(3.6*5.196152422706632)./(1+exp(-(V+21)./10))'};