% clear all;
xlspath = 'D:\Study\Serious\Picture\chap3\Fig 11\AllLoc_Floor.xlsx';
Floor_Time = xlsread(xlspath);
Time = size(Floor_Time,2);
Num_Time = zeros(Time,6); % 1:Time 2:Floor1 3:Floor2 4:Floor3 5:Evacuation 6:Casualty
for i = 1:Time
    Num_Time(i,1) = i/10;
    Num_Time(i,2) = sum(Floor_Time(:,i)==1);
    Num_Time(i,3) = sum(Floor_Time(:,i)==2);
    Num_Time(i,4) = sum(Floor_Time(:,i)==3);
    Num_Time(i,5) = sum(Floor_Time(:,i)==0);
    Num_Time(i,6) = sum(Floor_Time(:,i)==-1);
end
