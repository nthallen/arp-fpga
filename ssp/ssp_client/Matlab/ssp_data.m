function varargout = ssp_data(varargin)
% SSP_DATA M-file for ssp_data.fig
%      SSP_DATA, by itself, creates a new SSP_DATA or raises the existing
%      singleton*.
%
%      H = SSP_DATA returns the handle to a new SSP_DATA or the handle to
%      the existing singleton*.
%
%      SSP_DATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SSP_DATA.M with the given input arguments.
%
%      SSP_DATA('Property','Value',...) creates a new SSP_DATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ssp_data_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ssp_data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ssp_data

% Last Modified by GUIDE v2.5 01-May-2008 13:48:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ssp_data_OpeningFcn, ...
                   'gui_OutputFcn',  @ssp_data_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ssp_data is made visible.
function ssp_data_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ssp_data (see VARARGIN)

% Choose default command line output for ssp_data
handles.output = hObject;
handles.data.index = 1;
handles.data.stopped = 1;
handles.data.logging = 0;
set(handles.PAOOR, 'Visible','off');
set(handles.CAOVF, 'Visible','off');
NF = (1:32)';
MSPSstr = cellstr(num2str(100./NF,'%.2f'));
set(handles.NF,'String',MSPSstr,'Value', 20);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ssp_data wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ssp_data_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_btn.
function start_btn_Callback(hObject, eventdata, handles)
% hObject    handle to start_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.stopped = ~handles.data.stopped;
if handles.data.stopped
  set(hObject,'enable','off');
  system('start ssp_cmd DA');
  guidata(hObject, handles);
  return;
end
% could use the lock file to determine where to set index
NF = get(handles.NF,'Value');
handles.data.fsample = 100e6/NF;
NS = round(str2double(get(handles.NS, 'String')));
NA = round(str2double(get(handles.NA, 'String')));
if NA > 256
  NA = 256;
elseif NA < 1
  NA = 1;
end
set(handles.NA, 'String', sprintf('%d', NA));

NC = round(str2double(get(handles.NC, 'String')));
if NC > 16383
  NC = 16383;
elseif NC < 1
  NC = 1;
end
set(handles.NC, 'String', sprintf('%d', NC));

NE = get(handles.Ch0,'Value') + ...
     2 * get(handles.Ch1,'Value') + ...
     4 * get(handles.Ch2,'Value');
if NE == 0
  set(handles.Ch0, 'Value', 1);
  NE = 1;
end

NCh = [ 1 1 2 1 2 2 3 ];

x = (1:NS)';
x2 = (1:NS/2)';
f_fft = (x2-1)*handles.data.fsample/(NA*NS);
W = (1 - (2*x/NS - 1).^2) * ones(1, NCh(NE)); % Welch window
TC = TriggerSource_Command(handles);
IX = handles.data.index;
cmd = sprintf('start ssp_log NS:%d NA:%d NC:%d NF:%d NE:%d %s IX:%d', ...
  NS, NA, NC, NF, NE, TC, IX);
fprintf(1, '%s\n', cmd );
set(handles.NS, 'enable', 'off');
set(handles.NA, 'enable', 'off');
set(handles.NC, 'enable', 'off');
set(handles.NF, 'enable', 'off');
set(handles.Ch0, 'enable', 'off');
set(handles.Ch1, 'enable', 'off');
set(handles.Ch2, 'enable', 'off');
set(handles.CAOVF, 'visible','off');
set(handles.PAOOR, 'visible','off');
PAOOR = 0;
CAOVF = 0;
if ~exist('CPCI14','dir')
  mkdir('CPCI14');
end
if ~exist('CPCI14/ssp.log','file')
  ssp_log_fd = fopen('CPCI14/ssp.log','a');
  if ssp_log_fd < 0
    error('Unable to create CPCI14/ssp.log');
  end
  fclose(ssp_log_fd);
end
ssp_log_fd = fopen('CPCI14/ssp.log', 'r');
if ( ssp_log_fd < 0 )
  errordlg('Could not read CPCI14/ssp.log');
  return;
end
fseek(ssp_log_fd, 0, 'eof'); % seek to the end

system(cmd);
pause(1);
% files = dir('CPCI14/ssp_*.lock');
% if length(files) > 1
%   errordlg('More than one lock file found');
%   return;
% end
% if length(files) == 0
%   errordlg('No lock file found: start ssp_log first');
%   return;
% else
%   tokens = regexp(files.name, 'ssp_(\d+).lock','tokens' );
%   if length(tokens) ~= 1
%     error('Expected 1 token');
%   end
%   handles.data.index = str2num(tokens{1}{1})-1;
%   fprintf(1,'Saw lock file: "%s" setting index to %d\n', files.name, ...
%       handles.data.index );
% end
set( handles.start_btn, 'String', 'Stop');
guidata(hObject, handles);
index = handles.data.index;
SN = -1;
while 1
  handles = guidata(hObject);
  path = mlf_path( 'CPCI14', index );
  lockfile = sprintf('CPCI14/ssp_%d.lock', index);
  if exist( path, 'file' ) && ~exist( lockfile, 'file')
    D = loadbin(path);
    fseek(ssp_log_fd, ftell(ssp_log_fd), 'bof');
    hdrline = fgetl(ssp_log_fd);
    H = sscanf(hdrline,'%g');
    if length(H) < 13
      error('Short header');
    end
    hdr = struct( 'N', index, 'LN', H(2), 'T', H(1), ...
      'NWordsHdr', H(3), ...
      'FormatVersion', H(4), ...
      'NChannels', H(5), ...
      'NSamples', H(6), ...
      'NCoadd', H(7), ...
      'NAvg', H(8)+1, ...
      'NSkL', H(9), ...
      'NSkP', H(10), ...
      'ScanNum', H(11), ...
      'Spare', H(12), ...
      'OVF', H(13));
    if size(D,1) ~= hdr.NSamples
      error('Incorrect scan length: cpci: %d NS:%d NCh:%d len:%d', ...
        index, NS, hdr.NChannels, size(D,1));
    end
    if hdr.NChannels ~= NCh(NE)
      error('cpci %d: Header NChannels(%d) does not match request(%d)', ...
        index, hdr.NChannels, NCh(NE) );
    end
    if size(D,2) ~= hdr.NChannels
      error('cpci %d: Header NCh(%d) does not match array width(%d)', ...
        index, hdr.NChannels, size(D,2));
    end
    if hdr.NSamples ~= NS
      error('Incorrect NSamples: %d/%d', hdr.NSamples, NS );
    end
    if hdr.NAvg ~= NA
      error('Incorrect NAvg: %d/%d', hdr.NAvg, NA );
    end
    if hdr.NCoadd ~= NC
      error('Incorrect NCoadd: %d/%d', hdr.NCoadd, NC );
    end
    newSN = hdr.ScanNum;
    if SN >= 0
      dSN = newSN-SN;
      set(handles.dSN,'string',sprintf('%d',dSN));
    end
    SN = newSN;
    if ~handles.data.logging
      delete(path);
    end

    axes(handles.axes1);
    if get(handles.FFT,'Value')
      F = abs(fft(D.*W));
      loglog(f_fft, F(x2,:)*2/NS);
      ylim([.8/(hdr.NAvg*hdr.NCoadd) 32768]);
      set(gca,'ygrid','on');
    else
      plot(D,'*');
      ylim([-32767 32768]);
      xlim([1 length(D)]);
    end
    title(sprintf('Index %d', index));
    index = index+1;

    new_PAOOR = bitand(hdr.OVF,448) ~= 0;
    if new_PAOOR ~= PAOOR
      if new_PAOOR
        set( handles.PAOOR,'visible','on');
      else
        set( handles.PAOOR,'visible','off');
      end
      PAOOR = new_PAOOR;
    end

    new_CAOVF = bitand(hdr.OVF,7) ~= 0;
    if new_CAOVF ~= CAOVF
      if new_CAOVF
        set( handles.CAOVF,'visible','on');
      else
        set( handles.CAOVF,'visible','off');
      end
      CAOVF = new_CAOVF;
    end
  elseif handles.data.stopped && ~exist('CPCI14/ssp_log.pid','file')
    break;
  else
    pause( .1 );
  end
end
set( handles.start_btn, 'String', 'Start');
set( hObject, 'enable', 'on');
set( handles.NS, 'enable', 'on');
set( handles.NA, 'enable', 'on');
set( handles.NC, 'enable', 'on');
set( handles.NF, 'enable', 'on');
set( handles.Ch0, 'enable', 'on');
set( handles.Ch1, 'enable', 'on');
set( handles.Ch2, 'enable', 'on');
handles.data.index = index;
guidata(hObject,handles);



% --- Executes on button press in Auto.
function Auto_Callback(hObject, eventdata, handles)
% hObject    handle to Auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Auto
isauto = get(hObject,'Value');
if isauto
  cmd = 'start ssp_cmd AE';
else
  cmd = 'start ssp_cmd AD';
end
[status,result] = system(cmd);


% --- Executes on button press in Log.
function Log_Callback(hObject, eventdata, handles)
% hObject    handle to Log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Log
handles.data.logging = get(hObject,'Value');
guidata(hObject, handles);

function cmd = TriggerSource_Command(handles)
trigsrc = get(handles.TriggerSource,'Value') - 1;
triglevel = round(get(handles.triglevel,'Value'));
trigrising = get(handles.TrigRising,'Value');
trcmds = { 'TU', 'TD' };
cmd = sprintf('TS:%d %s:%d', trigsrc, trcmds{trigrising}, triglevel);

% --- Executes on selection change in TriggerSource.
function TriggerSource_Callback(hObject, eventdata, handles)
% hObject    handle to TriggerSource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns TriggerSource contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TriggerSource
cmd = TriggerSource_Command(handles);
if length(cmd)
    fprintf(1,'Trigger command: "%s"\n', cmd);
    [status,result] = system(sprintf('ssp_cmd %s', cmd));
    if status ~= 0
        errordlg(sprintf('system(%s) returned error', cmd));
    end
end

% --- Executes during object creation, after setting all properties.
function TriggerSource_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TriggerSource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on slider movement.
function triglevel_Callback(hObject, eventdata, handles)
% hObject    handle to triglevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
triglevel = round(get(handles.triglevel,'Value'));
set(handles.trigtext,'String',sprintf('%d',triglevel));
TriggerSource_Callback(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function triglevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to triglevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function trigtext_Callback(hObject, eventdata, handles)
% hObject    handle to trigtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trigtext as text
%        str2double(get(hObject,'String')) returns contents of trigtext as a double
triglevel = round(str2double(get(hObject,'String')));
if triglevel <= 32768 && triglevel > -32767
    set(handles.triglevel,'Value',triglevel);
    TriggerSource_Callback(hObject, eventdata, handles);
else
    errordlg('level value out of range');
end

% --- Executes during object creation, after setting all properties.
function trigtext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trigtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function NS_Callback(hObject, eventdata, handles)
% hObject    handle to NS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NS as text
%        str2double(get(hObject,'String')) returns contents of NS as a double


% --- Executes during object creation, after setting all properties.
function NS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in FFT.
function FFT_Callback(hObject, eventdata, handles)
% hObject    handle to FFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FFT



function NF_Callback(hObject, eventdata, handles)
% hObject    handle to NF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NF as text
%        str2double(get(hObject,'String')) returns contents of NF as a double


% --- Executes during object creation, after setting all properties.
function NF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NC_Callback(hObject, eventdata, handles)
% hObject    handle to NC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NC as text
%        str2double(get(hObject,'String')) returns contents of NC as a double


% --- Executes during object creation, after setting all properties.
function NC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NA_Callback(hObject, eventdata, handles)
% hObject    handle to NA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NA as text
%        str2double(get(hObject,'String')) returns contents of NA as a double


% --- Executes during object creation, after setting all properties.
function NA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in Ch0.
function Ch0_Callback(hObject, eventdata, handles)
% hObject    handle to Ch0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Ch0


% --- Executes on selection change in TrigRising.
function TrigRising_Callback(hObject, eventdata, handles)
% hObject    handle to TrigRising (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns TrigRising contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TrigRising
TriggerSource_Callback(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function TrigRising_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TrigRising (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Ch1.
function Ch1_Callback(hObject, eventdata, handles)
% hObject    handle to Ch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Ch1


% --- Executes on button press in Ch2.
function Ch2_Callback(hObject, eventdata, handles)
% hObject    handle to Ch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Ch2


