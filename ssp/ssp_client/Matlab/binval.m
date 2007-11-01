function s = binval( N )
v = N < 0;
N(v) = N(v) + 65536;
N = uint16(N);
s = bitand(N, 1);
for i=2:16
  N = bitshift(N,-1);
  s = [ s bitand(N, 1) ];
end