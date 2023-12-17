function [NewLocation,Distance] = PeoMoveMode1(Location,Static,CurrLoc)
    X = Location(1);
    Y = Location(2);
    Max_X = size(Static,1);    %%静态场阵 行的规模？？
    Max_Y = size(Static,2);
    Occupancy = conv2(CurrLoc,ones(5),'same');   %%用5*5的1阵对当前坐标进行卷积，
    CurrStatic = Static(X,Y);
    Neighbors = [X,Y-1;X,Y+1;X-1,Y-1;X+1,Y+1;X-1,Y;X-1,Y+1;X+1,Y-1;X+1,Y];     %%有8个邻居
    Target = zeros(8,2);     %%周围8格为目标坐标，先设8行2列0矩阵再填写入其中；
    j = 1;
    for i = 1:8
        Neigh_X = Neighbors(i,1);
        Neigh_Y = Neighbors(i,2);    %%遍历每个邻居坐标，若满足X、Y坐标在图中，另这个邻居坐标静态场为 NeighStatic的值
        if Neigh_X > 0 && Neigh_X < Max_X && Neigh_Y > 0 && Neigh_Y < Max_Y      %%若坐标在图内
           NeighStatic= Static(Neigh_X,Neigh_Y);                     %%计算邻居坐标静态场
            if (NeighStatic - CurrStatic <= 0.5) && Occupancy(Neigh_X,Neigh_Y) == 0    %%若邻居静态场比当前坐标静态场差值在0.5之内且周围无障碍物占据    限于局部移动，下面还要算distance距离
                Target(j,:) = [Neigh_X,Neigh_Y];                         %%则向该邻居坐标移动
                j = j + 1;
            end
        end
    end
    if j == 1
        NewLocation = Location;
        Distance = 0;                       %%留在原地
    else
        index = randi(j-1);
        NewLocation = Target(index,:);
        if abs(sum(NewLocation - Location)) == 1
            Distance = 1;                %%向上下左右移动
        else
            Distance = 1.414;      %%否则则斜向移动
        end
    end
end

    