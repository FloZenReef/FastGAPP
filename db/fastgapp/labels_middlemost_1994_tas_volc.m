function [plotax] = labels_middlemost_1994_tas_volc(control,plotax)

% Label segment #01
fontsel = 2;
text(55.000,18.500,sprintf('Sodalinite / Nephelinolith / Leucitolith'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

% Label segment #02
fontsel = 2;
text(78.500,5.500,sprintf('Rhyolite'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

% Label segment #03
fontsel = 2;
text(83.300,1.300,sprintf('Silexite'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

% Label segment #04
fontsel = 2;
text(66.700,5.500,sprintf('Dacite'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

% Label segment #05
fontsel = 2;
text(59.800,5.000,sprintf('Andesite'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

% Label segment #06
fontsel = 2;
text(54.300,4.000,sprintf('Basaltic\nAndesite'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

% Label segment #07
fontsel = 2;
text(47.300,4.200,sprintf('Alcalic\nBasalt'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

% Label segment #08
fontsel = 2;
text(48.300,2.000,sprintf('Subalcalic\nBasalt'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

% Label segment #09
fontsel = 2;
text(43.400,2.300,sprintf('Picro-\nbasalt'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

% Label segment #10
fontsel = 2;
text(49.150,5.650,sprintf('Trachy-\nbasalt'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

% Label segment #11
fontsel = 2;
text(39.000,9.500,sprintf('Foidite'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

% Label segment #12
fontsel = 2;
text(53.200,11.600,sprintf('Tephri-\nphonolite'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

% Label segment #13
fontsel = 2;
text(49.300,9.500,sprintf('Phono-\ntephrite'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

% Label segment #14
fontsel = 2;
text(43.800,6.500,sprintf('Tephrite'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

% Label segment #15
fontsel = 2;
text(57.000,15.000,sprintf('Phonolite'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

% Label segment #16
fontsel = 2;
text(64.000,12.200,sprintf('Trachyte'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

% Label segment #17
fontsel = 2;
text(65.700,8.800,sprintf('Trachydacite'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

% Label segment #18
fontsel = 2;
text(57.700,8.500,sprintf('Basaltic\nTrachy-\nandesite'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

% Label segment #19
fontsel = 2;
text(53.000,6.800,sprintf('Trachy-\nandesite'),'Rotation', 0,...
        'Parent',plotax,'HorizontalAlignment','center','VerticalAlignment','middle',...
        'Color',control.setup.fonts(fontsel).Color,...
        'FontName',control.setup.fonts(fontsel).FontName,...
        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
        'FontSize',control.setup.fonts(fontsel).FontSize.*control.scafac,...
        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
        'FontWeight',control.setup.fonts(fontsel).FontWeight);

end