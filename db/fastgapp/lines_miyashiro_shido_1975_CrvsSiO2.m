function [plotax] = lines_miyashiro_shido_1975_CrvsSiO2(control,plotax)

% Line segment #01
line = 2;
plot([45.70000 61.40000],[2000.00000 5.00000],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

end