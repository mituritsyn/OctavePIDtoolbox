gcbo
gcbf
PTfig = figure(1);
guiHandles.fileA = uicontrol(PTfig,'FontWeight', 'Bold');
try

    if ~isempty(logfileDir)
        cd(logfileDir);
    end

catch
end

[filenameA, filepathA] = uigetfile({'*.BBL; *.BFL; *.TXT'}, 'MultiSelect', 'on');

if ischar(filenameA),
    filenameA = {filenameA};
    end;

    if iscell(filenameA),
        PTload;
        PTviewerUIcontrol;
        %PTplotLogViewer;
    end
