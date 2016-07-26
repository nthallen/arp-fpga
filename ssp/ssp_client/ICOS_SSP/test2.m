%%
tcp = tcpip('10.0.0.206', 1500);
fopen(tcp);
cmd = sprintf('NP:%d\r','NP:');
%%
fwrite(tcp, cmd);
for i=1:100
  if tcp.BytesAvailable > 0
    break;
  end
  pause(.01);
end
if tcp.BytesAvailable > 0
  A = char(fread(tcp,tcp.BytesAvailable)');
else
  A = 'timeout';
end
disp(A);
%%
fclose(tcp);
clear tcp
