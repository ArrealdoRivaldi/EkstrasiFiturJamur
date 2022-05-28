function varargout = tekstur_analisis_jamur(varargin)
% TEKSTUR_ANALISIS_JAMUR MATLAB code for tekstur_analisis_jamur.fig
%      TEKSTUR_ANALISIS_JAMUR, by itself, creates a new TEKSTUR_ANALISIS_JAMUR or raises the existing
%      singleton*.
%
%      H = TEKSTUR_ANALISIS_JAMUR returns the handle to a new TEKSTUR_ANALISIS_JAMUR or the handle to
%      the existing singleton*.
%
%      TEKSTUR_ANALISIS_JAMUR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEKSTUR_ANALISIS_JAMUR.M with the given input arguments.
%
%      TEKSTUR_ANALISIS_JAMUR('Property','Value',...) creates a new TEKSTUR_ANALISIS_JAMUR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tekstur_analisis_jamur_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tekstur_analisis_jamur_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tekstur_analisis_jamur

% Last Modified by GUIDE v2.5 28-May-2022 17:57:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tekstur_analisis_jamur_OpeningFcn, ...
                   'gui_OutputFcn',  @tekstur_analisis_jamur_OutputFcn, ...
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


% --- Executes just before tekstur_analisis_jamur is made visible.
function tekstur_analisis_jamur_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tekstur_analisis_jamur (see VARARGIN)

% Choose default command line output for tekstur_analisis_jamur
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tekstur_analisis_jamur wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tekstur_analisis_jamur_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%Arrealdo Rivaldi
%1918084
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Menampilkan Menu Input Citra dengan format file png
[nama_file, nama_folder] = uigetfile('*.png');

% jika ada nama file yang dipilih maka akan melakukan perintah di bawah
%ini
if ~isequal (nama_file,0) % jika nama file tidak kosong
    % membaca file citra rgb
    Img = imread(fullfile(nama_folder,nama_file));
    % menampilkan citra rgb pada axes1 berdasarkan inputan gambar yang sudah
    % disimpan pada variabel Img
    axes(handles.axes1)
    imshow(Img)
    %dengan judul gambar rgb
    title('gambar rgb')
    % menyimpan variabel img pada lokasi handles agar dapat di panggil oleh
    % push button yang lain
    handles.Img = Img;
    guidata(hObject, handles)
else
    %jika tidak ada nama file yang di pilih maka akan kembali 
    return
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Memanggil variabel Img yang menampung file gambar kita di lokasi handles
Img = handles.Img;

% mengkonversi citra rgb menjadi citra grayscale
Img_gray = rgb2gray(Img);

% menampilkan citra grayscale pada axes2 dengan judul gambar grayscale
axes(handles.axes2)
imshow(Img_gray)
title('gambar grayscale')


% membaca pixel distance yang ada pada edit text 1 yang datanya diubah dari string menjadi double supaya bisa diolah
pixel_dist = str2double(get(handles.edit1,'String'));


% membentuk matriks kookurensi berdasarkan nilai inputan jarak pixel pada
% edit1 menggunakan fungsi graycomatrix 
% mengatur gambar grayscale yang di simpan pada variabel Img_gray
% jika nilai pixel_dist = 1
% maka jika nilai offset 
% 0 pixel_dist  sudut 0 derajat
% -pixel_dist pixel_dist sudut 45 derajat
% -pixel_dist 0 sudut 90 derajat
% -pixel_dist -pixel_dist sudut 135 derajat
GLCM = graycomatrix(Img_gray,'Offset',[0 pixel_dist;...
     -pixel_dist pixel_dist; -pixel_dist 0; -pixel_dist -pixel_dist]);
 
% mengekstrak fitur GLCM
% graycoprops digunakan untuk mengambil property dari matriks kookurensi
% yaitu Contrast,Correlation,Energy,Homogeneity
stats = graycoprops(GLCM,{'Contrast','Correlation','Energy','Homogeneity'});

% membaca fitur GLCM
Contrast = stats.Contrast;
Correlation = stats.Correlation;
Energy = stats.Energy;
Homogeneity = stats.Homogeneity;

% tampilkan fitur GLCM pada tabel
data = get(handles.uitable1,'Data');

% data baris pertama kolom pertama kita isi nilai Contrast 1 pada sudut 0 derajat
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{1,1} = num2str(Contrast(1));

% data baris pertama kolom kedua kita isi nilai Contrast 2 pada sudut 45 derajat
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{1,2} = num2str(Contrast(2));

% data baris pertama kolom ketiga kita isi nilai Contrast 3 pada sudut 90 derajat
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{1,3} = num2str(Contrast(3));

% data baris pertama kolom keempat kita isi nilai Contrast 4 pada sudut 135 derajat
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{1,4} = num2str(Contrast(4));

% data baris pertama kolom kelima kita isi nilai rata-rata Contrast
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{1,5} = num2str(mean(Contrast));

% data baris kedua kolom pertama kita isi nilai Correlation 1 pada sudut 0 derajat
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{2,1} = num2str(Correlation(1));

% data baris kedua kolom kedua kita isi nilai Correlation 1 pada sudut 45 derajat
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{2,2} = num2str(Correlation(2));

% data baris kedua kolom ketiga kita isi nilai Correlation 1 pada sudut 90 derajat
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{2,3} = num2str(Correlation(3));

% data baris kedua kolom keempat kita isi nilai Correlation 1 pada sudut 135 derajat
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{2,4} = num2str(Correlation(4));

% data baris kedua kolom kelima kita isi nilai rata-rata Correlation
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{2,5} = num2str(mean(Correlation));

% data baris ketiga kolom pertama kita isi nilai Energy 1 pada sudut 0 derajat
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{3,1} = num2str(Energy(1));

% data baris ketiga kolom kedua kita isi nilai Energy 1 pada sudut 45 derajat
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{3,2} = num2str(Energy(2));

% data baris ketiga kolom ketiga kita isi nilai Energy 1 pada sudut 90 derajat
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{3,3} = num2str(Energy(3));

% data baris ketiga kolom keempat kita isi nilai Energy 1 pada sudut 135 derajat
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{3,4} = num2str(Energy(4));

% data baris ketiga kolom kelima kita isi nilai rata-rata Energy
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{3,5} = num2str(mean(Energy));

% data baris keempat kolom pertama kita isi nilai Homogeneity 1 pada sudut 0 derajat
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{4,1} = num2str(Homogeneity(1));

% data baris keempat kolom kedua kita isi nilai Homogeneity 1 pada sudut 45 derajat
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{4,2} = num2str(Homogeneity(2));

% data baris keempat kolom ketiga kita isi nilai Homogeneity 1 pada sudut 90 derajat
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{4,3} = num2str(Homogeneity(3));

% data baris keempat kolom keempat kita isi nilai Homogeneity 1 pada sudut 135 derajat
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{4,4} = num2str(Homogeneity(4));

% data baris keempat kolom kelima kita isi nilai rata-rata Homogeneity
% yang tipe data di ubah dari number ke string sehingga bisa di tampilkan
% pada uitable1
data{4,5} = num2str(mean(Homogeneity));

% menampilkan data tersebut pada tabel dengan tag uitable1
set(handles.uitable1,'Data',data)

% variabel con menyimpan nilai rata-rata Contrast yang tipe datanya di ubah
% ke string
con = num2str(mean(Contrast));
% menampilkan data variabel con ke edit2
set(handles.edit2, 'String',con);

% variabel cor menyimpan nilai rata-rata Correlation yang tipe datanya di ubah
% ke string
cor = num2str(mean(Correlation));
% menampilkan data variabel con ke edit3
set(handles.edit3, 'String',cor);

% variabel ene menyimpan nilai rata-rata Energy yang tipe datanya di ubah
% ke string
ene = num2str(mean(Energy));
%menampilkan data variabel ene ke edit4
set(handles.edit4, 'String',ene);

% variabel hom menyimpan nilai rata-rata Homogeneity yang tipe datanya di ubah
% ke string
hom = num2str(mean(Homogeneity));
%menampilkan data variabel ene ke edit5
set(handles.edit5, 'String',hom);

% terdapat variabel jumlah yang menyimpan hasil perhitungan rata jumlah
% rata-rata nilai Homegenity  + rata-rata nilai Energy dibagi 2 kemudian
% ditampilkan pada text5
jumlah = (mean(Homogeneity)+mean(Energy))/2;
set(handles.text5,'string',jumlah);

% terdapat percabangan if 
% text6 untuk menampilkan hasil pengelompokan berdasarkan nilai yang pada text5
% jika nilai jumlah lebih sama dengan 0.7 maka akan menampilkan kata Teratur.
if(jumlah < 0.6)
    set(handles.text4,'string','Kasar');
end
% jika nilai jumlah lebih sama dengan 0.6 dan kurang dari 0.7 maka akan menampilan kata Halus.
if(jumlah >= 0.6 && jumlah < 0.7)
    set(handles.text4,'string','Halus');
end
% jika nilai jumlah kurang dari 0.6 maka akan menampilkan kata Kasar.
if(jumlah >= 0.7)
    set(handles.text4,'string','Teratur');
end;

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% perintah untuk menghapus atau mereset isi dari axes1
axes(handles.axes1)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

% perintah untuk menghapus atau mereset isi dari axes2
axes(handles.axes2)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

% perintah reset atau menghapus pada table dengan uitable1 dengan datanya kita kosongkan
set(handles.uitable1,'Data',[])

% perintah reset  isi nilai  edit1 menjadi 1
set(handles.edit1,'String','1')

% perintah reset  isi nilai  edit2 menjadi kosong
set(handles.edit2,'String','')

% perintah reset  isi nilai  edit3 menjadi kosong
set(handles.edit3,'String','')

% perintah reset  isi nilai  edit4 menjadi kosong
set(handles.edit4,'String','')

% perintah reset  isi nilai  edit5 menjadi kosong
set(handles.edit5,'String','')

%perintah reset menghapus menjadi kosong pada text4
set(handles.text4,'String','')

%perintah reset menghapus menjadi kosong pada text5
set(handles.text5,'String','')

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
