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

% Last Modified by GUIDE v2.5 26-Oct-2007 08:51:51

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
handles.data.index = 0;
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
  set( handles.start_btn, 'String', 'Start');
  guidata(hObject, handles);
  return;
end
% could use the lock file to determine where to set index
files = dir('LOG/ssp_*.lock');
if length(files) > 1
  error('More than one lock file found');
end
if length(files) == 0
  errordlg('No lock file found: start ssp_log first');
  return;
else
  tokens = regexp(files.name, 'ssp_(\d+).lock','tokens' );
  if length(tokens) ~= 1
    error('Expected 1 token');
  end
  handles.data.index = str2num(tokens{1}{1})-1;
end
set( handles.start_btn, 'String', 'Stop');
guidata(hObject, handles);
index = handles.data.index+1;
while 1
  handles = guidata(hObject);
  if handles.data.stopped break; end
  % index = handles.data.index+1;
  path = mlf_path( 'LOG', index );
  lockfile = sprintf('LOG/ssp_%d.lock', index);
  if exist( path, 'file' ) && ~exist( lockfile, 'file')
    D = load(path);
    if ~handles.data.logging
      delete(path); % avoid wasting lots of disk space, could be optional
    end
    axes(handles.axes1);
    plot(D,'*');
    title(sprintf('Index %d', index));
    index = index+1;
  else
    pause( .1 );
  end
end
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
  cmd = 'ssp_cmd AE';
else
  cmd = 'ssp_cmd AD';
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

