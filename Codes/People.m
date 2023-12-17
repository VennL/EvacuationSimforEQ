classdef People < handle
    %   类：人People
    %   属性properties：需要输入以生成对象
    %       ID：编号【数值，1，2，……】
    %       Speed：移动速度，标准速度为1个时间步0.1s移动1个网格0.1m=1m/s【数值，0~+∞】
    %       MoveMode：移动模式，表示该人的行为模式【数值，1，2，……】
    %       Location：位置坐标【1*2向量，x、y】
    %       Floor：楼层【数值，0表示已到达出口，-1表示已伤亡，X.5表示在X和（X+1）层的交界处】
    %   私有属性properties(Access = private)：不可访问不可手动修改
    %       SpeedIndex：用于根据Speed计算一个时间步内移动几次。
    %   方法methods：构造函数（需依次输入上述5个属性）和PeoMove函数
    %       PeoMove：人员移动函数，每次调用需输入对象与静态场
    properties
        ID
        Speed
        MoveMode
        Location
        Floor
    end
    properties(Access = private)
        SpeedIndex
        
    end
    
    methods
        function obj = People(ID,Speed,MoveMode,Location,Floor)
            if nargin == 5
                obj.ID = ID;
                obj.Speed = Speed;
                obj.MoveMode = MoveMode;
                obj.Location = Location;
                obj.Floor = Floor;
                obj.SpeedIndex = 0;
            end
        end
        
        function PeoMove(obj,static,enter,currentloc,allcurrfl,reductionmap)
            if obj.Floor > 0
                floor = obj.Floor;
                if fix(floor) == floor
                    if static{floor}(obj.Location(1),obj.Location(2)) < 2
                        if floor == 1
                            obj.Floor = 0;
                        else
                            waitnum = sum(allcurrfl == floor-0.5);
                            if waitnum < 30 % 楼梯间容量阈值，可修改
                                obj.Floor = floor - 0.5;
                            end
                        end
                    elseif static{floor}(obj.Location(1),obj.Location(2)) > 99999
                        obj.Floor = -1;
                    else
                        actualspeed = obj.Speed * (1 - reductionmap{floor}(obj.Location(1),obj.Location(2)));
						obj.SpeedIndex = obj.SpeedIndex + actualspeed;
                        while obj.SpeedIndex > 1
                            cl = currentloc{floor};
                            cl(obj.Location(1),obj.Location(2)) = 0;                            
                            switch obj.MoveMode                                
                                case 1
                                    [obj.Location,distance] = PeoMoveMode1(obj.Location,static{floor},cl);
                                    if distance == 0
                                        distance = actualspeed;
                                    end
                                case 2
                                    [obj.Location,distance] = PeoMoveMode2(obj.Location,static{floor},cl);
                                    if distance == 0
                                        distance = actualspeed;
                                    end
                                case 3
                                    [obj.Location,distance] = PeoMoveMode3(obj.Location,static{floor},cl);
                                    if distance == 0
                                        distance = actualspeed;
                                    end
                                case 4
                                    [obj.Location,distance] = PeoMoveMode4(obj.Location,static{floor},cl);
                                    if distance == 0
                                        distance = actualspeed;
                                    end
                            end                            
                            obj.SpeedIndex = obj.SpeedIndex - distance;
                        end
                        
                    end
                else
                    floor = fix(floor);
                    cl = currentloc{floor};                    
                    occupancy = conv2(cl,ones(5),'same');
                    [obj.Floor obj.Location(1) obj.Location(2)] = Move2Next(obj,enter{floor},static{floor},occupancy);
                end
            end
        end
    end
end

