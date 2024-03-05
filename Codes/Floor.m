classdef Floor
    %   类：楼层Floor
    %   属性properties：需要输入以生成对象。
    %       Input：建筑图【矩阵】
    %       Exit：出口坐标【某*2矩阵】
    %       EnterOrig：原始建筑图（Original）中的入口坐标，即上层通过楼梯进入该层的坐标【某*2矩阵】
    %   从属属性properties(Dependent)：不需要输入，根据其他属性值进行计算得到。
    %       Size：建筑图去掉空白后实际尺寸【1*4矩阵，最小行数、最小列数、最大行数、最大列数】
    %       Map：根据建筑图生成地图，-2表示路，0表示出口，999998表示墙【矩阵】
    %       Occupancy：被墙占据的网格坐标（由于每个人占据3*3网格而只用中心网格表示，所以除了墙本身坐标还需往外扩展一格）【某*2矩阵】
    %       Static：静态场【矩阵，和Map大小相同】
    %       Enter：入口坐标，上述EnterOrig坐标经过建筑图去掉空白处理后的坐标【某*2矩阵】
    %   方法methods：构造函数（需输入Input、Exit和Enter）和上述5个从属属性的计算方法（get函数）
    
    properties
        Input
        Exit
        EnterOrig
    end
    properties(Dependent)
        Size
        Map
        Occupancy
        Static
        Enter
    end
    
    methods
        
        function obj = Floor(Input,Exit,EnterOrig)
            % 构造函数
            if nargin == 3
                obj.Input = Input;
                obj.Exit = Exit;
                obj.EnterOrig = EnterOrig;
            end
        end
        
        function Size = get.Size(obj)
            % 获取图纸中实际用到的尺寸，去掉四周的空白
            imin = size(obj.Input, 1);
            jmin = size(obj.Input, 2);
            imax = 0;
            jmax = 0;
            for i = 1:size(obj.Input, 1)
                for j = 1:size(obj.Input, 2)
                    if obj.Input(i,j) == 1
                        if imin > i
                            imin = i;
                        end
                        if jmin > j
                            jmin = j;
                        end
                        if imax < i
                            imax = i;
                        end
                        if jmax < j
                            jmax = j;
                        end
                    end
                end
            end
            Size = [imin, jmin, imax, jmax];
        end
        
        function Map = get.Map(obj)
            % 获取建筑物地图（0表示出口，-2表示路，999998表示墙）
            Map = obj.Input;
            mapsize = obj.Size;
            Map(Map == 1) = 1000000;
            index = sub2ind(size(Map), obj.Exit(:, 1), obj.Exit(:, 2));
            Map(index) = 2;
            Map = Map(mapsize(1):mapsize(3), mapsize(2):mapsize(4)) - 2;
        end
        
        function Occupancy = get.Occupancy(obj)
            % 获取墙占用的网格坐标
            map = obj.Map;
            Occupancy = zeros(size(map,1)*size(map,2),2);
            k = 1;
            for i = 1:size(map,1)
                for j = 1:size(map,2)
                    if map(i,j) > 10000
                        Occupancy(k:k+8,:) = [i,j;i,j-1;i,j+1;i-1,j;i-1,j-1;i-1,j+1;i+1,j;i+1,j-1;i+1,j+1];                        
                        k = k+9;
                    end
                end
            end
            Occupancy = unique(Occupancy,'rows');
        end
        
        function Static = get.Static(obj)
            % 获取静态场
            map = obj.Map;
            mapexit = zeros(size(map,1)*size(map,2),2);            
            k = 1;
            for i = 1:size(map,1)
                for j = 1:size(map,2)
                    if map(i,j) == 0
                        mapexit(k,:) = [i,j];
                        k = k + 1;
                    end                    
                end
            end
            mapexit(k:end,:) = [];            

            current = mapexit;
            Static = map;

            while ~isempty(current)
                numofcurrent = size(current, 1);
                newcurrent = [];
                %
                for i = 1:numofcurrent
                    currentpoint_x = current(i, 1);
                    currentpoint_y = current(i, 2);
                    currentstatic = Static(currentpoint_x, currentpoint_y);
                    % RightPoint
                    if currentpoint_y < size(map,2)
                        rightpoint = [currentpoint_x,currentpoint_y + 1];
                        RP_Static = Static(rightpoint(1),rightpoint(2));
                        NewStatic = currentstatic + 1;
                        if RP_Static < 0 
                            Static(rightpoint(1),rightpoint(2)) = NewStatic;
                            newcurrent = [newcurrent; rightpoint(1),rightpoint(2)];
                        elseif RP_Static > NewStatic && RP_Static < 99999
                            Static(rightpoint(1),rightpoint(2)) = NewStatic;
                            newcurrent = [newcurrent; rightpoint(1),rightpoint(2)];
                        end                        
                    end
                    
                    % DownPoint
                    if currentpoint_x < size(map,1)
                        downpoint = [currentpoint_x + 1, currentpoint_y];
                        DP_Static = Static(downpoint(1),downpoint(2));
                        NewStatic = currentstatic + 1;
                        if DP_Static < 0
                            Static(downpoint(1),downpoint(2)) = NewStatic;
                            newcurrent = [newcurrent; downpoint(1),downpoint(2)];
                        elseif DP_Static > NewStatic && DP_Static < 99999
                            Static(downpoint(1),downpoint(2)) = NewStatic;
                            newcurrent = [newcurrent; downpoint(1),downpoint(2)];
                        end
                    end
                    
                    % LeftPoint
                    if currentpoint_y > 1
                        leftpoint = [currentpoint_x, currentpoint_y - 1];
                        LP_Static = Static(leftpoint(1),leftpoint(2));
                        NewStatic = currentstatic + 1;
                        if LP_Static < 0
                            Static(leftpoint(1),leftpoint(2)) = NewStatic;
                            newcurrent = [newcurrent; leftpoint(1),leftpoint(2)];
                        elseif LP_Static > NewStatic && LP_Static < 99999
                            Static(leftpoint(1),leftpoint(2)) = NewStatic;
                            newcurrent = [newcurrent; leftpoint(1),leftpoint(2)];
                        end
                    end
                    
                    % UpPoint
                    if currentpoint_x > 1
                        uppoint = [currentpoint_x - 1, currentpoint_y];
                        UP_Static = Static(uppoint(1),uppoint(2));
                        NewStatic = currentstatic + 1;
                        if UP_Static < 0
                            Static(uppoint(1),uppoint(2)) = NewStatic;
                            newcurrent = [newcurrent; uppoint(1),uppoint(2)];
                        elseif UP_Static > NewStatic && UP_Static < 99999
                            Static(uppoint(1),uppoint(2)) = NewStatic;
                            newcurrent = [newcurrent; uppoint(1),uppoint(2)];
                        end
                    end

                    % RightDownPoint
                    if currentpoint_x < size(map,1) && currentpoint_y < size(map,2)
                        rightdownpoint = [currentpoint_x + 1, currentpoint_y + 1];
                        RDP_Static = Static(rightdownpoint(1),rightdownpoint(2));
                        NewStatic = currentstatic + sqrt(2);
                        if RDP_Static < 0
                            Static(rightdownpoint(1),rightdownpoint(2)) = NewStatic;
                            newcurrent = [newcurrent; rightdownpoint(1),rightdownpoint(2)];
                        elseif RDP_Static > NewStatic && RDP_Static < 99999
                            Static(rightdownpoint(1),rightdownpoint(2)) = NewStatic;
                            newcurrent = [newcurrent; rightdownpoint(1),rightdownpoint(2)];
                        end
                    end

                    % RightUpPoint
                    if currentpoint_x > 1 && currentpoint_y < size(map,2)
                        rightuppoint = [currentpoint_x - 1, currentpoint_y + 1];
                        RUP_Static = Static(rightuppoint(1),rightuppoint(2));
                        NewStatic = currentstatic + sqrt(2);
                        if RUP_Static < 0
                            Static(rightuppoint(1),rightuppoint(2)) = NewStatic;
                            newcurrent = [newcurrent; rightuppoint(1),rightuppoint(2)];
                        elseif RUP_Static > NewStatic && RUP_Static < 99999
                            Static(rightuppoint(1),rightuppoint(2)) = NewStatic;
                            newcurrent = [newcurrent; rightuppoint(1),rightuppoint(2)];
                        end
                    end

                    % LeftDownPoint
                    if currentpoint_x < size(map,1) && currentpoint_y > 1
                        leftdownpoint = [currentpoint_x + 1, currentpoint_y - 1];
                        LDP_Static = Static(leftdownpoint(1),leftdownpoint(2));
                        NewStatic = currentstatic + sqrt(2);
                        if LDP_Static < 0
                            Static(leftdownpoint(1),leftdownpoint(2)) = NewStatic;
                            newcurrent = [newcurrent; leftdownpoint(1),leftdownpoint(2)];
                        elseif LDP_Static > NewStatic && LDP_Static < 99999
                            Static(leftdownpoint(1),leftdownpoint(2)) = NewStatic;
                            newcurrent = [newcurrent; leftdownpoint(1),leftdownpoint(2)];
                        end
                    end

                    % LeftUpPoint
                    if currentpoint_x > 1 && currentpoint_y > 1
                        leftuppoint = [currentpoint_x - 1, currentpoint_y - 1];
                        LUP_Static = Static(leftuppoint(1),leftuppoint(2));
                        NewStatic = currentstatic + sqrt(2);
                        if LUP_Static < 0
                            Static(leftuppoint(1),leftuppoint(2)) = NewStatic;
                            newcurrent = [newcurrent; leftuppoint(1),leftuppoint(2)];
                        elseif LUP_Static > NewStatic && LUP_Static < 99999
                            Static(leftuppoint(1),leftuppoint(2)) = NewStatic;
                            newcurrent = [newcurrent; leftuppoint(1),leftuppoint(2)];
                        end
                    end
                    
                    % Loop for every point in current
                end                
                current = newcurrent;
            end
            Static(Static < 0) = 999998;
        end
        
        function Enter = get.Enter(obj)
            enter = obj.EnterOrig;
            siz = obj.Size;
            Enter = enter - ones(size(enter,1),1)*[siz(1)-1,siz(2)-1];
        end
    end
end

