function [plotax] = lines_floyd_winchester_1975_TiO2vsZrP2O5(control,plotax)

% Line segment #01
line = 2;
plot([0.00000 2000.00000],[0.00000 4.00000],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

end