function tcp_send(tcp, cmd)
fprintf(1,'Sending command: %s\r', cmd);
cmdr = sprintf('%s\r', cmd);
fwrite(tcp, cmdr);
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
