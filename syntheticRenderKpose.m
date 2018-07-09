%% Create view point list

meanD = 3000;
        
el_num = 15;
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

sample_num = sum(az_num) + 2;


%% Load K poses and Align

addpath('tool_geometry/');
load('~/databag/mpii_human_pose/h36m_K_pose.mat');
K = length(h36m_K_poseAlign);
P = length(h36m_K_poseAlign{1});


%% Render all the images


h36m_K_rendered = zeros(sample_num*K,2*P);
h36m_K_renderedCos = zeros(sample_num*K,P*(P-1)/2);
h36m_K_renderedPos = zeros(sample_num*K,3);

idx = 1;
for i=1:K
    cPoseAlign = h36m_K_poseAlign{i};
    for el = 1:el_num
        for az = 1:length(az_list{el})
            elc = el_list(el);
            azc = az_list{el}(az);            
            p2d = render2azel(cPoseAlign,azc,elc,meanD);           
            h36m_K_rendered(idx,:) = p2d(:); 
            h36m_K_renderedCos(idx,:) = cart2cos(p2d);
            h36m_K_renderedPos(idx,:) = [azc,elc,meanD];
            idx = idx+1;
        end        
    end
end
save('~/databag/mpii_human_pose/h36m_K_rendered.mat','h36m_K_rendered','h36m_K_renderedCos','h36m_K_renderedPos');

