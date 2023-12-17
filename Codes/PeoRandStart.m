%% The function 'PeoRandStart()' generates random starting points for specified number of people.
% INPUT
%      Area: 2*2 matrix, the first row is the upper left corner and the second row is the lower right corner of the area.
%      Num: the number of people to be generated.
%      Occupancy: the occupancy of the area.
% OUTPUT
%      PeoStart: Num*2 matrix, the starting points of the people.
%%
function PeoStart = PeoRandStart(Area,Num,Occupancy)
    Up = Area(1,1);
    Left = Area(1,2);
    Down = Area(2,1);
    Right = Area(2,2);
    AllArea = zeros((Down-Up-1)*(Right-Left-1),2);
    k = 1;
    % AvailableArea = AllArea - Occupancy (in this area);
    for i = (Up+1):(Down-1)
        for j = (Left+1):(Right-1)         
            AllArea(k,:) = [i j];   
            k = k + 1;         
        end
    end
    AvailableArea = setdiff(AllArea,Occupancy,'rows');
    % Generate random starting points for people.
    PeoStart = [];
    for i = 1:Num
        j = randi(size(AvailableArea,1));
        CurrentPoint = AvailableArea(j,:);
        % Randomly choose a point in the available area as a new starting point.
        PeoStart = [PeoStart;CurrentPoint];
        AvailableArea(j,:) = []; % Remove the current point from AvailableArea.           
        Neighbors(1,:) = CurrentPoint + [-1,-1];
        Neighbors(2,:) = CurrentPoint + [-1,0];
        Neighbors(3,:) = CurrentPoint + [-1,1];
        Neighbors(4,:) = CurrentPoint + [0,-1];
        Neighbors(5,:) = CurrentPoint + [0,1];
        Neighbors(6,:) = CurrentPoint + [1,-1];
        Neighbors(7,:) = CurrentPoint + [1,0];
        Neighbors(8,:) = CurrentPoint + [1,1];
        Neighbors(9,:) = CurrentPoint + [-2,-2];
        Neighbors(10,:) = CurrentPoint + [-2,-1];
        Neighbors(11,:) = CurrentPoint + [-2,0];
        Neighbors(12,:) = CurrentPoint + [-2,1];
        Neighbors(13,:) = CurrentPoint + [-2,2];
        Neighbors(14,:) = CurrentPoint + [-1,-2];
        Neighbors(15,:) = CurrentPoint + [-1,2];
        Neighbors(16,:) = CurrentPoint + [0,-2];
        Neighbors(17,:) = CurrentPoint + [0,2];
        Neighbors(18,:) = CurrentPoint + [1,-2];
        Neighbors(19,:) = CurrentPoint + [1,2];
        Neighbors(20,:) = CurrentPoint + [2,-2];
        Neighbors(21,:) = CurrentPoint + [2,-1];
        Neighbors(22,:) = CurrentPoint + [2,0];
        Neighbors(23,:) = CurrentPoint + [2,1];
        Neighbors(24,:) = CurrentPoint + [2,2];
        [NewOccupancy,ia,ib] = intersect(AvailableArea, Neighbors, 'rows');
        AvailableArea(ia,:) = [];
        % Remove the neighbors of the current point from AvailableArea.
        if isempty(AvailableArea)
            error('The area is too small to generate the required number of people.');
        end
    end

