%% PTplotLogViewer - script to plot main line graphs

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

if ~isempty(fnameMaster)

    set(PTfig, 'pointer', 'watch');

    global logviewerYscale;
    logviewerYscale = str2num(get(guiHandles.maxY_input, 'String'));

    figure(PTfig);

    maxY = str2num(get(guiHandles.maxY_input, 'String'));

    alpha_red = .8;
    alpha_blue = .8;

    % scale fonts according to size of window and/or screen
    prop_max_screen = (max([get(PTfig, 'Position')(3) get(PTfig, 'Position')(4)]));
    fontsz = (screensz_multiplier * prop_max_screen);

    % todo
    % f = fields(guiHandles);

    % for i = 1:size(f, 1)
    %     eval(['guiHandles.' f{i} '.FontSize=fontsz;']);
    % end

    set(controlpanel, 'FontSize', fontsz);

    lineSmoothFactors = [1 10 20 40 80];

    if plotall_flag >= 0
        set(guiHandles.checkbox0, 'Value', get(guiHandles.checkbox15, 'Value'));
        set(guiHandles.checkbox1, 'Value', get(guiHandles.checkbox15, 'Value'));
        set(guiHandles.checkbox2, 'Value', get(guiHandles.checkbox15, 'Value'));
        set(guiHandles.checkbox3, 'Value', get(guiHandles.checkbox15, 'Value'));
        set(guiHandles.checkbox4, 'Value', get(guiHandles.checkbox15, 'Value'));
        set(guiHandles.checkbox5, 'Value', get(guiHandles.checkbox15, 'Value'));
        set(guiHandles.checkbox6, 'Value', get(guiHandles.checkbox15, 'Value'));
        set(guiHandles.checkbox7, 'Value', get(guiHandles.checkbox15, 'Value'));
        set(guiHandles.checkbox8, 'Value', get(guiHandles.checkbox15, 'Value'));
        set(guiHandles.checkbox9, 'Value', get(guiHandles.checkbox15, 'Value'));
        set(guiHandles.checkbox10, 'Value', get(guiHandles.checkbox15, 'Value'));
        set(guiHandles.checkbox11, 'Value', get(guiHandles.checkbox15, 'Value'));
        set(guiHandles.checkbox12, 'Value', get(guiHandles.checkbox15, 'Value'));
        set(guiHandles.checkbox13, 'Value', get(guiHandles.checkbox15, 'Value'));
        set(guiHandles.checkbox14, 'Value', get(guiHandles.checkbox15, 'Value'));
    end

    plotall_flag=-1;

    expand_sz = [0.05 0.07 0.82 0.855];

    %% where you want full range of data

    % if start or end > length of file, or start > end
    if (epoch1_A(get(guiHandles.FileNum, 'Value')) > (tta{(get(guiHandles.FileNum, 'Value'))}(end) / us2sec)) || (epoch2_A(get(guiHandles.FileNum, 'Value')) > (tta{(get(guiHandles.FileNum, 'Value'))}(end) / us2sec)) || (epoch1_A(get(guiHandles.FileNum, 'Value')) > epoch2_A(get(guiHandles.FileNum, 'Value')))
        epoch1_A(set(guiHandles.FileNum, 'Value', 2));
        epoch2_A(get(guiHandles.FileNum, 'Value')) = floor(tta{(get(guiHandles.FileNum, 'Value'))}(end) / us2sec) - 1;
    end

    y = [epoch1_A(get(guiHandles.FileNum, 'Value')) * us2sec epoch2_A(get(guiHandles.FileNum, 'Value')) * us2sec]; %%% used for fill in unused data range
    t1 = (tta{(get(guiHandles.FileNum, 'Value'))}(find(tta{(get(guiHandles.FileNum, 'Value'))} > y(1), 1))) / us2sec;
    t2 = (tta{(get(guiHandles.FileNum, 'Value'))}(find(tta{(get(guiHandles.FileNum, 'Value'))} > y(2), 1))) / us2sec;

    tIND{get(guiHandles.FileNum, 'Value')} = (tta{get(guiHandles.FileNum, 'Value')} > (t1 * us2sec)) & (tta{get(guiHandles.FileNum, 'Value')} < (t2 * us2sec));

    guiHandles.slider = uicontrol(PTfig, 'style', 'slider', 'SliderStep', [0.001 0.01], 'Visible', 'on', 'units', 'normalized', 'position', [0.0826 0.905 0.795 0.02],
    'min', 0, 'max', 1, 'callback', 'Slider');

    %% log viewer line plots
    %%%%%%%% PLOT %%%%%%%
    axLabel = {'Roll'; 'Pitch'; 'Yaw'};
    lineStyleLV = {'-'; '-'; '-'};
    lineStyle2LV = {'-'; '--'; ':'};
    lineStyle2LVnames = {'solid'; 'dashed'; 'dotted'};
    axesOptionsLV = find([get(guiHandles.plotR, 'Value') get(guiHandles.plotP, 'Value') get(guiHandles.plotY, 'Value')]);

    ylabelname = [];

    for i = 1:size(axesOptionsLV, 2)

        if i == size(axesOptionsLV, 2)
            ylabelname = [ylabelname axLabel{axesOptionsLV(i)} '-' lineStyle2LVnames{i} '   (deg/s) '];
        else
            ylabelname = [ylabelname axLabel{axesOptionsLV(i)} '-' lineStyle2LVnames{i} '   |   '];
        end

    end

    PTfig;
    % todo
    % if strcmp(get(zoom, 'Enable'), 'off') &&~expandON
    %delete(subplot('position', fullszPlot));
    %delete(subplot('position', posInfo.linepos1));
    %delete(subplot('position', posInfo.linepos2));
    %delete(subplot('position', posInfo.linepos3));
    % end

    for i = 1:19

        try
            eval(['delete([hch' int2str(i) '])']);
        catch
        end

    end

    % todo
    % dcm_obj = datacursormode(PTfig);
    % set(dcm_obj, 'UpdateFcn', @PTdatatip);

    cntLV = 0;
    lnstyle = lineStyleLV;

    if ~isempty(fnameMaster)

        for ii = axesOptionsLV
            if get(guiHandles.RPYcomboLV, 'Value'), expandON = 0; end
            %%%%%%%
            if ~get(guiHandles.RPYcomboLV, 'Value') &&~expandON
                eval(['LVpanel' int2str(ii) '=subplot(' '''position''' ',posInfo.linepos' int2str(ii) ');'])
            end

            if ~get(guiHandles.RPYcomboLV, 'Value') && expandON

                try
                    eval(['subplot(hexpand' int2str(ii) ',' '''position''' ',expand_sz);'])
                    warning off
                catch
                end

            end

            if eval(['~isempty(hexpand' int2str(ii) ') && ishandle(hexpand' int2str(ii) ') || ~expandON'])

                cntLV = cntLV + 1;

                if get(guiHandles.RPYcomboLV, 'Value')
                    LVpanel4 = subplot('position', fullszPlot)
                    lnstyle = lineStyle2LV;
                end

                if ~get(guiHandles.RPYcomboLV, 'Value') && expandON == 0
                    eval(['LVpanel' int2str(ii) '= subplot(' '''position''' ',posInfo.linepos' int2str(ii) ');'])
                    lnstyle = lineStyleLV;
                end

                xmax = max(tta{get(guiHandles.FileNum, 'Value')} / us2sec);

                h = plot([0 xmax], [-maxY -maxY], 'k');
                set(h, 'linewidth', .2)
                hold on

                set(gca, 'ytick', [2*-maxY -maxY -maxY + 1 -(maxY / 2) 0 maxY / 2 maxY], 'yticklabel', {'0%' '100%' '' num2str(-(maxY / 2)) '0' num2str((maxY / 2)) ''}, 'YColor', [.2 .2 .2], 'fontweight', 'bold')
                set(gca, 'xtick', [round(xmax / 10):round(xmax / 10):round(xmax)], 'XColor', [.2 .2 .2])

                sFactor = lineSmoothFactors(get(guiHandles.lineSmooth, 'Value'));
% todo replaced loess with moving need to implement loess
                if get(guiHandles.checkbox0, 'Value')
                hch1 = plot(tta{get(guiHandles.FileNum, 'Value')} / us2sec, eval(['smooth(T{get(guiHandles.FileNum,''Value'')}.debug_' int2str(ii - 1) '_, sFactor, ''moving'')'])); 
                hold on; 
                set(hch1, 'color', [linec.col0], 'LineWidth', get(guiHandles.linewidth, 'Value') / 2, 'linestyle', [lnstyle{cntLV}]) 
                end
                if get(guiHandles.checkbox1, 'Value'), hch2 = plot(tta{get(guiHandles.FileNum, 'Value')} / us2sec, eval(['smooth(T{get(guiHandles.FileNum,''Value'')}.gyroADC_' int2str(ii - 1) '_, sFactor, ''moving'')'])); hold on; set(hch2, 'color', [linec.col1], 'LineWidth', get(guiHandles.linewidth, 'Value') / 2, 'linestyle', [lnstyle{cntLV}]), end
                if get(guiHandles.checkbox2, 'Value'), hch3 = plot(tta{get(guiHandles.FileNum, 'Value')} / us2sec, eval(['smooth(T{get(guiHandles.FileNum,''Value'')}.axisP_' int2str(ii - 1) '_, sFactor, ''moving'')'])); hold on; set(hch3, 'color', [linec.col2], 'LineWidth', get(guiHandles.linewidth, 'Value') / 2, 'linestyle', [lnstyle{cntLV}]), end
                if get(guiHandles.checkbox3, 'Value'), hch4 = plot(tta{get(guiHandles.FileNum, 'Value')} / us2sec, eval(['smooth(T{get(guiHandles.FileNum,''Value'')}.axisI_' int2str(ii - 1) '_, sFactor, ''moving'')'])); hold on; set(hch4, 'color', [linec.col3], 'LineWidth', get(guiHandles.linewidth, 'Value') / 2, 'linestyle', [lnstyle{cntLV}]), end
                if get(guiHandles.checkbox4, 'Value') && ii < 3, hch5 = plot(tta{get(guiHandles.FileNum, 'Value')} / us2sec, eval(['smooth(T{get(guiHandles.FileNum,''Value'')}.axisDpf_' int2str(ii - 1) '_, sFactor, ''moving'')'])); hold on; set(hch5, 'color', [linec.col4], 'LineWidth', get(guiHandles.linewidth, 'Value') / 2, 'linestyle', [lnstyle{cntLV}]), end
                if get(guiHandles.checkbox5, 'Value') && ii < 3, hch6 = plot(tta{get(guiHandles.FileNum, 'Value')} / us2sec, eval(['smooth(T{get(guiHandles.FileNum,''Value'')}.axisD_' int2str(ii - 1) '_, sFactor, ''moving'')'])); hold on; set(hch6, 'color', [linec.col5], 'LineWidth', get(guiHandles.linewidth, 'Value') / 2, 'linestyle', [lnstyle{cntLV}]), end
                if get(guiHandles.checkbox6, 'Value'), hch7 = plot(tta{get(guiHandles.FileNum, 'Value')} / us2sec, eval(['smooth(T{get(guiHandles.FileNum,''Value'')}.axisF_' int2str(ii - 1) '_, sFactor, ''moving'')'])); hold on; set(hch7, 'color', [linec.col6], 'LineWidth', get(guiHandles.linewidth, 'Value') / 2, 'linestyle', [lnstyle{cntLV}]), end
                if get(guiHandles.checkbox7, 'Value'), hch8 = plot(tta{get(guiHandles.FileNum, 'Value')} / us2sec, eval(['smooth(T{get(guiHandles.FileNum,''Value'')}.setpoint_' int2str(ii - 1) '_, sFactor, ''moving'')'])); hold on; set(hch8, 'color', [linec.col7], 'LineWidth', get(guiHandles.linewidth, 'Value') / 2, 'linestyle', [lnstyle{cntLV}]), end
                if get(guiHandles.checkbox8, 'Value'), hch9 = plot(tta{get(guiHandles.FileNum, 'Value')} / us2sec, eval(['smooth(T{get(guiHandles.FileNum,''Value'')}.pidsum_' int2str(ii - 1) '_, sFactor, ''moving'')'])); hold on; set(hch9, 'color', [linec.col8], 'LineWidth', get(guiHandles.linewidth, 'Value') / 2, 'linestyle', [lnstyle{cntLV}]), end
                if get(guiHandles.checkbox9, 'Value'), hch10 = plot(tta{get(guiHandles.FileNum, 'Value')} / us2sec, eval(['smooth(T{get(guiHandles.FileNum,''Value'')}.piderr_' int2str(ii - 1) '_, sFactor, ''moving'')'])); hold on; set(hch10, 'color', [linec.col9], 'LineWidth', get(guiHandles.linewidth, 'Value') / 2, 'linestyle', [lnstyle{cntLV}]), end
                if get(guiHandles.checkbox10, 'Value'), hch11 = plot(tta{get(guiHandles.FileNum, 'Value')} / us2sec, (smooth(T{get(guiHandles.FileNum, 'Value')}.motor_0_, sFactor, 'moving')) * (maxY / 100) -(maxY * 2)); hold on; set(hch11, 'color', [linec.col10], 'LineWidth', get(guiHandles.linewidth, 'Value') / 2), end
                if get(guiHandles.checkbox11, 'Value'), hch12 = plot(tta{get(guiHandles.FileNum, 'Value')} / us2sec, (smooth(T{get(guiHandles.FileNum, 'Value')}.motor_1_, sFactor, 'moving')) * (maxY / 100) -(maxY * 2)); hold on; set(hch12, 'color', [linec.col11], 'LineWidth', get(guiHandles.linewidth, 'Value') / 2), end
                if get(guiHandles.checkbox12, 'Value'), hch13 = plot(tta{get(guiHandles.FileNum, 'Value')} / us2sec, (smooth(T{get(guiHandles.FileNum, 'Value')}.motor_2_, sFactor, 'moving')) * (maxY / 100) -(maxY * 2)); hold on; set(hch13, 'color', [linec.col12], 'LineWidth', get(guiHandles.linewidth, 'Value') / 2), end
                if get(guiHandles.checkbox13, 'Value'), hch14 = plot(tta{get(guiHandles.FileNum, 'Value')} / us2sec, (smooth(T{get(guiHandles.FileNum, 'Value')}.motor_3_, sFactor, 'moving')) * (maxY / 100) -(maxY * 2)); hold on; set(hch14, 'color', [linec.col13], 'LineWidth', get(guiHandles.linewidth, 'Value') / 2), end
                % motor sigs 4-7 for x8 configuration
                if get(guiHandles.checkbox10, 'Value'), try hch15 = plot(tta{get(guiHandles.FileNum, 'Value')} / us2sec, (smooth(T{get(guiHandles.FileNum, 'Value')}.motor_4_, sFactor, 'moving')) * (maxY / 100) -(maxY * 2)); hold on; set(hch15, 'color', [linec.col10], 'LineWidth', get(guiHandles.linewidth, 'Value') / 2, 'LineStyle', '--'), catch, end, end
                if get(guiHandles.checkbox11, 'Value'), try hch16 = plot(tta{get(guiHandles.FileNum, 'Value')} / us2sec, (smooth(T{get(guiHandles.FileNum, 'Value')}.motor_5_, sFactor, 'moving')) * (maxY / 100) -(maxY * 2)); hold on; set(hch16, 'color', [linec.col11], 'LineWidth', get(guiHandles.linewidth, 'Value') / 2, 'LineStyle', '--'), catch, end, end
                if get(guiHandles.checkbox12, 'Value'), try hch17 = plot(tta{get(guiHandles.FileNum, 'Value')} / us2sec, (smooth(T{get(guiHandles.FileNum, 'Value')}.motor_6_, sFactor, 'moving')) * (maxY / 100) -(maxY * 2)); hold on; set(hch17, 'color', [linec.col12], 'LineWidth', get(guiHandles.linewidth, 'Value') / 2, 'LineStyle', '--'), catch, end, end
                if get(guiHandles.checkbox13, 'Value'), try hch18 = plot(tta{get(guiHandles.FileNum, 'Value')} / us2sec, (smooth(T{get(guiHandles.FileNum, 'Value')}.motor_7_, sFactor, 'moving')) * (maxY / 100) -(maxY * 2)); hold on; set(hch18, 'color', [linec.col13], 'LineWidth', get(guiHandles.linewidth, 'Value') / 2, 'LineStyle', '--'), catch, end, end

                if get(guiHandles.checkbox14, 'Value'), hch19 = plot(tta{get(guiHandles.FileNum, 'Value')} / us2sec, (smooth(T{get(guiHandles.FileNum, 'Value')}.setpoint_3_ / 10, sFactor, 'moving')) * (maxY / 100) -(maxY * 2)); hold on; set(hch19, 'color', [linec.col14], 'LineWidth', get(guiHandles.linewidth, 'Value') / 2), end

                h = fill([0, t1, t1, 0], [-maxY * 2, -maxY * 2, maxY, maxY], [.8 .8 .8]);
                set(h, 'FaceAlpha', 0.8, 'EdgeColor', [.8 .8 .8]);
                h = fill([t2, xmax, xmax, t2], [-maxY * 2, -maxY * 2, maxY, maxY], [.8 .8 .8]);
                set(h, 'FaceAlpha', 0.8, 'EdgeColor', [.8 .8 .8]);
                % todo
                % if strcmp(get(zoom, 'Enable'), 'on')
                % v = axis;
                % axis(v)
                % else
                axis([0 xmax -maxY * 2 maxY])
                % end

                box off

                if get(guiHandles.RPYcomboLV, 'Value')
                    y = ylabel([ylabelname], 'fontweight', 'bold', 'rotation', 90);
                else
                    y = ylabel([axLabel{ii} ' (deg/s)'], 'fontweight', 'bold', 'rotation', 90);
                end

                set(y, 'Units', 'normalized', 'position', [-.035 .67 1], 'color', [.2 .2 .2]);
                y = xlabel('Time (s)', 'fontweight', 'bold');
                set(y, 'color', [.2 .2 .2]);
                set(gca, 'fontsize', fontsz, 'XMinorGrid', 'on')
                grid on
            end

            try

                if ii == 1 &&~expandON
                    set(LVpanel1, 'color', [1 1 1], 'fontsize', fontsz, 'tickdir', 'in', 'xminortick', 'on', 'yminortick', 'on', 'position', [posInfo.linepos1]),
                    set(LVpanel1, 'buttondownfcn', ['expandON=1;hexpand1 = copyobj(LVpanel1, gcf); set(hexpand1, ''Units'', ''normal'',''fontweight'', ''bold'','
                                ' ''Position'', [expand_sz],'
                                ' ''buttondownfcn'', ''delete(hexpand1);expandON=0; '');']);
                end

                if ii == 2 &&~expandON
                    set(LVpanel2, 'color', [1 1 1], 'fontsize', fontsz, 'tickdir', 'in', 'xminortick', 'on', 'yminortick', 'on', 'position', [posInfo.linepos2]),
                    set(LVpanel2, 'buttondownfcn', ['expandON=1;hexpand2 = copyobj(LVpanel2, gcf); set(hexpand2, ''Units'', ''normal'',''fontweight'', ''bold'','
                                ' ''Position'', [expand_sz],'
                                ' ''buttondownfcn'', ''delete(hexpand2);expandON=0; '');']);
                end

                if ii == 3 &&~expandON
                    set(LVpanel3, 'color', [1 1 1], 'fontsize', fontsz, 'tickdir', 'in', 'xminortick', 'on', 'yminortick', 'on', 'position', [posInfo.linepos3]),
                    set(LVpanel3, 'buttondownfcn', ['expandON=1;hexpand3 = copyobj(LVpanel3, gcf); set(hexpand3, ''Units'', ''normal'',''fontweight'', ''bold'','
                                ' ''Position'', [expand_sz],'
                                ' ''buttondownfcn'', ''delete(hexpand3);expandON=0; '');'])
                end

            catch
            end

        end

    end

    set(PTfig, 'pointer', 'arrow')
else
    warndlg('Please select file(s)');
end
