addpath('EPnP_matlab/EPnP/');
addpath('EPnP_matlab/error/');
load('~/databag/mpii_human_pose/MPI_anno.mat');
load('~/databag/mpii_human_pose/h36m_icon.mat');
load('~/databag/mpii_human_pose/MPI_3DAnno.mat');
mpi2h36m = [10 9 13 12 11 14 15 16 3 2 1 4 5 6]';

P = 16;

[F_anno,KNN] = size(MPI_3DAnno);
KNN = KNN/2;

h36m_cell = cellfun(@transpose,h36m_icon,'UniformOutput',false);

Anno3D_cell = h36m_cell(MPI_3DAnno(:,1)); %%KNN = 1
Anno2D_cell = cell(F_anno,1);


%% Calc normalized reprojection error.
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

err = MPI_3DAnno(:,6);

Anno2D_bbox_lt = cellfun(@min,Anno2D_cell,'UniformOutput',false);
Anno2D_bbox_rb = cellfun(@max,Anno2D_cell,'UniformOutput',false);
Anno2D_bbox_d = cellfun(@minus,Anno2D_bbox_rb,Anno2D_bbox_lt,'UniformOutput',false);
Anno2D_bbox_diag = cellfun(@norm,Anno2D_bbox_d);
normerr = err./Anno2D_bbox_diag;

%%




dist = 0:0.005:1;
PCK = sum(normerr<dist)./F_anno;

figure('Units','inches',...
'Position',[0 0 8 6],...
'PaperPositionMode','auto');

plot(dist,PCK,'LineWidth',1.5);
grid on;
title('PCK curve');

xlabel('Normlized err','FontSize',12,'FontName','Times');
ylabel('Rate','FontSize',12,'FontName','Times');
print('PCK_curve','-dpng');
save('~/databag/mpii_human_pose/MPI_3DAnnoerr.mat','MPI_3DAnno','normerr');


