currentPath = pwd;


ds = { 'uci_digit'};
% ds = { dat3000_2d 'Tetra''3-sources', 'WikipediaArticles','uci_digit','Caltech101-20',
% 'CMU-PIE','FACS_v2_Fat_3618n_15492d_9c_uni_Bs','coil100mtv','ALOI_100','LetterScale_20000n_16d_26c_Bs'};

currentPath = pwd;
addpath(genpath(currentPath));
n = length(ds);
close all
for i =1:n  
    
    dataname=ds{i};
    fprintf("\n=============dataset:%s=============\n", dataname);
    load(strcat(dataname,'.mat'));

    k = max(truth);
    tic
    [multi_res,cres] = main(data, k, truth,dataname); 


    [~, index] = max(multi_res(:, 7));
    acc = multi_res(index,3);
    ari = multi_res(index,4);
    nmi = multi_res(index,5);
    pur = multi_res(index,6);
    time = toc;
    result = [acc ari nmi pur time]




   

    
end
function re = minmax(b,a,X)
X_max = max(X);
X_min = min(X);
normalized_X = (X - X_min) * (b - a) / (X_max - X_min) + a;
re = normalized_X;
end
