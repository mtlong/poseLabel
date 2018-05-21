load('3D_library.mat');
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

val_edf = all_edf_mat(:,~limb_mask);


fprintf('starting---\n');


%% Purifying.

poseTh = 0.05*80;


icon_mask = ones(F,1);

for i=1:F    
    if(mod(i,100)==0)
        fprintf('Iter %d  IconNum %d  Icon Rate:%.3f \n',i,sum(icon_mask),sum(icon_mask)*1.0/F);
    end    
    if(icon_mask(i)<1) 
        continue;    
    end    
    c_edf = val_edf(i,:);            
    c_mask = pdist2(c_edf,val_edf(i+1:end,:),'cityblock')>poseTh;
    icon_mask(i+1:end) = icon_mask(i+1:end)&c_mask';
    
end

fprintf('Thank all the fish\n');

save('icon_mask.mat','icon_mask');




