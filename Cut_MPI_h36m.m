%% Load data
load('~/databag/mpii_human_pose/MPI_3DAnnoerr.mat');
load('~/databag/mpii_human_pose/h36m_icon.mat');
P = 14;
F_anno = length(MPI_3DAnno);
groupsizeTh = 10;
normerrTh = 0.04;

%% group size
group_num = length(h36m_icon);
group_id = cell(group_num,1);
for i=1:group_num
    group_id(i) = {find(MPI_3DAnno(:,1)==i & normerr<normerrTh)};
end


group_size = cellfun(@length,group_id,'UniformOutput',true);
select_group = find(group_size>groupsizeTh);
groups.mpi = group_id(select_group);
groups.h36m = select_group;
%%
save('~/databag/mpii_human_pose/groups.mat','groups');

