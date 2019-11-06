function [min_val,max_val] = parse_minmax(files_op,opt_check,data,header,control_datatype)
    
    % Create a counter
    counter = 0;
    
    for nr_dataset = 1:files_op

% Control elemtent
% disp(header)
% disp(data(1,nr_dataset).(control_datatype).(header).Values)

        % Increase the counter when the first dataset is activated for
        % plotting (input from dataset selection panel)
        if true(opt_check(nr_dataset,1))
            counter = counter + 1;
        end

        % If dataset is activated and counter is one write the first values
        if true(opt_check(nr_dataset,1)) 
            if counter == 1;
            min_val = data(1,nr_dataset).(control_datatype).(header).Min;
            max_val = data(1,nr_dataset).(control_datatype).(header).Max;
        % Else only assign if the values are higher or smaller
            else 
                if data(1,nr_dataset).(control_datatype).(header).Min < min_val
                    min_val = data(1,nr_dataset).(control_datatype).(header).Min;
                end
                if data(1,nr_dataset).(control_datatype).(header).Max > max_val
                    max_val = data(1,nr_dataset).(control_datatype).(header).Max;
                end
            end
        end
    end
    

        % Calculate the mean of min and max
        mid_val = max_val - min_val;
        % Special case = mid_val is zero
        if mid_val == 0;
            % Add or subtract 20% from these values and round
            % Minimum
            min_val = min_val - min_val.*0.20;
            if min_val < 0
               min_val = 0; 
            end
            min_val = fix(min_val);
            % Maximum
            max_val = max_val + max_val.*0.20;
            max_val = ceil(max_val);
        else
            % Add or subtract 20% from these values and round
            % Minimum
            min_val = min_val - mid_val.*0.20;
            if min_val < 0
               min_val = 0; 
            end
            min_val = fix(min_val);
            % Maximum
            max_val = max_val + mid_val.*0.20;
            max_val = ceil(max_val);
        end

% Control elemtent
% disp(header)
% disp(min_val)
% disp(max_val)
        
end