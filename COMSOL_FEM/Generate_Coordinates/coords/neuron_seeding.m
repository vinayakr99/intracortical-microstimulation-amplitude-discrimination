clear all
clear all
close all

% Column width (um)
a=400;
b=400; 

% Layer depth (um)
depth1=(27*2000)/100; % L6
depth2=(12*2000)/100; % L5
depth3=(19*2000)/100; % L4
depth4=(35*2000)/100; % L23
depth5=(7*2000)/100;  % L1

% Layer volume (mm^3)
v1=(a/1000)*(b/1000)*(depth1/1000); % L6
v2=(a/1000)*(b/1000)*(depth2/1000); % L5
v3=(a/1000)*(b/1000)*(depth3/1000); % L4
v4=(a/1000)*(b/1000)*(depth4/1000); % L23
v5=(a/1000)*(b/1000)*(depth5/1000); % L1

% Number of neurons each layer
nn_1=(v1*20000)+2; % L6
nn_2=(v2*20000)+2; % L5
nn_3=(v3*20000)+4; % L4
nn_4=v4*20000;     % L23
nn_5=(v5*20000)+2; % L1

tot_cell_count=[round(nn_5/5)*ones(1,5) round(nn_4/5)*ones(1,5) round(nn_3/5)*ones(1,5) round(nn_2/5)*ones(1,5) round(nn_1/5)*ones(1,5)];

% Generate neuron coordinates ============================================

n1 = bsxfun(@times, [a, b, depth1], rand(round(nn_1/5)*5,3) ); % L6
n2 = bsxfun(@times, [a, b, depth2], rand(round(nn_2/5)*5,3) ); % L5
n3 = bsxfun(@times, [a, b, depth3], rand(round(nn_3/5)*5,3) ); % L4
n4 = bsxfun(@times, [a, b, depth4], rand(round(nn_4/5)*5,3) ); % L23
n5 = bsxfun(@times, [a, b, depth5], rand(round(nn_5/5)*5,3) ); % L1

x1=n1(:,1);
z1=n1(:,2);
y1=n1(:,3);

x2=n2(:,1);
z2=n2(:,2);
y2=540+n2(:,3);

x3=n3(:,1);
z3=n3(:,2);
y3=540+240+n3(:,3);

x4=n4(:,1);
z4=n4(:,2);
y4=540+240+380+n4(:,3);

x5=n5(:,1);
z5=n5(:,2);
y5=540+240+380+700+n5(:,3);

realx=fliplr([x1' x2' x3' x4' x5']);
realy=fliplr([y1' y2' y3' y4' y5']);
realz=fliplr([z1' z2' z3' z4' z5']);

% angle
rot_ran=2*pi*rand(1,length(realx));

% Save coordinates
save coords/realx.dat realx -ascii
save coords/realy.dat realy -ascii
save coords/realz.dat realz -ascii
save coords/realang.dat rot_ran -ascii
 
save coords/cell_cnt.dat tot_cell_count -ascii

sum(tot_cell_count)

% Plot coordinates
figure(1)
plot3(realx,realz,realy,'.');
hold on
plot3(a/2,b/2,1000,'.r','Markersize',20);
hold off
view(3)
axis equal