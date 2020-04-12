clear;
clc;
% ���嵱850hpa��200hpaγ���ͬʱ����U850��3m/s��U200��-5m/s������5��,
% ͬʱ�ﵽ��׼�ĵ�һ�켴��ΪBOBSM�ı���������ΪBOBSM�������жϱ�׼.

% ��ȡ����
info = ncinfo('u.nc');
lon = ncread('u.nc','longitude');
lat = ncread('u.nc','latitude');
time = ncread('u.nc','time');
lev = ncread('u.nc','level');
u = ncread('u.nc','u');

% ʱ�䣨Сʱ����ת��������
t0 = datetime(1900,1,1);
date_yyyymmdd = t0 + double(time(:))/24; %timeΪ��1900��1��1��00ʱ��Сʱ��

% ��ʼ���������ÿ��BOBSM��������
u850_200 = zeros(length(u),2);
for i = 1 : length(u)
    u850_200(i,1) = mean(u(:,:,2,i),'all'); % ��ʱ��850hpa����
    u850_200(i,2) = mean(u(:,:,1,i),'all'); % ��ʱ��200hpa����
end

% ��ƽ������
r = 1;
daily = zeros(8702,2);
for i = 1 : 4 : length(u850_200)
    daily(r,1) = mean(u850_200(i:i+3,1));
    daily(r,2) = mean(u850_200(i:i+3,2));
    r = r + 1;
end

% ����5��ﵽ��׼��ʼ����
daily_yyyymmdd = date_yyyymmdd(1:4:end);
r = 1;
for i = 1 : length(daily)-4
    if daily(i:i+4,1) > 3 & daily(i:i+4,2) < -5
        t(r,1) = daily_yyyymmdd(i);
        r = r + 1;
    end
end

% ��ѡ����һ�δﵽ������ʱ�䣬��ΪBOBSM����ʱ��
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









