import scipy.io as sio
from yattag import Doc
import numpy as np
import os
outprefix = '/media/posefs1web/Users/xiu/poseLabel_data/'
def main():    
    numRecord = 1000
    numCol = 2
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
                htmltext('MPI to h36m observation distribution')            
            with htmltag('table'):
                for row in range(numRow):   
                    with htmltag('tr'):
                        for col in range(numCol):
                            idx = row*numCol+col                                  
                            with htmltag('td'):
                                htmltext('K pose id:{}'.format(idx))  
                            with htmltag('td'):
                                htmltext('view Heatmap XY')
                            with htmltag('td'):
                                htmltext('view Heatmap XZ')
                            with htmltag('td'):
                            	htmltext('view Heatmap YZ')                                                        
                    with htmltag('tr'):
                        for col in range(numCol):
                            idx = row*numCol+col
                            heatmapXY = 'heatmapxy{:04d}.png'.format(idx+1)
                            heatmapXZ = 'heatmapxh{:04d}.png'.format(idx+1)
                            heatmapYZ = 'heatmapyh{:04d}.png'.format(idx+1)
                            poseName = 'pose{:04d}.png'.format(idx+1)
                            with htmltag('td'):
                                htmldoc.stag('img', src='heatmap/'+poseName,width='300')
                            with htmltag('td'):
                                htmldoc.stag('img', src='heatmap/'+heatmapXY,width='300')
                            with htmltag('td'):
                            	htmldoc.stag('img', src='heatmap/'+heatmapXZ,width='300')
                            with htmltag('td'):
                            	htmldoc.stag('img', src='heatmap/'+heatmapYZ,width='300')    
                   

    htmlFile = open(outprefix+'viewHeatmap.html','w')                           
    htmlFile.write(htmldoc.getvalue())
    htmlFile.close()    

if __name__ == '__main__':
    main()






