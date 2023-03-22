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

% Last Modified by GUIDE v2.5 14-Jul-2010 15:02:00

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
function ssp_data_OpeningFcn(hObject, ~, handles, varargin)
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
handles.data.rd_nskip = 10;
handles.data.rd_noff = 5;
handles.data.rd_cavlen = 10.00;
handles.data.rd_show_loss = 0;
handles.data.closing = 0;
set(handles.PAOOR, 'Visible','off');
set(handles.CAOVF, 'Visible','off');
NF = (1:32)';
MSPSstr = cellstr(num2str(100./NF,'%.2f'));
set(handles.NF,'String',MSPSstr,'Value', 20);
if strcmp(getenv('SSP_HOSTNAME'),'simulator')
    handles.data.logcmd = 'ssp_sim';
else
    handles.data.logcmd = 'ssp_log';
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ssp_data wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ssp_data_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_btn.
function start_btn_Callback(hObject, ~, handles)
% hObject    handle to start_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.data.stopped
  set(hObject,'enable','off');
  handles.data.stopped = 1;
  cyg_system('ssp_cmd DA');
  guidata(hObject, handles);
  return;
end
handles.data.stopped = 0;
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
if get(handles.Ringdown,'Value')
  RD = sprintf('RD:%d,%d ', handles.data.rd_nskip, ...
      handles.data.rd_noff );
  set(handles.FFT, 'enable', 'off');
else
  RD = '';
end
cmd = sprintf('%s %sNS:%d NA:%d NC:%d NF:%d NE:%d %s IX:%d', ...
  handles.data.logcmd, RD, NS, NA, NC, NF, NE, TC, IX);
fprintf(1, '%s\n', cmd );
set(handles.NS, 'enable', 'off');
set(handles.NA, 'enable', 'off');
set(handles.NC, 'enable', 'off');
set(handles.NF, 'enable', 'off');
set(handles.Ch0, 'enable', 'off');
set(handles.Ch1, 'enable', 'off');
set(handles.Ch2, 'enable', 'off');
set(handles.Ringdown, 'enable', 'off'); % and disable FFT above
set(handles.CAOVF, 'visible','off');
set(handles.PAOOR, 'visible','off');
PAOOR = 0;
CAOVF = 0;
if ~exist('LOG','dir')
  mkdir('LOG');
end
if ~exist('LOG/ssp.log','file')
  ssp_log_fd = fopen('LOG/ssp.log','a');
  if ssp_log_fd < 0
    error('Unable to create LOG/ssp.log');d
  end
  fclose(ssp_log_fd);
end
ssp_log_fd = fopen('LOG/ssp.log', 'r');
if ( ssp_log_fd < 0 )
  errordlg('Could not read LOG/ssp.log');
  return;
end
fseek(ssp_log_fd, 0, 'eof'); % seek to the end

% setup for ringdown plots
if get(handles.Ringdown, 'Value')
    rdx = (1:NS)';
    rdv = ((handles.data.rd_nskip+1):NS)';
    rddt = NF*NA/100;
    rdt = rddt * (0:length(rdv)-1)';
    rdlc = 1e12*handles.data.rd_cavlen/lightspeed;
    set(handles.axes1,'HitTest','off');
else
    set( handles.RD_readout, 'visible', 'off');
    set( handles.RD_units, 'visible','off');
end
% cmd
cyg_start(cmd);
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
SN = -1;
while 1
  handles = guidata(hObject);
  path = mlf_path( 'LOG', index );
  lockfile = sprintf('LOG/ssp_%d.lock', index);
  if exist( path, 'file' ) && ~exist( lockfile, 'file')
    D = loadbin(path);
    fseek(ssp_log_fd, ftell(ssp_log_fd), 'bof');
    hdrline = fgetl(ssp_log_fd);
    if isempty(hdrline)
        break;
    end
    try
        H = sscanf(hdrline,'%g');
    catch
        break;
    end
    if length(H) < 13
      error('Short header');
    end
    if H(4) == 0
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
    elseif H(4) == 1
      if length(H) < 15
        error('Short header');
      end
      hdr = struct( 'N', index, 'LN', H(2), 'T', H(1), ...
        'NWordsHdr', H(3), ...
        'FormatVersion', H(4), ...
        'NChannels', H(5), ...
        'NF', H(6), ...
        'NSamples', H(7), ...
        'NCoadd', H(8), ...
        'NAvg', H(9)+1, ...
        'NSkL', H(10), ...
        'NSkP', H(11), ...
        'ScanNum', H(12), ...
        'T_HtSink', H(13), ...
        'T_FPGA', H(14), ...
        'OVF', H(15));
      set( handles.T_FPGA, 'String', sprintf( '%.3f', hdr.T_FPGA) );
      set( handles.T_HtSink, 'String', sprintf( '%.3f', hdr.T_HtSink) );
      set( handles.temp_panel, 'Visible', 'On' );
    else
      error('Unsupported FormatVersion: %d', H(4));
    end
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
    if ~handles.data.stopped
        if get(handles.FFT,'Value')
            F = abs(fft(D.*W));
            loglog(f_fft, F(x2,:)*2/NS);
            ylim([.8/(hdr.NAvg*hdr.NCoadd) 32768]);
            set(gca,'ygrid','on');
        elseif get(handles.Ringdown, 'Value')
            if length(H) ~= 15 + 4*hdr.NChannels
                error('Incorrect header length');
            end
            F = zeros(length(rdv),size(D,2));
            rdd = reshape(H(16:end),4,[])';
            if any(any(isnan(rdd)))
                plot(rdx,D);
                set(handles.axes1,'HitTest', 'off');
                set(handles.RD_readout,'String', 'NaN',...
                    'visible','on');
            else
                for i=1:size(D,2)
                    tau = rdd(i,1);
                    dtau = rdd(i,2);
                    b = rdd(i,3);
                    a = rdd(i,4);
                    z = a./(1-b);
                    fit = exp(-rdt/tau);
                    k = sum(fit.*(D(rdv,i)-z))/sum(fit.*fit);
                    F(:,i) = k*fit + z;
                end
                plot(rdx,D,'*',rdv,F,'r');
                set(handles.axes1,'HitTest','off');
                xlim([1 length(D)]);
                ylim([min([min(min(D)) min(min(F))]) ...
                      max([max(max(D)) max(max(F))]) ]);
                if handles.data.rd_show_loss
                    set(handles.RD_readout,'String', ...
                        sprintf('%.1f', rdlc/rdd(1,1) ), ...
                        'visible','on' );
                    set(handles.RD_units,'String','ppm','visible','on');
                else
                    str = sprintf('%.1f', rdd(1,1) );
                    set(handles.RD_readout,'String', str, ...
                        'visible','on' );
                    set(handles.RD_units,'String', 'usec', ...
                        'visible','on' );
                end
            end
        else
            plot(D,'*');
            ylim([-32767 32768]);
            xlim([1 length(D)]);
        end

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
        title(sprintf('Index %d', index));
    end
    index = index+1;
  elseif handles.data.stopped && ~exist('LOG/ssp_log.pid','file')
    break;
  else
    pause( .1 );
  end
end
fclose(ssp_log_fd);
set( handles.start_btn, 'String', 'Start');
set( hObject, 'enable', 'on');
set( handles.NS, 'enable', 'on');
set( handles.NA, 'enable', 'on');
set( handles.NC, 'enable', 'on');
set( handles.NF, 'enable', 'on');
set( handles.Ch0, 'enable', 'on');
set( handles.Ch1, 'enable', 'on');
set( handles.Ch2, 'enable', 'on');
set( handles.FFT, 'enable', 'on');
set( handles.Ringdown, 'enable', 'on');
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
cyg_system(cmd);


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
if ~isempty(cmd)
    fprintf(1,'Trigger command: "%s"\n', cmd);
    cyg_system(sprintf('ssp_cmd %s', cmd));
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
if get(hObject,'Value')
  set(handles.Ringdown, 'Value', 0);
  guidata(hObject, handles);
end



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


% --- Executes on button press in Ringdown.
function Ringdown_Callback(hObject, eventdata, handles)
% hObject    handle to Ringdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Ringdown
if get(hObject,'Value')
  set(handles.FFT,'Value',0);
  guidata(hObject,handles);
end

function RingdownProp_Callback(hObject, eventdata, handles)
if handles.data.stopped
  set(handles.RDProps,'enable','on');
else
  set(handles.RDProps,'enable','off');
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function RDProps_Callback(hObject, eventdata, handles)
% hObject    handle to RingdownProp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ssk = sprintf('%d', handles.data.rd_nskip);
soff = sprintf('%d', handles.data.rd_noff);
slen = sprintf('%.2f', handles.data.rd_cavlen);
result = inputdlg({'N Points to Skip', 'N Points Offset:', 'Cavity Length:' }, ...
    'Ringdown Properties',1,{ssk, soff, slen});
if length(result) == 3
    nsk = round(str2double(result{1}));
    noff = round(str2double(result{2}));
    nlen = str2double(result{3});
    warnings = {};
    if nsk < 0
        warnings = [ warnings 'NSkip value is invalid' ];
    else
        handles.data.rd_nskip = nsk;
    end
    if noff <= 0
        warnings = [ warnings 'NOffset value is invalid' ];
    else
        handles.data.rd_noff = noff;
    end
    if nlen <= 0
        warnings = [ warnings 'Cavity Length value is invalid' ];
    else
        handles.data.rd_cavlen = nlen;
    end
    if ~isempty(warnings)
        warndlg(warnings,'rdwarn', 'replace');
    end
    guidata(hObject,handles);
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over RD_readout.
function RD_readout_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to RD_readout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.rd_show_loss = ~handles.data.rd_show_loss;
guidata(hObject,handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if handles.data.stopped
    if handles.data.closing || strcmp( get(handles.start_btn,'enable'), 'on' )
        delete(hObject);
    else
        handles.data.closing = 1;
        guidata(hObject,handles);
    end
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over RD_units.
function RD_units_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to RD_units (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RD_readout_ButtonDownFcn(hObject, eventdata, handles);

function cyg_system(cmd)
fullcmd = sprintf('%s -c "/usr/local/bin/ssp_wrapper.sh %s"', 'c:\cygwin64\bin\bash', cmd);
[status] = system(fullcmd);
if status ~= 0
  errordlg(sprintf('system(%s) returned error', fullcmd));
end

function cyg_start(cmd)
fullcmd = sprintf('start %s -c "/usr/local/bin/ssp_wrapper.sh %s"', 'c:\cygwin64\bin\bash', cmd);
[status,result] = system(fullcmd);
if status ~= 0
  errordlg(sprintf('system(%s) returned error', fullcmd));
end
