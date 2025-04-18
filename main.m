function [tresult, cres] = main(data_feature,k,gt,dataname)


n_view=size(data_feature,2);
n_data=size(data_feature{1},1);
pair_sim=zeros(n_data,n_data,n_view);

for i=1:n_view
    now_feature=data_feature{i};
    now_feature=predata(now_feature);
    [pair_sim(:,:,i)]=pair_relation(now_feature,k);
end 
all_sim=sum(pair_sim,3)./n_view;

[stability1,consistency1] = calculate_certain(pair_sim);
stability = stability1;


SC = [stability1,consistency1];





select_ration=0.4:0.1:0.6;
[sta_value,sort_locat]=sort(stability,'descend');
stable_value = [sta_value',sort_locat'];
n_test=length(select_ration);
tresult=zeros(n_test,4);
all_detial_k=zeros(n_test,1);
num_selected=floor(n_data.*select_ration);

for ii=1:n_test
    ii;
    now_num_selected=num_selected(ii);
    stable_locat=sort_locat(1:now_num_selected);
    stable_sim2=all_sim(stable_locat,stable_locat);

    
    newsim_dist=1-stable_sim2; 
    newsim_dist=newsim_dist-diag(diag(newsim_dist));
    Z=linkage(newsim_dist,'single');
    detial_k=2*k;
    all_detial_k(ii)=detial_k;
    result=cluster(Z,'maxclust',detial_k);
    
    
    data=(1:1:n_data)';
    
    liu=data(stable_locat,:);

    detial_k=length(unique(result));
    liu=[liu result]; %�ȶ����������������
    [result] = link(all_sim,liu,detial_k); %ʵ���в���
   
    
    n_dataed=1;
    if detial_k==k
        cl=result;
    else
        simij=zeros(1,(detial_k-1)*(detial_k-2)/2+(detial_k-1));
        for i=1:detial_k
            locat_i=result==i;
            for j=i+1:detial_k
                locat_j=result==j;
                sim_ij=all_sim(locat_i,locat_j);
                ij=sum(sum(sim_ij))/(sum(locat_i)*sum(locat_j)); 
                simij((detial_k-1)*(i-1)-((i-1)*(i-2)/2)+j-i)=ij;
            end
        end
        simij=simij./max(simij);
        dis=1-simij;
        Z = linkage(dis,'average');
        clu=cluster(Z,k);
        CC=zeros(n_dataed,1);
        
        for i=1:detial_k
            biaoji=clu(i);
            l= result==i;
            CC(l,:)=biaoji;
        end
    
    cl=CC;
    end

    
    for t = 1:n_view
        dn(t) = indexDN(data_feature{1, t}, cl, 'euclidean');
%         cps(t) = CpS(cl, data_feature{1, t}, size(data_feature{1, t}, 2));
    end
    sum(dn)
    ddn(ii) = sum(dn)/n_view;
%     ccps(ii) = sum(cps)/n_view;
    tresult(ii,:)=getFourMetrics(cl,gt);
    if ii == 2
        cres = cl;
    end
end

tresult=[num_selected' all_detial_k tresult ddn'];
end

 
function [pair_sim]=pair_relation(data,k);
[n,~]=size(data);
% nei = ceil(log2(n)+10)
% nei = floor(n/(2*k))

%ʵ����
nei=floor(1.0*sqrt(n));
nei=min(nei,floor(n/k/2))


% nei = 800

% [dataed,~] = knnsearch(data,data,'K',nei,'Distance','cosine');
[dataed,~] = knnsearch(data,data,'K',nei);
% [dataed,~] = knnsearch(data,data,'K',nei,'Distance','seuclidean');

z=zeros(n,n);
for i=1:n
    z(i,dataed(i,:))=1;
end
pair_dist=z*z';
pair_sim=pair_dist./nei;

end

function [stability,consistency] = calculate_certain(pair_sim)
% th = 0.5;
n = size(pair_sim, 1);
v = size(pair_sim, 3);
cer_matrix = [];
num = zeros(n,1);
cnum = zeros(n,1);
th=graythresh(pair_sim);
for i = 1:n   
    Ai = zeros(n, v);
    for k = 1:v
        Ai(:, k) = pair_sim(:,i,k);
    end
    avg = mean(Ai,2);
    ucon = var(Ai, 0, 2)*(v-1)/v;
    sim = avg;
    sim1=sim>=th;
    sim1=sim1.*(1-th);
    sim2=sim<th;
    sim2=sim2.*(th);
    sim12=sim1+sim2;
    SH=((sim-th)./sim12).^2;
    con = 1-ucon;
    con = mapminmax(con);
    % size(SH)
    T = [SH con];
    s_th = 1.25*graythresh(SH);
    % an = find(T(:,1)>=0.75 & T(:,2)>=0.9);
    can = find(T(:,2)>=0.98);
    an = find(T(:,1)>=0.8);
    cnum(can)=cnum(can)+1;
    num(an) = num(an) + 1;


end
cnum = cnum./sum(cnum);
num = num./sum(num);
stability = num;
consistency = cnum;
end

function [data]=predata(s)%��С����һ��
n=size(s,1);
ma=max(s);
mi=min(s);
cha=ma-mi;
lo=cha==0;
cha(lo)=[];
mi(lo)=[];
s(:,lo)=[];
cha=repmat(cha,n,1);
mi=repmat(mi,n,1);

data=(s-mi)./cha;
end