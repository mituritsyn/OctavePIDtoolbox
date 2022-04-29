function obj = readtable(csvFname)
    fid = fopen (csvFname, "r");
    headers = fgets (fid);
    fclose (fid);
    headers = regexprep(headers, ' ', '')
    headers = regexprep(headers, '[\(]|[\)]|[\[]|[\]]', '_');
    VarNames = regexp(headers, ',', 'split');

    %VarNames = {'loopIteration', 'time_us_', 'axisP_0_', 'axisP_1_', 'axisP_2_', 'axisI_0_', 'axisI_1_', 'axisI_2_', 'axisD_0_', 'axisD_1_', 'axisF_0_', 'axisF_1_', 'axisF_2_', 'rcCommand_0_','rcCommand_1_', 'rcCommand_2_', 'rcCommand_3_', 'setpoint_0_', 'setpoint_1_', 'setpoint_2_', 'setpoint_3_','vbatLatest_V_', 'amperageLatest_A_', 'rssi', 'gyroADC_0_', 'gyroADC_1_', 'gyroADC_2_','accSmooth_0_', 'accSmooth_1_', 'accSmooth_2_', 'debug_0_', 'debug_1_', 'debug_2_', 'debug_3_','motor_0_', 'motor_1_', 'motor_2_', 'motor_3_', 'energyCumulative_mAh_', 'flightModeFlags_flags_','stateFlags_flags_', 'failsafePhase_flags_', 'rxSignalReceived', 'rxFlightChannelsValid'};
    excl = {'vbatLatest_V_', 'amperageLatest_A_', 'rssi', 'energyCumulative_mAh_', 'flightModeFlags_flags_', 'stateFlags_flags_', 'failsafePhase_flags_', 'rxSignalReceived', 'rxFlightChannelsValid'};

    Vars = dlmread (csvFname, ',', 1, 0);

    pkg load dataframe;
    obj = dataframe();

    for n = 1:columns(VarNames)

        if any(strcmp(excl, VarNames(n){}))
            continue
        end

        obj.(char(VarNames{n})) = Vars(:, n);
    end

endfunction
