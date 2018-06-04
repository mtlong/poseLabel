prefix = '~/databag/mpii_human_pose/';

load([prefix 'h36m_blockmask.mat']);
load([prefix 'h36m_edm.mat']);
load([prefix '3D_library.mat']);    
[~,P] = size(s1_s9_3d);
P = P/3;

X = all_edf_mat(icon_mask>0,:);
[F,~] = size(X);

%%
K = 1000;

pool = parpool;                      % Invokes workers
stream = RandStream('mlfg6331_64');  % Random number stream
options = statset('UseParallel',1,'UseSubstreams',1,...
    'Streams',stream);
tic; % Start stopwatch timer
[idx,C,sumd,D] = kmeans(X,K,'Options',options,'MaxIter',20000,...
    'Display','final','Distance','cityblock','Replicates',10);
toc; % Terminate stopwatch timer
delete(pool);




%%
iconmask_Id = find(icon_mask>0);
h36m_K_pose = cell(K,1);
h36m_K_ID = zeros(K,1);
h36m_K_err = zeros(F,1);
for i=1:K
    cId = find(idx==i);
    c_edf = all_edf_mat(cId,:);
    c_dist = pdist2(C(i,:),c_edf,'cityblock');
    h36m_K_err(cId) = c_dist;    
    [~,I] = sort(c_dist);
    h36m_K_ID(i) = iconmask_Id(cId(I(1)));
    cPose = s1_s9_3d(h36m_K_ID(i),:);
    h36m_K_pose(i) = {reshape(cPose,[3 P])'};
end

h36m_K_normerr = h36m_K_err./(vecnorm(X,1,2));
save('~/databag/mpii_human_pose/h36m_K_pose.mat','h36m_K_ID','h36m_K_pose');

% %%
% for i=1:K
%     figure(1);
%     clf;
%     vis_3d(h36m_K_pose{i});
%     grid on;
%     pause(0.1);
% end
