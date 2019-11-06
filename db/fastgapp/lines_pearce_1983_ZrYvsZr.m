function [plotax] = lines_pearce_1983_ZrYvsZr(control,plotax)

% Line segment #01
line = 2;
plot([15.00000 1000.00000],[3.00000 3.00000],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

end