function view_ssp( cpci )
if nargin < 1 || isempty(cpci)
  cpci = cpci_list('LOG');
end
if size(cpci,1) > 1
  cpci = cpci';
end
figno = figure;
for i = cpci
  path = mlf_path( 'LOG', i );
  if exist(path,'file')
    figure(figno);
    S = load(path);
    D = S(12:end);
    NCh = S(3);
    NS = S(4);
    if length(D) ~= NCh*NS
      error('Incorrect length of scan: cpci: %d NS:%d NCh:%d len:%d', ...
        i, NS, NCh, length(D));
    end
    D = reshape(D,NCh,NS)';
    plot(D);
    %ylim([-2e5 2e5]);
    title(sprintf('Index: %d', i));
    shg;
    pause
    if all(findobj('type','figure') ~= figno)
      break;
    end
  end
end
