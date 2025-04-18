function [data]=predata(s)%最小最大归一化
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