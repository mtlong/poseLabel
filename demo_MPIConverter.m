load('~/databag/mpii_human_pose/mpii_human_pose_v1_u12_1.mat');


%% valid annotation data.
annolist = RELEASE.annolist;
annovalid = cellfun(@isempty,{annolist.frame_sec});
annolist = annolist(~annovalid);

%%
F = length(annolist);

while(1)
    idx = randi(F,1);
    demo_data = annolist(idx);
    demo_img  = demo_data.image.name;
    img = imread(['~/databag/mpii_human_pose/images/' demo_img]);
    annorect = demo_data.annorect;
    if(isempty(annorect))
        continue;
    end
    
    demo_anno_x = cell2mat({annorect(1).annopoints.point.x});
    demo_anno_y = cell2mat({annorect(1).annopoints.point.y});
    
    figure(1);
    clf;
    imshow(img);
    hold on;
    plot(demo_anno_x,demo_anno_y,'ro','MarkerSize',5,'MarkerFaceColor','r');
    pause;
end

