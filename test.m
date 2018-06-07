% MPI data format   in   Adam
% 1 (head)  19
% 2 (neck)  0
% 3 (right shoulder)    9
% 4 (right elbow)   10
% 5 (right wrist)   11
% 6 (left shoulder) 3
% 7 (left elbow)    4
% 8 (left wrist)    5
% 9 (right hip) 12
% 10 (right knee)   13
% 11 (right ankle)  14
% 12 (left hip) 6
% 13 (left knee)    7
% 14 (left ankle)   8



%scale = 0.1;
scale = 0.1;

load('~/databag/mpii_human_pose/h36m_K_pose.mat');

kPose = cellfun(@transpose,h36m_K_pose,'UniformOutput',false);
kPoseMat = cell2mat(kPose);
kPoseMat = kPoseMat*scale;
fileID = fopen('~/databag/mpii_human_pose/h36m_K_pose.txt', 'w');

fprintf(fileID,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', kPoseMat');
fclose(fileID);