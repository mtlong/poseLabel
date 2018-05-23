addpath('EPnP_matlab/EPnP/');
addpath('EPnP_matlab/error/');
load('~/databag/mpii_human_pose/MPI_anno.mat');
load('~/databag/mpii_human_pose/h36m_icon.mat');
load('~/databag/mpii_human_pose/MPI_3Danno.mat');
mpi2h36m = [4 3 13 12 11 14 15 16 7 6 5 8 9 10];

P = 14;

F_anno = length(MPI_3Danno);

h36m_cell = cellfun(@transpose,h36m_icon,'UniformOutput',false);

Anno3D_cell = h36m_cell(MPI_3Danno(:,1));

%%
K_cell = {MPI_anno.image_K}';

