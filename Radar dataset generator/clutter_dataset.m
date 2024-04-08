clear all;
clc;

baseNoClutter = 'noClutter';
baseClutter = 'Clutter';

len = 120
ht = 22
width = 18

for i = 37:100
    %try
        file1 = [baseNoClutter, num2str(i), '.png']
        file2 = [baseClutter, num2str(i), '.png']
        randL = rand
        randH = rand
        randW = rand
        randLen = len + randL
        randHt = ht + randH
        randWidth = width + randW
        randLen1 = len - randL
        randHt1 = ht - randH
        randWidth1 = width - randW
        randL
        randH
        randW
        %random_freq= randi([10e9,10e10],1,1)
        %random_wind_deg= randi([0,50],1,1)
        %random_wind = randi([0,50],1,1)
        %random_rngres = randi([10,40],1,1)
        random_t_deg=randi([0,360],1,1)
        random_t_deg1=randi([0,360],1,1)
        %random_ts=randi([1,20],1,1)*10
        random_t_ang=randi([2,10],1,1)*10
        %random_sealength=randi([2e3,3e3],1,1)
         random_m1=0.5*rand(1,1)
         random_m=random_m1*(random_t_ang/20)*rand(1,1)
         random_k1=0.5 +(1-0.5)*rand(1,1)
         random_k=random_k1*(random_t_ang/20)*rand(1,1)
        ppiNoClutter(randLen,randLen1,randWidth,randWidth1,randHt,randHt1, file1,random_m,random_m1,random_k,random_k1,random_t_ang,random_t_deg,random_t_deg1)
        ppiClutter(randLen,randLen1,randWidth,randWidth1,randHt,randHt1, file2,random_m,random_m1,random_k,random_k1,random_t_ang,random_t_deg,random_t_deg1)
    %catch
        %i=i-1;
        %disp("ERROR!!!!!!!!!!!!!!!!!")
        %continue
    %end
end
