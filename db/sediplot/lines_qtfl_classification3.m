function [plotax] = lines_qtfl_classification3(control,plotax)

% Line segment #01
line = 2;
plot([0.50000 0.50000],[0.00000 0.75547],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #02
line = 2;
plot([0.46500 0.50000],[0.80540 0.75547],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #03
line = 2;
plot([0.53500 0.50000],[0.80540 0.75547],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #04
line = 2;
plot([0.50000 0.37500],[0.43301 0.64952],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #05
line = 2;
plot([0.62500 0.50000],[0.64952 0.43301],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

end