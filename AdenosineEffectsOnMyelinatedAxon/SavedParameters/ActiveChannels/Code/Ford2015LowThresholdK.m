function activeChannel = Ford2015LowThresholdK()

activeChannel.channames =                           'Low Threshold K+';
activeChannel.cond.value.ref =                      0.4;
activeChannel.cond.value.vec =                      [];
activeChannel.cond.units =                          {2, 'mS', 'mm', [1, -2]};
activeChannel.erev.value =                          -90;
activeChannel.erev.units =                          {1, 'mV', 1};
activeChannel.gates.temp =                          22;
activeChannel.gates.number =                        2;
activeChannel.gates.label =                         {'w', 'z'};
activeChannel.gates.numbereach =                    [4, 1];
activeChannel.gates.alpha.q10 =                     [3, 3];
activeChannel.gates.beta.q10 =                      [3, 3];
activeChannel.gates.alpha.equ =                     {'((1+exp(-(V+48)./6)).^(-0.25))./(1.5+(100./((6*exp((V+60)./6))+(16*exp(-(V+60)./45)))))', ...
                                                         '(0.5+0.5*(1./(1+exp((V+71)./10))))./(50+(1000./((exp((V+60)./20))+(exp(-(V+60)./8)))))'};
activeChannel.gates.beta.equ =                      {'(1-((1+exp(-(V+48)./6)).^(-0.25)))./(1.5+(100./((6*exp((V+60)./6))+(16*exp(-(V+60)./45)))))', ...
                                                         '(1-(0.5+0.5*(1./(1+exp((V+71)./10)))))./(50+(1000./((exp((V+60)./20))+(exp(-(V+60)./8)))))'};