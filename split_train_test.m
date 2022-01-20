function [X_train, y_train,  X_test, y_test] = split_train_test(X, y, k, ratio)
    %SPLIT_TRAIN_TEST 分割训练集和测试集
    %  参数X是数据矩阵 y是对应类标签 k是类别个数 ratio是训练集的比例
    %  返回训练集X_train和对应的类标签y_train 测试集X_test和对应的类标签y_test
    % 弹出提示框
    msgbox('正在分割数据集！', '提示');
    
    m = size(X, 1);
    class_num = m/k;%每一类的数量
    test_num = floor(class_num*(1-ratio));%每一类中抽出作为测试集的数量
    X_train = X;
    y_train = y;
    X_test = [];
    y_test= [];
    T = [];
    for i = 1:k
        test_idx = randperm(class_num,test_num)+(i-1)*class_num;
        T=[T,test_idx];
        for j=1:test_num
            X_test = [X_test;X(test_idx(j),:)];
            y_test = [y_test;y(test_idx(j),:)];
        end
    end
    save X_test.mat X_test;
    save y_test.mat y_test;
    T = sort(T);
    n = size(T,2);
    for i=n:-1:1
        X_train(T(i),:)=[];
        y_train(T(i),:)=[];
    end
    
    save X_train.mat X_train;
    save y_train.mat y_train;
    msgbox('数据集分割成功！', '提示');
end
