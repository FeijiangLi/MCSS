function [sim] = kernal_sim(data)
% n=size(data,1);
% nei=floor(1*sqrt(n));
% [dataed,~] = knnsearch(data,data,'K',nei);
% z=zeros(n,n);
% for i=1:n
%     z(i,dataed(i,:))=1;
% end
% sim=z*z';
% sim=sim./nei;

dist_line=pdist(data);
N=length(dist_line);
percent=8;
position=round(N*percent/100);
sda=sort(dist_line);
dc=sda(position);
dist=squareform(dist_line);
sim=exp(-(dist/dc).^2);
sim=sim*sim';
sim=sim./max(max(sim));
end