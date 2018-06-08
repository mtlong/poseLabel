% h36m data format
% 1 (head)
% 2 (neck) 
% 3 (right shoulder)
% 4 (right elbow)
% 5 (right wrist)
% 6 (left shoulder)
% 7 (left elbow)
% 8 (left wrist)
% 9 (right hip)
% 10 (right knee)
% 11 (right ankle)
% 12 (left hip)
% 13 (left knee)
% 14 (left ankle)

% MPI data format
%1 - r ankle, 
%2 - r knee, 
%3 - r hip,
%4 - l hip, 
%5 - l knee, 
%6 - l ankle, 
%7 - pelvis, 
%8 - thorax
%9 - upper neck, 
%10 - head top, 
%11 - r wrist, 
%12 - r elbow, 
%13 - r shoulder, 
%14 - l shoulder, 
%15 - l elbow, 
%16 - l wrist

% OP data format
% //     {1,  "Nose"},
% //     {2,  "Neck"},
% //     {3,  "RShoulder"},
% //     {4,  "RElbow"},
% //     {5,  "RWrist"},
% //     {6,  "LShoulder"},
% //     {7,  "LElbow"},
% //     {8,  "LWrist"},
% //     {9,  "RHip"},
% //     {10,  "RKnee"},
% //     {11, "RAnkle"},
% //     {12, "LHip"},
% //     {13, "LKnee"},
% //     {14, "LAnkle"},

% //     {15, "REye"},
% //     {16, "LEye"},
% //     {17, "REar"},
% //     {18, "LEar"},
% //     {19, "Background"},

KNN = 5;


addpath('EPnP_matlab/EPnP/');
addpath('EPnP_matlab/error/');

load('~/databag/SFRM/tsinghua_walk/pose2d.mat');
load('~/databag/mpii_human_pose/h36m_K_pose.mat');

imgs = dir('~/databag/SFRM/tsinghua_walk/image_0/*.jpg');

dnum = length(imgs);

camK = eye(3);
camK(1,1) = 7.005836945361845e+02;
camK(2,2) =  7.005836945361845e+02;
camK(1,3) = 7.577392339646816e+02;
camK(2,3) = 3.667215676837498e+02;

K = length(h36m_K_pose);

camK_cell = cell(K,1);
camK_cell(:) = {camK};

result_3d = zeros(dnum,1);


coco_mask = [0;0;ones(12,1)];
coco_mask = logical(coco_mask);
confTh = 0.2;


%%

parfor i=1:dnum
    cPose = openpose(i*3-2:i*3,:);  
    pts_cell = cell(K,1);
    pnp_mask = cell(K,1);
    pts_cell(:) = {cPose'};
    pnp_mask(:) = {cPose(3,:)'>confTh&coco_mask};
    
    [~,~,~,err]=cellfun(@efficient_pnp_error,h36m_K_pose,pts_cell,camK_cell,pnp_mask,'UniformOutput',false);
    [sorterr,sortid] = sort(cell2mat(err));   
    result_3d(i) = sortid(1);            
    fprintf('%d frame results in %d\n',i,result_3d(i));
end

save('result_3d.mat','result_3d');


%%

reperr = zeros(dnum,1);

f = figure('Units','points','Position',[0 0 1280 400]);

for i=1:dnum
    cimg = imread([imgs(i).folder '/' imgs(i).name]);
    cPose = openpose(i*3-2:i*3,:);  
    cmask = cPose(3,:)'>confTh&coco_mask;
    cTarget = h36m_K_pose{result_3d(i)};
    
    [R,t]=efficient_pnp_gauss(cTarget(cmask,:),cPose(:,cmask)',camK);        
    c3D = R*h36m_K_pose{result_3d(i)}'+t;
    c2D = camK*c3D;
    c2D = c2D./repmat(c2D(3,:),[3 1]);    
    %f = figure('visible','off');    

    figure(f);
    subtightplot (1, 3, 1, [0.01 0.01]);
    imshow(cimg);
    hold on;
    vis_2d(cPose',3,'-');
    title('Openpose');
    subtightplot (1, 3, 2, [0.01 0.01]);
    imshow(cimg);
    hold on;
    vis_2d(c2D',3,'-.');       
    title('h36m reprojection');
    subtightplot (1, 3, 3, [0.01 0.01]);
    imshow(cimg);
    
    hold on;
    vis_2d(c2D',3,'-.');       
    vis_2d(cPose',3,'-');
    title('overlaped');
    
    
    figureName = sprintf('~/databag/SFRM/tsinghua_walk/h36m_images/%04d.jpg',i); 
    print(figureName,'-djpeg');
    reperr(i) = sum(diag((cPose(1:2,:) - c2D(1:2,:))'*(cPose(1:2,:) - c2D(1:2,:))).*double(cmask));
end




%%
