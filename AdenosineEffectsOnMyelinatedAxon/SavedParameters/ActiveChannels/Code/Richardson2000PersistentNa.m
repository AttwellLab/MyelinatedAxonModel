function activeChannel = Richardson2000PersistentNa()

activeChannel.channames =                           'Persistent Na+';
activeChannel.cond.value.ref =                      0.05;
activeChannel.cond.value.vec =                      [];
activeChannel.cond.units =                          {2, 'mS', 'mm', [1, -2]};
activeChannel.erev.value =                          50;
activeChannel.erev.units =                          {1, 'mV', 1};
activeChannel.gates.temp =                          20;
activeChannel.gates.number =                        1;
activeChannel.gates.label =                         {'m'};
activeChannel.gates.numbereach =                    3;
activeChannel.gates.alpha.q10 =                     2.2;
activeChannel.gates.beta.q10 =                      2.2;
activeChannel.gates.alpha.equ =                     {'0.186*(V+48.4)./(1-exp(-(V+48.4)/10.3))'};
activeChannel.gates.beta.equ =                      {'0.0086*(-(V+42.7))./(1-exp((V+42.7)./9.16))'};