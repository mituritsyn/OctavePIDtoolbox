%% PTspecUIcontrol - ui controls for spectral analyses plots

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

if ~isempty(fnameMaster)

    %%% tooltips
    TooltipString_specRun = ['Run current spectral configuration',
                        '\n', 'Warning: Set subsampling dropdown @ or < medium for faster processing.'];
    TooltipString_presets = ['Choose from a selection of PRESET configurations'];
    TooltipString_cmap = ['Choose from a selection of colormaps'];
    TooltipString_smooth = ['Choose amount of smoothing'];
    TooltipString_2d = ['Show 2 dimensional plots'];
    TooltipString_user = ['Choose the variable you wish to plot (consider PRESETs dropdown menu above for quick configurations)'];
    TooltipString_sub100 = ['Zoom data to show sub 100Hz details',
                        '\n', 'Typically used to see propwash or mid-throttle vibration in e.g. Gyro/Pterm/PIDerror'];
    TooltipString_phase = ['Estimated phase delay based on cross-correlation technique.',
                        '\n', 'Note: estimate is most reliable with sufficient stick input so as to modulate the gyro and dterm.',
                        '\n', 'Also requires that betaflight debug_mode is set to ''GYRO_SCALED'' '];
    TooltipString_scale = ['Colormap scaling. Note, the default is set such that an optimally filtered gyro ',
                        '\n', 'should show little to no activity with the exception of a sub 100Hz band across throttle.',
                        '\n', 'Dterm and motor outputs will typically be noisier, so sometimes scale adjustments ',
                        '\n', 'are useful to see details. Otherwise, scaling should be the same when making comparisons'];
    TooltipString_controlFreqCutoff = ['Hz = Freq cutoff bounds for sub100Hz mean/peak analysis window.',
                                    '\n''Changing this will move the yellow dashed lines representing this range (only in sub100Hz view).'];

    %%%

    % define
    smat = []; %string
    ampmat = []; %spec matrix
    amp2d = []; %spec 2d
    freq = []; % freq

    % only need to call once to compute extra colormaps
    PTcolormap;
    SpecLineCols = [];
    SpecLineCols(:, :, 1) = [colorA; colorA; colorA; colorA];
    SpecLineCols(:, :, 2) = [colorA; colorA; colorB; colorB];
    SpecLineCols(:, :, 3) = [colorA; colorB; colorC; colorD];

    clear posInfo.SpecPos
    cols = [0.04 0.261 0.482 0.703];
    rows = [0.64 0.35 0.06];
    k = 0;

    for c = 1:4

        for r = 1:3
            k = k + 1;
            posInfo.SpecPos(k, :) = [cols(c) rows(r) 0.18 0.24];
        end

    end

    posInfo.computeSpec = [.896 .87 .0455 .026];
    posInfo.resetSpec = [.942 .87 .0455 .026];
    posInfo.saveFig1 = [.8965 .845 .0455 .026];
    posInfo.saveSettings1 = [.942 .845 .0455 .026];

    posInfo.specPresets = [.8945 .802 .096 .04];
    posInfo.ColormapSelect = [.8945 .778 .096 .04];
    posInfo.smooth_select = [.8945 .754 .096 .04];
    posInfo.controlFreq1Cutoff = [.91 .715 .023 .025];
    posInfo.controlFreq2Cutoff = [.945 .715 .023 .025];
    posInfo.controlFreqCutoff_text = [.9 .74 .07 .025];
    posInfo.checkbox2d = [.91 .685 .04 .02];
    posInfo.checkboxPSD = [.94 .685 .04 .02];

    posInfo.AphasedelayText1 = [.06 .984 .14 .02];
    posInfo.AphasedelayText2 = [.282 .984 .14 .02];
    posInfo.AphasedelayText3 = [.504 .984 .14 .02];
    posInfo.AphasedelayText4 = [.726 .984 .14 .02];

    posInfo.hCbar1pos = [0.04 0.89 0.18 0.02];
    posInfo.hCbar2pos = [0.262 0.89 0.18 0.02];
    posInfo.hCbar3pos = [0.484 0.89 0.18 0.02];
    posInfo.hCbar4pos = [0.706 0.89 0.18 0.02];

    posInfo.hDropdn1pos = [0.08 0.97 0.095 0.01];
    posInfo.hDropdn2pos = [0.302 0.97 0.095 0.01];
    posInfo.hDropdn3pos = [0.524 0.97 0.095 0.01];
    posInfo.hDropdn4pos = [0.746 0.97 0.095 0.01];

    posInfo.fDropdn1pos = [0.08 0.946 0.095 0.01];
    posInfo.fDropdn2pos = [0.302 0.946 0.095 0.01];
    posInfo.fDropdn3pos = [0.524 0.946 0.095 0.01];
    posInfo.fDropdn4pos = [0.746 0.946 0.095 0.01];

    posInfo.Sub100HzCheck1 = [0.175 0.945 .06 .025];
    posInfo.Sub100HzCheck2 = [.4 .945 .06 .025];
    posInfo.Sub100HzCheck3 = [0.62 0.945 .06 .025];
    posInfo.Sub100HzCheck4 = [.84 .945 .06 .025];

    posInfo.climMax_text = [.01 .913 .025 .024];
    posInfo.climMax_input = [.01 .888 .025 .024];
    posInfo.climMax_text2 = [.232 .913 .025 .024];
    posInfo.climMax_input2 = [.232 .888 .025 .024];
    posInfo.climMax_text3 = [.455 .913 .025 .024];
    posInfo.climMax_input3 = [.455 .888 .025 .024];
    posInfo.climMax_text4 = [.677 .913 .025 .024];
    posInfo.climMax_input4 = [.677 .888 .025 .024];
    climScale = [0.5 0.5 0.5 0.5; 10 10 10 10];
    Flim1 = 20; % 3.3333Hz steps
    Flim2 = 60;

    PTspecfig = figure(2);
    set(PTspecfig, 'units', 'normalized', 'Position', [.1 .1 .75 .8], 'NumberTitle', 'off',
    'Name', ['PIDtoolbox (' PtbVersion ') - Frequency x Throttle Spectrogram'],'InvertHardcopy','off','color', bgcolor);
% todo
    % dcm_obj2 = datacursormode(PTspecfig);
    % set(dcm_obj2, 'UpdateFcn', @PTdatatip);

    specCrtlpanel = uipanel('Title', 'Params', 'FontSize', fontsz,
    'BackgroundColor', [.95 .95 .95],
    'Position', [.89 .68 .105 .24]);

    %%% PRESET CONFIGURATIONS

    % guiHandles.FileNum = uicontrol(PTspecfig,'Style','popupmenu','string',[fnameMaster],'TooltipString', [TooltipString_FileNum],
    %     'fontsize',fontsz, 'units','normalized','Position', [posInfo.fnameASpec],'callback','PTplotSpec;');

    guiHandlesSpec.specPresets = uicontrol(PTspecfig, 'Style', 'popupmenu', 'string', {'Presets:'; '1. Gyro prefilt | Gyro | Dterm prefilt | Dterm'; '2. Gyro prefilt | Gyro | Pterm | Dterm'; '3. Gyro | Dterm | Set point | PID error'; '4. A|A|B|B Gyro prefilt | Gyro'; '5. A|A|B|B Dterm prefilt | Dterm'; '6. A|B|C|D Gyro prefilt '; '7. A|B|C|D Gyro '; '8. A|B|C|D Dterm '; '9. A|B|C|D PID error'},
    'fontsize', fontsz, 'TooltipString', [TooltipString_presets], 'units', 'normalized', 'Position', [posInfo.specPresets], 'callback',
    ['if get(guiHandlesSpec.specPresets, ''Value'') == 1, set(guiHandlesSpec.SpecSelect{1}, ''Value'',  1); set( guiHandlesSpec.SpecSelect{2}, ''Value'',  1); set(guiHandlesSpec.SpecSelect{3}, ''Value'',  1); set(guiHandlesSpec.SpecSelect{4}, ''Value'',  1); set(guiHandlesSpec.Sub100HzCheck{1}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{2}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{3}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{4}, ''Value'',  0); end;',
        'if get(guiHandlesSpec.specPresets, ''Value'') == 2, set(guiHandlesSpec.SpecSelect{1}, ''Value'',  3); set( guiHandlesSpec.SpecSelect{2}, ''Value'',  2); set(guiHandlesSpec.SpecSelect{3}, ''Value'',  8); set(guiHandlesSpec.SpecSelect{4}, ''Value'',  7); set(guiHandlesSpec.Sub100HzCheck{1}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{2}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{3}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{4}, ''Value'',  0); end;',
        'if get(guiHandlesSpec.specPresets, ''Value'') == 3, set(guiHandlesSpec.SpecSelect{1}, ''Value'',  3); set( guiHandlesSpec.SpecSelect{2}, ''Value'',  2); set(guiHandlesSpec.SpecSelect{3}, ''Value'',  6); set(guiHandlesSpec.SpecSelect{4}, ''Value'',  7); set(guiHandlesSpec.Sub100HzCheck{1}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{2}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{3}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{4}, ''Value'',  0); end;',
        'if get(guiHandlesSpec.specPresets, ''Value'') == 4, set(guiHandlesSpec.SpecSelect{1}, ''Value'',  2); set( guiHandlesSpec.SpecSelect{2}, ''Value'',  7); set(guiHandlesSpec.SpecSelect{3}, ''Value'',  5); set(guiHandlesSpec.SpecSelect{4}, ''Value'',  4); set(guiHandlesSpec.Sub100HzCheck{1}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{2}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{3}, ''Value'',  1); set(guiHandlesSpec.Sub100HzCheck{4}, ''Value'',  1); end;',
        'if get(guiHandlesSpec.specPresets, ''Value'') == 5, set(guiHandlesSpec.SpecSelect{1}, ''Value'',  3); set( guiHandlesSpec.SpecSelect{2}, ''Value'',  2); set(guiHandlesSpec.SpecSelect{3}, ''Value'',  3); set(guiHandlesSpec.SpecSelect{4}, ''Value'',  2); set(guiHandlesSpec.Sub100HzCheck{1}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{2}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{3}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{4}, ''Value'',  0); end;',
        'if get(guiHandlesSpec.specPresets, ''Value'') == 6, set(guiHandlesSpec.SpecSelect{1}, ''Value'',  8); set( guiHandlesSpec.SpecSelect{2}, ''Value'',  7); set(guiHandlesSpec.SpecSelect{3}, ''Value'',  8); set(guiHandlesSpec.SpecSelect{4}, ''Value'',  7); set(guiHandlesSpec.Sub100HzCheck{1}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{2}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{3}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{4}, ''Value'',  0); end;',
        'if get(guiHandlesSpec.specPresets, ''Value'') == 7, set(guiHandlesSpec.SpecSelect{1}, ''Value'',  3); set( guiHandlesSpec.SpecSelect{2}, ''Value'',  3); set(guiHandlesSpec.SpecSelect{3}, ''Value'',  3); set(guiHandlesSpec.SpecSelect{4}, ''Value'',  3); set(guiHandlesSpec.Sub100HzCheck{1}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{2}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{3}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{4}, ''Value'',  0); end;',
        'if get(guiHandlesSpec.specPresets, ''Value'') == 8, set(guiHandlesSpec.SpecSelect{1}, ''Value'',  2); set( guiHandlesSpec.SpecSelect{2}, ''Value'',  2); set(guiHandlesSpec.SpecSelect{3}, ''Value'',  2); set(guiHandlesSpec.SpecSelect{4}, ''Value'',  2); set(guiHandlesSpec.Sub100HzCheck{1}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{2}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{3}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{4}, ''Value'',  0); end;',
        'if get(guiHandlesSpec.specPresets, ''Value'') == 9, set(guiHandlesSpec.SpecSelect{1}, ''Value'',  7); set( guiHandlesSpec.SpecSelect{2}, ''Value'',  7); set(guiHandlesSpec.SpecSelect{3}, ''Value'',  7); set(guiHandlesSpec.SpecSelect{4}, ''Value'',  7); set(guiHandlesSpec.Sub100HzCheck{1}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{2}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{3}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{4}, ''Value'',  0); end;',
        'if get(guiHandlesSpec.specPresets, ''Value'') == 10, set(guiHandlesSpec.SpecSelect{1}, ''Value'',  4); set( guiHandlesSpec.SpecSelect{2}, ''Value'',  4); set(guiHandlesSpec.SpecSelect{3}, ''Value'',  4); set(guiHandlesSpec.SpecSelect{4}, ''Value'',  4); set(guiHandlesSpec.Sub100HzCheck{1}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{2}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{3}, ''Value'',  0); set(guiHandlesSpec.Sub100HzCheck{4}, ''Value'',  0); end;']);

    guiHandlesSpec.computeSpec = uicontrol(PTspecfig, 'string', 'Run', 'fontsize', fontsz, 'TooltipString', [TooltipString_specRun], 'units', 'normalized', 'Position', [posInfo.computeSpec],
    'ForegroundColor',[colRun],'callback', 'PTplotSpec;');

    guiHandlesSpec.resetSpec = uicontrol(PTspecfig, 'string', 'Reset', 'fontsize', fontsz, 'TooltipString', ['Reset Spectral Tool'], 'units', 'normalized', 'Position', [posInfo.resetSpec],
    'ForegroundColor', [cautionCol],'callback', ' for k = 1 :12, delete(subplot(''position'',posInfo.SpecPos(k,:))), end; guiHandlesSpec.specPresets, ''Value'', 1); PTspecUIcontrol; set(PTspecfig, ''pointer'', ''arrow'');');

    guiHandlesSpec.checkbox2d = uicontrol(PTspecfig, 'Style', 'checkbox', 'String', '2D', 'fontsize', fontsz, 'TooltipString', [TooltipString_2d],
    'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.checkbox2d], 'callback', 'if ~isempty(fnameMaster), end;updateSpec=1;PTplotSpec;');

    guiHandlesSpec.checkboxPSD = uicontrol(PTspecfig, 'Style', 'checkbox', 'String', 'PSD', 'fontsize', fontsz, 'TooltipString', ['Power Spectral Density'],
    'units', 'normalized', 'Value', 0, 'BackgroundColor', bgcolor, 'Position', [posInfo.checkboxPSD], 'callback', 'PTplotSpec;');

    guiHandlesSpec.controlFreqCutoff_text = uicontrol(PTspecfig, 'style', 'text', 'string', 'freq lims Hz', 'fontsize', fontsz, 'TooltipString', [TooltipString_controlFreqCutoff], 'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.controlFreqCutoff_text]);
    guiHandlesSpec.controlFreq1Cutoff = uicontrol(PTspecfig, 'style', 'edit', 'string', [num2str(round(Flim1))], 'fontsize', fontsz, 'TooltipString', [TooltipString_controlFreqCutoff], 'units', 'normalized', 'Position', [posInfo.controlFreq1Cutoff],
    'callback', '@textinput_call2; Flim1=round(str2num(get(guiHandlesSpec.controlFreq1Cutoff, ''String'')));updateSpec=1;PTplotSpec;');
    guiHandlesSpec.controlFreq2Cutoff = uicontrol(PTspecfig, 'style', 'edit', 'string', [num2str(round(Flim2))], 'fontsize', fontsz, 'TooltipString', [TooltipString_controlFreqCutoff], 'units', 'normalized', 'Position', [posInfo.controlFreq2Cutoff],
    'callback', '@textinput_call2; Flim2=round(str2num(get(guiHandlesSpec.controlFreq2Cutoff, ''String'')));updateSpec=1;PTplotSpec;');

    guiHandlesSpec.saveFig1 = uicontrol(PTspecfig, 'string', 'Save Fig', 'fontsize', fontsz, 'TooltipString', [TooltipString_saveFig], 'units', 'normalized', 'ForegroundColor', [saveCol], 'Position', [posInfo.saveFig1],
    'callback', 'guiHandlesSpec.saveFig1.FontWeight=''bold'';PTsaveFig;guiHandlesSpec.saveFig1.FontWeight=''normal'';');

    guiHandlesSpec.saveSettings1 = uicontrol(PTspecfig, 'string', 'Save Settings', 'fontsize', fontsz, 'TooltipString', ['Save current settings to PTB defaults'], 'units', 'normalized', 'Position', [posInfo.saveSettings1],
    'ForegroundColor', [saveCol],'callback', 'guiHandlesSpec.saveSettings1.FontWeight=''bold'';PTsaveSettings; guiHandlesSpec.saveSettings1.FontWeight=''normal'';');

    guiHandlesSpec.Sub100HzCheck{1} = uicontrol(PTspecfig, 'Style', 'checkbox', 'String', '<100Hz', 'fontsize', fontsz, 'TooltipString', [TooltipString_sub100], 'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.Sub100HzCheck1], 'callback', 'if ~isempty(fnameMaster), end;updateSpec=1;PTplotSpec;');
    guiHandlesSpec.Sub100HzCheck{2} = uicontrol(PTspecfig, 'Style', 'checkbox', 'String', '<100Hz', 'fontsize', fontsz, 'TooltipString', [TooltipString_sub100], 'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.Sub100HzCheck2], 'callback', 'if ~isempty(fnameMaster), end;updateSpec=1;PTplotSpec;');
    guiHandlesSpec.Sub100HzCheck{3} = uicontrol(PTspecfig, 'Style', 'checkbox', 'String', '<100Hz', 'fontsize', fontsz, 'TooltipString', [TooltipString_sub100], 'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.Sub100HzCheck3], 'callback', 'if ~isempty(fnameMaster), end;updateSpec=1;PTplotSpec;');
    guiHandlesSpec.Sub100HzCheck{4} = uicontrol(PTspecfig, 'Style', 'checkbox', 'String', '<100Hz', 'fontsize', fontsz, 'TooltipString', [TooltipString_sub100], 'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.Sub100HzCheck4], 'callback', 'if ~isempty(fnameMaster), end;updateSpec=1;PTplotSpec;');

    % create string list for SpecSelect
    sA = {'NONE', 'Gyro', 'Gyro prefilt', 'PID error', 'Set point', 'Pterm', 'Dterm', 'Dterm prefilt', 'PIDsum'};

    guiHandlesSpec.SpecSelect{1} = uicontrol(PTspecfig, 'Style', 'popupmenu', 'string', sA, 'fontsize', fontsz, 'TooltipString', [TooltipString_user], 'units', 'normalized', 'Position', [posInfo.hDropdn1pos]);
    guiHandlesSpec.SpecSelect{2} = uicontrol(PTspecfig, 'Style', 'popupmenu', 'string', sA, 'fontsize', fontsz, 'TooltipString', [TooltipString_user], 'units', 'normalized', 'Position', [posInfo.hDropdn2pos]);
    guiHandlesSpec.SpecSelect{3} = uicontrol(PTspecfig, 'Style', 'popupmenu', 'string', sA, 'fontsize', fontsz, 'TooltipString', [TooltipString_user], 'units', 'normalized', 'Position', [posInfo.hDropdn3pos]);
    guiHandlesSpec.SpecSelect{4} = uicontrol(PTspecfig, 'Style', 'popupmenu', 'string', sA, 'fontsize', fontsz, 'TooltipString', [TooltipString_user], 'units', 'normalized', 'Position', [posInfo.hDropdn4pos]);

    guiHandlesSpec.FileSelect{1} = uicontrol(PTspecfig, 'Style', 'popupmenu', 'string', [fnameMaster], 'fontsize', fontsz, 'TooltipString', [TooltipString_user], 'units', 'normalized', 'Position', [posInfo.fDropdn1pos]);
    guiHandlesSpec.FileSelect{2} = uicontrol(PTspecfig, 'Style', 'popupmenu', 'string', [fnameMaster], 'fontsize', fontsz, 'TooltipString', [TooltipString_user], 'units', 'normalized', 'Position', [posInfo.fDropdn2pos]);
    guiHandlesSpec.FileSelect{3} = uicontrol(PTspecfig, 'Style', 'popupmenu', 'string', [fnameMaster], 'fontsize', fontsz, 'TooltipString', [TooltipString_user], 'units', 'normalized', 'Position', [posInfo.fDropdn3pos]);
    guiHandlesSpec.FileSelect{4} = uicontrol(PTspecfig, 'Style', 'popupmenu', 'string', [fnameMaster], 'fontsize', fontsz, 'TooltipString', [TooltipString_user], 'units', 'normalized', 'Position', [posInfo.fDropdn4pos]);

    guiHandlesSpec.smoothFactor_select = uicontrol(PTspecfig, 'style', 'popupmenu', 'string', {'smoothing low' 'smoothing low-med' 'smoothing medium' 'smoothing med-high' 'smoothing high'}, 'fontsize', fontsz, 'TooltipString', [TooltipString_smooth], 'units', 'normalized', 'Position', [posInfo.smooth_select],
    'callback', '@selection2;updateSpec=1;PTplotSpec;');

    guiHandlesSpec.climMax_text = uicontrol(PTspecfig, 'style', 'text', 'string', 'scale', 'fontsize', fontsz, 'TooltipString', [TooltipString_scale], 'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.climMax_text]);
    guiHandlesSpec.climMax_input = uicontrol(PTspecfig, 'style', 'edit', 'string', [num2str(climScale(get(guiHandlesSpec.checkboxPSD, 'Value') + 1, 1))], 'fontsize', fontsz, 'TooltipString', [TooltipString_scale], 'units', 'normalized', 'Position', [posInfo.climMax_input],
    'callback', '@textinput_call2; climScale(get(guiHandlesSpec.checkboxPSD, ''Value'')+1, 1)=str2num(get(guiHandlesSpec.climMax_input, ''String''));updateSpec=1;PTplotSpec;');

    guiHandlesSpec.climMax_text2 = uicontrol(PTspecfig, 'style', 'text', 'string', 'scale', 'fontsize', fontsz, 'TooltipString', [TooltipString_scale], 'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.climMax_text2]);
    guiHandlesSpec.climMax_input2 = uicontrol(PTspecfig, 'style', 'edit', 'string', [num2str(climScale(get(guiHandlesSpec.checkboxPSD, 'Value') + 1, 2))], 'fontsize', fontsz, 'TooltipString', [TooltipString_scale], 'units', 'normalized', 'Position', [posInfo.climMax_input2],
    'callback', '@textinput_call2; climScale(get(guiHandlesSpec.checkboxPSD, ''Value'')+1, 2)=str2num(get(guiHandlesSpec.climMax_input2, ''String''));updateSpec=1;PTplotSpec;');

    guiHandlesSpec.climMax_text3 = uicontrol(PTspecfig, 'style', 'text', 'string', 'scale', 'fontsize', fontsz, 'TooltipString', [TooltipString_scale], 'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.climMax_text3]);
    guiHandlesSpec.climMax_input3 = uicontrol(PTspecfig, 'style', 'edit', 'string', [num2str(climScale(get(guiHandlesSpec.checkboxPSD, 'Value') + 1, 3))], 'fontsize', fontsz, 'TooltipString', [TooltipString_scale], 'units', 'normalized', 'Position', [posInfo.climMax_input3],
    'callback', '@textinput_call2; climScale(get(guiHandlesSpec.checkboxPSD, ''Value'')+1, 3)=str2num(get(guiHandlesSpec.climMax_input3, ''String''));updateSpec=1;PTplotSpec;');

    guiHandlesSpec.climMax_text4 = uicontrol(PTspecfig, 'style', 'text', 'string', 'scale', 'fontsize', fontsz, 'TooltipString', [TooltipString_scale], 'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.climMax_text4]);
    guiHandlesSpec.climMax_input4 = uicontrol(PTspecfig, 'style', 'edit', 'string', [num2str(climScale(get(guiHandlesSpec.checkboxPSD, 'Value') + 1, 4))], 'fontsize', fontsz, 'TooltipString', [TooltipString_scale], 'units', 'normalized', 'Position', [posInfo.climMax_input4],
    'callback', '@textinput_call2; climScale(get(guiHandlesSpec.checkboxPSD, ''Value'')+1, 4)=str2num(get(guiHandlesSpec.climMax_input4, ''String''));updateSpec=1;PTplotSpec;');

    guiHandlesSpec.ColormapSelect = uicontrol(PTspecfig, 'Style', 'popupmenu', 'string', {'parula', 'jet', 'hot', 'cool', 'gray', 'bone', 'copper', 'viridis', 'linear-RED', 'linear-GREY'},
    'fontsize', fontsz, 'Value', 3, 'TooltipString', [TooltipString_cmap], 'units', 'normalized', 'Position', [posInfo.ColormapSelect], 'callback', '@selection2;updateSpec=1; PTplotSpec;');

    try set(guiHandlesSpec.SpecSelect{1}, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'FreqXthr-Column1')))), catch, set(guiHandlesSpec.SpecSelect{1}, 'Value', 3); end
    try set(guiHandlesSpec.SpecSelect{2}, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'FreqXthr-Column2')))), catch, set(guiHandlesSpec.SpecSelect{2}, 'Value', 2); end
    try set(guiHandlesSpec.SpecSelect{3}, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'FreqXthr-Column3')))), catch, set(guiHandlesSpec.SpecSelect{3}, 'Value', 8); end
    try set(guiHandlesSpec.SpecSelect{4}, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'FreqXthr-Column4')))), catch, set(guiHandlesSpec.SpecSelect{4}, 'Value', 7); end
    try set(guiHandlesSpec.specPresets, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'FreqXthr-Preset')))), catch, set(guiHandlesSpec.specPresets, 'Value', 1); end
    try set(guiHandlesSpec.ColormapSelect, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'FreqXthr-Colormap')))), catch, set(guiHandlesSpec.ColormapSelect, 'Value', 3); end
    try set(guiHandlesSpec.smoothFactor_select, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'FreqXthr-Smoothing')))), catch, set(guiHandlesSpec.smoothFactor_select, 'Value', 3); end

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
