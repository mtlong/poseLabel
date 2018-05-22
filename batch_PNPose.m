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
% 1 (head)       4
% 2 (neck)       3
% 3 (right shoulder)    13
% 4 (right elbow)       12
% 5 (right wrist)       11
% 6 (left shoulder)     14
% 7 (left elbow)        15
% 8 (left wrist)        16
% 9 (right hip)         7
% 10 (right knee)       6
% 11 (right ankle)      5
% 12 (left hip)         8
% 13 (left knee)        9
% 14 (left ankle)       10


addpath('EPnP_matlab/EPnP/');
addpath('EPnP_matlab/error/');

load('~/databag/mpii_human_pose/MPI_anno.mat');
load('~/databag/mpii_human_pose/h36m_icon.mat');

mpi2h36m = [4 3 13 12 11 14 15 16 7 6 5 8 9 10];

P = 14;

%%
F_2d = length(MPI_anno);
F_3d = length(h36m_icon);
h36m_cell = cellfun(@transpose,h36m_icon,'UniformOutput',false);

MPI_3Danno = zeros(F_2d,1);
for idx=1:F_2d
    c_anno = MPI_anno(idx);    
    ptsX = cell2mat({c_anno.points.x});
    ptsY = cell2mat({c_anno.points.y});
    ptsX = ptsX(mpi2h36m);
    ptsY = ptsY(mpi2h36m);
    mpi_2dt = [ptsX' ptsY' ones(P,1)];    
    K_cell = cell(F_3d,1);
    Pts_cell = cell(F_3d,1);
    K_cell(:) = {c_anno.image_K};
    Pts_cell(:) = {mpi_2dt};             
    [~,~,~,err]=cellfun(@efficient_pnp_error,h36m_cell,Pts_cell,K_cell,'UniformOutput',false);
    [~,sol] = min(cell2mat(err));
    MPI_3Danno(idx) = sol;     
    fprintf('MPI 2D id: %d  3D id :%d\n',idx,sol);    
end

save('MPI_3Danno.mat','MPI_3Danno');








