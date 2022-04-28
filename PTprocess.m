%% PTprocess - script that extracts subset of total data based on highlighted epoch in main fig

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

try

    if ~isempty(filenameA) ||~isempty(filenameB)

        downsampleMultiplier = 5; % 5th of the resolution for faster plotting, display only

        set(PTfig, 'pointer', 'watch')

        if ~isempty(filenameA)

            if isempty(epoch1_A) || isempty(epoch2_A)
                epoch1_A = round(tta(1) / us2sec) + 2;
                epoch2_A = round(tta(end) / us2sec) - 2;
                guiHandles.Epoch1_A_Input = uicontrol(PTfig, 'style', 'edit', 'string', [int2str(epoch1_A)], 'fontsize', fontsz, 'units', 'normalized', 'Position', [posInfo.Epoch1_A_Input],
                'callback', '@textinput_call; epoch1_A=str2num(get(guiHandles.Epoch1_A_Input, ''String'')); PTprocess;PTplotLogViewer;');
                guiHandles.Epoch2_A_Input = uicontrol(PTfig, 'style', 'edit', 'string', [int2str(epoch2_A)], 'fontsize', fontsz, 'units', 'normalized', 'Position', [posInfo.Epoch2_A_Input],
                'callback', '@textinput_call;epoch2_A=str2num(get(guiHandles.Epoch2_A_Input, ''String'')); PTprocess;PTplotLogViewer;');
            end

            if (epoch2_A > round(tta(end) / us2sec))
                epoch2_A = round(tta(end) / us2sec);
                guiHandles.Epoch2_A_Input = uicontrol(PTfig, 'style', 'edit', 'string', [int2str(epoch2_A)], 'fontsize', fontsz, 'units', 'normalized', 'Position', [posInfo.Epoch2_A_Input],
                'callback', '@textinput_call;epoch2_A=str2num(get(guiHandles.Epoch2_A_Input, ''String'')); PTprocess;PTplotLogViewer;');
            end

            x = [epoch1_A * us2sec epoch2_A * us2sec];
            x2 = tta > tta(find(tta > x(1), 1)) & tta < tta(find(tta > x(2), 1));
            Time_A = tta(x2, 1) / us2sec;
            Time_A = Time_A - Time_A(1);
            DATtmpA.GyroFilt = DATmainA.GyroFilt(:, x2);
            DATtmpA.debug = DATmainA.debug(:, x2);
            DATtmpA.RCcommand = DATmainA.RCcommand(:, x2);
            DATtmpA.Pterm = DATmainA.Pterm(:, x2);
            DATtmpA.Iterm = DATmainA.Iterm(:, x2);
            DATtmpA.DtermRaw = DATmainA.DtermRaw(:, x2);
            DATtmpA.DtermFilt = DATmainA.DtermFilt(:, x2);
            DATtmpA.Fterm = DATmainA.Fterm(:, x2);
            DATtmpA.PIDsum = DATmainA.PIDsum(:, x2);
            DATtmpA.RCRate = DATmainA.RCRate(:, x2);
            DATtmpA.PIDerr = DATmainA.PIDerr(:, x2);
            DATtmpA.Motor12 = DATmainA.Motor(1:2, x2);
            DATtmpA.Motor34 = DATmainA.Motor(3:4, x2);
            DATtmpA.debug12 = DATmainA.debug(1:2, x2);
            DATtmpA.debug34 = DATmainA.debug(3:4, x2);

            dnsampleFactor = A_lograte * downsampleMultiplier; % 5 times less resolution for faster plotting, display only
            DATdnsmplA.tta = downsample(((tta - tta(1)) / us2sec), dnsampleFactor)';
            DATdnsmplA.GyroFilt = downsample(DATmainA.GyroFilt', dnsampleFactor)';
            DATdnsmplA.debug = downsample(DATmainA.debug', dnsampleFactor)';
            DATdnsmplA.RCcommand = downsample(DATmainA.RCcommand', dnsampleFactor)';
            DATdnsmplA.Pterm = downsample(DATmainA.Pterm', dnsampleFactor)';
            DATdnsmplA.Iterm = downsample(DATmainA.Iterm', dnsampleFactor)';
            DATdnsmplA.DtermRaw = downsample(DATmainA.DtermRaw', dnsampleFactor)';
            DATdnsmplA.DtermFilt = downsample(DATmainA.DtermFilt', dnsampleFactor)';
            DATdnsmplA.Fterm = downsample(DATmainA.Fterm', dnsampleFactor)';
            DATdnsmplA.RCRate = downsample(DATmainA.RCRate', dnsampleFactor)';
            DATdnsmplA.PIDsum = downsample(DATmainA.PIDsum', dnsampleFactor)';
            DATdnsmplA.PIDerr = downsample(DATmainA.PIDerr', dnsampleFactor)';
            DATdnsmplA.Motor = downsample(DATmainA.Motor', dnsampleFactor)';
        end

        if ~isempty(filenameB)

            if isempty(epoch1_B) || isempty(epoch2_B)
                epoch1_B = round(ttb(1) / us2sec) + 2;
                epoch2_B = round(ttb(end) / us2sec) - 2;
                guiHandles.Epoch1_B_Input = uicontrol(PTfig, 'style', 'edit', 'string', [int2str(epoch1_B)], 'fontsize', fontsz, 'units', 'normalized', 'Position', [posInfo.Epoch1_B_Input],
                'callback', '@textinput_call; epoch1_B=str2num(get(guiHandles.Epoch1_B_Input, ''String''));PTprocess;PTplotLogViewer; ');
                guiHandles.Epoch2_B_Input = uicontrol(PTfig, 'style', 'edit', 'string', [int2str(epoch2_B)], 'fontsize', fontsz, 'units', 'normalized', 'Position', [posInfo.Epoch2_B_Input],
                'callback', '@textinput_call; epoch2_B=str2num(get(guiHandles.Epoch2_B_Input, ''String''));PTprocess;PTplotLogViewer; ');
            end

            if (epoch2_B > round(ttb(end) / us2sec))
                epoch2_B = round(ttb(end) / us2sec);
                guiHandles.Epoch2_B_Input = uicontrol(PTfig, 'style', 'edit', 'string', [int2str(epoch2_B)], 'fontsize', fontsz, 'units', 'normalized', 'Position', [posInfo.Epoch2_B_Input],
                'callback', '@textinput_call; epoch2_B=str2num(get(guiHandles.Epoch2_B_Input, ''String'')); PTprocess;PTplotLogViewer;');
            end

            x = [epoch1_B * us2sec epoch2_B * us2sec];
            x2 = ttb > ttb(find(ttb > x(1), 1)) & ttb < ttb(find(ttb > x(2), 1));
            Time_B = ttb(x2, 1) / us2sec;
            Time_B = Time_B - Time_B(1);
            DATtmpB.GyroFilt = DATmainB.GyroFilt(:, x2);
            DATtmpB.debug = DATmainB.debug(:, x2);
            DATtmpB.RCcommand = DATmainB.RCcommand(:, x2);
            DATtmpB.Pterm = DATmainB.Pterm(:, x2);
            DATtmpB.Iterm = DATmainB.Iterm(:, x2);
            DATtmpB.DtermRaw = DATmainB.DtermRaw(:, x2);
            DATtmpB.DtermFilt = DATmainB.DtermFilt(:, x2);
            DATtmpB.Fterm = DATmainB.Fterm(:, x2);
            DATtmpB.PIDsum = DATmainB.PIDsum(:, x2);
            DATtmpB.RCRate = DATmainB.RCRate(:, x2);
            DATtmpB.PIDerr = DATmainB.PIDerr(:, x2);
            DATtmpB.Motor12 = DATmainB.Motor(1:2, x2);
            DATtmpB.Motor34 = DATmainB.Motor(3:4, x2);
            DATtmpB.debug12 = DATmainB.debug(1:2, x2);
            DATtmpB.debug34 = DATmainB.debug(3:4, x2);

            dnsampleFactor = B_lograte * downsampleMultiplier; % 5 times less resolution for faster plotting, display only
            DATdnsmplB.ttb = downsample(((ttb - ttb(1)) / us2sec), dnsampleFactor)';
            DATdnsmplB.GyroFilt = downsample(DATmainB.GyroFilt', dnsampleFactor)';
            DATdnsmplB.debug = downsample(DATmainB.debug', dnsampleFactor)';
            DATdnsmplB.RCcommand = downsample(DATmainB.RCcommand', dnsampleFactor)';
            DATdnsmplB.Pterm = downsample(DATmainB.Pterm', dnsampleFactor)';
            DATdnsmplB.Iterm = downsample(DATmainB.Iterm', dnsampleFactor)';
            DATdnsmplB.DtermRaw = downsample(DATmainB.DtermRaw', dnsampleFactor)';
            DATdnsmplB.DtermFilt = downsample(DATmainB.DtermFilt', dnsampleFactor)';
            DATdnsmplB.Fterm = downsample(DATmainB.Fterm', dnsampleFactor)';
            DATdnsmplB.RCRate = downsample(DATmainB.RCRate', dnsampleFactor)';
            DATdnsmplB.PIDsum = downsample(DATmainB.PIDsum', dnsampleFactor)';
            DATdnsmplB.PIDerr = downsample(DATmainB.PIDerr', dnsampleFactor)';
            DATdnsmplB.Motor = downsample(DATmainB.Motor', dnsampleFactor)';
        end

        set(PTfig, 'pointer', 'arrow')
    end

catch ME
    errmsg.PTprocess = PTerrorMessages('PTprocess', ME);
end
