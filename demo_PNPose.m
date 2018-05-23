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

%H36m
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


%%Load 2D data. Use cellfun to PnP input images and the library. Then the final pose is

addpath('EPnP_matlab/EPnP/');
addpath('EPnP_matlab/error/');

load('~/databag/mpii_human_pose/MPI_anno.mat');
load('~/databag/mpii_human_pose/h36m_icon.mat');

mpi2h36m = [4 3 13 12 11 14 15 16 7 6 5 8 9 10];

%%
F = length(MPI_anno);
F_3d = length(h36m_icon);
h36m_cell = cellfun(@transpose,h36m_icon,'UniformOutput',false);

%%
while(1)
    idx = randi(F,1);
    img = imread(['~/databag/mpii_human_pose/images/' MPI_anno(idx).image]);
    ptsX = cell2mat({MPI_anno(idx).points.x});
    ptsY = cell2mat({MPI_anno(idx).points.y});
    ptsX = ptsX(mpi2h36m);
    ptsY = ptsY(mpi2h36m);
    P = length(ptsX);
    
    mpi_2dt = [ptsX' ptsY' ones(P,1)];
    
    [h,w,~] = size(img);
    K = eye(3);
    fc = h;
    
    K(1,3) = w/2;
    K(2,3) = h/2;
    K(1,1) = fc;
    K(2,2) = fc;
    K_cell = cell(F_3d,1);
    K_cell(:) = {K};
    Pts_cell = cell(F_3d,1);
    Pts_cell(:) = {mpi_2dt};
    
    tic;
    [Rp,Tp,Xc,err]=cellfun(@efficient_pnp_error,h36m_cell,Pts_cell,K_cell,'UniformOutput',false);
    toc;
    err = cell2mat(err);
    
    [~,sol] = min(err);
    Rsol = Rp{sol};
    Tsol = Tp{sol};
    Ssol = h36m_cell{sol};
    
    mpi_2dRep = K*[Rsol,Tsol]*[Ssol,ones(14,1)]';
    mpi_2dRep = mpi_2dRep./repmat(mpi_2dRep(3,:),3,1);
    mpi_2dRep = mpi_2dRep';
    
    
    figure(1);
    clf;
    
    subplot(1,3,[1 2]);
    imshow(img);
    hold on;
    vis_2d(mpi_2dt,3,'-');
    vis_2d(mpi_2dRep,2,'--');
    subplot(1,3,3)
    vis_3d(h36m_cell{sol});
    grid on;
    view([0 30]);
    pause;
end
