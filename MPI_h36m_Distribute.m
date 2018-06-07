% 3D data format
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



% Torso part [3 6 12 9]  [ right shoulder, left shoulder, left hip, right
% hip]

addpath('EPnP_matlab/EPnP/');
addpath('EPnP_matlab/error/');
addpath('tool_geometry/');
load('~/databag/mpii_human_pose/MPI_anno.mat');
load('~/databag/mpii_human_pose/h36m_K_pose.mat');
load('~/databag/mpii_human_pose/MPI_h36m_Anno.mat');


%%
ssdist = 279.5914;
hhdist =   265.8974;
shdist = 431.3684;

TorsoFrame = zeros(4,3);
TorsoFrame(1,:) = [-ssdist/2 shdist 0];
TorsoFrame(2,:) = [ssdist/2 shdist 0];
TorsoFrame(3,:) = [hhdist/2 0 0];
TorsoFrame(4,:) = [-hhdist/2 0 0];


val_Length = 50;

K = length(h36m_K_pose);
[F_anno,KNN] = size(MPI_3DAnno);
KNN = KNN/2;
P = 16;

mpi2h36m = [10 9 13 12 11 14 15 16 3 2 1 4 5 6]';
mpi2torso = [3 6 12 9];
Anno3D_cell = h36m_K_pose(MPI_3DAnno(:,1)); %%KNN = 1
Anno2D_cell = cell(F_anno,1);





%% Data preparation. 3D data and 2D data
K_cell = {MPI_anno.image_K}';
for i=1:F_anno
    pts = [MPI_anno(i).points.x;MPI_anno(i).points.y];
    ptsid = [MPI_anno(i).points.id]+1;
    pts2d = zeros(size(pts));
    pts2d(:,ptsid) = pts;
    pts2d = [pts2d' ones(P,1)];
    pts2d = pts2d(mpi2h36m,:);
    Anno2D_cell{i} = pts2d;
end

%% PnP
[R_cell,T_cell,~,~,~]=cellfun(@efficient_pnp_gauss,Anno3D_cell,Anno2D_cell,K_cell,'UniformOutput',false);
Rep2D_cell = cellfun(@reproject,R_cell,T_cell,K_cell,Anno3D_cell,'UniformOutput',false);

%% Calculate the distribution

K_pose_mpi = [];
d1 = zeros(K,1);
d2 = zeros(K,1);
d12 = zeros(K,1);

for i=1:K
    cId = find(MPI_3DAnno(:,1)==i);
    K_pose_mpi(i).valid = length(cId)>val_Length;
    if(K_pose_mpi(i).valid)
        K_pose_mpi(i).id = {cId};
        
        kPose = h36m_K_pose{i};
        kTorso= kPose(mpi2torso,:);
        [Rc,Tc] = bodyAlign(kTorso,TorsoFrame);
        kPoseAlign = Rc*kPose'+Tc;
        
        cR = R_cell(cId);
        cT = T_cell(cId);
        
        [~,oCam] = cellfun(@invRT,cR,cT,'UniformOutput',false);
        oCam = cellfun(@transpose,oCam,'UniformOutput',false);
        oCam = cell2mat(oCam);
        K_pose_mpi(i).cam = Rc*oCam'+Tc;
        figure(1);
        clf;
        vis_3d(kPoseAlign');
        hold on;
        plot3(K_pose_mpi(i).cam(1,:),K_pose_mpi(i).cam(2,:),K_pose_mpi(i).cam(3,:),'r+');
        pause;
    end
end



%%



function x = reproject(R,T,K,X)
x = K*[R,T]*[X,ones(length(X),1)]';
x = x./repmat(x(3,:),3,1);
x = x';
end


function [invR,invT] = invRT(R,T)
invR = R';
invT = -invR*T;
end
