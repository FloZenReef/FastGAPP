function [plotax] = lines_macdonald_1968_tas(control,plotax)

% Line segment #01
line = 2;
plot([39.00000 66.50000],[0.00000 10.00000],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

end