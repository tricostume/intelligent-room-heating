%close all
iteration = 24000;
figure(3)
i = 5; j = 3; f = 2;
subplot(2,2,1)
hold on
plot(room_var(i,j,f).temperature(1:iteration));
plot(room_var(i,j,f).activation(1:iteration),'r');
plot(abs(room_var(i,j,f).solar_flux(1:iteration))*100,'g');
i = 5; j = 5; f = 2;
subplot(2,2,2)
hold on
xlabel('Years2')
plot(room_var(i,j,f).temperature(1:iteration));
plot(room_var(i,j,f).activation(1:iteration),'r');
plot(abs(room_var(i,j,f).solar_flux(1:iteration))*100,'g');
i = 6; j = 3; f = 2;
subplot(2,2,3)
hold on
plot(room_var(i,j,f).temperature(1:iteration));
plot(room_var(i,j,f).activation(1:iteration),'r');
plot(abs(room_var(i,j,f).solar_flux(1:iteration))*100,'g');
i = 6; j = 5; f = 2;
subplot(2,2,4)
hold on
xlabel('Years')
plot(room_var(i,j,f).temperature(1:iteration));
plot(room_var(i,j,f).activation(1:iteration),'r');
plot(abs(room_var(i,j,f).solar_flux(1:iteration))*100,'g');
