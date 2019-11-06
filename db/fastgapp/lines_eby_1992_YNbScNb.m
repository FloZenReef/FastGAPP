function [plotax] = lines_eby_1992_YNbScNb(control,plotax)

% Line segment #01
line = 2;
plot([1.50000 1.50000],[0.70000 0.00030],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

end