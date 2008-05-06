function ssp_diag(cpci)
if nargin < 1 || isempty(cpci)
  cpci = cpci_list('LOG');
end
if size(cpci,1) > 1
  cpci = cpci';
end
D = load_ssp(cpci);
cpci = [D.N]';
NSkP = [D.NSkP];
NSkL = [D.NSkL];
SN = [D.ScanNum];
NC = [D.NCoadd];
x = 2:length(D);
dSN = diff(SN);
figure;
nsubplot(3,1,1);
plot(cpci,NSkP,'-*');
set(gca,'xtick',[]);
legend('NSkP');
nsubplot(3,1,2);
plot(cpci,NSkL,'-*');
set(gca,'xtick',[],'yaxislocation','right');
legend('NSkL');
nsubplot(3,1,3);
plot(x,dSN-NC(x)-NSkP(x)-NSkL(x));
legend('Missing scans');
addzoom;

check_constant( D, 'NSamples');
check_constant( D, 'NCoadd');
check_constant( D, 'NChannels');
check_constant( D, 'NWordsHdr');
check_constant( D, 'FormatVersion');
check_constant( D, 'NAvg');
check_constant( D, 'Spare');



OVF = [D.OVF]';
digitize(OVF);
set(gca,'ytick',[1 4 7 10 12.5 14 15],'yticklabel', ...
  {'CAOVF','PAOVF','PAOOR','ChEn','TrigSrc','TrigRising','AE'});
FS = 5e6/(D(1).NAvg+1);
FScan = FS/D(1).NSamples;
ScanPeriod = 1e3/FScan; % msec
CoaddPeriod = ScanPeriod*D(1).NCoadd;
fprintf(1, 'Scan Period  = %.3f msec\n', ScanPeriod );
fprintf(1, 'Coadd Period = %.3f msec\n', CoaddPeriod );
ElapsedScans = (D(end).ScanNum - D(1).ScanNum);
SkippedScans = sum(NSkP(x)+NSkL(x));
CoaddedScans = sum(NC(x));
ElapsedTime =  ElapsedScans * ScanPeriod;
fprintf(1, 'Elapsed time = %.3f msec\n', ElapsedTime );
efficiency = CoaddPeriod * (length(D)-1)/ElapsedTime;
fprintf(1, 'Skipped Scans: %.2f %%\n', SkippedScans/ElapsedScans );
fprintf(1, 'Lost Scans: %.2f %%\n', ...
  (ElapsedScans-SkippedScans-CoaddedScans)/ElapsedScans);
fprintf(1, 'Overall Efficiency: %.2f %%\n', efficiency*100 );

return;

function check_constant( D, attr )
vals = [D.(attr)];
if any(vals ~= vals(1))
  fprintf(1,'%s is not constant\n', attr);
  cpci = [D.N];
  figure; plot(cpci,vals);
  title(attr);
  xlabel('scan number');
else
  fprintf(1,'%s = %d\n', attr, vals(1));
end
return;
