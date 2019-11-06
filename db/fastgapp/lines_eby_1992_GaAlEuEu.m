function [plotax] = lines_eby_1992_GaAlEuEu(control,plotax)

% Line segment #01
line = 2;
plot([0.00000 1.00000],[1.50000 1.50000],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

end