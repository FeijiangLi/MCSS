function [res_d] = pca_data(data)


numViews = size(data, 2);  % 视图的数量

% 定义方差贡献率阈值
varianceThreshold = 0.95;  % 方差贡献率阈值为0.95
reducedData = cell(1, numViews);
res_d = cell(1, numViews);
% 对每个视图进行降维
for i = 1:numViews
    X = data{1, i};  % 获取当前视图下的数据
    sparsity = nnz(X) / numel(X);
     if sparsity < 0.5 
         X = full(X);
     end
    % 中心化处理
    meanX = mean(X);
    centredX = X - meanX;
    
    % 计算协方差矩阵
    C = cov(centredX);
    
    % 执行PCA
    [~, ~, ~, ~, explained] = pca(centredX);
    
    % 计算方差贡献率的累积和
    cumulativeExplained = cumsum(explained) / sum(explained);
    
    % 根据方差贡献率选择降维维度
    dim = find(cumulativeExplained >= varianceThreshold, 1);
    
    % 保留降维后的数据
    [~, score, ~, ~, ~, ~] = pca(centredX, 'NumComponents', dim);
    reducedX = score;
    reducedData{1, i} = reducedX;
    res_d{1, i} = dim;
    
end
   Data  = reducedData;
%    disp(size(Data));
end
