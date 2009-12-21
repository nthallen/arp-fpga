function mdl = timing( mdl, option, varargin )
if nargin == 0
  mdl = struct('signals',struct([]),'Tmax',0);
  return;
end
if nargin == 1
  error('No option specified');
end
if strcmpi(option,'signal')
  % timing(mdl,'signal',<name>, <initcode>, <arg>)
  % <initcode> options include:
  %    'clock', [period]
  %    'init', [value]
  if nargin < 5
    error('Insufficient arguments for signal initialization');
  end
  signame = varargin{1};
  initcode = varargin{2};
  initarg = varargin{3};
  if isfield(mdl.signals, signame)
    error('Redefinition of signal %s', signame );
  end
  sigindex = length(fields(mdl.signals))+1;
  mdl.signals.(signame) = struct('name',signame,'index',sigindex);
  if strcmpi(initcode,'clock')
    mdl.signals.(signame).type = 'clock';
    mdl.signals.(signame).period = initarg;
    mdl.signals.(signame).transitions = [ 0 0 ];
  elseif strcmpi(initcode, 'init')
    mdl.signals.(signame).type = 'other';
    mdl.signals.(signame).transitions = [ 0 initarg ];
  else
    error('Invalid init code: %s', initcode);
  end
elseif strcmpi(option,'transition')
  % mdl = timing(mdl, 'transition', 'EOS', 1, 'after', 10, 'after', 'sys_clk', 1 );
  % <signame>, <newvalue>, <when>+
  % <when> : 'after' <event>
  % <event> : <number> (time)
  %         : <signame>, <sigvalue>
  % The new transition is implicitly after the last transition for that
  % signal. Clock signals on which this depends are extended as far as
  % necessary. Dependencies are stored globally in mdl.depends.
  signame = varargin{1};
  newval = varargin{2};
  if ~isfield(mdl.signals, signame)
    error('Invalid signal "%s" in transition', signame);
  end
  % Tnext will be the time when this transition begins, and we will
  % arbitrarily make it no earlier than 1 more than the end of the
  % last transition. It could be equal to the last transition...
  Tnext = mdl.signals.(signame).transitions(end,1)+1;
  argno = 3;
  while argno <= length(varargin)
    option = varargin{argno};
    if strcmpi(option,'after')
      if argno == length(varargin)
        error('transition option "after" requires arguments');
      end
      event = varargin{argno+1};
      if isnumeric(event)
        if event > Tnext
          Tnext = event;
        end
        argno = argno + 2;
      else
        depsig = event;
        if argno+2 > length(varargin)
          error('transition after signame requires value');
        end
        depsigval = varargin{argno+2};
        if ~isfield(mdl.signals, depsig)
          error('Unknown signal "%" in transition after', depsig);
        end
        % %%%### Now search
      end
    else
      error('Unknown transition option: "%s"', option);
    end
  end
elseif strcmpi(option,'render')
else
  error('Unrecognized option: %s', option);
end
