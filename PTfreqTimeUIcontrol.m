%% PTtimeFreqUIcontrol - ui controls for spectral analyses plots

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

if ~isempty(fnameMaster)

    %%% tooltips
    TooltipString_specRun = ['Run current spectral configuration'];
    TooltipString_cmap = ['Choose from a selection of colormaps'];
    TooltipString_smooth = ['Choose amount of smoothing along the freq axis'];
    TooltipString_subsampling = ['Choose amount of smoothing along the time axis'];
    TooltipString_user = ['Choose the variable you wish to plot'];
    TooltipString_sub100 = ['Zoom data to show sub 100Hz details',
                        '\n', 'Typically used to see propwash or mid-throttle vibration in e.g. Gyro/Pterm/PIDerror'];

    %%%
    clear posInfo.Spec3Pos
    cols = [0.09];
    rows = [0.69 0.395 0.1];
    k = 0;

    for c = 1:size(cols, 2)

        for r = 1:size(rows, 2)
            k = k + 1;
            posInfo.Spec3Pos(k, :) = [cols(c) rows(r) 0.77 0.255];
        end

    end

    updateSpec = 0;
    clear specMat

    posInfo.fileListWindowSpec = [.895 .865 .096 .04];
    posInfo.TermListWindowSpec = [.895 .84 .096 .04];

    posInfo.computeSpec3 = [.896 .83 .0455 .026];
    posInfo.resetSpec3 = [.942 .83 .0455 .026];
    posInfo.saveFig3 = [.896 .805 .0455 .026]; % .896 .495 .092 .026
    posInfo.saveSettings3 = [.942 .805 .0455 .026];
    posInfo.smooth_select3 = [.895 .78 .096 .026];
    posInfo.subsampling_select3 = [.895 .755 .096 .026];
    posInfo.ColormapSelect2 = [.895 .73 .096 .026];

    posInfo.clim3Max1_text = [.91 .71 .035 .024];
    posInfo.clim3Max1_input = [.915 .69 .025 .024];
    posInfo.clim3Max2_text = [.94 .71 .035 .024];
    posInfo.clim3Max2_input = [.945 .69 .025 .024];
    ClimScale3 = [-30 10];

    posInfo.sub100HzfreqTime = [.915 .665 .06 .024];

    PTspecfig3 = figure(31);
    set(PTspecfig3, 'units', 'normalized', 'Position', [.1 .1 .75 .8],
    'NumberTitle', 'off',
    'Name', ['PIDtoolbox (' PtbVersion ') - Frequency x Time Spectrogram'],
    'InvertHardcopy', 'off',
    'color', bgcolor);
    % todo
    % dcm_obj2 = datacursormode(PTspecfig3);
    % set(dcm_obj2, 'UpdateFcn', @PTdatatip);

    Spec3Crtlpanel = uipanel('Title', 'select file ', 'FontSize', fontsz,
    'BackgroundColor', [.95 .95 .95],
    'Position', [.89 .66 .105 .26]);

    guiHandlesSpec3.computeSpec = uicontrol(PTspecfig3, 'string', 'Run', 'fontsize', fontsz, 'TooltipString', [TooltipString_specRun], 'units', 'normalized', 'Position', [posInfo.computeSpec3],
    'ForegroundColor', [colRun], 'callback', 'updateSpec = 0; clear specMat; PTfreqTime;');

    guiHandlesSpec3.resetSpec = uicontrol(PTspecfig3, 'string', 'Reset', 'fontsize', fontsz, 'TooltipString', ['Reset Spectral Tool'], 'units', 'normalized', 'Position', [posInfo.resetSpec3],
    'ForegroundColor', [cautionCol], 'callback', 'updateSpec = 0; clear specMat; for k = 1 : 3, delete(subplot(''position'',posInfo.Spec3Pos(k,:))), end; set(PTspecfig3, ''pointer'', ''arrow'');');

    guiHandlesSpec3.saveFig3 = uicontrol(PTspecfig3, 'string', 'Save Fig', 'fontsize', fontsz, 'TooltipString', [TooltipString_saveFig], 'units', 'normalized', 'ForegroundColor', [saveCol], 'Position', [posInfo.saveFig3],
    'callback', 'guiHandlesSpec3.saveFig3.FontWeight=''bold'';PTsaveFig;guiHandlesSpec3.saveFig3.FontWeight=''normal'';');

    guiHandlesSpec3.saveSettings3 = uicontrol(PTspecfig3, 'string', 'Save Settings', 'fontsize', fontsz, 'TooltipString', ['Save current settings to PTB defaults'], 'units', 'normalized', 'Position', [posInfo.saveSettings3],
    'ForegroundColor', [saveCol], 'callback', 'guiHandlesSpec3.saveSettings3.FontWeight=''bold'';PTsaveSettings; guiHandlesSpec3.saveSettings3.FontWeight=''normal'';');

    % create string list for SpecSelect
    sA = {'Gyro', 'Gyro prefilt', 'Dterm', 'Dterm prefilt', 'Pterm', 'PID error', 'Set point', 'PIDsum'};

    guiHandlesSpec3.SpecList = uicontrol(PTspecfig3, 'Style', 'popupmenu', 'string', [sA], 'fontsize', fontsz, 'TooltipString', [TooltipString_user], 'units', 'normalized', 'Position', [posInfo.TermListWindowSpec]);

    guiHandlesSpec3.FileSelect = uicontrol(PTspecfig3, 'Style', 'popupmenu', 'string', [fnameMaster], 'Value', 1, 'fontsize', fontsz, 'TooltipString', [TooltipString_user], 'units', 'normalized', 'Position', [posInfo.fileListWindowSpec]);

    guiHandlesSpec3.smoothFactor_select = uicontrol(PTspecfig3,
    'style', 'popupmenu', 
    'Value', 2,'string', {'smooth freq axis off' 'smooth freq axis low' 'smooth freq axis med' 'smooth freq axis high'}, 'fontsize', fontsz, 'TooltipString', [TooltipString_smooth], 'units', 'normalized', 'Position', [posInfo.smooth_select3],
    'callback', 'PTfreqTime;');

    guiHandlesSpec3.subsampleFactor_select = uicontrol(PTspecfig3, 'style', 'popupmenu', 'Value', 2,'string', {'smooth time axis off' 'smooth time axis low' 'smooth time axis med' 'smooth time axis high'}, 'fontsize', fontsz, 'TooltipString', [TooltipString_subsampling], 'units', 'normalized', 'Position', [posInfo.subsampling_select3],
    'callback', 'PTfreqTime;');

    guiHandlesSpec3.ColormapSelect = uicontrol(PTspecfig3, 'Style', 'popupmenu', 'string', {'parula', 'jet', 'hot', 'cool', 'gray', 'bone', 'copper', 'viridis', 'linear-RED', 'linear-GREY'},
    'fontsize', fontsz, 'TooltipString', [TooltipString_cmap], 'units', 'normalized', 'Position', [posInfo.ColormapSelect2], 'callback', '@selection2;updateSpec=1; PTfreqTime;');

    guiHandlesSpec3.climMax1_text = uicontrol(PTspecfig3, 'style', 'text', 'string', 'Z min', 'fontsize', fontsz, 'TooltipString', ['adjusts the color limits'], 'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.clim3Max1_text]);
    guiHandlesSpec3.climMax1_input = uicontrol(PTspecfig3, 'style', 'edit', 'string', [num2str(ClimScale3(1))], 'fontsize', fontsz, 'TooltipString', ['adjusts the color limits'], 'units', 'normalized', 'Position', [posInfo.clim3Max1_input],
    'callback', '@textinput_call2; ClimScale3(1)=str2num(get(guiHandlesSpec3.climMax1_input, ''String''));updateSpec=1;PTfreqTime;');

    guiHandlesSpec3.climMax2_text = uicontrol(PTspecfig3, 'style', 'text', 'string', 'Z max', 'fontsize', fontsz, 'TooltipString', ['adjusts the color limits'], 'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.clim3Max2_text]);
    guiHandlesSpec3.climMax2_input = uicontrol(PTspecfig3, 'style', 'edit', 'string', [num2str(ClimScale3(2))], 'fontsize', fontsz, 'TooltipString', ['adjusts the color limits'], 'units', 'normalized', 'Position', [posInfo.clim3Max2_input],
    'callback', '@textinput_call2; ClimScale3(2)=str2num(get(guiHandlesSpec3.climMax2_input, ''String''));updateSpec=1;PTfreqTime;');

    guiHandlesSpec3.sub100HzfreqTime = uicontrol(PTspecfig3, 'Style', 'checkbox', 'String', 'sub 100Hz', 'fontsize', fontsz, 'ForegroundColor', [.2 .2 .2], 'BackgroundColor', bgcolor,
    'units', 'normalized', 'Position', [posInfo.sub100HzfreqTime], 'callback', '@selection2;updateSpec=1; PTfreqTime;');

    try set(guiHandlesSpec3.SpecList, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'FreqxTime-Preset')))), catch, set(guiHandlesSpec3.SpecList, 'Value', 1), end
    try set(guiHandlesSpec3.smoothFactor_select, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'FreqxTime-FreqSmoothing')))), catch, guiHandlesSpec3.smoothFactor_select, 'Value', 2, end
    try set(guiHandlesSpec3.subsampleFactor_select, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'FreqxTime-TimeSmoothing')))), catch, guiHandlesSpec3.subsampleFactor_select, 'Value', 2, end
    try set(guiHandlesSpec3.ColormapSelect, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'FreqxTime-Colormap')))), catch, guiHandlesSpec3.ColormapSelect, 'Value', 3, end

else
    warndlg('Please select file(s)');
end

% functions
function selection2(src, event)
    val = c.Value;
    str = c.String;
    str{val};
end

function getList2(hObj, event)
    v = get(hObj, 'value')
end

function textinput_call2(src, eventdata)
    str = get(src, 'String');

    if isempty(str2num(str))
        set(src, 'string', '0');
        warndlg('Input must be numerical');
    end

end
