function [plotax] = lines_miyashiro_shido_1975_VvsFeOMgO_2(control,plotax)

% Line segment #01
line = 2;
plot([1.55000 3.00000],[102.10173 8.53920],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #02
line = 2;
plot([2.15000 6.23000],[264.80009 8.99717],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

end