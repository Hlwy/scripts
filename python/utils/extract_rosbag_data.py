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

depth_cam_info = CameraInfo()
ir_cam_info = CameraInfo()
ir2_cam_info = CameraInfo()
rgb_cam_info = CameraInfo()
for topic, msg, t in bag.read_messages(topics=['/realsense/camera/depth/camera_info']):
    depth_cam_info = msg
    break
# print depth_cam_info
idx = 0
for topic, msg, t in bag.read_messages(topics=['/gazebo/model_states']):
    for i, name in enumerate(msg.name):
        if(name == 'ugv1'):
            print(name, i)
            idx = i
    break

# ========================================================
sub_topics = [
    '/realsense/camera/depth/camera_info',
    '/realsense/camera/color/camera_info',
    '/realsense/camera/ir/camera_info',
    '/realsense/camera/ir2/camera_info',
    '/odom',
    '/realsense/camera/depth/image_raw',
    '/realsense/camera/ir/image_raw',
    '/realsense/camera/ir2/image_raw',
    '/realsense/camera/color/image_raw',
    '/gazebo/model_states'
]

# ========================================================
for topic, msg, t in bag.read_messages(topics=['/gazebo/model_states']):
    orien = msg.pose[i].orientation
    pose = msg.pose[i].position
    quat = (orien.x, orien.y, orien.z, orien.w)
    euler = euler_from_quaternion(quat)
    roll = euler[0]
    pitch = euler[1]
    yaw = euler[2]
    info = [pose.x,pose.y,pose.z,roll, pitch,yaw]
    print(t,info)
