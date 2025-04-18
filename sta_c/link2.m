function [cl] = link2(~,pair_sim,liu,k)

[n,~,n_view]=size(pair_sim);
cl=zeros(n,1);
% sqrtns=ceil(sqrt(n));

cl(liu(:,1))=liu(:,2); %cl���ѻ�������-�������  δ��������-0���

sqrtns=ceil(sqrt(n-size(liu,1)));
disp("sqrtns:");
disp(sqrtns);

while sum(cl==0)>0 %����δ���������������������
    liu=find(cl==0);%liu�д洢δ������������
    labeled=n-length(liu);
%     disp(k);
     sim_in=zeros(length(liu),k,n_view);%�Ķ��� ����ޱ仯
%     sim_in=zeros(length(liu),labeled,n_view);%δ�Ķ�ǰ
   
    for i=1:k
        lo_label_i=cl==i; %���е�i����������
        liusimi=pair_sim(liu,lo_label_i,:);%������ͼ�� ���ǵ�i�����  δ���������͵�i�����������ƶ�  ���ƶȣ�δ���������� ��i�������� ��ͼ��
%         sim_in(:,i,:)=mean(liusimi,2);%�ĳ�ƽ��ֵ�� CA Purity���� ��ARI NMI�½�
        sim_in(:,i,:)=max(liusimi,[],2); %��liusimiÿ�����ֵ����sim_in
%         sim_in(:,i,:)=sum(liusimi,2);
%         sim_in(:,i,:)=min(liusimi,[],2); 
    end
%     disp(size(sim_in)); m*k*v  m���ȶ��������� k����� v����ͼ
      %sim_in: �����ͼ�²��ȶ��������䲻ͬ��������������������ƶ�
    re_sim_in=sort(sim_in,2,'descend');
    cha_sim_in=abs(re_sim_in(:,1,:)-re_sim_in(:,2,:));%���Ŷ������� �͵ڶ������Ĳ�
%     disp(size(cha_sim_in));  m*1*3
    if sum(sum(sum(cha_sim_in)))==0 %�жϵ�ǰ�Ƿ�Ϊ0����
        now_label_lo=1:1:size(cha_sim_in,1); 
        cl(liu(now_label_lo))=k+1;%���� �򽫵�ǰʣ���������ǩ��Ϊk+1
        disp("en");
    else
        
%         all_cha_sim_in=max(cha_sim_in,[],3);
        all_cha_sim_in=mean(cha_sim_in,3);%m*1
        [~,lo]=sort(all_cha_sim_in,'descend');%�ɸߵ������� 
%         disp("lo:");
%         disp(size(lo));
        now_label_lo=lo(1:min(sqrtns,length(lo)));%ȡǰmin(sqrtns,length(lo))��

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
        [~,label]=max(sim_value,[],2); %label�洢����ֵ����������
%         disp(label);
        cl(liu(now_label_lo))=label;
        
    end
end