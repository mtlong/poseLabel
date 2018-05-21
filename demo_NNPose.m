load('3D_library.mat');

dpath = '~/databag/slide_data/walk1/view2.json';
JsonStr = fileread(dpath);
JsonData = jsondecode(JsonStr);
allKps = JsonData.pose_keypoints(:,1:14*3);

[F,~] = size(allKps);

for i=1:F
    c2d = reshape(allKps(i,:),[3 14]);
    c3d = kNN_pose_procrus(s1_s9_2d_n,s1_s9_3d,c2d(1:2,:)',10);
    figure(1);
    clf;
    vis_3d(c3d);
    view(45,-45);
    grid on;
    pause(0.1 );
end