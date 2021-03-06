function [plotax] = labels_frost_frost_2008_PIvsSiO2(control,plotax)

% Label segment #01
fontsel = 2;
text(60.000,0.500,sprintf('peralkaline'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

% Label segment #02
fontsel = 2;
text(60.000,1.500,sprintf('subalkaline'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

end