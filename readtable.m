% function obj = createTable(VarName, Vars)

%   if strcmp(VarName, 'Var')
%     for n = 1:numel(Vars)
%       obj.(['Var' num2str(n)]) = Vars{n};
%     end
%   else
%     for n = 1:numel(Vars)
%       obj.(char(VarName{1}(n))) = Vars{n};
%     end
%   end
% end


function obj = readtable(csvFname)
VarNames = {'loopIteration', 'time_us_', 'axisP_0_', 'axisP_1_', 'axisP_2_', 'axisI_0_', 'axisI_1_', 'axisI_2_', 'axisD_0_', 'axisD_1_', 'axisF_0_', 'axisF_1_', 'axisF_2_', 'rcCommand_0_','rcCommand_1_', 'rcCommand_2_', 'rcCommand_3_', 'setpoint_0_', 'setpoint_1_', 'setpoint_2_', 'setpoint_3_','vbatLatest_V_', 'amperageLatest_A_', 'rssi', 'gyroADC_0_', 'gyroADC_1_', 'gyroADC_2_','accSmooth_0_', 'accSmooth_1_', 'accSmooth_2_', 'debug_0_', 'debug_1_', 'debug_2_', 'debug_3_','motor_0_', 'motor_1_', 'motor_2_', 'motor_3_', 'energyCumulative_mAh_', 'flightModeFlags_flags_','stateFlags_flags_', 'failsafePhase_flags_', 'rxSignalReceived', 'rxFlightChannelsValid'};
excl = {'vbatLatest_V_', 'amperageLatest_A_', 'rssi', 'energyCumulative_mAh_', 'flightModeFlags_flags_','stateFlags_flags_', 'failsafePhase_flags_', 'rxSignalReceived', 'rxFlightChannelsValid'};
        %csvFname='1109.cs'
Vars = dlmread (csvFname,',',1,0);
 %function obj = createTable(a)
  pkg load dataframe;
    %VarName=regexprep (VarName,' ','');
    %VarName=regexprep (VarName,'/[\(]|[\]]|[\[]|[\)]|[ ]/g','_');
  %dataframe2array = @(df) cell2mat( struct(df).x_data );
obj = dataframe();
%cell2mat(VarName)
%Vars = cell2mat({Vars});
    for n = 1:columns(VarNames)
    %for n = 1:columns(a.colheaders)
    if any(strcmp(excl,VarNames(n){}))
      continue
    end
        %obj.(char(VarName{1}(n))) = Vars{1}(:, n);
        %obj.(char(VarName{n})) = {Vars{:, n}};
        %obj.(char(VarName{n})) = Vars(:,1).';
        %obj.(char(a.colheaders{n})) = a.data(:,n).';
        % csvFname='1109.cs';
        obj.(char(VarNames{n})) = Vars(:,n);
    end
%obj = dataframe2array(obj)
end
