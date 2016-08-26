function D = sudoku_solver(D)

exe_name = 'leetcode.exe';
input = ' ';
for ii=1:9
    for jj=1:9
        input=[input, num2str(D(ii,jj))];
    end
end
[status, cmdout] = system([exe_name, input]);
if status==1
    for ii=1:9
        for jj=1:9
            D(ii,jj) = str2num(cmdout((ii-1)*9+jj));
        end
    end
end