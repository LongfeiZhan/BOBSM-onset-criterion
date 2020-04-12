clear;
clc;
% 定义当850hpa和200hpa纬向风同时满足U850＞3m/s和U200＜-5m/s并持续5天,
% 同时达到标准的第一天即作为BOBSM的爆发日期作为BOBSM爆发的判断标准.

% 读取数据
info = ncinfo('u.nc');
lon = ncread('u.nc','longitude');
lat = ncread('u.nc','latitude');
time = ncread('u.nc','time');
lev = ncread('u.nc','level');
u = ncread('u.nc','u');

% 时间（小时数）转换成日期
t0 = datetime(1900,1,1);
date_yyyymmdd = t0 + double(time(:))/24; %time为距1900年1月1日00时的小时数

% 开始按定义计算每年BOBSM爆发日期
u850_200 = zeros(length(u),2);
for i = 1 : length(u)
    u850_200(i,1) = mean(u(:,:,2,i),'all'); % 逐时刻850hpa风速
    u850_200(i,2) = mean(u(:,:,1,i),'all'); % 逐时刻200hpa风速
end

% 日平均风速
r = 1;
daily = zeros(8702,2);
for i = 1 : 4 : length(u850_200)
    daily(r,1) = mean(u850_200(i:i+3,1));
    daily(r,2) = mean(u850_200(i:i+3,2));
    r = r + 1;
end

% 连续5天达到标准开始日期
daily_yyyymmdd = date_yyyymmdd(1:4:end);
r = 1;
for i = 1 : length(daily)-4
    if daily(i:i+4,1) > 3 & daily(i:i+4,2) < -5
        t(r,1) = daily_yyyymmdd(i);
        r = r + 1;
    end
end

% 挑选出第一次达到条件的时间，即为BOBSM爆发时间
t_str = datestr(t,'yyyy-mm-dd');
r = 1;
for i = 1979 : 2019
    for j = 1 : length(t_str)
        yyyy = t_str(j,1:4);
        if strcmp(num2str(i),yyyy)
            begin_date(r,:) = t_str(j,:);
            r = r + 1;
            break
        end
    end
end

% a = datetime(begin_date)
% xlswrite('begin_date.xls',a)









