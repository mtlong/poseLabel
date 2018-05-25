addpath('EPnP_matlab/EPnP/');
addpath('EPnP_matlab/error/');
load('~/databag/mpii_human_pose/MPI_anno.mat');
load('~/databag/mpii_human_pose/h36m_icon.mat');
load('~/databag/mpii_human_pose/MPI_3Danno.mat');
mpi2h36m = [4 3 13 12 11 14 15 16 7 6 5 8 9 10];

P = 14;

F_anno = length(MPI_3Danno);
h36m_cell = cellfun(@transpose,h36m_icon,'UniformOutput',false);

Anno3D_cell = h36m_cell(MPI_3Danno(:,1)); %%KNN = 1
Anno2D_cell = cell(F_anno,1);

%% Calc normalized reprojection error.
K_cell = {MPI_anno.image_K}';

for i=1:F_anno
    c_2d_x = cell2mat({MPI_anno(i).points.x});
    c_2d_y = cell2mat({MPI_anno(i).points.y});        
    c_2d_x = c_2d_x(mpi2h36m);
    c_2d_y = c_2d_y(mpi2h36m);
    Anno2D_cell{i} = [c_2d_x' c_2d_y' ones(P,1)];     
end

[~,~,~,err]=cellfun(@efficient_pnp_error,Anno3D_cell,Anno2D_cell,K_cell,'UniformOutput',false);
err = cell2mat(err);

Anno2D_bbox_lt = cellfun(@min,Anno2D_cell,'UniformOutput',false);
Anno2D_bbox_rb = cellfun(@max,Anno2D_cell,'UniformOutput',false);
Anno2D_bbox_d = cellfun(@minus,Anno2D_bbox_rb,Anno2D_bbox_lt,'UniformOutput',false);
Anno2D_bbox_diag = cellfun(@norm,Anno2D_bbox_d);
normerr = err./Anno2D_bbox_diag;

MPI_3Danno(:,6) = normerr;

%%




dist = 0:0.01:1;
PCK = sum(normerr<dist)./F_anno;

figure('Units','inches',...
'Position',[0 0 8 6],...
'PaperPositionMode','auto');

plot(dist,PCK,'LineWidth',1.5);
grid on;
title('PCK curve');

xlabel('Normlized err','FontSize',12,'FontName','Times');
ylabel('Rate','FontSize',12,'FontName','Times');
print('PCK_curve','-dpng')


