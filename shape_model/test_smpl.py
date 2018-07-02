'''
Copyright 2015 Matthew Loper, Naureen Mahmood and the Max Planck Gesellschaft.  All rights reserved.
This software is provided for research purposes only.
By using this software you agree to the terms of the SMPL Model license here http://smpl.is.tue.mpg.de/license

More information about SMPL is available here http://smpl.is.tue.mpg.
For comments or questions, please email us at: smpl@tuebingen.mpg.de


Please Note:
============
This is a demo version of the script for driving the SMPL model with python.
We would be happy to receive comments, help and suggestions on improving this code 
and in making it available on more platforms. 


System Requirements:
====================
Operating system: OSX, Linux

Python Dependencies:
- Numpy & Scipy  [http://www.scipy.org/scipylib/download.html]
- Chumpy [https://github.com/mattloper/chumpy]
- OpenCV [http://opencv.org/downloads.html] 
  --> (alternatively: matplotlib [http://matplotlib.org/downloads.html])


About the Script:
=================
This script demonstrates loading the smpl model and rendering it using OpenDR 
to render and OpenCV to display (or alternatively matplotlib can also be used
for display, as shown in commented code below). 

This code shows how to:
  - Load the SMPL model
  - Edit pose & shape parameters of the model to create a new body in a new pose
  - Create an OpenDR scene (with a basic renderer, camera & light)
  - Render the scene using OpenCV / matplotlib


Running the Hello World code:
=============================
Inside Terminal, navigate to the smpl/webuser/hello_world directory. You can run 
the hello world script now by typing the following:
>	python render_smpl.py


'''

import numpy as np
import scipy.io as sio
from opendr.renderer import ColoredRenderer
from opendr.lighting import LambertianPointLight
from opendr.camera import ProjectPoints
from smpl_webuser.serialization import load_model
from smpl_webuser.lbs import global_rigid_transformation
from smpl_webuser.verts import verts_decorated

from matplotlib.widgets import Slider, Button, RadioButtons
import matplotlib.pyplot as plt
## Load SMPL model (here we load the female model)


# 1 (head)  added
# 2 (neck)  -
# 3 (right shoulder)  17
# 4 (right elbow) 19
# 5 (right wrist) 21
# 6 (left shoulder) 16
# 7 (left elbow)  18
# 8 (left wrist)  20
# 9 (right hip) 2
# 10 (right knee) 5
# 11 (right ankle)  8
# 12 (left hip) 1
# 13 (left knee)  4
# 14 (left ankle) 7



  #load SMPL model
m = load_model('/home/xiul/workspace/SMPL_python/smpl/models/basicModel_f_lbs_10_207_0_v1.0.0.pkl')  
print(m.pose.size)
m.pose[:] = np.random.rand(m.pose.size) * np.pi/2
m.betas[:] = 0  
m.pose[0] = np.pi
rn = ColoredRenderer()
w, h = (640, 480)
rn.camera = ProjectPoints(v=m, rt=np.zeros(3), t=np.array([0, 0, 2.]), f=np.array([w,w])/2., c=np.array([w,h])/2., k=np.zeros(5))
rn.frustum = {'near': 1., 'far': 10., 'width': w, 'height': h}
rn.set(v=m, f=m.f, bgcolor=np.zeros(3))
rn.vc = LambertianPointLight(
      f=m.f,
     v=rn.v,
     num_verts=len(m),
     light_pos=np.array([-1000,-1000,-2000]),
      vc=np.ones_like(m)*.9,
     light_color=np.array([1., 1., 1.]))
plt.imshow(rn.r)   
plt.show()