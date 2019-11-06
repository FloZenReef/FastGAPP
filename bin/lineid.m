function [lineval] = lineid(lines,line_nr)

if strcmp(lines(line_nr).LineStyle,'-')
    lineval = 1;
elseif strcmp(lines(line_nr).LineStyle,'--')
    lineval = 2;
elseif strcmp(lines(line_nr).LineStyle,':')
    lineval = 3;
elseif strcmp(lines(line_nr).LineStyle,'-.')
    lineval = 4;
end

end

