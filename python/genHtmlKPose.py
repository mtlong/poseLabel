import scipy.io as sio
from yattag import Doc
import numpy as np
import os
outprefix = '/media/posefs1web/Users/xiu/poseLabel_data/'
def main():    
    numRecord = 1000
    numCol = 5
    numRow = numRecord//numCol
    htmldoc, htmltag, htmltext = Doc().tagtext()
    htmldoc.asis('<!DOCTYPE html>')    
    with htmltag('html'):
        with htmltag('head'):
            with htmltag('style'):
                htmldoc.asis('table,th,td{')
                htmldoc.asis('border: 1px solid black;')                
                htmldoc.asis('align: center;')                
                htmldoc.asis('}')                

        with htmltag('body'):
            with htmltag('h2',align='center'):
                htmltext('K-mean K pose Visualization :K=1000')            
            with htmltag('table'):
                for row in range(numRow):                                                     
                    with htmltag('tr'):
                        for col in range(numCol):
                            idx = row*numCol+col                                  
                            imgName = '{:04d}.jpg'.format(idx)
                            with htmltag('td',colspan='2'):
                                htmldoc.stag('img', src='K_pose_Adam/'+imgName,width='300')                    

    htmlFile = open(outprefix+'KPose.html','w')                           
    htmlFile.write(htmldoc.getvalue())
    htmlFile.close()    

if __name__ == '__main__':
    main()






