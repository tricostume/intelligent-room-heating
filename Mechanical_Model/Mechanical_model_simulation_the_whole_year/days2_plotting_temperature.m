i = 12; j = 7;
D = 6;
day_s = D*144;
t_low_limit = 18.5;
t_max_limit = 21.5;

hold off
plot(room_var(i,j,2).temperature(1:day_s),'-b'); %base
hold on
plot(room_var(i,j,3).temperature(1:day_s),'-r'); %mid
plot(room_var(i,j,4).temperature(1:day_s),'-g'); %roof
clear axis_temp 
for i = 1 : day_s
    axis_tempDOWN(i) = t_low_limit; 
end
plot(axis_tempDOWN,'--k');

for i = 1 : day_s
    axis_tempUP(i) = t_max_limit; 
end
plot(axis_tempUP,'--k');