import scipy.io as sio
from yattag import Doc
import numpy as np
import os
outprefix = '/media/posefs1web/Users/xiu/poseLabel_data/'
prefix = '/home/xiul/databag/mpii_human_pose/'

def main():    
    tMat = sio.loadmat(prefix+'MPI_AnnoRep.mat')    
    MPI_anno = tMat['MPI_anno']
    tMat = sio.loadmat(prefix+'MPI_3DAnnoerr.mat')
    MPI_normerr = tMat['normerr'][:,0]    
    numRecord = 2000
    sortId = np.argsort(MPI_normerr)    
    MPI_normerr.sort()

    htmldoc, htmltag, htmltext = Doc().tagtext()
    numCol = 2
    numRow = numRecord//numCol
    htmldoc.asis('<!DOCTYPE html>')    
    with htmltag('html'):
        with htmltag('head'):
            with htmltag('style'):
                htmldoc.asis('table,th,td{')
                htmldoc.asis('border: 1px solid black;')                
                htmldoc.asis('align: center;')                
                htmldoc.asis('}')                

        with htmltag('body'):
            with htmltag('h2'):
                htmltext('PnP Pose visualization')            
            with htmltag('table'):
                for row in range(numRow):                                            
                    with htmltag('tr'):                        
                        for col in range(numCol):
                            idx = row*numCol+col
                            cerr = MPI_normerr[idx]                      
                            imgName = MPI_anno['image'][0,sortId[idx]][0]
                            with htmltag('td',colspan='2'):
                                htmltext('img:{} :  err {:.5f}'.format(imgName,cerr))
                    with htmltag('tr'):
                        for col in range(numCol):
                            with htmltag('td'):
                                htmltext('ground truth(MPI annotation)')
                            with htmltag('td'):                                
                                htmltext('prediction  (h3.6m alignment)')           
                    with htmltag('tr'):
                        for col in range(numCol):
                            idx = row*numCol+col                                  
                            imgName = MPI_anno['image'][0,sortId[idx]][0]
                            with htmltag('td',colspan='2'):
                                htmldoc.stag('img', src='anno_images/'+imgName,width='640')                    

    htmlFile = open(outprefix+'posePNP.html','w')                           
    htmlFile.write(htmldoc.getvalue())
    htmlFile.close()    

if __name__ == '__main__':
    main()






