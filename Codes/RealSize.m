%% The function 'RealSize()' processes the input matrix.
% INPUT
%      The original input matrix (0 for road, 1 for non-road)
% OUTPUT
%      The real size of the input (blank excluded)
%%
function Size = RealSize(Input)
HangMin = size(Input, 1);
LieMin = size(Input, 2);
HangMax = 0;
LieMax = 0;
for i = 1:size(Input, 1)
    for j = 1:size(Input, 2)
        if Input(i,j) == 1
            if HangMin > i
                HangMin = i;
            end
            if LieMin > j
                LieMin = j;
            end
            if HangMax < i
                HangMax = i;
            end
            if LieMax < j
                LieMax = j;
            end
        end
    end
end
Size = [HangMin, LieMin, HangMax, LieMax];
end
