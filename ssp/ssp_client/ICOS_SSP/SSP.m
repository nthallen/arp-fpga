classdef SSP < handle
  properties
    NS = 1000 % Number of (averaged) samples per scan (1-4096)
    NA = 100 % NAvg (1-256)
    NC = 1 % NCoadd (1-16383
    NF = 1 % Frequency Divisor (1-32)
    NE = 2 % 1-7 bit-mapped channel enable
    TS = 3 % Trigger channel 0-3 with 3 indicating external
    TriggerRising = true % true if rising
    TriggerLevel = 0 % -32768 to 32767 (if not external)
    AutoTrigger = false % true if auto enabled
    NScans = 1 % Number of Scans to buffer between events
  end
  
  properties (SetAccess = private)
    EN = false % boolean true when converting
    sspIP = '10.0.0.200' % string, IP address of SSP board
    myIP = '10.0.0.1' % My local IP address
    dropped_fragments = 0
    scans_recd = 0
    scans % cell array
    hdr % header for the most recent scan
  end
  
  properties (Access = private)
    tcp % tcpip object for control
    udpobj % udp object for receiving scan data
    NP % UDP port for receiving scan data
    pubprops % list of public properties
    scan_size % number of uint32 words in a full scan
    raw % raw input buffer
    cur_word % current offset into raw scan
    cur_sn % The current fragment serial number
    frag_hold
    pscans % cell array
    phdr
    scans_buffered
  end
  
  properties (Constant = true, Access = private)
    TCPport = 1500;
    frag_bit = uint32(2^31);
    lastfrag_bit = uint32(2^30);
    offset_mask = uint32(2^16-1);
    sn_mask = uint32(2^30 - 2^16);
    NCh = [1 1 2 1 2 2 3];
  end
  
  events
    ScanData
  end
  
  methods
    function S = SSP(varargin)
      S.pubprops = S.get_pubprops();
      for i = 1:2:length(varargin)-1
        arg = varargin{i};
        val = varargin{i+1};
        if ~ischar(arg)
          error('MATLAB:HUARP:Bad_Option', 'Expected option name');
        elseif any(strcmpi(arg,S.pubprops))
          S.(arg) = val;
        else
          error('MATLAB:HUARP:Bad_Option', 'Invalid option name: %s', arg);
        end
      end
      % Initialize connection to SSP
      S.tcp = tcpip(S.sspIP, S.TCPport);
      try
        fopen(S.tcp);
      catch err
        error('MATLAB:HUARP:Cannot_Connect', 'Unable to connect to SSP');
      end
    end
    
    function delete(S)
      if S.EN
        S.disable();
      end
      fclose(S.tcp);
    end
    
    function enable(S)
      if S.EN
        error('MATLAB:HUARP:AlreadyEnabled', 'SSP is already enabled');
      end
      S.EN = true;
      S.tcp_send('DA');
      % S.tcp_send('AD');
      S.tcp_send('NS:%d', S.NS);
      S.tcp_send('NA:%d', S.NA);
      S.tcp_send('NC:%d', S.NC);
      S.tcp_send('NF:%d', S.NF);
      S.tcp_send('NE:%d', S.NE);
      S.tcp_send('TS:%d', S.TS);
      if S.TriggerRising
        S.tcp_send('TU:%d', S.TriggerLevel);
      else
        S.tcp_send('TD:%d', S.TriggerLevel);
      end
      N_Ch = S.NCh(S.NE);
      S.pscans = cell(N_Ch,1);
      for i=1:N_Ch
        S.pscans{i} = zeros(S.NS,S.NScans);
      end
      S.scans_buffered = 0;
      S.udpobj = udp(S.sspIP, 'InputBufferSize', 1472*100);
      S.udpobj.UserData = S;
      S.udpobj.DatagramReceivedFcn = @SSP.UDP_Data;
      S.udpobj.DatagramTerminateMode = 'on';
      fopen(S.udpobj);
      S.NP = S.udpobj.LocalPort;
      S.tcp_send('NP:%d', S.NP);
      S.scan_size = 7+S.NS*S.NC;
      S.raw = uint32(zeros(S.scan_size+1,1));
      S.cur_word = 1;
      S.cur_sn = 0;
      S.frag_hold = 0;
      S.tcp_send('EN');
      readasync(S.udpobj);
    end
    
    function disable(S)
      S.tcp_send('DA');
      S.EN = false;
      if ~isempty(S.udpobj)
        stopasync(S.udpobj);
        fclose(S.udpobj);
        S.udpobj = [];
      end
    end
    
    function set.NS(S, Nsamples)
      % Set number of samples
      if Nsamples < 1 || Nsamples > 4096
        error('MATLAB:HUARP:NS_OOR', 'NS value out of range');
      else
        S.NS = Nsamples;
      end
    end
    
    function set.NA(S, Navg)
      % Set NAvg
      if Navg < 1 || Navg > 256
        error('MATLAB:HUARP:NA_OOR', 'NA value out of range');
      else
        S.NA = Navg;
      end
    end
    
    function set.NC(S, Ncoadd)
      % Set NAvg
      if Ncoadd < 1 || Ncoadd > 16383
        error('MATLAB:HUARP:NC_OOR', 'NC value out of range');
      else
        S.NC = Ncoadd;
      end
    end
    
    function set.NF(S, Fdivisor)
      % Set NAvg
      if Fdivisor < 1 || Fdivisor > 32
        error('MATLAB:HUARP:NF_OOR', 'NF value out of range');
      else
        S.NF = Fdivisor;
      end
    end
    
    function set.NE(S, Enables)
      % Set NAvg
      if Enables < 1 || Enables > 7
        error('MATLAB:HUARP:NE_OOR', 'NE value out of range');
      else
        S.NE = Enables;
      end
    end
    
    function set.TS(S, Tchan)
      % Set NAvg
      if Tchan < 0 || Tchan > 3
        error('MATLAB:HUARP:TS_OOR', 'TS value out of range');
      else
        S.TS = Tchan;
      end
    end
    
    function set.TriggerLevel(S, level)
      if level < -32768 || level > 32767
        error('MATLAB:HUARP:TL_OOR', 'TriggerLevel value out of range');
      else
        S.TriggerLevel = level;
      end
    end
    
    function set.TriggerRising(S, rising)
      if rising
        S.TriggerRising = true;
      else
        S.TriggerRising = false;
      end
    end
  end
  
  methods (Static)
    function UDP_Data(obj, ~, ~)
      % Args are (obj, event, time)
      S = obj.UserData;
      S.UDP_Data_I();
    end
  end
  
  methods (Access = private)
    function P = get_pubprops(S)
      mc = metaclass(S);
      l = length(mc.PropertyList);
      ix = zeros(l,1);
      for i = 1:l
        ix(i) = strcmp(mc.PropertyList(i).SetAccess,'public');
      end
      ixn = find(ix);
      P = cell(length(ixn)+2,1);
      for i = 1:length(ixn)
        P{i} = mc.PropertyList(ixn(i)).Name;
      end
      P{end-1} = 'sspIP';
      P{end} = 'myIP';
    end
    
    function tcp_send(S, varargin)
      % tcp_send(cmd)
      % tcp_send(fmt, arg)
      if length(varargin) == 1
        cmd = varargin{1};
      else
        cmd = sprintf(varargin{1}, varargin{2});
      end
      try
        fprintf(S.tcp, '%s\r\n', cmd);
        for i = 1:100
          if S.tcp.BytesAvailable > 0
            break;
          end
          pause(.01);
        end
        if S.tcp.BytesAvailable > 0
          s = char(fread(S.tcp,S.tcp.BytesAvailable)');
        else
          error('MATLAB:HUARP:TCP_TIMEOUT','Timeout waiting for reply');
        end
      catch ME
        % S.disable();
        error('MATLAB:HUARP:TCP_ERROR', 'TCP Error: %s', ME.message);
      end
      if isempty(s)
        % error('MATLAB:HUARP:NO_RESPONSE', 'Empty TCP read');
      elseif s(1) ~= '2'
        error('MATLAB:HUARP:SSP_ERROR', 'SSP response: %s', s);
      end
    end
    
    function process_scan(S, offset)
      S.scans_recd = S.scans_recd + 1;
      S.phdr.SerialNum = S.raw(5+offset,1);
      u16 = typecast(S.raw((2+offset):(6+offset),1),'uint16');
      u8 = typecast(u16(1,1),'uint8');
      N_Ch = u8(1);
      N_F = u8(2);
      N_S = u16(2);
      S.phdr.NCoadd = u16(3);
      S.phdr.NAvg = u16(4);
      S.phdr.NSkL = u16(5);
      S.phdr.NSkP = u16(6);
      S.phdr.T_HtSink = u16(9);
      S.phdr.T_FPGA = u16(10);
      S.phdr.Status = S.raw(S.scan_size+offset,1);
      if N_Ch ~= S.NCh(S.NE) || N_S ~= S.NS || N_F ~= S.NF || ...
          S.phdr.NCoadd ~= S.NC || S.phdr.NAvg ~= S.NA
        S.disable();
        error('MATLAB:HUARP:SCAN_MISMATCH', ...
          'Unexpected scan parameters: %d x %d, NF:%d NC:%d NA:%d', ...
          N_S, N_Ch, N_F, S.phdr.NCoadd, S.phdr.NAvg);
      end
      fe = reshape( ...
        float32(typecast(S.raw((7:S.scan_size-1)+offset,1),'int32_t'))/(S.NC * S.NA), ...
        N_Ch, N_S)';
      S.scans_buffered = S.scans_buffered + 1;
      for i=1:N_Ch
        S.pscans{i}(:,S.scans_buffered) = fe(:,i);
      end
      if S.scans_buffered == S.NScans
        S.scans = S.pscans;
        S.hdr = S.phdr;
        S.scans_buffered = 0;
        notify(S, 'ScanData');
      end
    end
    
    function UDP_Data_I(S)
      % called when UDP data is available
      % we should have the entire scan preallocated
      nb = S.udpobj.BytesAvailable;
      if (bitand(nb,3) ~= 0)
        S.disable();
        error('odd UDP packet size: %d', nb);
      end
      nw = nb/4;
      % nw is the total number of words buffered, but that can
      % cover more than one packet. We've asked to terminate our
      % read at a packet boundary, so we'll check our limits
      % then.
      try
        rawread = fread(S.udpobj, nw, 'uint32');
        if size(rawread,1) < nw
          nw = size(rawread,1);
        end
        if S.cur_word+nw-1 > S.scan_size+1 && S.cur_word > 1
          % This will overflow, must be an out of sequence
          % packet. Reset
          fprintf(1,'Dropped: cw:%d nw:%d ss:%d\n', S.cur_word, nw, S.scan_size);
          S.dropped_fragments = S.dropped_fragments + 1;
          S.cur_word = 1;
        end
        if nw > S.scan_size
          S.disable();
          error('MATLAB:HUARP:UDP_OVERRUN', 'Overlong UDP packet: %d words', nw);
        end
        fprintf(1,'nw=%d, rawread=%d x %d\n', nw, size(rawread,1), size(rawread,2));
        S.raw(S.cur_word:S.cur_word+nw-1,1) = uint32(rawread);
      catch ME
        S.disable();
        error('MATLAB:HUARP:UDP_SHORT_READ', 'Read from UDP failed: %s', ...
          ME.message);
      end
      frag_hdr = S.raw(S.cur_word);
      if bitand(frag_hdr, S.frag_bit)
        offset = bitand(frag_hdr, S.offset_mask);
        sn = bitand(frag_hdr, S.sn_mask);
        if offset == 0
          S.cur_sn = sn;
          if S.cur_word ~= 1
            fprintf(1,'Dropped: cw:%d offset:%d\n', S.cur_word, offset);
            S.dropped_fragments = S.dropped_fragments + 1;
            S.raw(1:nw,1) = S.raw(S.cur_word:S.cur_word+nw-1,1);
            S.cur_word = 1;
          end
        elseif offset+1 ~= S.cur_word || sn ~= S.cur_sn
          % packet out of sequence, not at start of scan,
          % nothing we can do
          fprintf(1,'Dropped: cw:%d offset:%d\n', S.cur_word, offset);
          S.dropped_fragments = S.dropped_fragments + 1;
          S.cur_word = 1;
          return;
        else
          S.raw(S.cur_word,1) = S.frag_hold;
        end
        if bitand(frag_hdr, S.lastfrag_bit)
          S.process_scan(1);
          S.cur_word = 1;
          return;
        end
        S.cur_word = S.cur_word + nw - 1;
        S.frag_hold = S.raw(S.cur_word);
      elseif nw == S.scan_size
        S.process_scan(0)
      end
    end
  end
end