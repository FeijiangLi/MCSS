function [sim]=pair_relation(data,k);
% flag = issparse(data);
% if flag == true
%     nei = 
n=size(data,1);
nei=floor(1*sqrt(n));
% nei=floor(n/(2*k)); 
% disp(nei)
data = normalize(data);%±ê×¼»¯

% nei=floor(n/(2*k));
% nei=10;
% [dataed,~] = knnsearch(data,data,'K',nei);
[dataed,~] = knnsearch(data,data,'K',nei,'Distance','correlation');
% [dataed,~] = knnsearch(data,data,'K',nei,'Distance','seuclidean');

% [dataed,~] = knnsearch(data,data,'K',nei,'Distance','cosine');
z=zeros(n,n);
for i=1:n
    z(i,dataed(i,:))=1;
end
sim=z*z';
sim=sim./nei;

end