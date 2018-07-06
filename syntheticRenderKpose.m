%% Create view point list

meanD = 3000;
        
el_num = 18;
el_step = pi/(el_num-1);
el_list = -pi/2:el_step:pi/2;

az_factor = cos(el_list);
az_num = round(el_num*2*az_factor);

az_list = cell(el_num,1);
for i=1:length(az_list)
    if(az_num(i)<=1)
        caz_list = 0;
    else
        caz_list = 0:2*pi/az_num(i):2*pi;
        caz_list = caz_list(1:end-1);
    end 
    az_list(i) = {caz_list};
end

%% Load K poses and Align

ddpath('tool_geometry/');
load('~/databag/mpii_human_pose/h36m_K_pose.mat');
K = length(h36m_K_poseAlign);
% ssdist = 279.5914;
% hhdist = 265.8974;
% shdist = 431.3684;
% TorsoFrame = zeros(4,3);
% TorsoFrame(1,:) = [-ssdist/2 0 shdist];
% TorsoFrame(2,:) = [ssdist/2 0 shdist];
% TorsoFrame(3,:) = [hhdist/2 0 0];
% TorsoFrame(4,:) = [-hhdist/2 0 0];
% TorsoId = [3 6 12 9];
% K = length(h36m_K_pose);
% h36m_K_poseAlign = cell(K,1);
% for i=1:K
%     cPose = h36m_K_pose{i};
%     cTorso = cPose(TorsoId,:);
%     [Rc,Tc] = bodyAlign(cTorso,TorsoFrame);
%     cPoseAlign = Rc*cPose'+Tc;
%     h36m_K_poseAlign(i) = {cPoseAlign'};
% end


%% Render all the images

% for i=1:K
%     cPoseAlign = h36m_K_poseAlign{i};
%     for el = 1:el_num
%         for az = 1:length(az_list{i})
%             
%         end        
%     end
%     
% end


%%
cPoseAlign = h36m_K_poseAlign{2};
figure(1);
hold on;
vis_3d(cPoseAlign);
for i=1:el_num
    for j=1:length(az_list{i})
        [x,y,z] = sph2cart(az_list{i}(j),el_list(i),meanD);
        plot3(x,y,z,'r^');
    end    
end
grid on;
axis equal;
view([30 30])
print -dpng renderview 
