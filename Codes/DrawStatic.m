%% ↓ 初始化 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;
%% ↓ Old %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NumofFloor = 1;
% ImgSize = [594, 841];
% ImgScale = 1; % 1
% ImgPath = "D:\Study\Serious\Program\Matlab\Evacuation\case1\input\1F.jpg"; % 'input/1F.jpg'
% MapInput = Img2Map(ImgPath,ImgSize,ImgScale);
% ExitPath = "D:\Study\Serious\Program\Matlab\Evacuation\case1\input\1F-Exit.jpg"; % 'input/1F-Exit.jpg'
% ExitImg = Img2Map(ExitPath,ImgSize,ImgScale);
% [row,col] = ind2sub(size(ExitImg),find(ExitImg));
% ExitInput = [row,col];
% F = Floor(MapInput, ExitInput, []);
% % 由Floor类生成对象并组成一维元胞数组F{fl}
% data = F.Static;  % 从对象F中获取楼层初始静态场信息
% figure;
% [m,n] = size(data);
% XX = 1:1:n;
% YY = 1:1:m;
% set(gcf,'unit','centimeters','position',[3,3,40,20]);
% pcolor(XX,YY,data);
% colormap pink;
% cmap = colormap;
% newcolormap = ones(256,3);
% for i = 1:256
%     newcolormap(i,:) = cmap(257-i,:);
% end
% colormap(newcolormap);
% shading flat;
% colorbar('southoutside','xtick',[0:50:300]);
% axis equal;
% axis([1 n 1 m]);
% caxis([0 300]); % 设置bar的数值范围
% ax = gca;
% ax.FontSize = 20;
% ax.Visible = 'off';
%% ↓ New %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NumofFloor = 1;
ImgSize = [594, 841];
ImgScale = 1; % 1
ImgPath = "D:\Study\Serious\Program\Matlab\Evacuation\case1 - 2\input\0.jpg"; % 'input/1F.jpg'
MapInput = Img2Map(ImgPath,ImgSize,ImgScale);
ExitPath = "D:\Study\Serious\Program\Matlab\Evacuation\case1 - 2\input\Exit.jpg"; % 'input/1F-Exit.jpg'
ExitImg = Img2Map(ExitPath,ImgSize,ImgScale);
[row,col] = ind2sub(size(ExitImg),find(ExitImg));
ExitInput = [row,col];
F = Floor(MapInput, ExitInput, []);
% 由Floor类生成对象并组成一维元胞数组F{fl}
data = F.Static;  % 从对象F中获取楼层初始静态场信息
figure;
[m,n] = size(data);
XX = 1:1:n;
YY = 1:1:m;
set(gcf,'unit','centimeters','position',[3,3,40,20]);
pcolor(XX,YY,data);
colormap pink;
cmap = colormap;
newcolormap = ones(256,3);
for i = 1:256
    newcolormap(i,:) = cmap(257-i,:);
end
colormap(newcolormap);
shading flat;
colorbar('southoutside','xtick',[0:100:800]);
axis equal;
axis([1 n 1 m]);
caxis([0 300]); % 设置bar的数值范围
ax = gca;
ax.FontSize = 20;
ax.Visible = 'off';
%% %%
% ax.DataAspectRatio = [1 1 3.5];
% ax.CameraPosition = [830.1659904909976,-1878.685016824151,2950.319089609905];
% ax.View = [17.005814628010469,34.557442148461227];
legend('off');
% % figure;
% % surf(data);
% 
% % Create a colormap excluding black
% colormap_used = jet;
% 
% % Create a mask for the huge number
% mask = data == huge_number;
% 
% % Replace the huge number with NaN
% data(mask) = NaN;
% data1 = zeros(size(data));
% data1(mask) = 350;
% % % Find the limits for colormap scaling (excluding the huge number)
% % cmin = min(data(:), [], 'omitnan');
% % cmax = max(data(:), [], 'omitnan');
% % 
% % % Normalize the data within the limits
% % normalized_data = (data - cmin) / (cmax - cmin);
% 
% % Create a figure
% figure;
% 
% % Display the colored matrix with custom colormap
% s = surf(data);
% s.EdgeColor = 'none';
% hold on;
% s1 = surf(data1,'FaceAlpha',0.5);
% s1.EdgeColor = 'none';
% % Apply the colormap to the current figure
% colormap(colormap_used);
% 
% % Add a color bar to show the mapping between colors and values
% colorbar;
% ax = gca;
% ax.Visible = 'off';
% ax.DataAspectRatio = [1 1 3.5];
% ax.CameraPosition = [830.1659904909976,-1878.685016824151,2950.319089609905];
% ax.View = [17.005814628010469,34.557442148461227];
% legend('off');
% % Add a title
% % title('Colored Matrix Visualization');

