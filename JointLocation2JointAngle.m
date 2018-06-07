% # 1 (head)  added
% # 2 (neck)  -
% # 3 (right shoulder)  17
% # 4 (right elbow) 19
% # 5 (right wrist) 21
% # 6 (left shoulder) 16
% # 7 (left elbow)  18
% # 8 (left wrist)  20
% # 9 (right hip) 2
% # 10 (right knee) 5
% # 11 (right ankle)  8
% # 12 (left hip) 1
% # 13 (left knee)  4
% # 14 (left ankle) 7
addpath('tool_geometry/');

load('~/databag/mpii_human_pose/h36m_K_pose.mat');

Torso = zeros(5,3);
TorsoId = [9 12 3 6 2];

K = length(h36m_K_pose);


SS = zeros(K,4);

for i=1:K
    cPose = h36m_K_pose{i};
    SS(i,1) = norm(cPose(3,:) - cPose(6,:)); %% S-S
    SS(i,2) = norm(cPose(9,:) - cPose(12,:));%% H-H
    cRoot = (cPose(9,:) + cPose(12,:))/2;
    rRoot = (cPose(3,:) + cPose(6,:))/2;
    SS(i,3) = norm(cRoot - cPose(2,:));      %% H-N
    SS(i,4) = norm(cRoot - rRoot);           %% S-H
end
Smean = mean(SS);

%TorsoId = [9 12 3 6 2]; [right hip, left hip, right shoulder, left
%shoulder,nexk]

Torso(1,:) = [-Smean(2)/2 0 0];
Torso(2,:) = [Smean(2)/2 0 0];
Torso(3,:) = [-Smean(1)/2 0 -Smean(4)];
Torso(4,:) = [-Smean(2)/2 0 -Smean(4)];
Torso(5,:) = [0 0 -Smean(3)];


SMPL_pose = zeros(K,72);
idmap = [0,0,17,19,21,16,18,20,2,5,8,1,4,7];

theTa = [-1 1 1];

for i=1:K
    cPose = h36m_K_pose{i};
    cTorso = cPose(TorsoId,:);
    [R,T] = bodyAlign(cTorso,Torso);
    cTPose = R*cPose'+T;
    cTPose = cTPose';
    
    rootVec = [-1 0 0];
    % Right arm
    
    idx1 = 3;
    idx2 = 4;
    idx3 = 5;
    uVec = cTPose(idx2,:) - cTPose(idx1,:);
    bVec = cTPose(idx3,:) - cTPose(idx2,:);
    uMatr = vrrotvec(rootVec,uVec);
    uMat = vrrotvec2mat(uMatr);
    bMatr = vrrotvec(uVec,bVec);
    bMat = vrrotvec2mat(bMatr);
    u = rotm2eul(uMat);
    b = rotm2eul(bMat);
    SMPL_pose(i,idmap(idx1)*3+1:idmap(idx1)*3+3) = u;
    SMPL_pose(i,idmap(idx2)*3+1:idmap(idx2)*3+3) = b;
    
    % Left arm
    rootVec = [1 0 0];
    idx=2;
    idx1 = (idx-1)*3+3;
    idx2 = (idx-1)*3+4;
    idx3 = (idx-1)*3+5;
    uVec = cTPose(idx2,:) - cTPose(idx1,:);
    bVec = cTPose(idx3,:) - cTPose(idx2,:);
    uMatr = vrrotvec(rootVec,uVec);
    uMat = vrrotvec2mat(uMatr);
    bMatr = vrrotvec(uVec,bVec);
    bMat = vrrotvec2mat(bMatr);
    u = rotm2eul(uMat);
    b = rotm2eul(bMat);
    SMPL_pose(i,idmap(idx1)*3+1:idmap(idx1)*3+3) = u;
    SMPL_pose(i,idmap(idx2)*3+1:idmap(idx2)*3+3) = b;
    
    rootVec = [0 0 1];
    for idx=3:4
        idx1 = (idx-1)*3+3;
        idx2 = (idx-1)*3+4;
        idx3 = (idx-1)*3+5;
        uVec = cTPose(idx2,:) - cTPose(idx1,:);
        bVec = cTPose(idx3,:) - cTPose(idx2,:);
        uMatr = vrrotvec(rootVec,uVec);
        uMat = vrrotvec2mat(uMatr);
        bMatr = vrrotvec(uVec,bVec);
        bMat = vrrotvec2mat(bMatr);
        u = rotm2eul(uMat);
        b = rotm2eul(bMat);
        SMPL_pose(i,idmap(idx1)*3+1:idmap(idx1)*3+3) = u;
        SMPL_pose(i,idmap(idx2)*3+1:idmap(idx2)*3+3) = b;
    end
end





save('~/databag/mpii_human_pose/h36m_K_SMPL.mat','SMPL_pose');
% 
% i = 1;
% cPose = h36m_K_pose{i};
%     cTorso = cPose(TorsoId,:);
%     [R,T] = bodyAlign(cTorso,Torso);
%     cTPose = R*cPose'+T;
%     cTPose = cTPose';
%     figure(1);
%     clf;
%     vis_3d(cTPose);
%     pause;

%%
for i=1:K
    cPose = h36m_K_pose{i};
    cTorso = cPose(TorsoId,:);
    [R,T] = bodyAlign(cTorso,Torso);
    cTPose = R*cPose'+T;
    cTPose = cTPose';
    figure(1);
    clf;
    vis_3d(cTPose);
    pause;
    
    
end
