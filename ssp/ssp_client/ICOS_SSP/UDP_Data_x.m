function UDP_Data(udpobj, event)
fprintf(1, 'Reveived a packet\n');
fprintf(1, 'BytesAvailable = %d\n', udpobj.BytesAvailable);
