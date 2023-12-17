figure;
floor = 1;
ts= 200;
imshow(ones(size(Obstacle{RefreshNum+1,floor})) - Obstacle{RefreshNum+1,floor});     %%显示障碍物矩阵
axis([0, length_X, 0, length_Y]);
axis off;
hold on;
for j = 1:ToPeo
    fl = AllLoc_Floor(j, ts);
    if fl == floor
        plot(AllLoc_Y(j, ts), AllLoc_X(j, ts), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 6);
        axis([0, length_X, 0, length_Y]);
        axis off;
        hold on;
    end
end
hold off;