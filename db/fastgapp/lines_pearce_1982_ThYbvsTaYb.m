function [plotax] = lines_pearce_1982_ThYbvsTaYb(control,plotax)

% Line segment #01
line = 2;
plot([0.01886 0.15956],[0.01992 0.25648],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #02
line = 2;
plot([0.15956 0.01644],[0.25648 0.32417],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #03
line = 2;
plot([0.01644 0.15956],[0.32417 0.25648],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #04
line = 2;
plot([0.15956 0.50755],[0.25648 1.06000],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #05
line = 2;
plot([0.50755 0.81075],[1.06000 1.72000],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #06
line = 2;
plot([1.29000 0.01678],[2.79961 3.97798],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #07
line = 2;
plot([0.81075 1.29000],[1.72000 2.79961],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #08
line = 2;
plot([1.29000 10.01650],[2.79961 24.01237],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #09
line = 2;
plot([17.02345 1.54906],[11.49074 0.95000],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #10
line = 2;
plot([1.54906 1.00373],[0.95000 0.61092],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #11
line = 2;
plot([1.00373 0.63707],[0.61092 0.35945],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #12
line = 2;
plot([0.63707 0.03506],[0.35945 0.01317],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

end