function temp = defaults_temp(data)
%#ok<*AGROW> % Supress size change in loop iteration
for i=1:9
   temp(1,i).symbol = data(1,i).symbol;
   temp(1,i).label  = data(1,i).label;
end

end