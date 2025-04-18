function [cl] = link(sim,liu,k)
n=size(sim,1);
cl=zeros(n,1);
sqrtns=ceil(sqrt(n));

cl(liu(:,1))=liu(:,2);

while sum(cl==0)>0

    






    liu=find(cl==0);%不稳定样本索引
    labeled=n-length(liu);
    sim_in=zeros(length(liu),length(labeled));%不稳定*稳定矩阵
    for i=1:k
        lo_label_i=cl==i;%第i类中稳定样本的索引
        liusimi=sim(liu,lo_label_i);
        sim_in(:,i)=max(liusimi,[],2);
    end
    
    re_sim_in=sort(sim_in,2,'descend');
    cha_sim_in=abs(re_sim_in(:,1)-re_sim_in(:,2));
    
    if sum(sum(cha_sim_in))==0 %所有不稳定样本相似性差异为0 标记新类
        now_label_lo=1:1:length(cha_sim_in);
        cl(liu(now_label_lo))=k+1;
    else
    
%         th=graythresh(cha_sim_in);
%         now_label_lo=find(cha_sim_in>th);

        [~,lo]=sort(cha_sim_in,'descend');
        now_label_lo=lo(1:min(sqrtns,length(lo)));
        

        if isempty(now_label_lo)
            now_label_lo=1:1:length(cha_sim_in);
        end
        [~,label]=max(sim_in(now_label_lo,:),[],2);
        cl(liu(now_label_lo))=label;
        
    end
end
disp("done")