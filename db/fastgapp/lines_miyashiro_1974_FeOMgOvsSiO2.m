function [plotax] = lines_miyashiro_1974_FeOMgOvsSiO2(control,plotax)

% Line segment #01
line = 2;
plot([46.00000 78.00000],[0.50000 5.50000],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

end