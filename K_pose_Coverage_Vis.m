addpath('EPnP_matlab/EPnP/');
addpath('EPnP_matlab/error/');
addpath('tool_geometry/');

%%
load('~/databag/mpii_human_pose/KPose_Cov.mat');
load('~/databag/mpii_human_pose/h36m_K_pose.mat');
ssdist = 279.5914;
hhdist =   265.8974;
shdist = 431.3684;

%%

TorsoFrame = zeros(4,3);
TorsoFrame(1,:) = [-ssdist/2 0 shdist];
TorsoFrame(2,:) = [ssdist/2 0 shdist];
TorsoFrame(3,:) = [hhdist/2 0 0];
TorsoFrame(4,:) = [-hhdist/2 0 0];


mpi2h36m = [10 9 13 12 11 14 15 16 3 2 1 4 5 6]';
mpi2torso = [3 6 12 9];

K = length(KPose_Cov);
%%
for i=1:K
    cPose = h36m_K_pose{i};
    cTorso = cPose(mpi2torso,:);
    [Rc,Tc] = bodyAlign(cTorso,TorsoFrame);
    cPoseAlign = Rc*cPose'+Tc;
    cRecord = KPose_Cov(i).record;
    cR = {cRecord(2:end).R};
    cT = {cRecord(2:end).T};
    [~,cCam] = cellfun(@invRT,cR,cT,'UniformOutput',false);
    % oCam = cellfun(@transpose,oCam,'UniformOutput',false);
    cCam = cCam';
    cCam = cellfun(@transpose,cCam,'UniformOutput',false);
    cCam = cell2mat(cCam);
    cCamAlign = Rc*cCam'+Tc;
    cScore = cell2mat({cRecord(2:end).err});
    [xymap,~] = cam2heatmap(cCamAlign',cScore);
    
    figure(1);
    clf;
    smK = 0.5*ones(3);
    xymapSM = conv2(xymap,smK,'same');
    imagesc(xymapSM);
    axis equal;
    imgName = sprintf('heatmap%04d',i);
    skName = sprintf('pose%04d',i);
    print(['~/databag/mpii_human_pose/' imgName],'-dpng');
    figure(2);
    clf;
    vis_3d(cPoseAlign');
    view([0 0]);
    axis equal;
    print(['~/databag/mpii_human_pose/' skName],'-dpng');
    
    %         kPose = h36m_K_pose{i};
    %         kTorso= kPose(mpi2torso,:);
    %         [Rc,Tc] = bodyAlign(kTorso,TorsoFrame);
    
end


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
function [xymap,hmap] = cam2heatmap(cams,scores)

nBins = 300;
wBins = 5000;
hBins = 100;
xymap = zeros(nBins,nBins);
hmap = zeros(nBins,nBins);
[nCam,~] = size(cams);
for i=1:nCam
idx = (cams(i,1:2)/wBins+0.5)*nBins;
idx = int32(idx);
if(max(idx)>nBins||min(idx)<1)
    continue;
end

xymap(idx(1),idx(2)) = xymap(idx(1),idx(2))+0.01/scores(i);
end





end


function [invR,invT] = invRT(R,T)
invR = R';
invT = -invR*T;
end
