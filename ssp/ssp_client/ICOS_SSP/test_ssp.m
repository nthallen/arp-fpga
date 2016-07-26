%%
% Test SSP driver for ISO
S = SSP('sspIP', '10.0.0.200');
WaveSpecs = load_waves;
wv = WaveSpecs(1);
S.NF = round(1e8/wv.RawRate);
S.NA = wv.NAverage;
S.NC = wv.NCoadd;
S.NS = wv.NetSamples;
%%
addlistener(S,'ScanData',@test_ssp_callback);
%%
S.enable();
%%
S.disable();
