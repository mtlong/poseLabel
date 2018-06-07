addpath('EPnP_matlab/EPnP/');
addpath('EPnP_matlab/error/');
load('~/databag/mpii_human_pose/MPI_anno.mat');
load('~/databag/mpii_human_pose/h36m_K_pose.mat');
load('~/databag/mpii_human_pose/MPI_h36m_Anno.mat');

%%
mpi2h36m = [10 9 13 12 11 14 15 16 3 2 1 4 5 6]';

P = 16;

[F_anno,KNN] = size(MPI_3DAnno);
KNN = KNN/2;

Anno3D_cell = h36m_K_pose(MPI_3DAnno(:,1)); %%KNN = 1
Anno2D_cell = cell(F_anno,1);


%% Align 3D and 2D
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

[R_cell,T_cell,~,~,~]=cellfun(@efficient_pnp_gauss,Anno3D_cell,Anno2D_cell,K_cell,'UniformOutput',false);
Rep2D_cell = cellfun(@reproject,R_cell,T_cell,K_cell,Anno3D_cell,'UniformOutput',false);

%%

function x = reproject(R,T,K,X)
    x = K*[R,T]*[X,ones(length(X),1)]';
    x = x./repmat(x(3,:),3,1);    
    x = x';
end
