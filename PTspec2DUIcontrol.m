%% PTspec2DUIcontrol - ui controls for spectral analyses plots

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------
pkg load communications
if ~isempty(fnameMaster)

    %%% tooltips
    TooltipString_specRun = ['Run current spectral configuration'];
    TooltipString_cmap = ['Choose from a selection of colormaps'];
    TooltipString_smooth = ['Choose amount of smoothing'];
    TooltipString_user = ['Choose the variable you wish to plot'];
    TooltipString_sub100 = ['Zoom data to show sub 100Hz details',
                        '\n', 'Typically used to see propwash or mid-throttle vibration in e.g. Gyro/Pterm/PIDerror'];

    %%%
    PTcolormap;
    % define
    smat = []; %string
    ampmat = []; %spec matrix
    amp2d2 = []; %spec 2d
    freq2d2 = []; % freq

    clear posInfo.Spec2Pos
    cols = [0.05 0.48];
    rows = [0.69 0.395 0.1];
    k = 0;

    for c = 1:size(cols, 2)

        for r = 1:size(rows, 2)
            k = k + 1;

            if c == 1
                posInfo.Spec2Pos(k, :) = [cols(c) rows(r) 0.38 0.25];
            else
                posInfo.Spec2Pos(k, :) = [cols(c) rows(r) 0.38 0.25];
            end

        end

    end

    vPosSpec2d = .037;

    posInfo.fileListWindowSpec = [.898 .7 + vPosSpec2d .088 .20];
    posInfo.TermListWindowSpec = [.898 .55 + vPosSpec2d .088 .14];

    posInfo.computeSpec = [.896 .52 + vPosSpec2d .0455 .026];
    posInfo.resetSpec = [.942 .52 + vPosSpec2d .0455 .026];
    posInfo.spectrogramButton2 = [.896 .495 + vPosSpec2d .0915 .026];
    posInfo.spectrogramButton3 = [.896 .47 + vPosSpec2d .0915 .026];
    posInfo.saveFig2 = [.896 .445 + vPosSpec2d .0455 .026]; % .896 .495 .092 .026
    posInfo.saveSettings2 = [.942 .445 + vPosSpec2d .0455 .026];

    posInfo.smooth_select = [.895 .405 + vPosSpec2d .0955 .04];
    posInfo.Delay = [.895 .379 + vPosSpec2d .0955 .04];

    posInfo.plotRspec = [.90 .37 + vPosSpec2d .03 .025];
    posInfo.plotPspec = [.925 .37 + vPosSpec2d .03 .025];
    posInfo.plotYspec = [.95 .37 + vPosSpec2d .03 .025];

    posInfo.checkboxPSD = [.90 .35 + vPosSpec2d .03 .02];
    posInfo.RPYcomboSpec = [.932 .35 + vPosSpec2d .055 .02];

    posInfo.climMax1_text = [.894 .322 + vPosSpec2d .026 .022];
    posInfo.climMax1_input = [.918 .322 + vPosSpec2d .022 .022];
    posInfo.climMax2_text = [.943 .322 + vPosSpec2d .026 .022];
    posInfo.climMax2_input = [.968 .322 + vPosSpec2d .022 .022];

    climScale1 = [0; -50];
    climScale2 = [0.5; 20];

    PTspecfig2 = figure(3);
    set(PTspecfig2, 'units', 'normalized', 'Position', [.1 .1 .75 .8], 
    'NumberTitle','off', 'Name', ['PIDtoolbox (' PtbVersion ') - Spectral Analyzer'],'InvertHardcopy','off','color', bgcolor);
    % todo
    % dcm_obj2 = datacursormode(PTspecfig2);
    % set(dcm_obj2, 'UpdateFcn', @PTdatatip);

    specCrtlpanel = uipanel('Title', 'select files (max 10)', 'FontSize', fontsz,
    'BackgroundColor', [.95 .95 .95],
    'Position', [.89 .31 + vPosSpec2d .105 .61]);

    guiHandlesSpec2.computeSpec = uicontrol(PTspecfig2, 'string', 'Run', 
    'ForegroundColor',[colRun], 'fontsize', fontsz, 'TooltipString', [TooltipString_specRun], 'units', 'normalized', 'Position', [posInfo.computeSpec],
    'callback', 'PTplotSpec2D;');
    
    guiHandlesSpec2.resetSpec = uicontrol(PTspecfig2, 'string', 'Reset', 'fontsize', fontsz, 'TooltipString', ['Reset Spectral Tool'], 'units', 'normalized', 'Position', [posInfo.resetSpec],
    'ForegroundColor' , [cautionCol],'callback', ' for k = 1 : 6, delete(subplot(''position'',posInfo.Spec2Pos(k,:))), end; set(PTspecfig2, ''pointer'', ''arrow'');');
    

    guiHandlesSpec2.saveFig2 = uicontrol(PTspecfig2, 'string', 'Save Fig', 'fontsize', fontsz, 'TooltipString', [TooltipString_saveFig], 'units', 'normalized', 'ForegroundColor', [saveCol], 'Position', [posInfo.saveFig2],
    'callback', 'guiHandlesSpec2.saveFig2.FontWeight=''bold'';PTsaveFig;guiHandlesSpec2.saveFig2.FontWeight=''normal'';');

    guiHandlesSpec2.saveSettings2 = uicontrol(PTspecfig2, 'string', 'Save Settings', 'fontsize', fontsz, 'TooltipString', ['Save current settings to PTB defaults'], 'units', 'normalized', 'Position', [posInfo.saveSettings2],
    'ForegroundColor',[saveCol],'callback', 'guiHandlesSpec2.saveSettings2.FontWeight=''bold'';PTsaveSettings; guiHandlesSpec2.saveSettings2.FontWeight=''normal'';');
    

    % create string list for SpecSelect
    sA = {'Gyro', 'Gyro prefilt', 'Dterm', 'Dterm prefilt', 'Pterm', 'PID error', 'Set point', 'PIDsum'};

    guiHandlesSpec2.SpecList = uicontrol(PTspecfig2, 'Style', 'listbox', 'Value', [1 2], 'string', [sA], 'max', 3, 'min', 1, 'fontsize', fontsz, 'TooltipString', [TooltipString_user], 'units', 'normalized', 'Position', [posInfo.TermListWindowSpec], 'callback', 'if length(get(guiHandlesSpec2.SpecList, ''Value'')) > 2, set(guiHandlesSpec2.SpecList, ''Value'',1); end;');
    % guiHandlesSpec2.SpecList, 'Value', [1 2];

    guiHandlesSpec2.FileSelect = uicontrol(PTspecfig2, 'Style', 'listbox', 'string', [fnameMaster], 'max', 10, 'min', 1, 'fontsize', fontsz, 'TooltipString', [TooltipString_user], 'units', 'normalized', 'Position', [posInfo.fileListWindowSpec], 'callback', 'if length(get(guiHandlesSpec2.FileSelect, ''Value'')) > 10, set(guiHandlesSpec2.FileSelect, ''Value'',1); end;');

    guiHandlesSpec2.smoothFactor_select = uicontrol(PTspecfig2, 'style', 'popupmenu', 'string', {'smoothing low' 'smoothing low-med' 'smoothing medium' 'smoothing med-high' 'smoothing high'}, 'fontsize', fontsz, 'TooltipString', [TooltipString_smooth], 'units', 'normalized', 'Position', [posInfo.smooth_select],
    'callback', '@selection2;PTplotSpec2D;');

    guiHandlesSpec2.spectrogramButton2 = uicontrol(PTspecfig2, 'string', 'Freq x Throttle', 'fontsize', fontsz, 'TooltipString', ['Opens Freq x Throttle Spectrogram in New Window'], 'units', 'normalized', 'Position', [posInfo.spectrogramButton2],
    'ForegroundColor', [colorA],'callback', 'PTspecUIcontrol;');
    

    guiHandlesSpec2.spectrogramButton3 = uicontrol(PTspecfig2, 'string', 'Freq x Time', 'fontsize', fontsz, 'TooltipString', ['Opens Freq x Time Spectrogram in New Window'], 'units', 'normalized', 'Position', [posInfo.spectrogramButton3],
    'ForegroundColor',[colorB],'callback', 'PTfreqTimeUIcontrol;');
    

    guiHandlesSpec2.Delay = uicontrol(PTspecfig2, 'style', 'popupmenu', 'string', {'filter delay', 'SP-gyro delay', 'SP smoothing delay'}, 'fontsize', fontsz, 'TooltipString', ['Select which Delay Display'], 'units', 'normalized', 'Position', [posInfo.Delay],
    'callback', 'PTplotSpec2D;');

    guiHandlesSpec2.plotR = uicontrol(PTspecfig2, 'Style', 'checkbox', 'String', 'R', 'fontsize', fontsz, 'TooltipString', ['Plot Roll '],
    'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.plotRspec], 'callback', 'for k = 1 : 6, delete(subplot(''position'',posInfo.Spec2Pos(k,:))), end; set(PTspecfig2, ''pointer'', ''arrow'');');

    guiHandlesSpec2.plotP = uicontrol(PTspecfig2, 'Style', 'checkbox', 'String', 'P', 'fontsize', fontsz, 'TooltipString', ['Plot Pitch '],
    'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.plotPspec], 'callback', 'for k = 1 : 6, delete(subplot(''position'',posInfo.Spec2Pos(k,:))), end; set(PTspecfig2, ''pointer'', ''arrow'');');

    guiHandlesSpec2.plotY = uicontrol(PTspecfig2, 'Style', 'checkbox', 'String', 'Y', 'fontsize', fontsz, 'TooltipString', ['Plot Yaw '],
    'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.plotYspec], 'callback', 'for k = 1 : 6, delete(subplot(''position'',posInfo.Spec2Pos(k,:))), end; set(PTspecfig2, ''pointer'', ''arrow'');');

    guiHandlesSpec2.checkboxPSD = uicontrol(PTspecfig2, 'Style', 'checkbox', 'String', 'PSD', 'fontsize', fontsz, 'TooltipString', ['Power Spectral Density'],
    'units', 'normalized', 'Value', 0, 'BackgroundColor', bgcolor, 'Position', [posInfo.checkboxPSD], 'callback', 'PTplotSpec2D;');
    % guiHandlesSpec2.checkboxPSD, 'Value', 1);

    guiHandlesSpec2.RPYcomboSpec = uicontrol(PTspecfig2, 'Style', 'checkbox', 'String', 'Single Panel', 'fontsize', fontsz, 'TooltipString', ['Plot RPY in same panel '],
    'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.RPYcomboSpec], 'callback', 'PTplotSpec2D;');

    guiHandlesSpec2.climMax1_text = uicontrol(PTspecfig2, 'style', 'text', 'string', 'Y min', 'fontsize', fontsz, 'TooltipString', ['Y min'], 'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.climMax1_text]);
    guiHandlesSpec2.climMax1_input = uicontrol(PTspecfig2, 'style', 'edit', 'string', [num2str(climScale1(get(guiHandlesSpec2.checkboxPSD, 'Value') + 1, 1))], 'fontsize', fontsz, 'TooltipString', ['Y min'], 'units', 'normalized', 'Position', [posInfo.climMax1_input],
    'callback', '@textinput_call2; climScale1(get(guiHandlesSpec2.checkboxPSD, ''Value'')+1, 1)=str2num(get(guiHandlesSpec2.climMax1_input, ''String''));PTplotSpec2D;');

    guiHandlesSpec2.climMax2_text = uicontrol(PTspecfig2, 'style', 'text', 'string', 'Y max', 'fontsize', fontsz, 'TooltipString', ['Y max'], 'units', 'normalized', 'BackgroundColor', bgcolor, 'Position', [posInfo.climMax2_text]);
    guiHandlesSpec2.climMax2_input = uicontrol(PTspecfig2, 'style', 'edit', 'string', [num2str(climScale2(get(guiHandlesSpec2.checkboxPSD, 'Value') + 1, 1))], 'fontsize', fontsz, 'TooltipString', ['Y max'], 'units', 'normalized', 'Position', [posInfo.climMax2_input],
    'callback', '@textinput_call2; climScale2(get(guiHandlesSpec2.checkboxPSD, ''Value'')+1, 1)=str2num(guiHandlesSpec2.climMax2_input, ''String''));PTplotSpec2D;');

    try
        set(guiHandlesSpec2.SpecList, 'Value', [defaults.Values(find(strcmp(defaults.Parameters, 'spec2D-term1'))) defaults.Values(find(strcmp(defaults.Parameters, 'spec2D-term2')))]);
    catch
        set(guiHandlesSpec2.SpecList, 'Value', [1 2]);
    end

    try
        set(guiHandlesSpec2.smoothFactor_select, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'spec2D-smoothing'))));
    catch
        set(guiHandlesSpec2.smoothFactor_select, 'Value', 3);
    end

    try
        set(guiHandlesSpec2.Delay, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'spec2D-delay'))));
    catch
        set(guiHandlesSpec2.Delay, 'Value', 1);
    end

    try
        set(guiHandlesSpec2.plotR, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'spec2D-plotR'))));
        catch, set(guiHandlesSpec2.plotR, 'Value', 1);
    end

    try
        set(guiHandlesSpec2.plotP, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'spec2D-plotP'))));
        catch, set(guiHandlesSpec2.plotP, 'Value', 1);
    end

    try
        set(guiHandlesSpec2.plotY, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'spec2D-plotY'))));
        catch, set(guiHandlesSpec2.plotY, 'Value', 1);
    end

    try
        set(guiHandlesSpec2.RPYcomboSpec, 'Value', defaults.Values(find(strcmp(defaults.Parameters, 'spec2D-SinglePanel'))));
        catch, set(guiHandlesSpec2.RPYcomboSpec, 'Value', 0);
    end

    FilterDelayDterm = {};
    SPGyroDelay = [];
    Debug01 = {};
    Debug02 = {};

    for k = 1:Nfiles
        Fs = 1000 / A_lograte(k); % yields more consistent results (mode(diff(tta)));
        maxlag = int8(round(30000 / Fs)); %~30ms delay

        clear d pg g1 g1 s1 g2 s2  g3 s3

        try
            pg = smooth(T{k}.debug_0_(tIND{k}), 50);
        catch
            pg = 0;
        end

        g1 = smooth(T{k}.gyroADC_0_(tIND{k}), 50);
        s1 = smooth(T{k}.setpoint_0_(tIND{k}), 50);

        g2 = smooth(T{k}.gyroADC_1_(tIND{k}), 50);
        s2 = smooth(T{k}.setpoint_1_(tIND{k}), 50);

        g3 = smooth(T{k}.gyroADC_2_(tIND{k}), 50);
        s3 = smooth(T{k}.setpoint_2_(tIND{k}), 50);

        % d = finddelay(pg, g1, maxlag); % pre vs post filt gyro
        d = finddelay(pg, g1);
        d = d * (Fs / 1000);
        if d < .1, Debug01{k} = ' '; else Debug01{k} = num2str(d); end

        % d = finddelay(pg, s1, maxlag); % pre vs post filt set point
        d = finddelay(pg, s1);
        d = d * (Fs / 1000);
        if d < .1, Debug02{k} = ' '; else Debug02{k} = num2str(d); end

        % d = finddelay(s1, g1, maxlag); % set point to gyro
        d = finddelay(s1, g1);
        d = d * (Fs / 1000);
        SPGyroDelay(k, 1) = d;

        % d = finddelay(s2, g2, maxlag); % set point to gyro
        d = finddelay(s2, g2);
        d = d * (Fs / 1000);
        SPGyroDelay(k, 2) = d;

        % d = finddelay(s3, g3, maxlag); % set point to gyro
        d = finddelay(s3, g3);
        d = d * (Fs / 1000);
        SPGyroDelay(k, 3) = d;

        clear d d1 d2
        d1 = smooth(T{k}.axisDpf_0_(tIND{k}), 50);
        d2 = smooth(T{k}.axisD_0_(tIND{k}), 50);
        % d = finddelay(d1, d2, maxlag); % pre vs post filt dterm
        d = finddelay(d1, d2);
        d = d * (Fs / 1000);
        if d < .1, FilterDelayDterm{k} = ' '; else FilterDelayDterm{k} = num2str(d); end
    end

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
