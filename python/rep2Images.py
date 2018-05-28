import scipy.io as sio
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np
import cv2
import os
import sys
import shutil
prefix = '/home/xiul/databag/mpii_human_pose/'
outprefix = '/media/posefs1web/Users/xiu/poseLabel_data/'
mpi2h36m = [9,8,12,11,10,13,14,15,2,1,0,3,4,5]

def parseMatAnno(anno):
    ptsX = anno['x']
    ptsY = anno['y']
    ptsID = anno['id']
    
    mpipts = np.zeros((16,2))        
    for id in range(16):        
        mpipts[ptsID[0,id][0,0],0] = ptsX[0,id][0,0]
        mpipts[ptsID[0,id][0,0],1] = ptsY[0,id][0,0]
    h36mpts = np.zeros((14,2))
    for id in range(14):
        h36mpts[id] = mpipts[mpi2h36m[id]]
    return h36mpts    

def draw2DPose(img,ptsF):
    pts = ptsF.astype(int)
    linWidth = 3
    cv2.line(img,tuple(pts[0]),tuple(pts[1]),(255,0,0),linWidth)
    cv2.line(img,tuple(pts[1]),tuple(pts[2]),(255,0,0),linWidth)
    cv2.line(img,tuple(pts[2]),tuple(pts[3]),(0,255,0),linWidth)
    cv2.line(img,tuple(pts[3]),tuple(pts[4]),(0,255,0),linWidth)
    cv2.line(img,tuple(pts[1]),tuple(pts[5]),(255,0,0),linWidth)
    cv2.line(img,tuple(pts[5]),tuple(pts[6]),(0,0,255),linWidth)
    cv2.line(img,tuple(pts[6]),tuple(pts[7]),(0,0,255),linWidth)
    cv2.line(img,tuple(pts[8]),tuple(pts[9]),(0,255,0),linWidth)
    cv2.line(img,tuple(pts[9]),tuple(pts[10]),(0,255,0),linWidth)
    cv2.line(img,tuple(pts[11]),tuple(pts[12]),(0,0,255),linWidth)
    cv2.line(img,tuple(pts[12]),tuple(pts[13]),(0,0,255),linWidth)
    cv2.line(img,tuple((pts[8]+pts[11])//2),tuple(pts[1]),(255,0,0),linWidth)
    cv2.line(img,tuple(pts[8]),tuple(pts[11]),(255,0,0),linWidth)
    
def main():
    tMat = sio.loadmat(prefix+'MPI_AnnoRep.mat')
    MPI_anno = tMat['MPI_anno']
    REP_anno = tMat['Rep2D_cell']
    annoNum = MPI_anno.shape[1]    
    outPath = outprefix+'anno_images/'    
    if os.path.isdir(outPath):
        shutil.rmtree(outPath)
    os.mkdir(outPath)        
    for idx in range(annoNum):
        imgName = MPI_anno['image'][0,idx][0]
        imgPath = prefix+'images/'+imgName
        pts2D = parseMatAnno(MPI_anno['points'][0,idx])
        ptsRep = REP_anno[idx,0]
        imgl = cv2.imread(imgPath)
        imgr = imgl.copy()
        draw2DPose(imgl,pts2D)
        draw2DPose(imgr,ptsRep[:,0:2])
        imgout = np.concatenate((imgl, imgr), axis=1)
        cv2.imwrite(outPath+imgName,imgout)
        print('Writing image {} path : {}'.format(idx,outPath+imgName))        
if __name__ == '__main__':
    main()


