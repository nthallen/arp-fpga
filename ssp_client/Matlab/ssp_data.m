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

% Last Modified by GUIDE v2.5 07-Nov-2007 15:36:58

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
handles.data.fsample = str2double(get(handles.MSPS,'String')) * 1e6;
NS = str2double(get(handles.NS, 'String'));
x = (1:NS)';
x2 = (1:NS/2)';
f_fft = (x2-1)*handles.data.fsample/NS;
W = 1 - (2*x/NS - 1).^2; % Welch window
TC = Trigger_Command(handles);
IX = handles.data.index;
cmd = sprintf('start ssp_log NS:%d %s IX:%d', NS, TC, IX);
fprintf(1, '%s\n', cmd );
set(handles.NS, 'enable', 'off');
system(cmd);
pause(1);
% files = dir('LOG/ssp_*.lock');
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
while 1
  handles = guidata(hObject);
  path = mlf_path( 'LOG', index );
  lockfile = sprintf('LOG/ssp_%d.lock', index);
  if exist( path, 'file' ) && ~exist( lockfile, 'file')
    D = load(path);
    if ~handles.data.logging
      delete(path); % avoid wasting lots of disk space, could be optional
    end
    axes(handles.axes1);
    if get(handles.FFT,'Value')
      F = abs(fft(D.*W));
      loglog(f_fft, F(x2)*2/NS);
      ylim([.8 32768]);
    else
      plot(D,'*');
      ylim([-32767 32768]);
      xlim([1 length(D)]);
    end
    title(sprintf('Index %d', index));
    index = index+1;
  elseif handles.data.stopped && ~exist('LOG/ssp_log.pid','file')
    break;
  else
    pause( .1 );
  end
end
set( handles.start_btn, 'String', 'Start');
set( hObject, 'enable', 'on');
set( handles.NS, 'enable', 'on');
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

function cmd = Trigger_Command(handles)
trigtypes = get(handles.Trigger,'String');
trigtype = trigtypes{get(handles.Trigger,'Value')};
triglevel = round(get(handles.triglevel,'Value'));
switch (trigtype)
    case 'External'
        cmd = 'TE';
    case 'Level Rising'
        cmd = sprintf('TU:%d', triglevel);
    case 'Level Falling'
        cmd = sprintf('TD:%d', triglevel);
    otherwise
        errordlg('Invalid Trigger Type');
        cmd = ''
end

% --- Executes on selection change in Trigger.
function Trigger_Callback(hObject, eventdata, handles)
% hObject    handle to Trigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Trigger contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Trigger
cmd = Trigger_Command(handles);
if length(cmd)
    fprintf(1,'Trigger command: "%s"\n', cmd);
    [status,result] = system(sprintf('ssp_cmd %s', cmd));
    if status ~= 0
        errordlg(sprintf('system(%s) returned error', cmd));
    end
end

% --- Executes during object creation, after setting all properties.
function Trigger_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Trigger (see GCBO)
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
trigtypes = get(handles.Trigger,'String');
trigtype = trigtypes{get(handles.Trigger,'Value')};
switch (trigtype)
    case 'External'
        return
    case { 'Level Rising', 'Level Falling' }
        Trigger_Callback(hObject, eventdata, handles);
    otherwise
        errordlg('Invalid Trigger Type');
        return;
end


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
    triglevel_Callback(hObject,eventdata,handles);
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



function MSPS_Callback(hObject, eventdata, handles)
% hObject    handle to MSPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MSPS as text
%        str2double(get(hObject,'String')) returns contents of MSPS as a double


% --- Executes during object creation, after setting all properties.
function MSPS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MSPS (see GCBO)
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


