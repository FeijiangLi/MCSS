function [cl] = link3(sim,liu,k,stability,ii)
n=size(sim,1);
cl=zeros(n,1);
sqrtns=ceil(sqrt(n));
load dat3000_2d6.mat;
load colorData.mat
cl(liu(:,1))=liu(:,2);
stacolor = 0.000390317;
if ii ==4
     figure   
     scatter(data_ori(:,1),data_ori(:,2),4,stability,'filled');
     % mycolor = slanCM(1);
     % mycolor = slanCM(116);
     mycolor = slanCM(19);
     % mycolor = Pastel13;
     colormap(mycolor)
     
     colorbar; % 显示 colorbar

     % title('Pastel13'); % 设置标题为颜色映射的名称
     
     % 设置坐标轴线的粗细
     ax = gca;
    set(gca,'FontWeight','bold','FontSize',20,'LineWidth',2);
    xlabel("x",'fontweight','bold');
     ylabel("y", 'fontweight','bold','Rotation', 0);
     hold on
end
% colorMap_ori = [    67/255,170/255,139/255;% 类别1的颜色
%                     255/255,202/255,58/255;   % 类别2的颜色
%                     77/255,144/255,142/255;
%                     87/255,117/255,144/255
%                     138/255,201/255,38/255;
%                     255/255,89/255,94/255;
%                     ];

colorMap_ori = [    67/255,170/255,139/255;% 类别1的颜色
                    69/255,123/255,157/255;%深蓝
                    77/255,144/255,142/255;
                    87/255,117/255,144/255
                    231/255,56/255,71/255;%红
                    168/255,218/255,219/255;   % 浅蓝
                    ];
max_stability = stacolor;
num_diedai = 0;
while sum(cl==0)>0
    num_diedai = num_diedai+1;
    




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


    if ii == 4
     sta_locat = find(cl~=0);
     figure

     scatter(data_ori(sta_locat,1),data_ori(sta_locat,2),3,cl(sta_locat),'filled')
     colormap(colorMap_ori);
     hold on
     unsta_locat = find(cl == 0);
     % unsta_color = zeros(size(unsta_locat ,1),1);
     scatter(data_ori(unsta_locat,1),data_ori(unsta_locat,2),3,[128/255,128/255,128/255],'filled')


        ax = gca;

    set(gca,'FontWeight','bold','FontSize',20,'LineWidth',2);
    xlabel("x",'fontsize',20);
     ylabel("y", 'fontsize',20,'Rotation', 0);
    end
end

if ii == 4
     sta_locat = find(cl~=0);
     figure

     scatter(data_ori(sta_locat,1),data_ori(sta_locat,2),15,data_ori(sta_locat,3),'filled')
     colormap(colorMap_ori);
     hold on
     unsta_locat = find(cl == 0);
     % unsta_color = zeros(size(unsta_locat ,1),1);
     scatter(data_ori(unsta_locat,1),data_ori(unsta_locat,2),15,'cyan','filled')


        ax = gca;

    set(gca,'FontWeight','bold','FontSize',20,'LineWidth',2);
    xlabel("x",'fontsize',20);
     ylabel("y", 'fontsize',20,'Rotation', 0);
end


disp("done")