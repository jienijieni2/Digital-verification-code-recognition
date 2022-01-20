%²âÊÔBPÉñ¾­ÍøÂç
function [sum_N,wrong,rightRate]=testbp(X_test,y_test,net)
    Y = sim( net , X_test')';
    sum_N = size(Y,1);
    [maxY,col_pre] = max(Y');
    class_pre = col_pre -1;
    [maxY,col_test] = max(y_test');
    class_test = col_test - 1;
    wrong = 0;
    for i=1:sum_N
        if class_test(1,i) ~= class_pre(1,i)
            wrong = wrong + 1;
        end
    end
    rightRate = 1-wrong/sum_N;
end