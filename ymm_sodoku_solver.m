%给杨咩咩玩PAD上面的数独游戏用的
%能读取游戏截图之后识别出初始的棋盘
%然后解之
%by 02xiaoma
function [] = ymm_sodoku_solver()
    %% get the image
    [FileName,PathName,FilterIndex] = uigetfile({'*.jpg'; '*.bmp'}, '请打开数度游戏的截图', '数独_1.jpg');
    I = imread([PathName, FileName]);
    if FilterIndex==1
        I = rgb2gray(I);
    end
    
    %% prepare num data
    if ~isDataReady()
        generate_num_datas();
    end
    num_data = get_num_data();
    
    %% generate the board
    left = 101; right = 281;%数独的左上角坐标
    width = 711; high = 711;%数独的宽度和高度
    delta_width = 711/9;
    delta_high = 711/9;
    board = zeros(9,9);
    for ii=0:8
        for jj=0:8
            rec = [left+ii*delta_width, right+jj*delta_high, delta_width, delta_high];
            temp = I(rec(1):rec(1)+delta_width, rec(2):rec(2)+delta_high);
            temp = temp(23:69, 17:69);
            marker = imerode(temp, strel('line',10,0));
            Iclean = imreconstruct(marker, temp);
            BW2 = imbinarize(Iclean);
            board(ii+1, jj+1) = detect_num(BW2, num_data);            
        end
    end
    
    %% solve the board
    board = sudoku_solver(board);
    
    %% draw the result
    drawSudoku(board);
end

function b = isDataReady()
    b = true;
    if ~exist('num_imgs', 'dir')
        b = false;
    else
        for ii=1:9
            name = ['./num_imgs/', num2str(ii), '.bmp'];
            if ~exist(name, 'file')
                b=false;
                break;
            end
        end
    end
end

function num_data = get_num_data()
    num_data = cell(9,1);
    for ii=1:9
        name = ['./num_imgs/', num2str(ii), '.bmp'];
        num_data{ii} = remove_bound(imread(name));
    end
end

function num = detect_num(img, num_data)
    img = remove_bound(img);
    if (isempty(img))
        num=0;
    else
        t = zeros(9,1);
        for ii=1:9
            t(ii) = corr2(imresize(img, [32,32]), imresize(num_data{ii}, [32,32]));
        end
        num = 0;
        sorted_t = sort(t, 'descend');
        if sorted_t(1) > 0.2
            num = find(t == sorted_t(1));
        end
    end
end