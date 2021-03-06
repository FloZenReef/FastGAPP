function [plotax] = lines_whalen_1987_TAvsGaAl(control,plotax)

% Line segment #01
line = 2;
plot([0.10000 2.60000],[8.50000 8.50000],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #02
line = 2;
plot([2.60000 2.60000],[8.50000 0.01000],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

end