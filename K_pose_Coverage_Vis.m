addpath('EPnP_matlab/EPnP/');
addpath('EPnP_matlab/error/');
addpath('tool_geometry/');

%%
load('~/databag/mpii_human_pose/KPose_Cov.mat');
load('~/databag/mpii_human_pose/h36m_K_pose.mat');
ssdist = 279.5914;
hhdist =   265.8974;
shdist = 431.3684;

%%

TorsoFrame = zeros(4,3);
TorsoFrame(1,:) = [-ssdist/2 0 shdist];
TorsoFrame(2,:) = [ssdist/2 0 shdist];
TorsoFrame(3,:) = [hhdist/2 0 0];
TorsoFrame(4,:) = [-hhdist/2 0 0];


mpi2h36m = [10 9 13 12 11 14 15 16 3 2 1 4 5 6]';
mpi2torso = [3 6 12 9];

K = length(KPose_Cov);


%[xymap,hmapx,hmapy] = HeatMapGenerator(cCamAlign',cErr,xyRange,hRange,xBins,hBins);
xyRange = 5000;
hRange = 3000;
xBins = 500;
hBins = 300;
%%
for i=1:K
    cPose = h36m_K_pose{i};
    cTorso = cPose(mpi2torso,:);
    [Rc,Tc] = bodyAlign(cTorso,TorsoFrame);
    cPoseAlign = Rc*cPose'+Tc;
    cRecord = KPose_Cov(i).record;
    cR = {cRecord(2:end).R};
    cT = {cRecord(2:end).T};
    cErr = {cRecord(2:end).err};
    cErr = cell2mat(cErr);
    
    
    
    [~,cCam] = cellfun(@invRT,cR,cT,'UniformOutput',false);
    
    cCam = cCam';
    cCam = cellfun(@transpose,cCam,'UniformOutput',false);
    cCam = cell2mat(cCam);
    cCamAlign = Rc*cCam'+Tc;
    
    
    [xymap,hmapx,hmapy] = HeatMapGenerator(cCamAlign',cErr,xyRange,hRange,xBins,hBins);
    
    
    smK = 0.5*ones(9);
    xymapSM = conv2(xymap,smK,'same');
    hmapxSM = conv2(hmapx,smK,'same');
    hmapySM = conv2(hmapy,smK,'same');
    pose2dxy = (cPoseAlign(1:2,:)./xyRange+0.5)*xBins;
    pose2dh = (cPoseAlign(3,:)./hRange+0.5)*hBins;
    
    figure(1);
    clf;
    
    imagesc(xymapSM);
    axis equal;
    colormap jet;
    vis_2d(pose2dxy',3,'-');
    xlim([1 xBins]);
    ylim([1 xBins]);
    ax = gca;
    ax.YDir = 'reverse';
    imgNameXY = sprintf('heatmapxy%04d',i);
    imgNameXH = sprintf('heatmapxh%04d',i);
    imgNameYH = sprintf('heatmapyh%04d',i);
    skName = sprintf('pose%04d',i);
    
    print(['~/databag/mpii_human_pose/' imgNameXY],'-dpng');
    figure(2);
    clf;
    vis_3d(cPoseAlign');
    view([0 0]);
    axis equal;
    print(['~/databag/mpii_human_pose/' skName],'-dpng');
    figure(3);
    clf;
    imagesc(hmapxSM');
    axis equal;
    colormap jet;
    vis_2d([pose2dxy(1,:);pose2dh]',3,'-');
    xlim([1 xBins]);
    ylim([1 hBins]);
    print(['~/databag/mpii_human_pose/' imgNameXH],'-dpng');
    figure(4);
    
    imagesc(hmapySM');
    axis equal;
    colormap jet;
    vis_2d([pose2dxy(2,:);pose2dh]',3,'-');
    xlim([1 xBins]);
    ylim([1 hBins]);
    print(['~/databag/mpii_human_pose/' imgNameYH],'-dpng');
    
    %         kPose = h36m_K_pose{i};
    %         kTorso= kPose(mpi2torso,:);
    %         [Rc,Tc] = bodyAlign(kTorso,TorsoFrame);
    
end


%HeatMapGenerator(cCamAlign',cErr,xyRange,hRange,xBins,hBins)
function [xymap,hmapv,hmaph] = HeatMapGenerator(cams,scores,xyRange,hRange,xBins,hBins)

xymap = zeros(xBins,xBins);
hmapv = zeros(xBins,hBins);
hmaph = zeros(xBins,hBins);
[nCam,~] = size(cams);

for i=1:nCam
    idx = (cams(i,1:2)/xyRange+0.5)*xBins;
    idx = int32(idx);
    
    if(scores(i)>0.03)
        continue;
    end
    
    
    if(max(idx)>xBins||min(idx)<1)
        continue;
    end
    xymap(idx(1),idx(2)) = (xymap(idx(1),idx(2))+0.02/scores(i))/2;
    hidx = (cams(i,3)/hRange+0.5)*hBins;
    hidx = int32(hidx);
    if(hidx>hBins||hidx<1)
        continue;
    end
    
    hmaph(idx(1),hidx) = (hmaph(idx(1),hidx)+0.02/scores(i))/2;
    hmapv(idx(2),hidx) = (hmapv(idx(2),hidx)+0.02/scores(i))/2;
end





end


function [invR,invT] = invRT(R,T)
invR = R';
invT = -invR*T;
end
