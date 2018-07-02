load('~/databag/mpii_human_pose/MPI_anno.mat');
load('~/databag/mpii_human_pose/h36m_K_pose.mat');


%% Randomly generate some human pose from this K-pose dataset

genNum = 100;
pNum = 14;
K = length(h36m_K_pose);
genCoff = randn(genNum,K);
genCoff = genCoff./repmat(sum(genCoff,2),1,K);
h36m_K_edm = zeros(pNum*(pNum-1)/2,K);
parfor i=1:K
    h36m_K_edm(:,i) = pdist(h36m_K_pose{i});
end
gen_edm = h36m_K_edm*genCoff';

gen_pose = cell(genNum,1);
parfor i=1:genNum
    D = squareform(gen_edm(:,i));
    D = (D+D')/2;
    gen_pose(i) = {mdscale(D,3)};
end

%%