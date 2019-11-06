function [control] = defaults_misc(control)
%% Create line defaults in control structure
% Line 1
control.setup.lines(1) = struct('LineWidth',2.5,'LineStyle','-','Color',[0,0,0]);
% Line 2
control.setup.lines(2) = struct('LineWidth',2,'LineStyle','-','Color',[0,0,0]);
% Line 3
control.setup.lines(3) = struct('LineWidth',2,'LineStyle',':','Color',[0,0,0]);
% Line 4
control.setup.lines(4) = struct('LineWidth',2,'LineStyle','--','Color',[0,0,0]);
% Line 5
control.setup.lines(5) = struct('LineWidth',1.5,'LineStyle','-','Color',[0,0,0]);       
% Line 6
control.setup.lines(6) = struct('LineWidth',1.5,'LineStyle',':','Color',[0,0,0]);
% Line 7
control.setup.lines(7) = struct('LineWidth',1.5,'LineStyle','--','Color',[0,0,0]);
% Line 8
control.setup.lines(8) = struct('LineWidth',1.0,'LineStyle','-','Color',[0,0,0]);
% Line 9
control.setup.lines(9) = struct('LineWidth',0.5,'LineStyle',':','Color',[0,0,0]);

%% Create font defaults in control structure
% Font 1
control.setup.fonts(1) = struct('FontName','Arial','FontWeight','bold',...
                                 'FontAngle','normal','FontSize',20,...
                                 'Color',[0,0,0],'FontUnits','points');
% Font 2
control.setup.fonts(2) = struct('FontName','Arial','FontWeight','bold',...
                                 'FontAngle','normal','FontSize',12,...
                                 'Color',[0,0,0],'FontUnits','points');
% Font 3
control.setup.fonts(3) = struct('FontName','Arial','FontWeight','bold',...
                                 'FontAngle','normal','FontSize',10,...
                                 'Color',[0,0,0],'FontUnits','points');
% Font 4
control.setup.fonts(4) = struct('FontName','Arial','FontWeight','bold',...
                                 'FontAngle','normal','FontSize',8,...
                                 'Color',[0,0,0],'FontUnits','points');
% Font 5
control.setup.fonts(5) = struct('FontName','Arial','FontWeight','bold',...
                                 'FontAngle','normal','FontSize',6,...
                                 'Color',[0,0,0],'FontUnits','points');
% Font 6
control.setup.fonts(6) = struct('FontName','Arial','FontWeight','normal',...
                                 'FontAngle','normal','FontSize',12,...
                                 'Color',[0,0,0],'FontUnits','points');
% Font 7
control.setup.fonts(7) = struct('FontName','Arial','FontWeight','normal',...
                                 'FontAngle','normal','FontSize',10,...
                                 'Color',[0,0,0],'FontUnits','points');
% Font 8
control.setup.fonts(8) = struct('FontName','Arial','FontWeight','normal',...
                                 'FontAngle','normal','FontSize',8,...
                                 'Color',[0,0,0],'FontUnits','points');
% Font 9
control.setup.fonts(9) = struct('FontName','Arial','FontWeight','normal',...
                                 'FontAngle','normal','FontSize',6,...
                                 'Color',[0,0,0],'FontUnits','points');
end

