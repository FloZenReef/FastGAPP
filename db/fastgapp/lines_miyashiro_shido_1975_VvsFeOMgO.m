function [plotax] = lines_miyashiro_shido_1975_VvsFeOMgO(control,plotax)

% Line segment #01
line = 2;
plot([2.73000 4.46000],[100.00585 22.97452],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

end