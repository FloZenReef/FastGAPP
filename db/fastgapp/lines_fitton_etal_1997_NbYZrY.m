function [plotax] = lines_fitton_etal_1997_NbYZrY(control,plotax)

% Line segment #01
line = 2;
plot([0.01850 20.00000],[0.01850 5.30000],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

end