%%
fid = fopen('Data.tmp','w');
fwrite(fid,0:255,'uint8');
fclose(fid);
%%
ifid = fopen('Data.tmp','r');
req = 200;
A = uint16(zeros(2*req,0));
try
  [A(1:req), count] = fread(ifid,req,'*uint16');
catch
  fclose(ifid);
  error('Not enough data on input');
end
fclose(ifid);
format hex
size(A)
fprintf(1,'req = %d x uint16: count = %d\n', req, count);
