%% 根据左边的1~9生成用来比对的图片
img = imread('数独_1.jpg');
I = rgb2gray(img);
%准备截取的坐标
high = 106;
width = 106;
%奇数，左边五个
odd_left_up_y = [110:150:710].';
odd_left_down_y = odd_left_up_y+high;
odd_left_up_x = 35*ones(5,1);
odd_right_up_x = odd_left_up_x+width;
odd = [odd_left_up_y, odd_left_down_y, odd_left_up_x, odd_right_up_x];
%偶数，右边四个
even_left_up_y = [165:150:615].';
even_left_down_y = even_left_up_y+high;
even_left_up_x = 125*ones(4,1);
even_right_up_x = even_left_up_x+width;
even = [even_left_up_y, even_left_down_y, even_left_up_x, even_right_up_x];
recs=zeros(9, 4);
recs(1:2:end, :) = odd;
recs(2:2:end, :) = even;
%截取图形后存在子目录num_imgs里
if ~exist('num_imgs', 'dir')
    mkdir('num_imgs');
end
for ii=1:length(recs)
    name = ['./num_imgs/', num2str(ii), '.bmp'];
    rect = recs(ii, :);
    temp = I(rect(1):rect(2), rect(3):rect(4));
    temp = temp(30:80, 30:80);
    marker = imerode(temp, strel('line',10,0));
    Iclean = imreconstruct(marker, temp);
    bw2 = imbinarize(Iclean);
    bw2 = remove_bound(bw2);
    imwrite(bw2, name);
end