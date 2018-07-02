function pts2d = decodeMPI(mpiRecord)
%MPI2D2H36M Summary of this function goes here
%   Detailed explanation goes here
mpi2h36m = [10 9 13 12 11 14 15 16 3 2 1 4 5 6]';
pts = [mpiRecord.points.x;mpiRecord.points.y];
ptsid = [mpiRecord.points.id]+1;
pts2d = zeros(size(pts));
pts2d(:,ptsid) = pts;
pts2d = pts2d(mpi2h36m,:);
end

