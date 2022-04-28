%PIDtoolbox
TooltipString_files = ['Select the .BBL or .BFL file you wish to analyze. \n',
                    'Warning: blackbox_decode must be in the same folder as the selected log file!', '/n'
                    'It usually does not matter where the PIDtoolbox program file is located.'];

TooltipString_loadRun = ['Select one or more files to analyze. '];
TooltipString_Epochs = ['Input the desired start and end points (in seconds) of the selected log file', '/n', 'Note: the selected time window denotes the data used for all other analyses.', '/n', 'The shaded regions indicate ignored data.'];
TooltipString_spec = ['Opens spectral analysis tool in new window'];
TooltipString_step = ['Opens step response tool in new window'];
TooltipString_setup = ['Displays detailed setup information in new window'];
TooltipString_saveFig = ['Saves current figure', '\n', 'Note: Clicking the ''Save fig'' button for the first time creates a folder using the log file names'];
TooltipString_wiki = ['Link to the PIDtoolbox wiki in Github'];
TooltipString_selectButton = ['With box checked, position mouse over desired start position,', '/n', 'then mouse click, then desired end position, then mouse click again;', '/n', 'to escape, deselect then click anywhere'];

% PTdispSetupInfoUIcontrol
TooltipString_FileNumDispA = ['List of files available. Click to view setup info for each'];

% PTerrUIcontrol
TooltipString_degsec = ['Sets the maximum rate used in the PID error analysis (distribution plots only).',
                        '\n', 'E.g., the default means only data in which set point was <= 100deg/s is used.',
                        '\n', 'This cutoff helps to reduce inclusion of data with inflated PID error as a result of snap maneuvers'];
