function varargout = ilan(varargin)
% ILAN MATLAB code for ilan.fig
%      ILAN, by itself, creates a new ILAN or raises the existing
%      singleton*.
%
%      H = ILAN returns the handle to a new ILAN or the handle to
%      the existing singleton*.
%
%      ILAN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ILAN.M with the given input arguments.
%
%      ILAN('Property','Value',...) creates a new ILAN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ilan_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ilan_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ilan

% Last Modified by GUIDE v2.5 08-May-2018 07:45:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ilan_OpeningFcn, ...
                   'gui_OutputFcn',  @ilan_OutputFcn, ...
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


% --- Executes just before ilan is made visible.
function ilan_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ilan (see VARARGIN)

% Choose default command line output for ilan
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ilan wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ilan_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse_btn.
function browse_btn_Callback(hObject, eventdata, handles)
% hObject    handle to browse_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname]=uigetfile('*.*','Choose an image');
imageData=imread(strcat(pathname,filename));
%setappdata(handles.axes1,'imageData',imageData);
axes(handles.axes1);
imshow(imageData);
setappdata(handles.axes1,'imageData',imageData);

if(get(handles.aa_chb,'Value')==0)
    [center,radius] = findPupil(imageData);
    center = round(center,0);
    radius = round(radius,0);
    set(handles.xp_edit,'string',num2str(center(1)));
    set(handles.yp_edit,'string',num2str(center(2)));
    set(handles.rp_edit,'string',num2str(radius));
    axes(handles.axes2);
    imshow(imageData);
    h = viscircles(center,radius);
    
    [ci,cp,out] = thresh(imageData,110,160);
    ci = round(ci,0);
    set(handles.xi_edit,'string',num2str(ci(2)));
    set(handles.yi_edit,'string',num2str(ci(1)));
    set(handles.ri_edit,'string',num2str(ci(3)));
    h = viscircles([ci(2) ci(1)],ci(3));
else % else aa_chb uncheck
    axes(handles.axes2);
    imshow(imageData);
    [ci,cp,out] = thresh(imageData,110,160);
    ci = round(ci,0);
    cp = round(cp,0);
    
    set(handles.xp_edit,'string',num2str(cp(2)));
    set(handles.yp_edit,'string',num2str(cp(1)));
    set(handles.rp_edit,'string',num2str(cp(3)));
    h = viscircles([cp(2) cp(1)],cp(3));
    
    set(handles.xi_edit,'string',num2str(ci(2)));
    set(handles.yi_edit,'string',num2str(ci(1)));
    set(handles.ri_edit,'string',num2str(ci(3)));
    h = viscircles([ci(2) ci(1)],ci(3));
end

if(get(handles.aa_chb,'Value')==0)
    %[ring,parr]=normaliseiris(imageData,ci(1),ci(2),ci(3),center(1),center(2),radius,'normal.bmp',100,300);
    [ring,parr]=normaliseiris(imageData,ci(2),ci(1),ci(3),center(1),center(2),radius,'normal.bmp',100,300);
    parr=adapthisteq(parr);
    axes(handles.axes3);
    imshow(parr);
    
    parr = imresize(parr,[227 227]); % resize
    imageNormalize = cat(3, parr, parr, parr); % convert 2d image to 3d image
else
    %[ring,parr]=normaliseiris(imageData,ci(1),ci(2),ci(3),center(1),center(2),radius,'normal.bmp',100,300);
    [ring,parr]=normaliseiris(imageData,ci(2),ci(1),ci(3),center(1),center(2),radius,'normal.bmp',100,300);
    parr=adapthisteq(parr);
    axes(handles.axes3);
    imshow(parr);
    
    parr = imresize(parr,[227 227]); % resize
    imageNormalize = cat(3, parr, parr, parr); % convert 2d image to 3d image
end

setappdata(handles.axes3,'imageNormalize',imageNormalize);


disp(get(handles.aa_chb,'Value'));


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function xp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xp_edit as text
%        str2double(get(hObject,'String')) returns contents of xp_edit as a double


% --- Executes during object creation, after setting all properties.
function xp_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to yp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yp_edit as text
%        str2double(get(hObject,'String')) returns contents of yp_edit as a double


% --- Executes during object creation, after setting all properties.
function yp_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to rp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rp_edit as text
%        str2double(get(hObject,'String')) returns contents of rp_edit as a double


% --- Executes during object creation, after setting all properties.
function rp_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xi_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xi_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xi_edit as text
%        str2double(get(hObject,'String')) returns contents of xi_edit as a double


% --- Executes during object creation, after setting all properties.
function xi_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xi_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yi_edit_Callback(hObject, eventdata, handles)
% hObject    handle to yi_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yi_edit as text
%        str2double(get(hObject,'String')) returns contents of yi_edit as a double


% --- Executes during object creation, after setting all properties.
function yi_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yi_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ri_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ri_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ri_edit as text
%        str2double(get(hObject,'String')) returns contents of ri_edit as a double


% --- Executes during object creation, after setting all properties.
function ri_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ri_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in manual_btn.
function manual_btn_Callback(hObject, eventdata, handles)
% hObject    handle to manual_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in save_btn.
function save_btn_Callback(hObject, eventdata, handles)
% hObject    handle to save_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname]=uiputfile('*.*','save');
%imageData=imread(strcat(pathname,filename));
imageNormalize = getappdata(handles.axes3,'imageNormalize');
imwrite(imageNormalize,strcat(pathname,filename));
disp(strcat(pathname,filename))

% --- Executes on button press in aa_chb.
function aa_chb_Callback(hObject, eventdata, handles)
% hObject    handle to aa_chb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of aa_chb
