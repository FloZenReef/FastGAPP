function [plotax] = lines_mullen_1983_MnOTiO2P2O5(control,plotax)

% Line segment #01
line = 2;
plot([0.92000 0.55700],[0.00000 0.25600],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #02
line = 2;
plot([0.55700 0.41200],[0.25600 0.59400],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #03
line = 2;
plot([0.29500 0.45900],[0.51100 0.23000],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #04
line = 2;
plot([0.45900 0.59200],[0.23000 0.23000],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #05
line = 3;
plot([0.19500 0.30000],[0.33800 0.15500],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #06
line = 3;
plot([0.30000 0.69300],[0.15500 0.15500],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

% Line segment #07
line = 3;
plot([0.55700 0.72900],[0.25600 0.36500],...
        'LineWidth',control.setup.lines(1,line).LineWidth.*control.scafac,...
        'LineStyle',control.setup.lines(1,line).LineStyle,...
        'Color',control.setup.lines(1,line).Color);

end