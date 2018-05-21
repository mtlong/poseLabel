load('3D_library.mat');
load('icon_mask.mat');

[F,P] = size(s1_s9_3d);

P = P/3;
%% Load H3.6m and change to distance representation

all_3d = cell(F,1);
for i=1:F
    c3d = s1_s9_3d(i,:);
    all_3d{i} = reshape(c3d,[3 P])';  
  
end

fprintf('Loading data\n');


[all_edf] = cellfun(@pdist,all_3d,'UniformOutput',false);

fprintf('Data Loaded\n');
%% Find the max limb and normlize it.
all_edf_mat = cell2mat(all_edf);
limb_mask = var(all_edf_mat)<1e-1;
max_limb = max(all_edf_mat(1,limb_mask));
all_edf_mat = all_edf_mat./max_limb;

val_edf = all_edf_mat(logical(icon_mask),~limb_mask);

val_num = sum(icon_mask);
icon_mask_sparse = ones(val_num,1);
icon_mask_idx = find(icon_mask>0);


poseTh = 0.065*80;

fprintf('starting---\n');
for i=1:val_num
        fprintf('Iter %d  IconNum %d  Icon Rate:%.3f \n',i,sum(icon_mask_sparse),sum(icon_mask_sparse)*1.0/val_num);
	if(icon_mask_sparse(i)<1)
		continue;
	end
	c_edf = val_edf(i,:);
	c_mask = pdist2(c_edf,val_edf(i+1:end,:),'cityblock')>poseTh;
	icon_mask_sparse(i+1:end) = icon_mask_sparse(i+1:end)&c_mask'; 		
end

idx_iconmask_sparse = icon_mask_idx(logical(icon_mask_sparse));
h36m_sparse = s1_s9_3d(idx_iconmask_sparse,:);

fprintf('Thank all the fish\n');

save('iconmask_sparse.mat','idx_iconmask_sparse');
save('h36m_sparse.mat','h36m_sparse');



