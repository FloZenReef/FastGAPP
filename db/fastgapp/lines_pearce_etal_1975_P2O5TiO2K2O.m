function [plotax] = lines_pearce_etal_1975_P2O5TiO2K2O(control,plotax)

% Line segment #01
line = 2;
plot([0.60000 0.27000],[0.69300 0.46800],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

end