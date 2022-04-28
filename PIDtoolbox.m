%% PIDtoolbox - main
%  script for main control panel and log viewer
%
% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------
clear
close all

pkg load signal
pkg load data-smoothing
% graphics_toolkit qt

Init;

%todo
vPos = 1;
% todo
controlpanel = uipanel('Title', 'Control Panel',
'FontSize', fontsz,
'BackgroundColor', [.95 .95 .95],
'Position', [.89 vPos - .325 .105 .305]);

guiHandles.Firmware = uicontrol(controlpanel,%PTfig,
'Style', 'popupmenu',
'string', [{'Betaflight logfiles'; 'Emuflight logfiles'; 'INAV logfiles'}],
'fontsize', fontsz,
'units', 'normalized',
'position', [0 0 1 .1]);
% [posInfo.firmware]);

guiHandles.fileA = uicontrol(PTfig,
'string', 'Select ',
'fontsize', fontsz,
'TooltipString', [TooltipString_loadRun],
'units', 'normalized',
'position', [posInfo.fileA],
'callback', 'Select',
% 'guiHandles.fileA.FontWeight=''Bold''; try, if ~isempty(logfileDir), cd(logfileDir), end, catch, end; [filenameA, filepathA] = uigetfile({''*.BBL;*.BFL;*.TXT''}, ''MultiSelect'',''on''); if isstr(filenameA), filenameA={filenameA}; end; if iscell(filenameA), PTload; PTviewerUIcontrol; PTplotLogViewer; end',
'ForegroundColor', [colRun]);

guiHandles.clr = uicontrol(PTfig,
'string', 'Reset',
'fontsize', fontsz,
'TooltipString', ['clear all data'],
'units', 'normalized',
'position', [posInfo.clr],
'callback', 'clear T dataA tta A_lograte epoch1_A epoch2_A SetupInfo rollPIDF pitchPIDF yawPIDF filenameA fnameMaster; fcnt = 0; filenameA={};fnameMaster = {}; try, delete(subplot(''position'',posInfo.linepos1)); delete(subplot(''position'',posInfo.linepos2)); delete(subplot(''position'',posInfo.linepos3)); catch, end; set(guiHandles.FileNum, ''String'','' ''); set(guiHandles.Epoch1_A_Input, ''String'','' ''); set(guiHandles.Epoch2_A_Input, ''String'','' '');PIDtoolbox;',
'ForegroundColor', [cautionCol]);

guiHandles.startEndButton = uicontrol(PTfig,
'style', 'checkbox',
'string', 'select start/end points ',
'fontsize', fontsz,
'TooltipString', [TooltipString_selectButton],
'units', 'normalized',
'position', [posInfo.startEndButton],
'callback', 'if ~isempty(filenameA) && get(guiHandles.startEndButton, ''Value''), [x y] = ginput(1); epoch1_A(get(guiHandles.FileNum, ''Value'')) = round(x(1)*10)/10; PTplotLogViewer; [x y] = ginput(1); epoch2_A(get(guiHandles.FileNum, ''Value'')) = round(x(1)*10)/10; PTplotLogViewer, end');

guiHandles.FileNum = uicontrol(PTfig,
'Style', 'popupmenu',
'string', [filenameA],
'fontsize', fontsz,
'units', 'normalized',
'position', [posInfo.fnameAText],
'String', ' ');

guiHandles.lineSmooth = uicontrol(PTfig,
'Style', 'popupmenu',
'string', {'line smooth off', 'line smooth low', 'line smooth med', 'line smooth med-high', 'line smooth high'},
'position', [posInfo.lineSmooth],
'fontsize', fontsz,
'TooltipString', ['zero-phase filter lines'],
'units', 'normalized',
'Value', 1,
'callback', '@selection; if ~isempty(filenameA), PTplotLogViewer; end');

guiHandles.linewidth = uicontrol(PTfig,
'Style', 'popupmenu',
'string', {'line width 1', 'line width 2', 'line width 3', 'line width 4', 'line width 5'},
'position', [posInfo.linewidth],
'fontsize', fontsz,
'TooltipString', ['line thickness'],
'units', 'normalized',
'Value', 3,
'callback', '@selection; if ~isempty(filenameA), PTplotLogViewer; end');

guiHandles.spectrogramButton = uicontrol(PTfig,
'string', 'Spectral Analyzer',
'fontsize', fontsz,
'TooltipString', [TooltipString_spec],
'units', 'normalized',
'position', [posInfo.spectrogramButton],
'ForegroundColor', [colorA],
'callback', 'PTspec2DUIcontrol;');

guiHandles.TuningButton = uicontrol(PTfig,
'string', 'Step Resp Tool',
'fontsize', fontsz,
'TooltipString', [TooltipString_step],
'units', 'normalized',
'position', [posInfo.TuningButton],
'ForegroundColor', [colorB],
'callback', 'PTtuneUIcontrol');

guiHandles.DispInfoButton = uicontrol(PTfig,
'string', 'Setup Info',
'fontsize', fontsz,
'TooltipString', [TooltipString_setup],
'units', 'normalized',
'position', [posInfo.DispInfoButton],
'ForegroundColor', [setUpCol],
'callback', 'PTdispSetupInfoUIcontrol;PTdispSetupInfo;');

guiHandles.saveFig = uicontrol(PTfig,
'string', 'Save Fig',
'fontsize', fontsz,
'TooltipString', [TooltipString_saveFig],
'units', 'normalized',
'position', [posInfo.saveFig],
'ForegroundColor', [saveCol],
'callback', 'guiHandles.saveFig.FontWeight=''bold'';PTsaveFig; guiHandles.saveFig.FontWeight=''normal'';');

guiHandles.wiki = uicontrol(PTfig,
'string', 'User Guide',
'fontsize', fontsz,
'FontName', 'arial',
'FontAngle', 'normal',
'TooltipString', [TooltipString_wiki],
'units', 'normalized',
'position', [posInfo.wiki],
'ForegroundColor', [cautionCol],
'callback', 'web(wikipage);');

guiHandles.PIDtuningService = uicontrol(PTfig,
'string', 'Donate',
'fontsize', fontsz,
'FontName', 'arial',
'FontAngle', 'normal',
'TooltipString', ['Donate to the PIDtoolbox project'],
'units', 'normalized',
'position', [posInfo.PIDtuningService],
'ForegroundColor', [cautionCol],
'callback', 'web(''https://www.paypal.com/paypalme/PIDtoolbox'');');

guiHandles.RPYcomboLV = uicontrol(PTfig, 'Style', 'checkbox', 'String', 'Single Panel', 'fontsize', fontsz, 'BackgroundColor', bgcolor,
'units', 'normalized', 'Position', [posInfo.RPYcomboLV], 'callback', 'if ~isempty(fnameMaster), PTplotLogViewer; end');
guiHandles.plotR = uicontrol(PTfig, 'Style', 'checkbox', 'String', 'R', 'fontsize', fontsz, 'TooltipString', ['Plot Roll '],
'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.plotR_LV], 'callback', 'if ~isempty(fnameMaster), PTplotLogViewer; end');

guiHandles.plotP = uicontrol(PTfig, 'Style', 'checkbox', 'String', 'P', 'fontsize', fontsz, 'TooltipString', ['Plot Pitch '],
'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.plotP_LV], 'callback', 'if ~isempty(fnameMaster), PTplotLogViewer; end');

guiHandles.plotY = uicontrol(PTfig, 'Style', 'checkbox', 'String', 'Y', 'fontsize', fontsz, 'TooltipString', ['Plot Yaw '],
'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.plotY_LV], 'callback', 'if ~isempty(fnameMaster), PTplotLogViewer; end');

try set(guiHandles.Firmware, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'firmware')))); catch, set(guiHandles.Firmware, 'Value', 1); end
try set(guiHandles.RPYcomboLV, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'LogViewer-SinglePanel')))); catch, set(guiHandles.RPYcomboLV, 'Value', 0); end
try set(guiHandles.plotR, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'LogViewer-plotR')))); catch, set(guiHandles.plotR, 'Value', 1); end
try set(guiHandles.plotP, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'LogViewer-plotP')))); catch, set(guiHandles.plotP, 'Value', 1); end
try set(guiHandles.plotY, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'LogViewer-plotY')))); catch, set(guiHandles.plotY, 'Value', 1); end
try set(guiHandles.lineSmooth, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'LogViewer-lineSmooth')))); catch, set(guiHandles.lineSmooth, 'Value', 1); end
try set(guiHandles.linewidth, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'LogViewer-lineWidth')))); catch, set(guiHandles.linewidth, 'Value', 3); end

% functions
function selection(src, event)
    val = c.Value;
    str = c.String;
    str{val};
    % disp(['Selection: ' str{val}]);
end

function textinput_call(src)
    str = get(src, 'String');

    if isempty(str2num(str))
        set(src, 'string', '0');
        warndlg('Input must be numerical');
    end

end
