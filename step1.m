function [binvat] =step1(vat)
binvat=im2bw(vat,graythresh(vat));
end