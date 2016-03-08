classdef ParentWindow < handle
    % ParentWindow: Class definition for main window and all its components
    % More than one parent windows can be intiated at the same time and
    % work completely independantely.
    % Properties: 2
    %       ParentHandles: Struct which has all components of the parent
    %                         window as its member
    %       ChildWindows: Array of opened child windows of the parent
    %                        window.
    % Methods: 31
    %       All functions which involve the parent window are defined in
    %       the member functions of this class.
    
    
    properties
        ParentHandles
    end
    
    methods
        % Constructor function
        function parentWindow = ParentWindow()
            parentWindow.ParentHandles = struct();
            
            parentWindow.ParentHandles.FontSize = 10.5;
            parentWindow.ParentHandles.FontName = 'FixedWidth';
            
            parentWindow.ParentHandles.IsSaved = 0;
            parentWindow.ParentHandles.PathName = '';
            parentWindow.ParentHandles.FileName = '';

            parentWindow.ParentHandles.CurrentConfiguration = 1;
            parentWindow.ParentHandles.OpticalSystem = OpticalSystem();
            
            parentWindow.ParentHandles.nMainTab = 4;
            parentWindow.ParentHandles.FigureHandle = figure( ...
                'Tag', 'parentWindowdow', ...
                'Units', 'normalized', ...
                'Position', [0 0.05 1 0.88], ...
                'Name', 'parentWindowdow', ...
                'MenuBar', 'none', ...
                'NumberTitle', 'off', ...
                'Color', get(0,'DefaultUicontrolBackgroundColor'), ...
                'Resize', 'on', ...
                'Visible', 'off');
            
            % Create Separate windows for System Configuration
            parentWindow.ParentHandles.SystemConfigurationFigureHandle = figure( ...
                'Tag', 'SystemConfigurationFigureHandle', ...
                'Units', 'normalized', ...
                'Position', [0.25 0.25 0.5 0.5], ...
                'Name', 'SystemConfiguration', ...
                'MenuBar', 'none', ...
                'NumberTitle', 'off', ...
                'WindowStyle','modal',...
                'Color', get(0,'DefaultUicontrolBackgroundColor'), ...
                'Resize', 'on', ...
                'Visible', 'off');
            
            parentWindow.resetParentParameters;
            parentWindow.InitializePanels;
            %----------------- Initialize Panel Components -------------------
            parentWindow.InitializeToolbarPanel;
            parentWindow.InitializeSystemConfigurationPanel;
            parentWindow.InitializeOpticalElementEditorPanel;
%             parentWindow.InitializeComponentEditorPanel;
            
            % ---------------- MENU and TOOLBAR ITEMS -------------------------
            parentWindow.InitializeMenuAndToolbarItems;
            
            % Make the window visible and define custom clos function which
            % closes all child windows before the main window.
            set(parentWindow.ParentHandles.FigureHandle,...
                'Visible', 'on',...
                'CloseRequestFcn',{@customCloseRequest});
            set(parentWindow.ParentHandles.SystemConfigurationFigureHandle,...%'Visible', 'on',...
                'CloseRequestFcn',{@customCloseRequestSystemCofiguration});
            function customCloseRequest(~,~)
                parentWindow.closeAllWindows();
            end
            function customCloseRequestSystemCofiguration(src,callbackdata)
                set(src,'Visible','Off');
            end
            
        end
    end
end

