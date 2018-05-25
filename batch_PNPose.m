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

%MPI 2 h36m:
% 10 9 13 12 11 14 15 16 3 2 1 4 5 6
KNN = 5;


addpath('EPnP_matlab/EPnP/');
addpath('EPnP_matlab/error/');

load('~/databag/mpii_human_pose/MPI_anno.mat');
load('~/databag/mpii_human_pose/h36m_icon.mat');

P = 16;

mpi2h36m = [10 9 13 12 11 14 15 16 3 2 1 4 5 6]';
%% 
F_2d = length(MPI_anno);
F_3d = length(h36m_icon);
h36m_cell = cellfun(@transpose,h36m_icon,'UniformOutput',false);
MPI_3DAnno = zeros(F_2d,KNN*2);

for idx=1:F_2d
    c_anno = MPI_anno(idx).points;
    pts = [c_anno.x;c_anno.y];
    ptsid = [c_anno.id]+1;    
    pts2d = zeros(size(pts));    
    pts2d(:,ptsid) = pts; 
    pts2d = [pts2d' ones(P,1)];
    pts2d = pts2d(mpi2h36m,:);
    
    K_cell = cell(F_3d,1);
    Pts_cell = cell(F_3d,1);
    K_cell(:) = {c_anno.image_K};
    Pts_cell(:) = {pts2d};
    [~,~,~,err]=cellfun(@efficient_pnp_error,h36m_cell,Pts_cell,K_cell,'UniformOutput',false);
    [sorterr,sortid] = sort(cell2mat(err));    
    solid = sortid(1:KNN);
    solerr = sorterr(1:KNN);
    MPI_3DAnno(idx,:) = [solid,solerr];    
    fprintf('MPI 2D id: %d \n',idx);    
end

save('MPI_3DAnno.mat','MPI_3DAnno');

