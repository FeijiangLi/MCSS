function [cl] = link2(~,pair_sim,liu,k)

[n,~,n_view]=size(pair_sim);
cl=zeros(n,1);
% sqrtns=ceil(sqrt(n));

cl(liu(:,1))=liu(:,2); %cl中已划分样本-所属类别  未划分样本-0类别

sqrtns=ceil(sqrt(n-size(liu,1)));
disp("sqrtns:");
disp(sqrtns);

while sum(cl==0)>0 %存在未划分样本则继续迭代划分
    liu=find(cl==0);%liu中存储未划分样本索引
    labeled=n-length(liu);
%     disp(k);
     sim_in=zeros(length(liu),k,n_view);%改动后 结果无变化
%     sim_in=zeros(length(liu),labeled,n_view);%未改动前
   
    for i=1:k
        lo_label_i=cl==i; %现有第i类样本索引
        liusimi=pair_sim(liu,lo_label_i,:);%所有视图下 考虑第i类别中  未划分样本和第i类样本的相似度  相似度（未划分样本， 第i类样本， 视图）
%         sim_in(:,i,:)=mean(liusimi,2);%改成平均值后 CA Purity上升 但ARI NMI下降
        sim_in(:,i,:)=max(liusimi,[],2); %将liusimi每行最大值赋给sim_in
%         sim_in(:,i,:)=sum(liusimi,2);
%         sim_in(:,i,:)=min(liusimi,[],2); 
    end
%     disp(size(sim_in)); m*k*v  m不稳定样本个数 k个类别 v个视图
      %sim_in: 多个视图下不稳定样本和其不同类别下最相似样本的相似度
    re_sim_in=sort(sim_in,2,'descend');
    cha_sim_in=abs(re_sim_in(:,1,:)-re_sim_in(:,2,:));%置信度最大类别 和第二大类别的差
%     disp(size(cha_sim_in));  m*1*3
    if sum(sum(sum(cha_sim_in)))==0 %判断当前是否为0矩阵
        now_label_lo=1:1:size(cha_sim_in,1); 
        cl(liu(now_label_lo))=k+1;%若是 则将当前剩余数据项标签设为k+1
        disp("en");
    else
        
%         all_cha_sim_in=max(cha_sim_in,[],3);
        all_cha_sim_in=mean(cha_sim_in,3);%m*1
        [~,lo]=sort(all_cha_sim_in,'descend');%由高到低排序 
%         disp("lo:");
%         disp(size(lo));
        now_label_lo=lo(1:min(sqrtns,length(lo)));%取前min(sqrtns,length(lo))项

%         disp(size(now_label_lo));
%         th=graythresh(all_cha_sim_in);
%         now_label_lo=find(all_cha_sim_in>th);

        if isempty(now_label_lo)
            now_label_lo=1:1:length(all_cha_sim_in);
        end
%         [sim_value,~]=max(sim_in(now_label_lo,:,:),[],3);
        [sim_value]=mean(sim_in(now_label_lo,:,:).*cha_sim_in(now_label_lo,:,:),3);
%         disp(size(sim_value));
%         disp(sim_value); 
        [~,label]=max(sim_value,[],2); %label存储返回值最大的列索引
%         disp(label);
        cl(liu(now_label_lo))=label;
        
    end
end