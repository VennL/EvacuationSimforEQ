%% The function 'Img2Map()' turns images to maps.
% INPUT
%      Image Path (eg. input 'D:\Program\Matlab\1.jpg')
%      Image Size (eg. input [594 841] if A1 page. NOTICE: a matrix with 594 rows and 841 columns refers to a Landscape Image)
%      Scale (eg. input '2' if 1 grid/pixel == 200*200 mm in reality == '2*2' mm in AutoCAD )
% OUTPUT
%      Map (matrix, 0 for road, 1 for non-road)
%% %%
function Map = Img2Map(ImgPath,ImgSize,Scale)
    % The first input argument (the image path) is required.
    % The second input argument (the image size = [594 841] by default) and the third input argument (the scale = 1 by default) have default values. 
    if nargin == 1
        ImgSize = [594 841];
        Scale = 1;
    end
    if nargin == 2
        Scale = 1;
    end
    if nargin < 1 || nargin > 3
        error('WRONG INPUT.  Img2Map(''ImagePath'', ImageSize, Scale) : the image path is required, the image size and the scale are optional.');
    end
    % 
    if isempty(ImgPath)
        Map = [];
        return;
    end
    
    
    Img = imread(ImgPath);
    color = size(Img,3); % color = 3 if RGB, color = 1 if gray
    if color == 3
        Img = rgb2gray(Img); % if RGB, convert to gray
    end
    Img = imbinarize(Img);  %  convert to binary image
    MapSize = fix(ImgSize./Scale);  %  map size
    Img = imresize(Img,MapSize);  %  resize to map size
    Map = zeros(MapSize);
    for i = 1:MapSize(1)
        for j = 1:MapSize(2)
            if Img(i,j) == 0
                Map(i,j) = 1; % Img = 0 means black means non-road
            end
        end
    end
end
%% %%