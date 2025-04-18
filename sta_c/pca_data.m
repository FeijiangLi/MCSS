function [res_d] = pca_data(data)


numViews = size(data, 2);  % ��ͼ������

% ���巽�������ֵ
varianceThreshold = 0.95;  % ���������ֵΪ0.95
reducedData = cell(1, numViews);
res_d = cell(1, numViews);
% ��ÿ����ͼ���н�ά
for i = 1:numViews
    X = data{1, i};  % ��ȡ��ǰ��ͼ�µ�����
    sparsity = nnz(X) / numel(X);
     if sparsity < 0.5 
         X = full(X);
     end
    % ���Ļ�����
    meanX = mean(X);
    centredX = X - meanX;
    
    % ����Э�������
    C = cov(centredX);
    
    % ִ��PCA
    [~, ~, ~, ~, explained] = pca(centredX);
    
    % ���㷽����ʵ��ۻ���
    cumulativeExplained = cumsum(explained) / sum(explained);
    
    % ���ݷ������ѡ��άά��
    dim = find(cumulativeExplained >= varianceThreshold, 1);
    
    % ������ά�������
    [~, score, ~, ~, ~, ~] = pca(centredX, 'NumComponents', dim);
    reducedX = score;
    reducedData{1, i} = reducedX;
    res_d{1, i} = dim;
    
end
   Data  = reducedData;
%    disp(size(Data));
end
