%%尝试分开处理各个区域

function [cl] = newlink(sim,liu,k,sort_locat,ii)
n=size(sim,1);
cl=zeros(n,1);
sqrtns=ceil(sqrt(n));
stable_locat = liu(:,1);
cl(liu(:,1))=liu(:,2);
narea1=size(liu,1);

rate = 0.3;
narea3 = floor((n-narea1)*rate);
narea4=n-narea1-narea3;
area3_locat = sort_locat(narea1+1:narea1+narea3,:);
area4_locat = sort_locat(narea1+narea3+1:end,:);







%% 处理3区域样本
cl(area4_locat,:) = -1;
sqrtn3s=ceil(sqrt(n-narea4));
while sum(cl==0)>0
    liu=find(cl==0);%3区域样本索引
    labeled=n-narea4-length(liu);
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
        now_label_lo=lo(1:min(sqrtn3s,length(lo)));
        

        if isempty(now_label_lo)
            now_label_lo=1:1:length(cha_sim_in);
        end
        [~,label]=max(sim_in(now_label_lo,:),[],2);
        cl(liu(now_label_lo))=label;
        
    end
end



%% 处理4区域
cl(area4_locat,:) = 0;
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



    % if ii ==3
    % 
    % 
    %     load("dat3000_2d.mat");
    %     n_view = size(data,2);
    %     n_data = size(cl,1);
    %     % for i = 1:n_view
    %     %     figure
    %     %     scatter(data{i}(:,1),zeros(1,n_data),25,truth,'filled');
    %     %     title('Scatter of all samples');
    %     %     hold on
    %     %     scatter(data{i}(stable_locat,1),zeros(1,size(stable_locat,2)),25,'magenta','filled');
    %     %     hold on
    %     %     scatter(data{i}(area3_locat,1),zeros(1,size(area3_locat,2)),25,'red','filled');
    %     %     hold on
    %     %     scatter(data{i}(area4_locat,1),zeros(1,size(area4_locat,2)),25,'green','filled');
    %     % end
    %     figure   
    %     scatter(data_ori(:,1),data_ori(:,2),25,data_ori(:,3),'filled');
    %     hold on
    % 
    %     scatter(data_ori(stable_locat,1),data_ori(stable_locat,2),25,'magenta','filled');
    %     hold on
    % 
    %     scatter(data_ori(area3_locat,1),data_ori(area3_locat,2),25,'red','filled');
    %     hold on 
    % 
    %     scatter(data_ori(area4_locat,1),data_ori(area4_locat,2),25,'green','filled');
    % end





% %%处理3区域
% while sum(cl3(:,2)==0)>0
%     liu_3=cl3(find(cl3(:,2)==0),1);%3区域不稳定样本索引
%     labeled3=narea3-length(liu_3);
%     sim3_in=zeros(length(liu_3),length(labeled3));%不稳定*稳定矩阵
%     for i=1:k
%         lo_label_i=cl==i;%第i类中稳定样本的索引
%         liu3simi=sim(liu_3,lo_label_i);
%         sim3_in(:,i)=max(liu3simi,[],2);
%     end
% 
%     re_sim3_in=sort(sim3_in,2,'descend');
%     cha_sim3_in=abs(re_sim3_in(:,1)-re_sim3_in(:,2));
% 
%     if sum(sum(cha_sim3_in))==0 %所有不稳定样本相似性差异为0 标记新类
%         % now_label_lo3=1:1:length(cha_sim3_in);
%         cl(liu_3)=k+1;
%         tlocat3=find(ismember(cl3(:,1),liu_3));
%         cl3(tlocat3,2)=k+1;
%     else
% 
% %         th=graythresh(cha_sim_in);
% %         now_label_lo=find(cha_sim_in>th);
% 
%         [~,lo3]=sort(cha_sim3_in,'descend');
%         now_label_lo3=lo3(1:min(sqrtn3s,length(lo3)));
% 
% 
%         if isempty(now_label_lo3)
%             now_label_lo3=1:1:length(cha_sim3_in);
%         end
%         [~,label3]=max(sim3_in(now_label_lo3,:),[],2);
%         cl(liu_3(now_label_lo3))=label3;
%         locat_3 = liu_3(now_label_lo3);
%         llocat_3=find(ismember(cl3(:,1),locat_3));
%         cl3(llocat_3,2)=label3;
% 
%     end
% end
% 
% 
% %%处理4区域
% time4 = 0;
% while sum(cl4(:,2)==0)>0
%     time4 = time4 + 1
%     liu_4=cl4(find(cl4(:,2)==0),1);%4区域不稳定样本索引
%     labeled4=narea4-length(liu_4);
%     sim4_in=zeros(length(liu_4),length(labeled4));%不稳定*稳定矩阵
%     for i=1:k
%         lo_label_i=cl==i;%第i类中稳定样本的索引
%         nnz(lo_label_i)
%         liu4simi=sim(liu_4,lo_label_i);
%         size(liu4simi)
%         sim4_in(:,i)=max(liu4simi,[],2);
%     end
% 
%     re_sim4_in=sort(sim4_in,2,'descend');
%     cha_sim4_in=abs(re_sim4_in(:,1)-re_sim4_in(:,2));
% 
%     if sum(sum(cha_sim4_in))==0 %所有不稳定样本相似性差异为0 标记新类
%         % now_label_lo3=1:1:length(cha_sim3_in);
%         cl(liu_4)=k+1;
%         tlocat4=find(ismember(cl4(:,1),liu_4));
%         cl4(tlocat4,2)=k+1;
%     else
% 
% %         th=graythresh(cha_sim_in);
% %         now_label_lo=find(cha_sim_in>th);
% 
%         [~,lo4]=sort(cha_sim4_in,'descend');
%         now_label_lo4=lo4(1:min(sqrtn4s,length(lo4)));
% 
% 
%         if isempty(now_label_lo4)
%             now_label_lo4=1:1:length(cha_sim4_in);
%         end
%         [~,label4]=max(sim4_in(now_label_lo4,:),[],2);
%         cl(now_label_lo4)=label4;
%         % locat_4 = find(ismember(cl4(:,1),now_label_lo4));
%         locat_4 = liu_4(now_label_lo4);
%         llocat_4=find(ismember(cl4(:,1),locat_4));
%         cl4(llocat_4,2)=label4;
% 
%     end
% end
% 
% disp("done!")
end