function digitize( N )
b = binval(N);
x = (1:size(N,1));
figure;
for i = 1:16
  D = (double(b(:,i))-0.5)*0.8 + i - 1;
  v = find(diff(D));
  Di = [ 1; reshape([v v+1]',[],1) ];
  xi = [ 1; reshape([v+1 v+1]',[],1) ];
  if isempty(v) || v(end)+1 < length(D)
    Di = [ Di; length(D) ];
    xi = [ xi; length(D) ];
  end
  plot(xi,D(Di));
  hold on;
end
hold off;
ylim([ -.6 15.6]);
