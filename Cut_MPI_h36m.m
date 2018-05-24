load('~/databag/mpii_human_pose/MPI_anno.mat');
load('~/databag/mpii_human_pose/h36m_icon.mat');
load('~/databag/mpii_human_pose/MPI_3Danno.mat');
mpi2h36m = [4 3 13 12 11 14 15 16 7 6 5 8 9 10];
P = 14;
F_anno = length(MPI_3Danno);


groupsize_Th = 10;

%%
num_h36m = length(h36m_icon);
group_id = cell(num_h36m,1);

for i=1:num_h36m
    group_id(i) = {find(MPI_3Danno(:,1)==i)};
end

group_size = cellfun(@length,group_id,'UniformOutput',true);
select_group = find(group_size>groupsize_Th);
system('rm -rf ~/databag/group_images');
mkdir('~/databag/group_images/');

%%
for i=1:length(select_group)
    
    mkdir(['~/databag/group_images/' int2str(select_group(i))]);
    mpi_idx = group_id{select_group(i)};
    for j=1:length(mpi_idx)        
        img = imread(['~/databag/mpii_human_pose/images/', MPI_anno(mpi_idx(j)).image]);
        c_2d_x = cell2mat({MPI_anno(mpi_idx(j)).points.x});
        c_2d_y = cell2mat({MPI_anno(mpi_idx(j)).points.y});        
        c_2d_x = c_2d_x(mpi2h36m);
        c_2d_y = c_2d_y(mpi2h36m);
        c_2d = [c_2d_x' c_2d_y' ones(P,1)];    
        f = figure('visible','off');
        clf;
        hold on;
        imshow(img);
        vis_2d(c_2d,3,'-');
        print(['~/databag/group_images/',int2str(select_group(i)),'/',MPI_anno(mpi_idx(j)).image],'-djpeg')
    end    
    t = i
end