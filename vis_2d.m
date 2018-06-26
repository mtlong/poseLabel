% visualize 2d pose
function vis_2d(j_p,lineWidth,lineStyle)
prediction = j_p;
%prediction(:,1)=prediction(:,1)*(-1);
hold on;
    %for a = 1:14
    %    scatter(prediction(a,1),prediction(a,2));
    %    axis equal
    %end
line([prediction(1,1),prediction(2,1)],[prediction(1,2),prediction(2,2)],'Color','b','LineWidth',lineWidth,'lineStyle',lineStyle);
line([prediction(2,1),prediction(3,1)],[prediction(2,2),prediction(3,2)],'Color','b','LineWidth',lineWidth,'lineStyle',lineStyle);
line([prediction(3,1),prediction(4,1)],[prediction(3,2),prediction(4,2)],'Color','g','LineWidth',lineWidth,'lineStyle',lineStyle);
line([prediction(4,1),prediction(5,1)],[prediction(4,2),prediction(5,2)],'Color','g','LineWidth',lineWidth,'lineStyle',lineStyle);
line([prediction(2,1),prediction(6,1)],[prediction(2,2),prediction(6,2)],'Color','b','LineWidth',lineWidth,'lineStyle',lineStyle);
line([prediction(6,1),prediction(7,1)],[prediction(6,2),prediction(7,2)],'Color','r','LineWidth',lineWidth,'lineStyle',lineStyle);
line([prediction(7,1),prediction(8,1)],[prediction(7,2),prediction(8,2)],'Color','r','LineWidth',lineWidth,'lineStyle',lineStyle);
line([prediction(9,1),prediction(10,1)],[prediction(9,2),prediction(10,2)],'Color','g','LineWidth',lineWidth,'lineStyle',lineStyle);
line([prediction(10,1),prediction(11,1)],[prediction(10,2),prediction(11,2)],'Color','g','LineWidth',lineWidth,'lineStyle',lineStyle);
line([prediction(12,1),prediction(13,1)],[prediction(12,2),prediction(13,2)],'Color','r','LineWidth',lineWidth,'lineStyle',lineStyle);
line([prediction(13,1),prediction(14,1)],[prediction(13,2),prediction(14,2)],'Color','r','LineWidth',lineWidth,'lineStyle',lineStyle);
line([(prediction(9,1)+prediction(12,1))/2,prediction(2,1)],[(prediction(9,2)+prediction(12,2))/2,prediction(2,2)],'Color','b','LineWidth',lineWidth,'lineStyle',lineStyle);
line([prediction(9,1),prediction(12,1)],[prediction(9,2),prediction(12,2)],'Color','b','LineWidth',lineWidth,'lineStyle',lineStyle);

hold off
end