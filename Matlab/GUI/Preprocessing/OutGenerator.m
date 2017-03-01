function varargout = OutGenerator(varargin)
% Before using this GUI Downlaod EEGlab toolbox (https://sccn.ucsd.edu/eeglab/) and 
% NeuralGenOut.m 
%


% OUTGENERATOR MATLAB code for OutGenerator.fig
%      OUTGENERATOR, by itself, creates a new OUTGENERATOR or raises the existing
%      singleton*.
%
%      H = OUTGENERATOR returns the handle to a new OUTGENERATOR or the handle to
%      the existing singleton*.
%
%      OUTGENERATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OUTGENERATOR.M with the given input arguments.
%
%      OUTGENERATOR('Property','Value',...) creates a new OUTGENERATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OutGenerator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OutGenerator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OutGenerator

% Last Modified by Bahar Khlaighinejad (bk2556@columbia.edu) v2.5 30-Jul-2016 17:48:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @OutGenerator_OpeningFcn, ...
    'gui_OutputFcn',  @OutGenerator_OutputFcn, ...
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


% --- Executes just before OutGenerator is made visible.
function OutGenerator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OutGenerator (see VARARGIN)

% Choose default command line output for OutGenerator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OutGenerator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OutGenerator_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in GenerateH.
function GenerateH_Callback(hObject, eventdata, handles)
% hObject    handle to GenerateH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Load, 'String', 'In Progress ...');
drawnow

channelnames=handles.channelnames;
elects=1:length(channelnames);
cond='htkraw';
new_cond='HighGamma';
datapath=handles.Path;
Blcks=handles.Blocks;%
for cnt=1:length(Blcks)
    Blck=Blcks{cnt};
    mkdir([datapath,Blck,'/',new_cond]);
    data=[];
    data_O=[];
    for cnt1 = elects
        cnt1
        [signal,Fs] = readhtk([datapath,Blck,'/' cond '/Ch' num2str(cnt1) '.htk']);
        if Fs~=1000
            error('ERROR');
        end
        %%%% WRITE THE FUNCTION HERE %%%%
        %signal=(signal(:)-mean(signal));%/std(signal(1:end));
        
       % data(cnt1,:)=signal;
        outf=100;
        data_O(cnt1,:) = EcogExtractHighGamma(signal, Fs, outf);
        %%% END Of Function
    end
    %%% Common average referencing
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Fs=100;
    for cnt1 = elects
        
        data_out=data_O(cnt1,:);
        writehtk([datapath,Blck,'/',new_cond,'/Ch', num2str(cnt1) '.htk'],data_out,Fs);
    end
end

set(handles.Load, 'String', 'Done');
guidata(hObject,handles);


% --- Executes on button press in GenerateLFP.
function GenerateLFP_Callback(hObject, eventdata, handles)
% hObject    handle to GenerateLFP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Load, 'String', 'In Progress ...');
drawnow

channelnames=handles.channelnames;
elects=1:length(channelnames);
cond='htkraw';
new_cond='LFP';
datapath=handles.Path;
Blcks=handles.Blocks;%
for cnt=1:length(Blcks)
    Blck=Blcks{cnt};
    mkdir([datapath,Blck,'/',new_cond]);
    data=[];
    for cnt1 = elects
        [signal,Fs] = readhtk([datapath,Blck,'/' cond '/Ch' num2str(cnt1) '.htk']);
        if Fs~=1000
            error('ERROR');
        end
        %%%% WRITE THE FUNCTION HERE %%%%
        %signal=(signal(:)-mean(signal));%/std(signal(1:end));
        d=signal;
        
        fs=Fs;
        
        notchFreq=60;
        [b,a]=fir2(1000,[0 notchFreq-1 notchFreq-.5 notchFreq+.5 notchFreq+1 fs/2]/(fs/2),[1 1 0 0 1 1 ]);
        d=filtfilt(b,a,d')';
        
        d = resample(d,1,10);
        fs=100;
        
        % apply notch filter:

        
        
        data(cnt1,:)=d;
        %%% END Of Function
    end
    %%% Common average referencing
    outf=100;
    data_O = data;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Fs=100;
    for cnt1 = elects
        
        data_out=data_O(cnt1,:);
        writehtk([datapath,Blck,'/',new_cond,'/Ch', num2str(cnt1) '.htk'],data_out,Fs);
    end
end

set(handles.Load, 'String', 'Done');
guidata(hObject,handles);



% --- Executes on button press in SubjectFolder.
function SubjectFolder_Callback(hObject, eventdata, handles)
% hObject    handle to SubjectFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Load, 'String', 'In Progress ...');
drawnow

tmp = inputdlg('Specify subject name');
handles.SubjectName=tmp{1};
filepath=uigetdir(pwd,...
    'Select subject folder');

handles.Path = [filepath filesep];

tmp2 = strjoin(cellstr((get(handles.DataTxt, 'String'))),'\n');
Inf = sprintf('%s\n%s',tmp2,['SubjectName: ' handles.SubjectName '. Path is loaded: ' handles.Path]);
set(handles.DataTxt, 'String', Inf);

set(handles.Load, 'String', 'Done');

guidata(hObject,handles);


% --- Executes on button press in Blocks.
function Blocks_Callback(hObject, eventdata, handles)
% hObject    handle to Blocks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = get(handles.BlockEdit,'string')
handles.Blocks = strsplit(tmp,',');

tmp2 = strjoin(cellstr((get(handles.DataTxt, 'String'))),'\n');
Inf = sprintf('%s\n%s',tmp2,['Blocks are: ' tmp]);
set(handles.DataTxt, 'String', Inf);
guidata(hObject,handles);



function BlockEdit_Callback(hObject, eventdata, handles)
% hObject    handle to BlockEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BlockEdit as text
%        str2double(get(hObject,'String')) returns contents of BlockEdit as a double


% --- Executes during object creation, after setting all properties.
function BlockEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BlockEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Analog.
function Analog_Callback(hObject, eventdata, handles)
% hObject    handle to Analog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.analog=[get(handles.analogtxt,'String') '.htk'];
tmp2 = strjoin(cellstr((get(handles.DataTxt, 'String'))),'\n');
Inf = sprintf('%s\n%s',tmp2,['analog channel: ' handles.analog]);
set(handles.DataTxt, 'String', Inf);

guidata(hObject,handles);


function analogtxt_Callback(hObject, eventdata, handles)
% hObject    handle to analogtxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of analogtxt as text
%        str2double(get(hObject,'String')) returns contents of analogtxt as a double


% --- Executes during object creation, after setting all properties.
function analogtxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to analogtxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GenerateEvnt.
function GenerateEvnt_Callback(hObject, eventdata, handles)
% hObject    handle to GenerateEvnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Load, 'String', 'In Progress ...');
drawnow

evnt=NeuralFindEvent (handles.Path, handles.SoundPath, handles.SubjectName, handles.Blocks,[],handles.StimName,handles.analog);
handles.evnt=evnt;

tmp2 = strjoin(cellstr((get(handles.DataTxt, 'String'))),'\n');
Inf = sprintf('%s\n%s',tmp2,['Evnt is generated']);
set(handles.DataTxt, 'String', Inf);

set(handles.Load, 'String', 'Done');
guidata(hObject,handles);



% --- Executes on button press in SaveEvnt.
function SaveEvnt_Callback(hObject, eventdata, handles)
% hObject    handle to SaveEvnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uiputfile('*.mat','Save Event',handles.Path);
evnt= handles.evnt;

save([path,file],'evnt');
guidata(hObject,handles);


% --- Executes on button press in LoadEvnt.
function LoadEvnt_Callback(hObject, eventdata, handles)
% hObject    handle to LoadEvnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,path]=uigetfile(handles.Path,...
    'Select Event structure');
tmp=load([path,file]);
name=fieldnames(tmp);
handles.evnt=getfield(tmp,name{1});

tmp2 = strjoin(cellstr((get(handles.DataTxt, 'String'))),'\n');
Inf = sprintf('%s\n%s',tmp2,['Evnt is loaded']);
set(handles.DataTxt, 'String', Inf);

guidata(hObject,handles);


% --- Executes on button press in GenerateOut.
function GenerateOut_Callback(hObject, eventdata, handles)
% hObject    handle to GenerateOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.HighGammaBut,'value')==1
    cond{1}='HighGamma';
elseif get(handles.LFPBut,'value')==1
    cond{1}='LFP';
elseif get(handles.OtherBut,'value')==1
    cond{1}='EEG';
end
channelnames=handles.channelnames;
elects=1:length(channelnames);
befaft=[1 1];
dataf=100;
% only for online implementation
dataf=[];
% % % % % 

specflag='Auditory';
datatype='ECoG';
evnt=handles.evnt;
datapath=handles.Path;

out=NeuralGenOut(evnt, datapath, cond, elects, befaft, dataf, specflag, datatype);

handles.out=out;


tmp2 = strjoin(cellstr((get(handles.DataTxt, 'String'))),'\n');
Inf = sprintf('%s\n%s',tmp2,['Out structure is generated']);
set(handles.DataTxt, 'String', Inf);

guidata(hObject,handles);


% --- Executes on button press in SaveOut.
function SaveOut_Callback(hObject, eventdata, handles)
% hObject    handle to SaveOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uiputfile('*.mat','Save Event',handles.Path);
out= handles.out;

save([path,file],'out');
guidata(hObject,handles);

% --- Executes on button press in LFPBut.
function LFPBut_Callback(hObject, eventdata, handles)
% hObject    handle to LFPBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LFPBut


% --- Executes on button press in HighGammaBut.
function HighGammaBut_Callback(hObject, eventdata, handles)
% hObject    handle to HighGammaBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HighGammaBut



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SoundFolder.
function SoundFolder_Callback(hObject, eventdata, handles)
% hObject    handle to SoundFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filepath=uigetdir(pwd,...
    'Select sound folder');

handles.SoundPath = filepath;

tmp2 = strjoin(cellstr((get(handles.DataTxt, 'String'))),'\n');
Inf = sprintf('%s\n%s',tmp2,['Sound folder is loaded']);
set(handles.DataTxt, 'String', Inf);

set(handles.Load, 'String', 'Done');

guidata(hObject,handles);


% --- Executes on button press in SoundO.
function SoundO_Callback(hObject, eventdata, handles)
% hObject    handle to SoundO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = what(['@' get(handles.SoundTxt,'string')]);
handles.SoundPath = [tmp.path filesep 'Sounds'] ;

tmp2 = strjoin(cellstr((get(handles.DataTxt, 'String'))),'\n');
Inf = sprintf('%s\n%s',tmp2,['SoundPath is: ' handles.SoundPath]);
set(handles.DataTxt, 'String', Inf);


guidata(hObject,handles);



function SoundTxt_Callback(hObject, eventdata, handles)
% hObject    handle to SoundTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SoundTxt as text
%        str2double(get(hObject,'String')) returns contents of SoundTxt as a double


% --- Executes during object creation, after setting all properties.
function SoundTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SoundTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.DataTxt, 'String', []);
guidata(hObject,handles);


% --- Executes on button press in StimName.
function StimName_Callback(hObject, eventdata, handles)
% hObject    handle to StimName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=get(handles.StimTxt,'String');
handles.StimName=tmp;

tmp2 = strjoin(cellstr((get(handles.DataTxt, 'String'))),'\n');
Inf = sprintf('%s\n%s',tmp2,['Stim Name: ' handles.StimName]);
set(handles.DataTxt, 'String', Inf);


guidata(hObject,handles);


function StimTxt_Callback(hObject, eventdata, handles)
% hObject    handle to StimTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimTxt as text
%        str2double(get(hObject,'String')) returns contents of StimTxt as a double


% --- Executes during object creation, after setting all properties.
function StimTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LoadChannel.
function LoadChannel_Callback(hObject, eventdata, handles)
% hObject    handle to LoadChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,path]=uigetfile(handles.Path,...
    'Select subject folder');
tmp=load([path,file]);
name=fieldnames(tmp);
handles.channelnames=getfield(tmp,name{1});

tmp2 = strjoin(cellstr((get(handles.DataTxt, 'String'))),'\n');
Inf = sprintf('%s\n%s',tmp2,['Channelnames are loaded']);
set(handles.DataTxt, 'String', Inf);

guidata(hObject,handles);


% --- Executes on button press in custom.
function custom_Callback(hObject, eventdata, handles)
% hObject    handle to custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Load, 'String', 'In Progress ...');
drawnow

channelnames=handles.channelnames;
elects=1:length(channelnames);
cond='htkraw';
new_cond='2_15hz';
datapath=handles.Path;
Blcks=handles.Blocks;%
for cnt=1:length(Blcks)
    Blck=Blcks{cnt};
    mkdir([datapath,Blck,'/',new_cond]);
    data=[];
    for cnt1 = elects
        [signal,f] = readhtk([datapath,Blck,'/' cond '/Ch' num2str(cnt1) '.htk']);
        signal=signal+r2-((r1+r2)/2);
        if f~=2400
            error('ERROR');
        end
        

        %%%% WRITE THE FUNCTION HERE %%%%
        signal=(signal(:)-mean(signal))/std(signal(500:end));
        
        fs=2400;
        notchFreq=60;
        d=signal;
        notchFreq=120;
        [b,a]=fir2(1000,[0 notchFreq-1 notchFreq-.5 notchFreq+.5 notchFreq+1 fs]/(fs),[1 1 0 0 1 1 ]);
        d=filtfilt(b,a,d')';
        notchFreq=180;
        [b,a]=fir2(1000,[0 notchFreq-1 notchFreq-.5 notchFreq+.5 notchFreq+1 fs]/(fs),[1 1 0 0 1 1 ]);
        d=filtfilt(b,a,d')';
      
        signalnew=d;
        signalnew=resample(signal,1,24);
        f=100;
        filtered_data=eegfilt(signalnew',f,2,15,0,100);
        data_out=filtered_data;
        %%% END Of Function
        
        writehtk([datapath,Blck,'/',new_cond,'/Ch', num2str(cnt1) '.htk'],data_out,Fs);
        
    end
end

set(handles.Load, 'String', 'Done');
guidata(hObject,handles);
