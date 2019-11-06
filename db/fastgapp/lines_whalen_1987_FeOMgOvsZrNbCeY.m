function [plotax] = lines_whalen_1987_FeOMgOvsZrNbCeY(control,plotax)

% Line segment #01
line = 2;
plot([0.10000 350.00000],[16.00000 16.00000],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #02
line = 2;
plot([350.00000 350.00000],[16.00000 0.00100],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

end