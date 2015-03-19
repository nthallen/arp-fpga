classdef SSP < handle
  properties
    NS = 1000 % Number of (averaged) samples per scan (1-4096)
    NA = 100 % NAvg (1-256)
    NC = 1 % NCoadd (1-16383
    NF = 1 % Frequency Divisor (1-32)
    NE = 3 % 1-7 bit-mapped channel enable
    NT = 3 % Trigger channel 0-3 with 3 indicating external
    TriggerRising = true % true if rising
    TriggerLevel = 0 % -32768 to 32767 (if not external)
    AutoTrigger = false % true if auto enabled
  end
  
  properties (SetAccess = private)
    sspIP = '10.0.0.200' % string, IP address of SSP board
    myIP = '10.0.0.1' % My local IP address
  end
  
  properties (Access = private)
    tcp % tcpip object for control
    udpobj % udp object for receiving scan data
    NP % UDP port for receiving scan data
    EN = false % boolean true when converting
    pubprops % list of public properties
  end
  
  properties (Constant = true)
    TCPport = 1500;
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
        % fopen(S.tcp);
      catch err
        error('MATLAB:HUARP:Cannot_Connect', 'Unable to connect to SSP');
      end
    end
    
    function enable(S)
      if S.EN
        error('MATLAB:HUARP:AlreadyEnabled', 'SSP is already enabled');
      end
      tcp_send('DA');
      tcp_send('AD');
      tcp_send('NS:%d', S.NS);
      tcp_send('NA:%d', S.NA);
      tcp_send('NC:%d', S.NC);
      tcp_send('NF:%d', S.NF);
      tcp_send('NE:%d', S.NE);
      tcp_send('NT:%d', S.NT);
      if S.TriggerRising
        tcp_send('NU:%d', S.TriggerLevel);
      else
        tcp_send('ND:%d', S.TriggerLevel);
      end
      S.udpobj = udp(S.sspIP);
      fopen(S.udpobj);
      S.udpobj.BytesAvailableFcnCount = 1;
      S.udpobj.UserData = S;
      S.udpobj.BytesAvailableFcn = @UDP_Data;
      S.NP = S.udpobj.LocalPort;
      tcp_send('NP:%d', S.NP);
      tcp_send('EN');
      readasynch(S.udpobj);
    end
    
    function disable(S)
      tcp_send('DA');
      S.EN = false;
      stopasync(S.udpobj);
      fclose(S.udpobj);
      S.udpobj = [];
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
      if Navg < 1 || NAvg > 256
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
    
    function set.NT(S, Tchan)
      % Set NAvg
      if Tchan < 0 || Tchan > 3
        error('MATLAB:HUARP:NT_OOR', 'NT value out of range');
      else
        S.NT = Tchan;
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
    
    function tcp_send(varargin)
      % tcp_send(cmd)
      % tcp_send(fmt, arg)
      if length(varargin) == 1
        cmd = varargin{1};
      else
        cmd = sprintf(varargin{1}, varargin{2});
      end
      cmd = sprintf('%s\r\n', cmd);
      % write to tcp
      % read response from tcp
      % complain if there is an error
    end
    
    function UDP_Data_I(S)
      % called when UDP data is available
      % we should have the entire scan preallocated
    end
  end
end