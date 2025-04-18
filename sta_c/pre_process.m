function data_ = pre_process(X,labels, k)

% 假设我们有m个视图和n个样本
% X1、X2、...、Xm分别为各个视图的特征矩阵，每个矩阵维度为n x d_i

m = size(X, 1);
% 首先，将每个视图的特征进行归一化
for i = 1:m
    X{i} = normalize(X{i});
end

% 然后，使用Relief算法对每个视图进行特征选择


for i = 1:m
    [rank{i}, weight{i}] = relieff(X{i}, labels, k);
    num = round(length(rank{i}) * 7/8);
    X{i} = X{i}(:, rank{i}(1: num));
end


data_ = X;

end
