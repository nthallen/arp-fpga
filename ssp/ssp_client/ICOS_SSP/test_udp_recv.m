%%
% Test UDP reception
sspIP = '10.0.0.200';
UR = udp('');
UR.DatagramReceivedFcn = @UDP_Data;
UR.DatagramTerminateMode = 'on';
UR.LocalHost = '10.0.0.1';
fopen(UR);
readasync(UR);
%%
tcp = tcpip(sspIP, 1500);
fopen(tcp);
cmd = sprintf('NP:%d',UR.LocalPort);
tcp_send(tcp, cmd);
%%
tcp_send(tcp,'EN');
%%
tcp_send(tcp, 'DA');
fclose(tcp);
clear tcp


%%
fclose(UR);
clear UR

%%
% Set up a sender
US = udp('10.0.0.1',UR.LocalPort);
fopen(US);
%%
fwrite(US, pi+(1:4));
%%
fclose(US);
clear US

