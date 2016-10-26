% Author: Kyle McGahee
% Description: Show that the two methods for coordinate projections are symbollically equivalent. 

clear all
close all;

rng default;  % For reproducibility

original = 100*rand(2,10);

% Mean + std. dev * randn 
east_errors = 0 + sqrt(3) *randn(1,10);
north_errors = 0 + sqrt(6) *randn(1,10);
total_errors = [east_errors; north_errors];

surveyed = original + total_errors;

avg_errors = mean(total_errors, 2);

abs_avg_errors = mean(abs(total_errors), 2)

std(total_errors, 0, 2)

east_errors = east_errors - avg_errors(1,1);
north_errors = north_errors - avg_errors(2,1);

scatter(east_errors, north_errors, 'b', '*')
hold on
scatter(0, 0, 'r')
xlim([-6, 6])
grid on
legend('QR Codes', 'Average Error')
title('Error of Reference QR Codes After Shifting Coordinates')
xlabel('East Error (centimeters)')
ylabel('North Error (centimeters)')

%lsline

figure

east_errors = -.6 + 3 *randn(1,20);
north_errors = -.8 + 5 *randn(1,20);
plant_errors = [east_errors; north_errors];

avg_plant_errors = mean(plant_errors, 2)

abs_avg_plant_errors = mean(abs(plant_errors), 2)

scatter(east_errors, north_errors, 'b', '*')
hold on
scatter(avg_plant_errors(1,1), avg_plant_errors(2,1), 'r')
xlim([-12, 12])
ylim([-12, 12])
grid on
legend('Plants', 'Average Error')
title('Error of Surveyed Plants After Shifting Coordinates')
xlabel('East Error (centimeters)')
ylabel('North Error (centimeters)')
hold on
%lsline

std(plant_errors, 0, 2)
