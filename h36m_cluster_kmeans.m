prefix = '~/databag/mpii_human_pose/';

load([prefix 'h36m_blockmask.mat']);
load([prefix 'h36m_edm.mat']);

X = all_edf_mat(icon_mask>0,:);

%%
K = 500;

pool = parpool;                      % Invokes workers
stream = RandStream('mlfg6331_64');  % Random number stream
options = statset('UseParallel',1,'UseSubstreams',1,...
    'Streams',stream);
tic; % Start stopwatch timer
[idx,C,sumd,D] = kmeans(X,K,'Options',options,'MaxIter',20000,...
    'Display','final','Replicates',10);
toc; % Terminate stopwatch timer
delete(pool);


%%
h36m_K_pose = cell(K,1);
for i=1:K
    cId = find(idx==i);
    c_edf = all_edf_mat(cId,:);
    c_dist = pdist2(C(i,:),c_edf,'cityblock');
    [~,I] = sort(c_dist);
    h36m_K_pose(i) = {mdscale(squareform(c_edf(I(1),:)),3)};    
end

%%
for i=1:K
    figure(1);
    clf;
    vis_3d(h36m_K_pose{i});
    grid on;
    pause(0.1);
end
