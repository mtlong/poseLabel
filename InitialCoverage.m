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
%% Load MPI 2D data and h36m K pose;
addpath('EPnP_matlab/EPnP/');
addpath('EPnP_matlab/error/');
addpath('tool_geometry/');

load('~/databag/mpii_human_pose/MPI_anno.mat');
load('~/databag/mpii_human_pose/h36m_K_pose.mat');
load('~/databag/mpii_human_pose/MPI_h36m_Anno.mat');


%% Torso Frame Initialization for Alignment and Visualization
ssdist = 279.5914;
hhdist =   265.8974;
shdist = 431.3684;

TorsoFrame = zeros(4,3);
TorsoFrame(1,:) = [-ssdist/2 shdist 0];
TorsoFrame(2,:) = [ssdist/2 shdist 0];
TorsoFrame(3,:) = [hhdist/2 0 0];
TorsoFrame(4,:) = [-hhdist/2 0 0];
%%
reproTh=0.05;

K = length(h36m_K_pose);
[F_2d,~] = size(MPI_h36m_Anno);
P = 16;

mpi2h36m = [10 9 13 12 11 14 15 16 3 2 1 4 5 6]';
mpi2torso = [3 6 12 9];


KPose_Cov = {};
normerr = zeros(F_2d,K);

for i=1:K
KPose_Cov(i).record(1) = struct('id',0,'R',eye(3),'T',zeros(3,1),'err',-1);
end



%% Data preparation. 3D data and 2D data, convert error to norm err
for i=1:F_2d
    pts = [MPI_anno(i).points.x;MPI_anno(i).points.y];
    ptsid = [MPI_anno(i).points.id]+1;
    pts2d = zeros(size(pts));
    pts2d(:,ptsid) = pts;
    diff_xy = max(pts2d) - min(pts2d);
    diff_d = norm(diff_xy);
    normerr = MPI_h36m_Anno(i,1001:end)/diff_d;
    Kpose_id = MPI_h36m_Anno(i,1:1000); 
    Kpose_id = Kpose_id(normerr<reproTh);
    if isempty(Kpose_id)
        continue;
    end
    tKpose = h36m_K_pose(Kpose_id);
    tKposeNum = length(tKpose);
    pts2d = [pts2d' ones(P,1)];
    pts2d = pts2d(mpi2h36m,:);
    tpts2d = cell(tKposeNum,1);
    K_cell = cell(tKposeNum,1);
    K_cell(:) = {MPI_anno(i).image_K};
    tpts2d(:) = {pts2d};
    [R_cell,T_cell,~,~,~]=cellfun(@efficient_pnp_gauss,tKpose,tpts2d,K_cell,'UniformOutput',false);
    for j=1:tKposeNum
        KPose_Cov(Kpose_id(j)).record(end+1) = struct('id',i,'R',R_cell{j},'T',T_cell{j},'err',normerr(j));
    end
    fprintf('Update coverage from observation id: %d\n',i);
end


%% calculate how each 2D observation contribution to such a 3D representation
save('~/databag/mpii_human_pose/KPose_Cov.mat','KPose_Cov');
% 
% K_cell = {MPI_anno.image_K}';
% for i=1:F_anno
%     pts = [MPI_anno(i).points.x;MPI_anno(i).points.y];
%     ptsid = [MPI_anno(i).points.id]+1;
%     pts2d = zeros(size(pts));
%     pts2d(:,ptsid) = pts;
%     pts2d = [pts2d' ones(P,1)];
%     pts2d = pts2d(mpi2h36m,:);
%     Anno2D_cell{i} = pts2d;
% end
% % 
% %% PnP
% [R_cell,T_cell,~,~,~]=cellfun(@efficient_pnp_gauss,Anno3D_cell,Anno2D_cell,K_cell,'UniformOutput',false);
% Rep2D_cell = cellfun(@reproject,R_cell,T_cell,K_cell,Anno3D_cell,'UniformOutput',false);

%% Calculate the distribution
% 
% K_pose_mpi = [];
% d1 = zeros(K,1);
% d2 = zeros(K,1);
% d12 = zeros(K,1);
% 
% for i=1:K
%     cId = find(MPI_3DAnno(:,1)==i);
%     K_pose_mpi(i).valid = length(cId)>val_Length;
%     if(K_pose_mpi(i).valid)
%         K_pose_mpi(i).id = {cId};
%         
%         kPose = h36m_K_pose{i};
%         kTorso= kPose(mpi2torso,:);
%         [Rc,Tc] = bodyAlign(kTorso,TorsoFrame);
%         kPoseAlign = Rc*kPose'+Tc;
%         
%         cR = R_cell(cId);
%         cT = T_cell(cId);
%         
%         [~,oCam] = cellfun(@invRT,cR,cT,'UniformOutput',false);
%         oCam = cellfun(@transpose,oCam,'UniformOutput',false);
%         oCam = cell2mat(oCam);
%         K_pose_mpi(i).cam = Rc*oCam'+Tc;
%         figure(1);
%         clf;
%         vis_3d(kPoseAlign');
%         hold on;
%         plot3(K_pose_mpi(i).cam(1,:),K_pose_mpi(i).cam(2,:),K_pose_mpi(i).cam(3,:),'r+');
%         pause;
%     end
% end
% 


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
