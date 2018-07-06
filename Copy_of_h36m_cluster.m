prefix = '~/databag/h36m_dataset';
seq = dir(prefix);
seq = seq(3:end);
isdir = cell2mat({seq.isdir});
poseseq = seq(isdir);
numseq = length(poseseq);

%%
for i=1:numseq
    posedir = dir(fullfile(poseseq(i).folder,poseseq(i).name,'MyPoseFeatures/D3_Positions_mono','*.cdf'));
    
end




%% Load H3.6m and change to distance representation
outshape = cell(F,1);
outshape(:) = {[3 P]};

raw_3d = cellfun(@reshape,num2cell(s1_s9_3d,2),outshape,'UniformOutput',false);
raw_3d = cellfun(@transpose,raw_3d,'UniformOutput',false);


%%
fprintf('Data loaded\n');
[edf_3d] = cellfun(@pdist,raw_3d,'UniformOutput',false);
fprintf('EDM Created\n');
%% Find the max limb and normlize it.
all_edf_mat = cell2mat(edf_3d);
limb_mask = var(all_edf_mat)<1e-1;
max_limb = max(all_edf_mat(1,limb_mask));
all_edf_mat = all_edf_mat./max_limb;
val_edf = all_edf_mat(:,~limb_mask);


fprintf('starting---\n');


%% Purifying.

poseTh = 0.01*80;


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

fprintf('So Long and Thanks for All the Fish\n');
save('~/databag/mpii_human_pose/h36m_blockmask.mat','icon_mask');




