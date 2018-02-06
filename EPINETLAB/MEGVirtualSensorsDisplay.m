function varargout = MEGVirtualSensorsDisplay(varargin)
% MEGVIRTUALSENSORSDISPLAY MATLAB code for MEGVirtualSensorsDisplay.fig
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MEGVirtualSensorsDisplay_OpeningFcn, ...
                   'gui_OutputFcn',  @MEGVirtualSensorsDisplay_OutputFcn, ...
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


% --- Executes just before MEGVirtualSensorsDisplay is made visible.
function MEGVirtualSensorsDisplay_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MEGVirtualSensorsDisplay (see VARARGIN)

% Choose default command line output for MEGVirtualSensorsDisplay
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MEGVirtualSensorsDisplay wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function varargout = MEGVirtualSensorsDisplay_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function pushbutton1_Callback(hObject, eventdata, handles)
[fileName, filePath]= uiputfile('*.png', 'Save figure as');

if fileName == 0 
    return
end
fullName = fullfile(filePath,fileName);
set(gcf,'PaperPositionMode','auto')
print('-dpng','-r0', fullName)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
delete(gcf)
