function [plotax] = lines_frost_frost_2008_ASIvsSiO2(control,plotax)

% Line segment #01
line = 2;
plot([40.00000 80.00000],[1.00000 1.00000],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

end