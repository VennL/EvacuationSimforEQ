%% ↓ 初始化 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;

%% ↓ 建筑信息输入 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['----------建筑信息输入----------']);
NumofFloor = input('>>请输入楼层数：');
ImgSize = input('>>请输入图纸尺寸：'); % [594, 841]
ImgScale = input('>>请输入图纸缩放比（单个网格边长在图纸中的长度，例如网格边长为100mm，图纸比例尺为1:100，单个网格边长在图纸中的长度为1mm，则输入1）：'); % 1
Wall = cell(1,NumofFloor);
FloorSize = cell(1,NumofFloor);
Hang = zeros(1,NumofFloor);
Lie = zeros(1,NumofFloor);
Exit = cell(1,NumofFloor);
Exit_HangLie = cell(1,NumofFloor);
Enter = cell(1,NumofFloor);
Enter_HangLie = cell(1,NumofFloor);
Static = cell(1,NumofFloor);

%%%%%%%%%%%%%%建筑平面图纸批量上传
pathname=uigetdir(cd,'请选择建筑平面图纸文件夹');
if pathname==0
    msgbox('您没有正确选择文件夹');
    return;
end
filesbmp=ls(strcat(pathname,'\*.bmp'));
filesjpg=ls(strcat(pathname,'\*.jpg'));
filesjpeg=ls(strcat(pathname,'\*.jpeg'));
filesgif=ls(strcat(pathname,'\*.gif'));
filestif=ls(strcat(pathname,'\*.tif'));
filespng=ls(strcat(pathname,'\*.png'));
files=[cellstr(filesbmp);cellstr(filesjpg);...
    cellstr(filesjpeg);cellstr(filesgif);...
    cellstr(filestif);cellstr(filespng)];
len=length(files);           %%串联后的文件cell的最大长度
flag=[];
for ii=1:len                 %%遍历第一个到最后一个图片文件
    if strcmp(cell2mat(files(ii)),'')
        continue;
    end
    Filesname{ii}=strcat(pathname,'\',files(ii));        %%把F1编写成可读路径的形式   %%strcat把字符串连接成一个长字符串。易于读取文件路径     %%filesname就是所有文件的路径了
    
    allWallPath{ii}=cell2mat(Filesname{ii});
end
allWallPath(cellfun(@isempty,allWallPath))=[];           %%删除元胞数组wallpath中的空集并整理，目的：防止路径读取出现空集的情况，形成路径矩阵，之后直接读取使用。

%%出口图纸输入------------------------------------------------------------------------------------------------------------

pathname=uigetdir(cd,'请选择出口图纸文件夹');
if pathname==0
    msgbox('您没有正确选择文件夹');
    return;
end
filesbmp=ls(strcat(pathname,'\*.bmp'));
filesjpg=ls(strcat(pathname,'\*.jpg'));
filesjpeg=ls(strcat(pathname,'\*.jpeg'));
filesgif=ls(strcat(pathname,'\*.gif'));
filestif=ls(strcat(pathname,'\*.tif'));
filespng=ls(strcat(pathname,'\*.png'));
files=[cellstr(filesbmp);cellstr(filesjpg);...
    cellstr(filesjpeg);cellstr(filesgif);...
    cellstr(filestif);cellstr(filespng)];
len=length(files);           %%串联后的文件cell的最大长度
flag=[];
for ii=1:len                 %%遍历第一个到最后一个图片文件
    if strcmp(cell2mat(files(ii)),'')
        continue;
    end
    Filesname{ii}=strcat(pathname,'\',files(ii));     %%把F1编写成可读路径的形式   %%strcat把字符串连接成一个长字符串。易于读取文件路径     %%filesname就是所有文件的路径了
    
    allExitPath{ii}=cell2mat(Filesname{ii});
end
allExitPath(cellfun(@isempty,allExitPath))=[];           %%删除元胞数组wallpath中的空集并整理，目的：形成路径矩阵，之后直接读取使用。
%入口图纸输入------------------------------------------------------------------------------------------------------------
pathname=uigetdir(cd,'请选择入口图纸文件夹');
if pathname==0
    msgbox('您没有正确选择文件夹');
    return;
end
filesbmp=ls(strcat(pathname,'\*.bmp'));
filesjpg=ls(strcat(pathname,'\*.jpg'));
filesjpeg=ls(strcat(pathname,'\*.jpeg'));
filesgif=ls(strcat(pathname,'\*.gif'));
filestif=ls(strcat(pathname,'\*.tif'));
filespng=ls(strcat(pathname,'\*.png'));
files=[cellstr(filesbmp);cellstr(filesjpg);...
    cellstr(filesjpeg);cellstr(filesgif);...
    cellstr(filestif);cellstr(filespng)];
len=length(files);           %%串联后的文件cell的最大长度
flag=[];
for ii=1:len                 %%遍历第一个到最后一个图片文件
    if strcmp(cell2mat(files(ii)),'')
        continue;
    end
    Filesname{ii}=strcat(pathname,'\',files(ii));         %%把F1编写成可读路径的形式   %%strcat把字符串连接成一个长字符串。易于读取文件路径     %%filesname就是所有文件的路径了
    
    allEnterPath{ii}=cell2mat(Filesname{ii});
end
allEnterPath(cellfun(@isempty,allEnterPath))=[];           %%删除元胞数组wallpath中的空集并整理，目的：形成路径矩阵，之后直接读取使用。
%%%%开始循环，使用处理后的元胞数组中的图片文件路径，挨个读取处理%%%%%%
for fl = 1:NumofFloor
    WallPath = allWallPath{fl};                      %%取用路径，带入子函数,衔接后续图像处理
    ExitPath = allExitPath{fl};
    EnterPath = allEnterPath{fl};
    WallInput = Img2Map(WallPath,ImgSize,ImgScale); % 将输入的图片转换为矩阵，每个元素代表一个网格，元素值为0表示该网格为空，为1表示该网格不可通行
    FloorSize{1,fl} = RealSize(WallInput); % % 获取图纸中实际用到的尺寸，去掉四周的空白
    Hang(1,fl) = FloorSize{1,fl}(3) - FloorSize{1,fl}(1) + 1;
    Lie(1,fl) = FloorSize{1,fl}(4) - FloorSize{1,fl}(2) + 1;
    Wall{1,fl} = WallInput(FloorSize{1,fl}(1):FloorSize{1,fl}(3),FloorSize{1,fl}(2):FloorSize{1,fl}(4)); % 取出实际用到的图纸
    
    ExitInput = Img2Map(ExitPath,ImgSize,ImgScale);
    Exit{1,fl} = ExitInput(FloorSize{1,fl}(1):FloorSize{1,fl}(3),FloorSize{1,fl}(2):FloorSize{1,fl}(4));
    [row,col] = ind2sub(size(Exit{1,fl}),find(Exit{1,fl}));
    Exit_HangLie{1,fl} = [row,col];
    
    EnterInput = Img2Map(EnterPath,ImgSize,ImgScale);
    Enter{1,fl} = EnterInput(FloorSize{1,fl}(1):FloorSize{1,fl}(3),FloorSize{1,fl}(2):FloorSize{1,fl}(4));
    [row,col] = ind2sub(size(Enter{1,fl}),find(Enter{1,fl}));
    Enter_HangLie{1,fl} = [row,col];
    
    
    
    
    Map = Wall{1,fl}*1000000 - ones(Hang(1,fl),Lie(1,fl)) + Exit{1,fl};        %%%处理墙体平面矩阵数值，形成大平面矩阵
    Static{1,fl} = Map2Static(Map,Exit_HangLie{1,fl});                         %%%数字计算化为静态场
    level = 0:5:400;
    %%建立窗口
    figure;
    set(gcf,'Position',[100 100 100+Lie(1,fl)*2 100+Hang(1,fl)*2]);
    contourf(Static{1,fl},level,'LineColor','none');
    
    colorbar;
end
disp('★★★建筑信息输入完毕，各层静态场已生成！');



%% ↓ 人员信息输入 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp([newline '----------人员信息输入----------']);
confirm = 1;
while ~isempty(confirm)
    PeoMoveMode = input('>>请输入人员移动行为模式：');
    PeoInputMode = input('>>请输入初始坐标输入方式（1：随机生成；2：从图纸中读取；3：从Excel文件读取）：');
    switch PeoInputMode
        case 1
            % PeoRandStart函数：随机生成人员初始坐标
            % 先从未被占用的网格中随机生成一个人员初始坐标，再从未被占用的网格集合去除该坐标及周围24个点
            % 再随机生成下一个人员初始坐标，直到所有人员坐标都生成或未被占用的网格集合为空
            for fl = 1:NumofFloor
                disp(['##第' num2str(fl) '层人员初始坐标生成……']);
                PeoStart{fl} = [];
                occup = conv2(Wall{1,fl},[1 1 1;1 1 1;1 1 1],'same');
                [row,col] = ind2sub(size(occup),find(occup>0));
                Occupancy = [row,col];
                Area = input('  >>请输入该层第一块设定区域（格式：[小行数，小列数；大行数，大列数]）：'); % [3 3; 66 110]
                while ~isempty(Area)
                    PeopNumb = input('  >>请输入该区域内人数：'); % 100
                    PeoStart{fl} = [PeoStart{fl}; PeoRandStart(Area, PeopNumb, Occupancy)];
                    Area = input('  >>请输入该层下一块设定区域（若已输入完毕请按回车键）：');
                end
                YorN = input('>>生成的该层人员初始坐标是否保存？若保存请输入1：');
                if YorN == 1
                    filename = ['.\output\PeoStart_Floor' num2str(fl) '.xlsx'];
                    xlswrite(filename, PeoStart{fl});
                    disp(['第' num2str(fl) '层人员初始坐标已保存在以下路径：' filename]);
                end
            end
        case 2
            %%人员初始位置图纸输入------------------------------------------------------------------------------------------------------------
            pathname=uigetdir(cd,'请选择人员初始位置图纸文件夹');
            if pathname==0
                msgbox('您没有正确选择文件夹');
                return;
            end
            filesbmp=ls(strcat(pathname,'\*.bmp'));
            filesjpg=ls(strcat(pathname,'\*.jpg'));
            filesjpeg=ls(strcat(pathname,'\*.jpeg'));
            filesgif=ls(strcat(pathname,'\*.gif'));
            filestif=ls(strcat(pathname,'\*.tif'));
            filespng=ls(strcat(pathname,'\*.png'));
            files=[cellstr(filesbmp);cellstr(filesjpg);...
                cellstr(filesjpeg);cellstr(filesgif);...
                cellstr(filestif);cellstr(filespng)];
            len=length(files);           %%串联后的文件cell的最大长度
            flag=[];
            for ii=1:len                 %%遍历第一个到最后一个图片文件
                if strcmp(cell2mat(files(ii)),'')
                    continue;
                end
                Filesname{ii}=strcat(pathname,'\',files(ii));         %%把F1编写成可读路径的形式   %%strcat把字符串连接成一个长字符串。易于读取文件路径     %%filesname就是所有文件的路径了
                
                allPeoPath{ii}=cell2mat(Filesname{ii});
            end
            allPeoPath(cellfun(@isempty,allPeoPath))=[];           %%删除元胞数组wallpath中的空集并整理，目的：形成路径矩阵，之后直接读取使用。
            for fl = 1:NumofFloor
                PeoPath = allPeoPath{fl};                      %%取用路径，带入子函数,衔接后续图像处理
                PeoInput = Img2Map(PeoPath,ImgSize,ImgScale);
                PeoNeigh = [0,0,0;0,1,-1;-1,-1,-1];
                PeoSt = conv2(PeoInput,PeoNeigh,'same');
                peost = PeoSt > 0;
                % ↑ 读取图纸并缩放的过程中，可能将一个人识别为多个网格。通过卷积操作，将相连的网格识别为一个人，保留最上、最左的网格
                PeoStartMap = peost(FloorSize{1,fl}(1):FloorSize{1,fl}(3),FloorSize{1,fl}(2):FloorSize{1,fl}(4));
                [row,col] = ind2sub(size(PeoStartMap),find(PeoStartMap));    %%收集坐标行列
                PeoStart{fl} = [row,col];
            end
            
            
            
            
        case 3
            for fl = 1:NumofFloor
                PeoStartPath = input(['  >>请输入第' num2str(fl) '层人员初始坐标Excel文件（格式：2列）：']); % 'input/1F-Peo.xlsx'
                PeoStart{fl} = xlsread(PeoStartPath);
            end
    end
    % ↓ 计算各层人数，记为向量TotalPeo(fl)，fl为楼层号
    for fl = 1:NumofFloor
        TotalPeo(fl) = size(PeoStart{fl}, 1);
        disp(['★第' num2str(fl) '层总人数为：' num2str(TotalPeo(fl))]);
    end
    % ↓ 绘制人员初始位置分布图
    for fl = 1:NumofFloor
        level = 0:5:400;
        figure;
        set(gcf,'Position',[100 100 100+Lie(1,fl)*2 100+Hang(1,fl)*2]);
        contourf(Static{1,fl},level,'LineColor','none');
        title(['第' num2str(fl) '层人员初始位置分布']);
        hold on
        for i =1:TotalPeo(fl)
            plot(PeoStart{fl}(i,2),PeoStart{fl}(i,1) ,'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 3);
            text(PeoStart{fl}(i,2),PeoStart{fl}(i,1),num2str(i));
        end
        hold off
    end
    % ↓ 输入人员速度并生成向量AllPeo，向量长度为总人数，每个元素为People类的对象，带有编号、速度、行为模式、平面网格坐标、所在楼层这五个属性
    disp([newline '##本程序支持以下人员速度定义方式：' newline '    1.所有人使用同一个指定的速度' newline '    2.每个人使用不同的随机生成的速度' newline '    3.通过Excel表格输入人员速度']);
    SpeedInputMode = input('>>请输入人员速度定义方式：');
    switch SpeedInputMode
        case 1
            Speed = input('  >>请输入人员速度（单位：米/秒，直接按回车则生成0.5~2.5的随机数）：');
            if isempty(Speed)
                Speed = (rand*2+0.5); % rand产生0~1的随机数，则速度为0.5~2.5的随机数
                disp(['  随机生成的速度为' num2str(Speed) '米/秒']);
            end
            k = 1;
            for fl = 1:NumofFloor
                for j = 1:TotalPeo(fl)
                    Location = PeoStart{fl}(j, :);
                    AllPeo(k) = People(k, Speed, PeoMoveMode, Location, fl);
                    k = k + 1;
                end
            end
        case 2
            SpeedMax = input('  >>请输入随机生成的人员速度上限（单位：米/秒）：');
            SpeedMin = input('  >>请输入随机生成的人员速度下限（单位：米/秒）：');
            k = 1;
            for fl = 1:NumofFloor
                for j = 1:TotalPeo(fl)
                    Location = PeoStart{fl}(j, :);
                    AllPeo(k) = People(k, (rand*(SpeedMax-SpeedMin)+SpeedMin), PeoMoveMode, Location, fl);
                    k = k + 1;
                end
            end
        case 3
            SpeedPath = input('  >>请输入人员速度表格文件（列向量，行数等于建筑内总人数，按楼层从1层开始排列）：');
            Speed = xlsread(SpeedPath);
            k = 1;
            for fl = 1:NumofFloor
                for j = 1:TotalPeo(fl)
                    Location = PeoStart{fl}(j, :);
                    AllPeo(k) = People(k, Speed(k), PeoMoveMode, Location, fl);
                    k = k + 1;
                end
            end
    end
    ToPeo = k - 1; % 总人数
    disp('★★★人员信息输入完毕！');
    confirm = input('  >>按回车键程序继续；若输入有误，输入任意值重新进行人员信息输入：');
end

%% ↓ 场景更新输入 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
confirm = 1;
while ~isempty(confirm)
    disp([newline '----------场景更新输入----------']);
    RefreshTotal = input('>>请输入场景更新次数：'); % 2
    if RefreshTotal > 0
        RefreshTime = zeros(1,RefreshTotal);        %%生成更新次数相同的0阵
        Obstacle = [Wall;cell(RefreshTotal,NumofFloor)];     %%每次更新每个时间节点五层图纸都要重新全部输入
        ReductionMap = cell(RefreshTotal+1,NumofFloor);
        for fl = 1:NumofFloor
            ReductionMap{1,fl} = Wall{1,fl};
        end
        
        %%场景变化障碍物图纸输入-----------------------------------------------------------------------------------------------------------
        [excelfile,excelpath] = uigetfile({'*.xlsx';'*.slx';'*.mat';'*.*'}, '请输入场景更新时间Excel表格（单位：秒）：');
        changexlsx = [excelpath,excelfile];      %%'input/更新.xlsx'
        RefreshTime = xlsread(changexlsx);
        RefreshTotal = length(RefreshTime);
        
        for i = 1:RefreshTotal
            j=num2str(i);
            pathname=uigetdir(cd,'请上传本次场景更新各层平面图纸文件夹');
            if pathname==0
                msgbox('您没有正确选择文件夹');
                return;
            end
            filesbmp=ls(strcat(pathname,'\*.bmp'));
            filesjpg=ls(strcat(pathname,'\*.jpg'));
            filesjpeg=ls(strcat(pathname,'\*.jpeg'));
            filesgif=ls(strcat(pathname,'\*.gif'));
            filestif=ls(strcat(pathname,'\*.tif'));
            filespng=ls(strcat(pathname,'\*.png'));
            files=[cellstr(filesbmp);cellstr(filesjpg);...
                cellstr(filesjpeg);cellstr(filesgif);...
                cellstr(filestif);cellstr(filespng)];
            len=length(files);           %%串联后的文件cell的最大长度
            flag=[];
            for ii=1:len                 %%遍历第一个到最后一个图片文件
                if strcmp(cell2mat(files(ii)),'')
                    continue;
                end
                Filesname{ii}=strcat(pathname,'\',files(ii));         %%把F1编写成可读路径的形式   %%strcat把字符串连接成一个长字符串。易于读取文件路径     %%filesname就是所有文件的路径了
                
                allChangePath{ii}=cell2mat(Filesname{ii});
            end
            allChangePath(1)=[];       %%删除第一个元素
            
            for fl = 1:NumofFloor
                ChangePath = allChangePath{fl};                      %%取用路径，带入子函数,衔接后续图像处理
                ObstacleInput = Img2Map(ChangePath,ImgSize,ImgScale);
                Obstacle{i+1,fl} = ObstacleInput(FloorSize{1,fl}(1):FloorSize{1,fl}(3),FloorSize{1,fl}(2):FloorSize{1,fl}(4));
                Map = Obstacle{i+1,fl}*1000000 - ones(Hang(1,fl),Lie(1,fl)) + Exit{1,fl};    %%计算各点数值
                Static{i+1,fl} = Map2Static(Map,Exit_HangLie{1,fl});
                ReductionMap{i+1,fl} = Wall{1,fl};
                
            end
            
        end
    else
        Obstacle=Wall;
    end
    
    
    
    for fl = 1:NumofFloor
        ReductionMap{1,fl} = Wall{1,fl};
    end
    disp('★★★场景更新信息输入完毕！');
    confirm = input('  >>按回车键程序继续；若输入有误，输入任意值重新进行场景更新信息输入：');
end


%% ↓ 疏散模拟 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp([newline '----------人员疏散模拟----------']);
DeltaTime = input('>>请输入疏散模拟的时间步长（单位：秒）：'); % 0.1
TotalTime = input('>>请输入疏散模拟的总时间（单位：秒，模拟中若人员全部疏散完毕则会自动停止）：'); % 2000
Command = 'disp("★★★信息已全部输入完毕！")';
while ~isempty(Command)
    eval(Command);
    Command = input('>>是否有需要修改或补充的信息？若有请输入（须带引号），若无请按回车键继续：');
end
close all;
TTS = TotalTime / DeltaTime; % TotalTimeSteps，总时间步数
AllLoc_X = zeros(ToPeo, TTS); % 每时间步人员位置X坐标
AllLoc_Y = zeros(ToPeo, TTS); % 人员位置Y坐标
AllLoc_Floor = zeros(ToPeo, TTS); % 人员所在楼层
% ↑ AllLoc_X/Y/Floor为三个相同尺寸的矩阵，每个矩阵的第一个维度为人员编号，第二个维度为时间步，三个矩阵分别表示人员位置坐标X/Y/楼层
% 楼层数若为1.5则表示人员正在从2楼进入1楼，以此类推
% 楼层数若为0则表示人员已经从出口逃出，若为-1则表示人员被砸或被困，即为伤亡人员。
AllCurrFl = []; % AllCurrentFloor 当前时间步所有人员所在楼层
for fl = 1:NumofFloor
    %     if ~isempty
    AllCurrFl = [AllCurrFl; fl*ones(TotalPeo(fl),1)];
end
CurrentLoc = cell(1,NumofFloor); % 当前时刻所有人的平面位置
for fl = 1:NumofFloor
    CurrentLoc{1,fl} = zeros(Hang(1,fl),Lie(1,fl));
    if ~isempty(PeoStart{fl})
        CurrentLoc{1,fl}(sub2ind(size(CurrentLoc{1,fl}), PeoStart{fl}(:, 1), PeoStart{fl}(:, 2))) = 1; % 有人的网格值为1，没人的网格值为0
    end
end
% ↓ 开始按时间步迭代
ATTS = TTS; % Actual Total Time Step
RefreshNum = 0; % 场景更新次数计数
disp(['##正在进行第' num2str(RefreshNum + 1) '阶段疏散模拟……']);
tic
for ts = 1:TTS
    % ↓ 判断是否更新场景
    if RefreshNum < RefreshTotal
        if ts * DeltaTime >= RefreshTime(RefreshNum + 1)
            toc
            RefreshNum = RefreshNum + 1;
            disp(['##正在进行第' num2str(RefreshNum + 1) '阶段疏散模拟……']);
            tic
        end
    end
    % ↓ 同一时间步内遍历所有人
    for j = 1:ToPeo
        CL = AllPeo(j).Location;  % CurrentLocation 当前时刻人员位置
        CF = AllPeo(j).Floor; % CurrentFloor 当前时刻人员楼层
        AllLoc_X(j, ts) = CL(1);
        AllLoc_Y(j, ts) = CL(2);
        AllLoc_Floor(j, ts) = CF;
        PeoMove(AllPeo(j), Static(RefreshNum+1,:), Enter_HangLie, CurrentLoc, AllCurrFl, ReductionMap(RefreshNum+1,:));     %%5个属性
        NewX = AllPeo(j).Location(1);
        NewY = AllPeo(j).Location(2);
        NewF = AllPeo(j).Floor;
        if fix(CF) == CF && CF > 0                                   %%当前楼层和位置
            CurrentLoc{CF}(CL(1),CL(2)) = 0;
            if NewF == CF
                CurrentLoc{NewF}(NewX,NewY) = 1;
            end
        elseif fix(NewF) == NewF && NewF > 0
            CurrentLoc{NewF}(NewX,NewY) = 1;
        end
    end
    AllCurrFl = AllLoc_Floor(:,ts);
    NumofRemain = 0;
    for fl = 1:NumofFloor
        NumofRemain = NumofRemain + sum(CurrentLoc{fl}>0,'all');
    end
    if NumofRemain == 0
        ATTS = ts;
        disp(['★★★在第' num2str(ATTS*DeltaTime) '秒人员全部疏散' newline '★★★总计伤亡人数：' num2str(sum(AllLoc_Floor(:,ATTS)==-1,'all'))]);
        AllLoc_Floor(:,ts+1:end) = [];                                       %%伤亡人数的判断
        AllLoc_X(:,ts+1:end) = [];
        AllLoc_Y(:,ts+1:end) = [];
        break;
    end
end
toc
disp('人员疏散模拟完毕！');


%% ↓ 结果输出 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp([newline '----------结果输出----------' newline '开始写入文件……']);
xlswrite('.\AllLoc_Floor.xlsx', AllLoc_Floor);
xlswrite('.\AllLoc_X.xlsx', AllLoc_X);
xlswrite('.\AllLoc_Y.xlsx', AllLoc_Y);

tic
length_X = max(Lie);
length_Y = max(Hang);
VideoName = ['result.avi'];
Video = VideoWriter(VideoName);
IFS = input('>>请输入帧间隔（即每几个时间步输出一帧）：'); % 5
disp('开始生成视频……');
Video.FrameRate = 1 / (DeltaTime * IFS);
open(Video);
RefreshNum = 0; % 场景更新次数计数
for ts = 1:IFS:ATTS
    if RefreshNum < RefreshTotal
        if ts * DeltaTime >= RefreshTime(RefreshNum + 1)
            RefreshNum = RefreshNum + 1;
        end
    end
    figure;
    set(gcf,'Visible','off');
    %set(gcf,'Position',[0 0 length_X*1 length_Y*2*NumofFloor]);
    set(gcf,'Position',[0 0 length_X*1.5 length_Y*4]);
    for fl = 1:NumofFloor
        % subplot(NumofFloor,1,fl);
        subplot(3,1,fl);
        imshow(ones(size(Obstacle{RefreshNum+1,fl})) - Obstacle{RefreshNum+1,fl});     %%显示障碍物矩阵
        axis([0, length_X, 0, length_Y]);
        axis off;
        hold on;
    end
    
    for j = 1:ToPeo
        fl = AllLoc_Floor(j, ts);
        if fix(fl) == fl && fl > 0
            % subplot(NumofFloor,1,fl);
            subplot(3,1,fl);
            plot(AllLoc_Y(j, ts), AllLoc_X(j, ts), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 2);
            axis([0, length_X, 0, length_Y]);
            axis off;
            hold on;
        end
    end
    hold off;
    frame = getframe(gcf);
    writeVideo(Video, frame);
    close(gcf);
    disp(['已完成' num2str(fix(ts/ATTS*100)) '%……']);
end
close(Video);
disp(['视频生成完毕！']);
toc
close all;
disp(['----------程序运行完毕----------']);



