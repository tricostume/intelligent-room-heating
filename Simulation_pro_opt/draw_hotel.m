%Draw hotel
figure(1);
hold on;
for i=1:11
    draw_patches(hotel_patches(i,:),'b');
end