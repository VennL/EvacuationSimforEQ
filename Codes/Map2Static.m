function Static = Map2Static(Map,Exit)       %%静态场需要地图和出口两个属性。
current = Exit;
Static = Map;   %%（最初输入的静态场是初步处理后的图纸，墙99999，空地-1）

while ~isempty(current)
    numofcurrent = size(current, 1);  %%入口有几行，几个坐标
    newcurrent = [];
    %
    for i = 1:numofcurrent
        currentpoint_x = current(i, 1);
        currentpoint_y = current(i, 2);  %%读取每个出口坐标
        currentstatic = Static(currentpoint_x, currentpoint_y);
        if currentstatic >= 0 && currentstatic < 99999
            NewStatic1 = currentstatic + 1;    %加1
            NewStatic2 = currentstatic + sqrt(2);   %加根号2
            % RightPoint  右点
            if currentpoint_y < size(Map,2)   %%2是第二维度（列），指若当前坐标在去空白后的图纸内
                rightpoint = [currentpoint_x,currentpoint_y + 1];    %%右边点的坐标表示
                RP_Static = Static(rightpoint(1),rightpoint(2));
                if RP_Static < 0
                    Static(rightpoint(1),rightpoint(2)) = NewStatic1;
                    newcurrent = [newcurrent; rightpoint(1),rightpoint(2)];
                elseif RP_Static > NewStatic1 && RP_Static < 99999
                    Static(rightpoint(1),rightpoint(2)) = NewStatic1;
                    newcurrent = [newcurrent; rightpoint(1),rightpoint(2)];
                end
            end
            
            % DownPoint
            if currentpoint_x < size(Map,1)
                downpoint = [currentpoint_x + 1, currentpoint_y];   %%下方的点的坐标
                DP_Static = Static(downpoint(1),downpoint(2));
                if DP_Static < 0
                    Static(downpoint(1),downpoint(2)) = NewStatic1;
                    newcurrent = [newcurrent; downpoint(1),downpoint(2)];
                elseif DP_Static > NewStatic1 && DP_Static < 99999
                    Static(downpoint(1),downpoint(2)) = NewStatic1;
                    newcurrent = [newcurrent; downpoint(1),downpoint(2)];
                end
            end
            
            % LeftPoint
            if currentpoint_y > 1
                leftpoint = [currentpoint_x, currentpoint_y - 1];
                LP_Static = Static(leftpoint(1),leftpoint(2));
                if LP_Static < 0
                    Static(leftpoint(1),leftpoint(2)) = NewStatic1;
                    newcurrent = [newcurrent; leftpoint(1),leftpoint(2)];
                elseif LP_Static > NewStatic1 && LP_Static < 99999
                    Static(leftpoint(1),leftpoint(2)) = NewStatic1;
                    newcurrent = [newcurrent; leftpoint(1),leftpoint(2)];
                end
            end
            
            % UpPoint
            if currentpoint_x > 1
                uppoint = [currentpoint_x - 1, currentpoint_y];
                UP_Static = Static(uppoint(1),uppoint(2));
                if UP_Static < 0
                    Static(uppoint(1),uppoint(2)) = NewStatic1;
                    newcurrent = [newcurrent; uppoint(1),uppoint(2)];
                elseif UP_Static > NewStatic1 && UP_Static < 99999
                    Static(uppoint(1),uppoint(2)) = NewStatic1;
                    newcurrent = [newcurrent; uppoint(1),uppoint(2)];
                end
            end
            
            % RightDownPoint
            if currentpoint_x < size(Map,1) && currentpoint_y < size(Map,2)
                rightdownpoint = [currentpoint_x + 1, currentpoint_y + 1];
                RDP_Static = Static(rightdownpoint(1),rightdownpoint(2));
                if RDP_Static < 0
                    Static(rightdownpoint(1),rightdownpoint(2)) = NewStatic2;
                    newcurrent = [newcurrent; rightdownpoint(1),rightdownpoint(2)];
                elseif RDP_Static > NewStatic2 && RDP_Static < 99999
                    Static(rightdownpoint(1),rightdownpoint(2)) = NewStatic2;
                    newcurrent = [newcurrent; rightdownpoint(1),rightdownpoint(2)];
                end
            end
            
            % RightUpPoint
            if currentpoint_x > 1 && currentpoint_y < size(Map,2)
                rightuppoint = [currentpoint_x - 1, currentpoint_y + 1];
                RUP_Static = Static(rightuppoint(1),rightuppoint(2));
                if RUP_Static < 0
                    Static(rightuppoint(1),rightuppoint(2)) = NewStatic2;
                    newcurrent = [newcurrent; rightuppoint(1),rightuppoint(2)];
                elseif RUP_Static > NewStatic2 && RUP_Static < 99999
                    Static(rightuppoint(1),rightuppoint(2)) = NewStatic2;
                    newcurrent = [newcurrent; rightuppoint(1),rightuppoint(2)];
                end
            end
            
            % LeftDownPoint
            if currentpoint_x < size(Map,1) && currentpoint_y > 1
                leftdownpoint = [currentpoint_x + 1, currentpoint_y - 1];
                LDP_Static = Static(leftdownpoint(1),leftdownpoint(2));
                if LDP_Static < 0
                    Static(leftdownpoint(1),leftdownpoint(2)) = NewStatic2;
                    newcurrent = [newcurrent; leftdownpoint(1),leftdownpoint(2)];
                elseif LDP_Static > NewStatic2 && LDP_Static < 99999
                    Static(leftdownpoint(1),leftdownpoint(2)) = NewStatic2;
                    newcurrent = [newcurrent; leftdownpoint(1),leftdownpoint(2)];
                end
            end
            
            % LeftUpPoint
            if currentpoint_x > 1 && currentpoint_y > 1
                leftuppoint = [currentpoint_x - 1, currentpoint_y - 1];
                LUP_Static = Static(leftuppoint(1),leftuppoint(2));
                if LUP_Static < 0
                    Static(leftuppoint(1),leftuppoint(2)) = NewStatic2;
                    newcurrent = [newcurrent; leftuppoint(1),leftuppoint(2)];
                elseif LUP_Static > NewStatic2 && LUP_Static < 99999
                    Static(leftuppoint(1),leftuppoint(2)) = NewStatic2;
                    newcurrent = [newcurrent; leftuppoint(1),leftuppoint(2)];
                end
            end
        end
        % Loop for every point in current
    end
    current = newcurrent;
end
Static(Static < 0) = 999999;
