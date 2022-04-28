pkg load signal;

PtbVersion='v0.55';

Tooltips;

t = now;
% currentDate = char(datetime(t,'ConvertFrom','datenum'));
% currentDate = currentDate(1:strfind(currentDate,' ')-1);

set(0, 'defaultUicontrolFontName', 'Helvetica')%calibri Helvetica
set(0, 'defaultUicontrolFontSize', 10)
BF = 1;

%%%%%%%%%% used debug modes %%%%%%% - must consider emu and INAV
GYRO_SCALED = 6;
RC_INTERPOLATION = 7;
FEEDFORWARD = 59;
FFT_FREQ = 17;

LogStDefault = 2; % default ignore first 2 seconds of logfile
LogNdDefault = 1; % default ignore last 1 second of logfile

executableDir = pwd;
main_directory = [executableDir '/'];

try
    fid = fopen([main_directory 'logfileDir.txt'],'r');
    logfile_directory = fscanf(fid, '%s');
    fclose(fid);
catch
    logfile_directory = pwd;
end
rdr = ['rootDirectory: ' executableDir ];
mdr = ['mainDirectory: ' main_directory ];
ldr = ['logfileDirectory: ' logfile_directory ];
pause(1);



wikipage='https://github.com/bw1129/PIDtoolbox/wiki/PIDtoolbox-user-guide';

if ~exist('filenameA', 'var'), filenameA = []; end

expandON = 0;
use_randsamp = 0;
smp_sze = 100;
choose_epoch = 0;
epoch1_A = [];
epoch2_A = [];
tIND = [];
maxY = 500;
nLineCols = 8;
multiLineCols=PTlinecmap(nLineCols);
updateSpec = 0;
A_debugmode = 0; %default to gyro_scaled
filepathA = [];
filenameA = {};

hexpand1 = [];
hexpand2 = [];
hexpand3 = [];

errmsg = [];

plotall_flag=-1;
bgcolor = [.95 .95 .95];
colorA = [.8 .1 .1];
colorA2 = [.48 .0 .72];
colorB = [.12 .48 .96];
colorC = [1 .2 .2];
colorD = [.1 1 .2];

colRun = [0 .6 .3];
saveCol = [.1 .1 .1];
setUpCol = [.1 .1 .1];
cautionCol = [0.7 0.4 0];
%use_phsCorrErr = 0;
flightSpec = 0;
vPos = 0.94; 

posInfo.firmware =[.8965 vPos-.04 .091 .04];          
posInfo.fileA=[.896 vPos-.055 .0455 .026];
posInfo.clr=[.942 vPos-.055 .0455 .026];
posInfo.fnameAText = [.8965 vPos-.1 .091 .04];

posInfo.startEndButton=[.90 vPos-.115 .06 .026];

posInfo.RPYcomboLV = [.93 vPos-0.115 .06 .026]; %[x_start y_start x_width y_width]
% posInfo.RPYcomboLV = [.93 vPos-.115 0.2 .026];

posInfo.plotR_LV =  [.90 vPos-0.135 .03 .025];
posInfo.plotP_LV =  [.93 vPos-0.135 .03 .025];
posInfo.plotY_LV =  [.96 vPos-0.135 .03 .025];

posInfo.lineSmooth = [.895 .76 .046 .026];
posInfo.linewidth = [.943 .76 .046 .026];

posInfo.spectrogramButton=[.895 vPos-.195 .093 .026];
posInfo.TuningButton=[.895 vPos-.225 .093 .026];
posInfo.period2Hz = [.895 vPos-0.255 .046 .026]; 
posInfo.DispInfoButton=[.943 vPos-.255 .046 .026]; 
posInfo.saveFig=[.895 vPos-.285 .046 .026];
posInfo.saveSettings=[.943 vPos-.285 .046 .026];
posInfo.wiki=[.895 vPos-.315 .046 .026];
posInfo.PIDtuningService=[.943 vPos-.315 .046 .026];

fnameMaster = {};
fcnt = 0;

% NmultiLineCols = 10;
% cmap = flipud(colormap(jet));
% multiLineCols = (downsample(cmap, ceil(length(cmap) / NmultiLineCols)));

% for i = 4:7
%     multiLineCols(i, :) = multiLineCols(i, :) * .76;
% end

% ColorSet=colormap(jet);%hsv jet gray lines colorcube
% j=[1     8    17    20    23    27   45    50    58    64];
ColorSet = [.6 .6 .6; % gray - Gyro raw
        0 0 0; % black - Gyro filt
        0 .7 0; % green - Pterm
        .8 .65 .1; % yellow - I term
        .3 .7 .9; % light blue - Dterm raw
        .1 .2 .8; % dark blue -Dterm Filt
        .6 .3 .3; % brown - Fterm
        .8 0 .2; % dark red
        1 .2 .9; % light purple
        .4 0 .9; % dark purple
        .9 0 0; %M1
        1 .6 0; %M2
        0 0 .9; %M3
        .1 1 .8; %M4
        0 0 0; % throttle
        0 0 0]; % all
j = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16];

k = 1;

for i = 1:length(j)
    eval(['linec.col' int2str(k - 1) '=ColorSet(j(i),:);']);
    k = k + 1;
end

screensz = get(0, 'ScreenSize');
screensz(3) = round(1.78 * screensz(4)); % force 16:9

PTfig = figure(1,
'menubar', 'none',
'inverthardcopy', 'off',
'color', bgcolor,
% 'outerposition', [10, 10, screensz(3) * .5, screensz(4) * .5],
'units', 'normalized',
'position', [.1 .1 .75 .8],
'NumberTitle', 'off',
"Name", ['PIDtoolbox (' PtbVersion ') - Log Viewer']);

pause(.1)% need to wait for figure to open before extracting screen values

screensz_multiplier = sqrt(screensz(4)^2) * .01; % based on vertical dimension only, to deal with for ultrawide monitors

prop_max_screen = get(PTfig, 'Position')(4);
fontsz = (screensz_multiplier * prop_max_screen);
markerSz = round(screensz_multiplier * 0.7);

try
    defaults = readtable('PTBdefaults.txt');
    a = char([cellstr([char(defaults.Parameters) num2str(defaults.Values)]); {rdr}; {mdr}; {ldr}]);
    t = uitable(PTfig, 'ColumnWidth',{500},'ColumnFormat',{'char'},'Data',[cellstr(a)]);
    set(t,'units','normalized','Position',[.89 vPos-.86 .105 .3],'FontSize',fontsz*.8, 'ColumnName', [''])
catch
    defaults = ' '; 
    a = char([ {rdr}; {mdr}; {ldr}]);
    t = uitable(PTfig, 'ColumnWidth',{500},'ColumnFormat',{'char'},'Data',[cellstr(a)]);
    set(t,'units','normalized','Position',[.89 vPos-.86 .105 .3],'FontSize',fontsz*.8, 'ColumnName', [''])
end

