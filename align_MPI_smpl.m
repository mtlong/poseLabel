ptsA = load('/home/xiul/workspace/smplify_public/results/lsp/joints.txt');
load('~/databag/mpii_human_pose/MPI_anno.mat');

%%
P = 16;
i=5;
pts = [MPI_anno(i).points.x;MPI_anno(i).points.y];
ptsid = [MPI_anno(i).points.id]+1;



figure(1);
plot(pts(1,:),pts(2,:),'ro');
for i=1:16
    text(pts(1,i),pts(2,i),num2str(ptsid(i)));
end

axis equal;


% %%
% 1 14
% 2 13
% 3 9
% 6 10
