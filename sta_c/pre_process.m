function data_ = pre_process(X,labels, k)

% ����������m����ͼ��n������
% X1��X2��...��Xm�ֱ�Ϊ������ͼ����������ÿ������ά��Ϊn x d_i

m = size(X, 1);
% ���ȣ���ÿ����ͼ���������й�һ��
for i = 1:m
    X{i} = normalize(X{i});
end

% Ȼ��ʹ��Relief�㷨��ÿ����ͼ��������ѡ��


for i = 1:m
    [rank{i}, weight{i}] = relieff(X{i}, labels, k);
    num = round(length(rank{i}) * 7/8);
    X{i} = X{i}(:, rank{i}(1: num));
end


data_ = X;

end
