function [plotax] = lines_floyd_winchester_1975_P2O5vsZr(control,plotax)

% Line segment #01
line = 2;
plot([0.00000 500.00000],[0.10000 0.70000],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

end