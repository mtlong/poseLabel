mPath = '~/databag/slide_data/walk1';
kps1str = fileread([mPath '/' 'view1.json']);
kps2str = fileread([mPath '/' 'view2.json']);
kps1 = jsondecode(kps1str);
kps2 = jsondecode(kps2str);
kps1 = kps1.pose_keypoints(:,1:14*3);
kps2 = kps2.pose_keypoints(:,1:14*3);

kps1 = reshape(kps1(1,:),[3 14]);
kps2 = reshape(kps2(1,:),[3 14]);

Fmat = Fmat8Points(kps1,kps2);
