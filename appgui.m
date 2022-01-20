function varargout = appgui(varargin)
% APPGUI MATLAB code for appgui.fig
%      APPGUI, by itself, creates a new APPGUI or raises the existing
%      singleton*.
%
%      H = APPGUI returns the handle to a new APPGUI or the handle to
%      the existing singleton*.
%
%      APPGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APPGUI.M with the given input arguments.
%
%      APPGUI('Property','Value',...) creates a new APPGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before appgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to appgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help appgui

% Last Modified by GUIDE v2.5 27-Dec-2021 00:45:34

% Begin initialization code - DO NOT EDIT
global I_white
I_white = uint8(ones(80,200)*255);
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @appgui_OpeningFcn, ...
                   'gui_OutputFcn',  @appgui_OutputFcn, ...
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


% --- Executes just before appgui is made visible.
function appgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to appgui (see VARARGIN)
h = handles.figure1; %获取句柄
newIcon = javax.swing.ImageIcon('.\Icon.png'); %读取图片文件
figFrame = get(h,'JavaFrame');
figFrame.setFigureIcon(newIcon);
% Choose default command line output for appgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes appgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = appgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in testCode_btn.
function testCode_btn_Callback(hObject, eventdata, handles)
% hObject    handle to testCode_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global str filename level bpnn lastfilename lastway change_level

if isequal(level,[])
    level = 0.9;
end
way = get(handles.way_num, 'value');
if filename == 0 
    h=warndlg('请先选择一张图片！','警告','modal');
    return
end
if isequal(lastfilename,filename) && way ==lastway && change_level == 0
    h=warndlg('请重新选择一张图片或方法！','警告','modal');
    return
end

load bp.mat
bpnn = net;
way = get(handles.way_num, 'value');
[resultCode,gray_I,BW_I,Med_I,bwarea_I,Idx] = testcode(bpnn,str,filename,false,way,level);
axes(handles.axes3);
imshow(gray_I);
axes(handles.axes4);
imshow(BW_I);
axes(handles.axes5);
imshow(Med_I);
axes(handles.axes6);
imshow(bwarea_I);
axes(handles.axes7);
imshow(bwarea_I);
[L,num] = bwlabel(bwarea_I,8); %找到图中的连通域，num为连通域数量
for i=1:num
    hold on
    plot([Idx(i,3),Idx(i,3)],[Idx(i,1),Idx(i,2)],'r--','LineWidth', 2);
    hold on
    plot([Idx(i,4),Idx(i,4)],[Idx(i,1),Idx(i,2)],'r--','LineWidth', 2);
    hold on
    plot([Idx(i,3),Idx(i,4)],[Idx(i,1),Idx(i,1)],'r--','LineWidth', 2);
    hold on
    plot([Idx(i,3),Idx(i,4)],[Idx(i,2),Idx(i,2)],'r--','LineWidth', 2);
end
code = '';
for i=1:length(resultCode)
    code =[code,num2str(resultCode(i))];
end
set(handles.result_edit,'String',code)
lastfilename = filename;
lastway = way;
change_level = 0;



function result_Callback(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of result as text
%        str2double(get(hObject,'String')) returns contents of result as a double


% --- Executes during object creation, after setting all properties.
function result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function level_num_Callback(hObject, eventdata, handles)
% hObject    handle to level_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of level_num as text
%        str2double(get(hObject,'String')) returns contents of level_num as a double


% --- Executes during object creation, after setting all properties.
function level_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to level_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global level change_level
level_temp = get(handles.level_num,'String');
if ~isequal(size(level_temp),[1 0])
    level = str2double(level_temp);
    msgbox('灰度值修改成功！', '提示');
    change_level = 1;
else
    h=warndlg('请输入数值！','警告','modal');
end

% --- Executes on button press in getCode_btn.
function getCode_btn_Callback(hObject, eventdata, handles)
% hObject    handle to getCode_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global codeinput codeoutput
path2 = get(handles.code_savepath,'String');
code_num = 20;
if size(path2) == [1 0]
    h=warndlg('请输入验证码存储路径！','警告','modal');
else
    code_num_temp = get(handles.code_num,'String');
    if ~isequal(size(code_num_temp),[1 0])
        code_num = str2num(code_num_temp);
    end
    getCode(codeinput,codeoutput,path2,code_num);
end


function code_srcpath_Callback(hObject, eventdata, handles)
% hObject    handle to code_srcpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of code_srcpath as text
%        str2double(get(hObject,'String')) returns contents of code_srcpath as a double


% --- Executes during object creation, after setting all properties.
function code_srcpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to code_srcpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function code_savepath_Callback(hObject, eventdata, handles)
% hObject    handle to code_savepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of code_savepath as text
%        str2double(get(hObject,'String')) returns contents of code_savepath as a double


% --- Executes during object creation, after setting all properties.
function code_savepath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to code_savepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function code_num_Callback(hObject, eventdata, handles)
% hObject    handle to code_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of code_num as text
%        str2double(get(hObject,'String')) returns contents of code_num as a double


% --- Executes during object creation, after setting all properties.
function code_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to code_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function train_rate_Callback(hObject, eventdata, handles)
% hObject    handle to train_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of train_rate as text
%        str2double(get(hObject,'String')) returns contents of train_rate as a double


% --- Executes during object creation, after setting all properties.
function train_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to train_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in train_rate_btn.
function train_rate_btn_Callback(hObject, eventdata, handles)
% hObject    handle to train_rate_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global input output X_trains y_trains X_tests y_tests
rate = get(handles.train_rate,'String');
if size(rate) == [1 0]
    h=warndlg('请输入训练样本占比！','警告','modal');
else
    rate = str2double(rate);
    load inputs.mat
    load outputs.mat
    input = inputs;
    output =outputs;
    split_train_test(input,output,10,rate);
    load X_train.mat
    load y_train.mat
    load X_test.mat
    load y_test.mat
    X_trains = X_train;
    y_trains = y_train;
    X_tests = X_test;
    y_tests = y_test;
end




function pathname_Callback(hObject, eventdata, handles)
% hObject    handle to pathname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pathname as text
%        str2double(get(hObject,'String')) returns contents of pathname as a double


% --- Executes during object creation, after setting all properties.
function pathname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pathname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pathname_btn.
function pathname_btn_Callback(hObject, eventdata, handles)
% hObject    handle to pathname_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathsrc
pathsrc = get(handles.pathname,'String');
if size(pathsrc) == [1 0]
    h=warndlg('请输入数据路径！','警告','modal');
else
    set(buildDataGui,'Visible','on')
end



% --- Executes on button press in test_btn.
function test_btn_Callback(hObject, eventdata, handles)
% hObject    handle to test_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global X_tests y_tests bpnn
[sum_N,wrong,rightRate] = testbp(X_tests,y_tests,bpnn);
set(handles.test_Num,'String',sum_N);
set(handles.wrong_Num,'String',wrong);
set(handles.right_rate,'String',rightRate);


function test_Num_Callback(hObject, eventdata, handles)
% hObject    handle to test_Num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of test_Num as text
%        str2double(get(hObject,'String')) returns contents of test_Num as a double


% --- Executes during object creation, after setting all properties.
function test_Num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to test_Num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wrong_Num_Callback(hObject, eventdata, handles)
% hObject    handle to wrong_Num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wrong_Num as text
%        str2double(get(hObject,'String')) returns contents of wrong_Num as a double


% --- Executes during object creation, after setting all properties.
function wrong_Num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wrong_Num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function right_rate_Callback(hObject, eventdata, handles)
% hObject    handle to right_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of right_rate as text
%        str2double(get(hObject,'String')) returns contents of right_rate as a double


% --- Executes during object creation, after setting all properties.
function right_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to right_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function show_Callback(hObject, eventdata, handles)
% hObject    handle to show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of show as text
%        str2double(get(hObject,'String')) returns contents of show as a double


% --- Executes during object creation, after setting all properties.
function show_CreateFcn(hObject, eventdata, handles)
% hObject    handle to show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function goal_Callback(hObject, eventdata, handles)
% hObject    handle to goal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of goal as text
%        str2double(get(hObject,'String')) returns contents of goal as a double


% --- Executes during object creation, after setting all properties.
function goal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to goal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function learnRate_Callback(hObject, eventdata, handles)
% hObject    handle to learnRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of learnRate as text
%        str2double(get(hObject,'String')) returns contents of learnRate as a double


% --- Executes during object creation, after setting all properties.
function learnRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to learnRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function epochs_Callback(hObject, eventdata, handles)
% hObject    handle to epochs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epochs as text
%        str2double(get(hObject,'String')) returns contents of epochs as a double


% --- Executes during object creation, after setting all properties.
function epochs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trainFn_Callback(hObject, eventdata, handles)
% hObject    handle to trainFn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trainFn as text
%        str2double(get(hObject,'String')) returns contents of trainFn as a double


% --- Executes during object creation, after setting all properties.
function trainFn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trainFn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function layer_n_Callback(hObject, eventdata, handles)
% hObject    handle to layer_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of layer_n as text
%        str2double(get(hObject,'String')) returns contents of layer_n as a double


% --- Executes during object creation, after setting all properties.
function layer_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layer_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in train_btn.
function train_btn_Callback(hObject, eventdata, handles)
% hObject    handle to train_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global X_trains y_trains bpnn
show1 = 20;
epochs1 = 1000;
goal1 = 0.001;
learnRate1 = 0.01;
trainFn1 = 'trainrp';
layer_n1 = 30;

show_temp = get(handles.show,'String');
epochs_temp = get(handles.epochs,'String');
goal_temp = get(handles.goal,'String');
learnRate_temp = get(handles.learnRate,'String');
trainFn_temp = get(handles.trainFn,'String');
layer_n_temp = get(handles.layer_n,'String');

if ~isequal(size(show_temp),[1 0])
    show1 = str2num(show_temp);
end
if ~isequal(size(epochs_temp),[1 0])
    epochs1 = str2num(epochs_temp);
end
if ~isequal(size(goal_temp),[1 0])
    goal1 = str2double(goal_temp);
end
if ~isequal(size(learnRate_temp),[1 0])
    learnRate1 = str2double(learnRate_temp);
end
if ~isequal(size(trainFn_temp),[1 0])
    trainFn1 = trainFn_temp;
end
if ~isequal(size(layer_n_temp),[1 0])
    layer_n1 = str2num(layer_n_temp);
end
trainbp(X_trains, y_trains,show1,epochs1,goal1,learnRate1,trainFn1,layer_n1);
load bp.mat
bpnn = net;


% --- Executes on button press in split_btn.
function split_btn_Callback(hObject, eventdata, handles)
% hObject    handle to split_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in bwarea_btn.
function bwarea_btn_Callback(hObject, eventdata, handles)
% hObject    handle to bwarea_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in med_btn.
function med_btn_Callback(hObject, eventdata, handles)
% hObject    handle to med_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in bw_btn.
function bw_btn_Callback(hObject, eventdata, handles)
% hObject    handle to bw_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in way_num.
function way_num_Callback(hObject, eventdata, handles)
% hObject    handle to way_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns way_num contents as cell array
%        contents{get(hObject,'Value')} returns selected item from way_num


% --- Executes during object creation, after setting all properties.
function way_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to way_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in gray_btn.
function gray_btn_Callback(hObject, eventdata, handles)
% hObject    handle to gray_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in choose_btn.
function choose_btn_Callback(hObject, eventdata, handles)
% hObject    handle to choose_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global str filename I_white
[filename,pathname]=uigetfile({'*.jpg'},'选择验证码图片');
if filename ~= 0
    str=[pathname,filename];
    img=imread(str);
    axes(handles.axes2);
    imshow(img);
    axes(handles.axes3);
    imshow(I_white);
    axes(handles.axes4);
    imshow(I_white);
    axes(handles.axes5);
    imshow(I_white);
    axes(handles.axes6);
    imshow(I_white);
    cla(handles.axes7);
    axes(handles.axes7);
    imshow(I_white);
    set(handles.result_edit,'String','')
end

% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2
set(gca,'XColor',get(gca,'Color')) ;% 这两行代码功能：将坐标轴和坐标刻度转为白色
set(gca,'YColor',get(gca,'Color'));
 
set(gca,'XTickLabel',[]); % 这两行代码功能：去除坐标刻度
set(gca,'YTickLabel',[]);
 


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3
set(gca,'XColor',get(gca,'Color')) ;% 这两行代码功能：将坐标轴和坐标刻度转为白色
set(gca,'YColor',get(gca,'Color'));
 
set(gca,'XTickLabel',[]); % 这两行代码功能：去除坐标刻度
set(gca,'YTickLabel',[]);
 


% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes4
set(gca,'XColor',get(gca,'Color')) ;% 这两行代码功能：将坐标轴和坐标刻度转为白色
set(gca,'YColor',get(gca,'Color'));
 
set(gca,'XTickLabel',[]); % 这两行代码功能：去除坐标刻度
set(gca,'YTickLabel',[]);


% --- Executes during object creation, after setting all properties.
function axes5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes5
set(gca,'XColor',get(gca,'Color')) ;% 这两行代码功能：将坐标轴和坐标刻度转为白色
set(gca,'YColor',get(gca,'Color'));
 
set(gca,'XTickLabel',[]); % 这两行代码功能：去除坐标刻度
set(gca,'YTickLabel',[]);


% --- Executes during object creation, after setting all properties.
function axes6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes6
set(gca,'XColor',get(gca,'Color')) ;% 这两行代码功能：将坐标轴和坐标刻度转为白色
set(gca,'YColor',get(gca,'Color'));
 
set(gca,'XTickLabel',[]); % 这两行代码功能：去除坐标刻度
set(gca,'YTickLabel',[]);


% --- Executes during object creation, after setting all properties.
function axes7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes7
set(gca,'XColor',get(gca,'Color')) ;% 这两行代码功能：将坐标轴和坐标刻度转为白色
set(gca,'YColor',get(gca,'Color'));
 
set(gca,'XTickLabel',[]); % 这两行代码功能：去除坐标刻度
set(gca,'YTickLabel',[]);


% --- Executes on button press in loadData.
function loadData_Callback(hObject, eventdata, handles)
% hObject    handle to loadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global input output X_trains y_trains X_tests y_tests
    load X_train.mat
    load y_train.mat
    load X_test.mat
    load y_test.mat
    load inputs.mat
    load outputs.mat
    input = inputs;
    output = outputs; 
    X_trains = X_train;
    y_trains = y_train;
    X_tests = X_test;
    y_tests = y_test;
    msgbox('数据导入成功！', '提示');


% --- Executes on button press in getCodeData.
function getCodeData_Callback(hObject, eventdata, handles)
% hObject    handle to getCodeData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global codeinput codeoutput I_white
path1 = get(handles.code_srcpath,'String');
if size(path1) == [1 0]
    h=warndlg('请输入数据路径！','警告','modal');
else
    buildCodeSet(path1);
    load codeInputs.mat
    load codeOutputs.mat
    codeinput = codeInputs;
    codeoutput = codeOutputs;  
end



function result_edit_Callback(hObject, eventdata, handles)
% hObject    handle to result_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of result_edit as text
%        str2double(get(hObject,'String')) returns contents of result_edit as a double


% --- Executes during object creation, after setting all properties.
function result_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to result_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
button=questdlg('你确定退出吗？','退出应用','是','否','是'); %内容，标题，选项，默认选项
if strcmp(button,'是')
      delete(hObject);
      clear global
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global filename change_level
filename = 0;
change_level = 1;



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
