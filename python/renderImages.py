import scipy.io as sio
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np
import cv2
prefix = '/home/xiul/databag/mpii_human_pose/'
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
    tMat = sio.loadmat(prefix+'MPI_anno.mat')
    MPI_anno = tMat['MPI_anno']
    nAnno = (MPI_anno.shape)[1]
    for idx in range(0,nAnno):        
        imgPath = prefix+'images/'+MPI_anno['image'][0,idx][0]
        pts = parseMatAnno(MPI_anno['points'][0,idx])
        img = cv2.imread(imgPath)
        draw2DPose(img,pts)
        cv2.imshow('img',img)
        cv2.waitKey(-1)


if __name__ == '__main__':
    main()


