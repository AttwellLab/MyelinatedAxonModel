function k = rateequation(V, T, tempDefined, q10, equStr)

hEqu = eval(sprintf('@(V)(%s)', equStr));

k = (q10^((T - tempDefined)/10)) * hEqu(V);

invalidGateValues = isinf(k) | isnan(k);
if ~any(invalidGateValues); return; end

I = find(invalidGateValues);
for i = 1 : length(I)
    
    x = V(I(i))-1e-6:1e-7:V(I(i))+1e-6;
    y = (q10^((T - tempDefined)/10)) * hEqu(x);
    
    k(I(i)) = interp1(x(x~=V(I(i))), y(x~=V(I(i))), V(I(i)));
    
end