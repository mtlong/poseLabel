%H36m
% 1 (head)       4
% 2 (neck)       3
% 3 (right shoulder)    13
% 4 (right elbow)       12
% 5 (right wrist)       11
% 6 (left shoulder)     14
% 7 (left elbow)        15
% 8 (left wrist)        16
% 9 (right hip)         7
% 10 (right knee)       6
% 11 (right ankle)      5
% 12 (left hip)         8
% 13 (left knee)        9
% 14 (left ankle)       10

%MPI
%1 - pelvis,    
%2 - thorax, 
%3 - upper neck, 
%4 - head top, 
%5-  r ankle, 
%6-  r knee, 
%7 - r hip, 
%8 - l hip, 
%9 - l knee, 
%10 - l ankle, 
%11 - r wrist, 
%12 - r elbow, 
%13 - r shoulder, 
%14 - l shoulder, 
%15 - l elbow, 
%16 - l wrist

%% Loading MPII dataset with valid human pose annotations.



load('~/databag/mpii_human_pose/mpii_human_pose.mat');
annolist = RELEASE.annolist;
annovalid = cellfun(@isempty,{annolist.frame_sec});
annolist = annolist(~annovalid);


%% convert format

MPI_anno = {};
idxCnt = 1;

F = length(annolist);
for i=1:F    
    [~,numRect] = size(annolist(i).annorect);    
    for j=1:numRect        
        if(~isfield(annolist(i).annorect(j),'annopoints')||isempty(annolist(i).annorect(j).annopoints))
            continue;
        end        
        cData = annolist(i).annorect(j).annopoints.point;                        
        if(length(cData)==16)
            MPI_anno(idxCnt).image = annolist(i).image.name;   
            MPI_anno(idxCnt).points = cData;
            idxCnt = idxCnt+1;
        end                
    end
    t = i
end

