function [NewFl,NewX,NewY] = Move2Next(obj,Enter,Static,Occupancy)    %%移动到下一步  需要入口坐标、静态场、障碍物信息
    X = obj.Location(1);
    Y = obj.Location(2);
    num = size(Enter,1);
    target = zeros(num,2);
    j = 1;
    for i = 1:num
        distance = abs(Enter(i,1)-X)+abs(Enter(i,2)-Y);  %各个入口坐标-当前坐标计算距离，小于30就是目标坐标了，且j加1
        if distance < 30
            target(j,:) = Enter(i,:);
            j = j+1;
        end
    end
    target(j:end,:) = [];
    if j > 1
        for i = 1:(j-1)
            tarX = target(i,1);
            tarY = target(i,2);
            if Static(tarX,tarY) < 9999 && Occupancy(tarX,tarY) == 0
                NewFl = fix(obj.Floor);
                NewX = tarX;
                NewY = tarY;
                return;
            end
        end
    end
    NewFl = obj.Floor;
    NewX = X;
    NewY = Y;
end