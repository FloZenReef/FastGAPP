function [G_3km,G_5km,G_10km,G_all,z_step,T_step] = tool_geoT_field(A,k,q0,T_surface,z_model)
% This function calculate temperature field and geothermal gradients for GeoT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Florian Riefstahl
% Institutions: University of Bremen, Bremen, Germany
%               Alfred-Wegener-Institute, Bremerhaven, Germany
%               Christian-Albrechts-University Kiel, Kiel, Germany
% Version: Initial version 2014-2015
%%% Revisions %%%
% 2019 - Some minor revisions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculate temperature field

% Create linear depth values
z_step = linspace(0,z_model./1000,z_model./1000+1);
% Preallocate temperature array
T_step = zeros(1,z_model./1000+1);
% Calculate the temperature corrosponding to depth values
for i = z_step

    T_step(i+1) = -(A ./ (2 .* k) .* i.^2 ) + ...
                    q0 .* i ./ k + ...
                    T_surface ;

end

%% Calculate the geothermal gradient from temperature field

% average over 3 km
G_3km = (T_step(4) - T_step(1)) ./ (4-1);
% average over 5 km
G_5km = (T_step(6) - T_step(1)) ./ (6-1);
% average over 10 km
G_10km = (T_step(11) - T_step(1)) ./ (11-1);
% average the whole model
G_all = (T_step(z_model./1000+1) - T_step(1)) ./ (z_model./1000+1-1);

end