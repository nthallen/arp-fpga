function s = bintext( N )
bits = ('01')';
v = N < 0;
N(v) = N(v) + 65536;
N = uint16(N);
s = bits(bitand(N, 1)+1);
for i=2:16
  N = bitshift(N,-1);
  s = [ bits(bitand(N, 1)+1) s ];
end