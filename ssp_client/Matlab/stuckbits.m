function stuckbits( V )

O = V(1);
Z = V(1);
for i = 2:length(V)
  O = bitand(O,V(i));
  Z = bitor(Z,V(i));
end
% bits set in O are set in all of V
if O ~= 0
  fprintf(1,'%04X: Bits always on\n', O);
end
if Z ~= 65535
  fprintf(1,'%04X: Bits always off\n', bitcmp(Z,16));
end
moving = bitcmp(bitor(O,bitcmp(Z,16)),16);
fprintf(1, '%04X: Bits moving\n', moving );
