# Created by: Hunter Young
# Date: 10/5/17
#
# Script Description:
# 	Script is designed to take various commandline arguments making a very simple
# 	and user-friendly method to take any video file of interest as input and extract
# 	all the possible images available into a seperate folder, in addition to outputting
# 	a .csv file logging any additional useful information that is associated with each image.
#
# Current Recommended Usage: (in terminal)
# 	python parse_video.py -p /path/to/videos/home/directory -v name_of_video.mp4 -o name_of_output_data_file


import cv2
import rosbag
import numpy as np
import os, csv, time, argparse

from nav_msgs.msg import Odometry
from geometry_msgs.msg import Twist
from gazebo_msgs.msg import ModelStates
from sensor_msgs.msg import Image, CameraInfo
from cv_bridge import CvBridge, CvBridgeError
from tf.transformations import euler_from_quaternion, quaternion_from_euler

# Setup commandline argument(s) structures
ap = argparse.ArgumentParser(description='Extract images from a video file.')
ap.add_argument("--bagfile", "-b", type=str, metavar='FILE', help="Path to rosbag")
ap.add_argument("--stream", "-s", type=str, metavar='NAME', default="/realsense/camera/depth/image_raw", help="Name of the video stream topic to extract")
ap.add_argument("--prefix", "-p", type=str, metavar='NAME', default="depth_frame", help="Name of the video stream topic to extract")
ap.add_argument("--output", "-o", type=str, metavar='NAME', default='extracted_video_topic.avi', help="Name of output file containing the extracted video")
ap.add_argument("--dir", "-d", type=str, metavar='NAME', default='extracted/depth', help="Name of output file containing the extracted video")
# Store parsed arguments into array of variables
args = vars(ap.parse_args())

# Extract stored arguments array into individual variables for later usage in script
bag = args["bagfile"]
vid_topic = args["stream"]
output = args["output"]
prefix = args["prefix"]
dirs = args["dir"]

# Create the directories used to store the extracted data, if they haven't already been made
if(not os.path.exists(dirs)): os.mkdir(dirs)
else: print("[INFO] Directory [%s] already exists" % (dirs))

# ========================================================
#				    Read in ROSBAG topic data
# ========================================================
bridge = CvBridge()
bag = rosbag.Bag('/home/hunter/data/rosbags/2019-02-27-16-00-27.bag')

# types = []
# topics = bag.get_type_and_topic_info()[1].keys()
# for i in range(0,len(bag.get_type_and_topic_info()[1].values())):
# 	types.append(bag.get_type_and_topic_info()[1].values()[i][0])

ts = []
imgs = []
for topic, msg, t in bag.read_messages(topics=[vid_topic]):
	t = msg.header.stamp.to_sec()
	tmpImg = bridge.imgmsg_to_cv2(msg)
	ts.append(t)
	imgs.append(tmpImg)

bag.close()

dt_avg = 0
count = 0
for i in range(1,len(ts)):
    dt = ts[i] - ts[i-1]
    dt_avg+=dt
    count+=1
dt_avg = dt_avg / float(count)

# ========================================================
#				    Save Images to file
# ========================================================
for i, img in enumerate(imgs):
	# cv2.cvtColor(img,cv2.COLOR_GRAY2BGR)
	name = dirs + "/" + prefix + "_" + str(i) + ".png"
	cv2.imwrite(name, img)

# ========================================================
#				    Save Video to file
# ========================================================
if(False):
	fps = np.ceil(1.0 / dt_avg)
	fourcc_string = "MJPG"
	(h, w) = imgs[0].shape[:2]

	fourcc = cv2.VideoWriter_fourcc(*fourcc_string)
	writer = cv2.VideoWriter(output, fourcc, fps, (w,h))

	for img in imgs:
		img = cv2.cvtColor(img,cv2.COLOR_GRAY2BGR)
		writer.write(img)


	writer.release()
