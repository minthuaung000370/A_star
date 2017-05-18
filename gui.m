function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 15-May-2017 03:25:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)
% Clear all stored values
    if ( isappdata(0, 'startPos') )
        rmappdata(0, 'startPos');
    end
    if ( isappdata(0, 'finishPos') )
        rmappdata(0, 'finishPos');
    end
    if ( isappdata(0, 'whichList') )
        rmappdata(0, 'whichList');
    end
    if ( isappdata(0, 'figHandle') )
        rmappdata(0, 'figHandle');
    end
    if ( isappdata(0, 'objMap') )
        rmappdata(0, 'objMap');
    end
    if ( isappdata(0, 'mapSize') )
        rmappdata(0, 'mapSize');
    end
    if ( isappdata(0, 'specOption') )
    	getappdata(0, 'specOption');
    end
    % Set the window position
    tempPos = get(gcf, 'Position');
    set(gcf, 'Position', [20 35 tempPos(3) tempPos(4)]);
    
handles.output = hObject;
% Deselect specify and type
set(handles.specifypanel,'SelectedObject',[]); %No selection
%on change use appropriate callbacks
set(handles.specifypanel,'SelectionChangeFcn',@specify_CallBack);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Executes on change in selection on specifypanel.
function specify_CallBack(hObject, eventdata)
    handles = guidata(hObject);
    
    % get the figure handle
    figHandle = getappdata(0, 'figHandle');
    
    setappdata(0, 'handles', handles);
    
    % See which field is selected
    switch get(eventdata.NewValue, 'Tag')
        case 'startradio'
            % Set the option to 1 - Start
            specOption = 1;
            % Store specOption
            setappdata(0, 'specOption', specOption);
            
            % Call the function if mouse is pressed
            set(figHandle, 'WindowButtonDownFcn',@figButton_CallBack);
           
        case 'finishradio'
            % Set the option to 1 - Finish
            specOption = 2;
            % Store specOption
            setappdata(0, 'specOption', specOption);
            % Call the function if mouse is pressed
            set(figHandle, 'WindowButtonDownFcn',@figButton_CallBack);

        case 'obstacleradio'
            % Set the option to 1 - Obstacle
            specOption = 3;
            % Store specOption
            setappdata(0, 'specOption', specOption);
            % Call the function if mouse is pressed
            set(figHandle, 'WindowButtonDownFcn',@figButton_CallBack); 
    end

function figButton_CallBack(hObject, eventdata)
    %get the figure handle, specOption and ObjMap
    figHandle=getappdata(0,'figHandle');
    specOption=getappdata(0,'specOption');
    objMap=getappdata(0,'objMap');
    %find min and max of objMap
    minObjMap=min(min(objMap));
    maxObjMap=max(max(objMap));
    tempObj=get(figHandle,'CurrentObject');
    if((tempObj>=minObjMap)&&(tempObj<=maxObjMap))
        [x y]=find(objMap==tempObj);
        whichList=getappdata(0,'whichList');
        %set walkable and unwalkable 'constants'
        walkable= 1;
        unwalkable= 4;
        
        switch specOption
            case 1
                %if startposition has been defined previously
                if(isappdata(0,'startPos'))
                    %get start position
                    startPos=getappdata(0,'startPos');
                    %if it's the same point
                    if((x==startPos(1)) && (y==startPos(2)))
                        %remove the point
                        set(tempObj,'FaceColor','white');
                        rmappdata(0,'startPos');
                    elseif (isappdata(0,'finishPos'))
                        finishPos=getappdata(0,'finishPos');
                        %if it's instead of finish point
                        if((x==finishPos(1))&&(y==finishPos(2)))
                            %find coordinates of previous startpos
                            prevStartPos=getappdata(0,'startPos');
                            set(objMap(prevStartPos(1),prevStartPos(2)),'FaceColor','white');
                            %set new one and remove finishPos
                            set(tempObj,'FaceColor','green');
                            startPos(1)=x;
                            startPos(2)=y;
                            setappdata(0,'startPos',startPos);
                            rmappdata(0,'finishPos')
                        else
                            %find coordinates of previous startPos
                            prevStartPos=getappdata(0,'startPos');
                            set(objMap(prevStartPos(1),prevStartPos(2)),'FaceColor','white');
                            %set new startpoint
                            set(tempObj,'FaceColor','green');
                            startPos(1)=x;
                            startPos(2)=y;
                            setappdata(0,'startPos',startPos);
                        end
                    %if obstacle is located at the location
                    elseif (whichList(x,y)==unwalkable)
                        %find coordinates of previous startpos
                        prevStartPos=getappdata(0,'startPos');
                        set(objMap(prevStartPos(1),prevStartPost(2)),'FaceColor','white');
                        %set new startpoint
                        set(tempObj,'FaceColor','green');
                        startPos(1)=x;
                        startPos(2)=y;
                        setappdata(0,'startPos',startPos);
                        %set the point as walkable and store matrix
                        whichList(x,y)=walkable;
                        setappdata(0,'whichList',whichList);
                    %if new start pos is on neutral spot
                    else
                        %remove previous start position and assign new
                        %find coordinates of previous startpos
                        prevStartPos=getappdata(0,'startPos');
                        set(objMap(prevStartPos(1),prevStartPos(2)),'FaceColor','white');
                        %start new startPos
                        set(tempObj,'FaceColor','green');
                        startPos(1)=x;
                        startPos(2)=y;
                        setappdata(0,'startPos',startPos);
                    end
                %if finish position is set
                elseif(isappdata(0,'finishPos'))
                    finishPos=getappdata(0,'finishPos');
                    %if it's instead of finish point
                    if((x==finishPos(1))&&(y==finishPos(2)))
                        %set new one and remove finishPos
                        set(tempObj,'FaceColor','green');
                        startPos(1)=x;
                        startPos(2)=y;
                        setappdata(0,'startPos',startPos);
                        rmappdata(0,'finishPos');
                    else
                        %set new startpoint
                        set(tempObj,'FaceColor','green');
                        startPos(1)=x;
                        startPos(2)=y;
                        setappdata(0,'startPos',startPos);
                    end
                %if it's instead of obstacle
                elseif(whichList(x,y) == unwalkable)
                    % Set new startPoint
                    set(tempObj, 'FaceColor', 'green');
                    startPos(1) = x;
                    startPos(2) = y;
                    setappdata(0, 'startPos', startPos);
                    % Set the point as walkable and store matrix
                    whichList(x,y) = walkable;
                    setappdata(0, 'whichList', whichList);
                % If no start or finish position was previously defined
                else
                    set(tempObj, 'FaceColor', 'green');
                    startPos(1) = x;
                    startPos(2) = y;
                    setappdata(0, 'startPos', startPos);
                end
                
            case 2
                   % If finishPosition has been defined previously
                if (isappdata(0, 'finishPos')),
                    % Get finish position
                    finishPos = getappdata(0, 'finishPos');
                    % If it's the same point
                    if ( (x == finishPos(1)) && (y == finishPos(2)) )
                        % Remove the point
                        set(tempObj, 'FaceColor', 'white');
                        rmappdata(0, 'finishPos');
                    % Check if start point is present
                    elseif ( isappdata(0, 'startPos') )
                        startPos = getappdata(0, 'startPos');
                        % If it's instead of start point
                        if ( (x == startPos(1)) && (y == startPos(2)) )
                            % Find coordinates of previous finishPos
                            prevFinishPos = getappdata(0, 'finishPos');
                            set(objMap(prevFinishPos(1),prevFinishPos(2)), 'FaceColor', 'white');
                            % Set new one and remove startPos
                            set(tempObj, 'FaceColor', 'red');
                            finishPos(1) = x;
                            finishPos(2) = y;
                            setappdata(0, 'finishPos', finishPos);
                            rmappdata(0, 'startPos');
                        else
                            % Find coordinates of previous finishPos
                            prevFinishPos = getappdata(0, 'finishPos');
                            set(objMap(prevFinishPos(1),prevFinishPos(2)), 'FaceColor', 'white');
                            % Set new finishPoint
                            set(tempObj, 'FaceColor', 'red');
                            finishPos(1) = x;
                            finishPos(2) = y;
                            setappdata(0, 'finishPos', finishPos);
                        end
                    % If obstacle is located at the location
                    elseif (whichList(x,y) == unwalkable)
                        % Find coordinates of previous finishPos
                        prevFinishPos = getappdata(0, 'finishPos');
                        set(objMap(prevFinishPos(1),prevFinishPos(2)), 'FaceColor', 'white');
                        % Set new finishPoint
                        set(tempObj, 'FaceColor', 'red');
                        finishPos(1) = x;
                        finishPos(2) = y;
                        setappdata(0, 'finishPos', finishPos);
                        % Set the point as walkable and store matrix
                        whichList(x,y) = walkable;
                        setappdata(0, 'whichList', whichList);
                    % If new finish pos is on neutral spot
                    else
                        % Remove previous finish position and assign new
                        % Find coordinates of previous finishPos
                        prevFinishPos = getappdata(0, 'finishPos');
                        set(objMap(prevFinishPos(1),prevFinishPos(2)), 'FaceColor', 'white');
                        % Set new finishPoint
                        set(tempObj, 'FaceColor', 'red');
                        finishPos(1) = x;
                        finishPos(2) = y;
                        setappdata(0, 'finishPos', finishPos);
                    end
                % If start position is set
                elseif ( isappdata(0, 'startPos') )
                	startPos = getappdata(0, 'startPos');
                    % If it's instead of start point
                    if ( (x == startPos(1)) && (y == startPos(2)) )
                        % Set new one and remove startPos
                        set(tempObj, 'FaceColor', 'red');
                        finishPos(1) = x;
                        finishPos(2) = y;
                        setappdata(0, 'finishPos', finishPos);
                        rmappdata(0, 'startPos');
                    else
                        % Set new finishPoint
                        set(tempObj, 'FaceColor', 'red');
                        finishPos(1) = x;
                        finishPos(2) = y;
                        setappdata(0, 'finishPos', finishPos);
                    end
                    
                % If it's instead of obstacle
                elseif (whichList(x,y) == unwalkable)
                	% Set new finishPoint
                    set(tempObj, 'FaceColor', 'red');
                    finishPos(1) = x;
                    finishPos(2) = y;
                    setappdata(0, 'finishPos', finishPos);
                    % Set the point as walkable and store matrix
                    whichList(x,y) = walkable;
                    setappdata(0, 'whichList', whichList);
                % If no start or finish position was previously defined
                else
                    set(tempObj, 'FaceColor', 'red');
                    finishPos(1) = x;
                    finishPos(2) = y;
                    setappdata(0, 'finishPos', finishPos);
                end 
                
            case 3
                % If both, start and finish points exist
                if ( (isappdata(0, 'startPos')) && (isappdata(0, 'finishPos')) )
                    startPos = getappdata(0, 'startPos');
                    finishPos = getappdata(0, 'finishPos');
                    % If obstacle is set instead of start
                    if ( (x == startPos(1)) && (y == startPos(2)) )
                        % Remove startPos and put obstacle instead
                        set(tempObj, 'FaceColor', 'black');
                        whichList(x,y) = unwalkable;
                        rmappdata(0, 'startPos');
                    % If obstacle is set instead of finish
                    elseif ( (x == finishPos(1)) && (y == finishPos(2)) )
                        % Remove startPos and put obstacle instead
                        set(tempObj, 'FaceColor', 'black');
                        whichList(x,y) = unwalkable;
                        rmappdata(0, 'finishPos');
                    % If obstacle exists at that location
                    elseif ( whichList(x,y) == unwalkable )
                        % Remove obstacle
                        set(tempObj, 'FaceColor', 'white');
                        whichList(x,y) = walkable;
                    else
                        % Put new obstacle
                        set(tempObj, 'FaceColor', 'black');
                        whichList(x,y) = unwalkable;
                    end
                % If only startPos exists
                elseif ( isappdata(0, 'startPos') )
                    startPos = getappdata(0, 'startPos');
                    % If obstacle is set instead of it
                    if ( (x == startPos(1)) && (y == startPos(2)) )
                        % Remove startPos and put obstacle instead
                        set(tempObj, 'FaceColor', 'black');
                        whichList(x,y) = unwalkable;
                        rmappdata(0, 'startPos');
                    % If obstacle exists at that location
                    elseif ( whichList(x,y) == unwalkable )
                        % Remove obstacle
                        set(tempObj, 'FaceColor', 'white');
                        whichList(x,y) = walkable;
                    else
                        % Put new obstacle
                        set(tempObj, 'FaceColor', 'black');
                        whichList(x,y) = unwalkable;
                    end
                % If only finishPos exists
                elseif ( isappdata(0, 'finishPos') )
                    finishPos = getappdata(0, 'finishPos');
                    % If obstacle is set instead of it
                    if ( (x == finishPos(1)) && (y == finishPos(2)) )
                        % Remove startPos and put obstacle instead
                        set(tempObj, 'FaceColor', 'black');
                        whichList(x,y) = unwalkable;
                        rmappdata(0, 'finishPos');
                    % If obstacle exists at that location
                    elseif ( whichList(x,y) == unwalkable )
                        % Remove obstacle
                        set(tempObj, 'FaceColor', 'white');
                        whichList(x,y) = walkable;
                    else
                        % Put new obstacle
                        set(tempObj, 'FaceColor', 'black');
                        whichList(x,y) = unwalkable;
                    end
                % If no start or finish point exists
                else
                    % If obstacle exists at that location
                    if ( whichList(x,y) == unwalkable )
                        % Remove obstacle
                        set(tempObj, 'FaceColor', 'white');
                        whichList(x,y) = walkable;
                    else
                        % Put new obstacle
                        set(tempObj, 'FaceColor', 'black');
                        whichList(x,y) = unwalkable;
                    end
                end
                    
                % Store whichList
                setappdata(0, 'whichList', whichList);
        end
        handles = getappdata(0, 'handles');
    end
    
% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

        
% --- Executes on selection change in mapsizepopup.
function mapsizepopup_Callback(hObject, eventdata, handles)
% hObject    handle to mapsizepopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mapsizepopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mapsizepopup


% --- Executes during object creation, after setting all properties.
function mapsizepopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapsizepopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in openmapbutton.
function openmapbutton_Callback(hObject, eventdata, handles)
% hObject    handle to openmapbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if(isappdata(0,'startPos'))
        rmappdata(0,'startPos');
    end
    if(isappdata(0,'finishPos'))
        rmappdata(0,'finishPos');
    end
    if(isappdata(0,'whichList'))
        rmappdata(0,'whichList');
    end
    if(isappdata(0,'figHandle'))
        rmappdata(0,'figHandle');
    end
    if(isappdata(0,'objMap'))
        rmappdata(0,'objMap');
    end
    
    %Get map size figure
    switch get(handles.mapsizepopup,'Value')
        case 1
            mapSize=10;
        case 2
            mapSize=20;
        case 3
            mapSize=30;
        case 4
            mapSize=40;
        case 5
            mapSize=50;
        otherwise
            mapSize=10;
    end
    
    %create map
    [figHandle objMap]=nav_CreateMap(mapSize);
    %store figure handle and size of Map
    setappdata(0,'figHandle',figHandle);
    setappdata(0,'objMap',objMap);
    %create whichlist array
    whichList=zeros(mapSize,mapSize);
    setappdata(0,'whichList',whichList);


% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)
% hObject    handle to startbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %get the speed option
    startPos=getappdata(0,'startPos');
    finishPos=getappdata(0,'finishPos');
    whichList=getappdata(0,'whichList');
    figHandle=getappdata(0,'figHandle');
    objMap=getappdata(0,'objMap');
    
    figure(figHandle);
    Astar(startPos(1),startPos(2),finishPos(1),finishPos(2),whichList,figHandle,objMap);
