import matplotlib.pyplot as plt
from csv import reader
from dateutil import parser
from matplotlib import animation
import math
import numpy as np


# file = '/home/hunter/devel/robo-dev/data/fusion/output/ekf_outputs.csv'
# file = '/home/hunter/devel/robo-dev/data/fusion/output/isam_outputs.csv'
# file = '/home/hunter/theHuntingGround/src/tricycle_pose_estimator/data/processed/trike_straight_generated_outputs.csv'
file = '/home/hunter/theHuntingGround/src/tricycle_pose_estimator/data/processed/trike_circle_generated_outputs.csv'

r2d = 360/(2*math.pi)

# with open(file, 'r') as fIn:
#     outputs = list(reader(fIn))
outputs = np.genfromtxt(file, delimiter=',')

# time = [i[0] for i in dataIn[1::]]
# y = [i[2] for i in dataIn[1::]]
# x = [i[1] for i in dataIn[1::]]
# yaw = [i[3] for i in dataIn[1::]]
# err = [i[4] for i in dataIn[1::]]

# x = [i[0] for i in outputs[1::]]
# y = [i[1] for i in outputs[1::]]
# yaw = [i[2] for i in outputs[1::]]

x = outputs[1:,0]
y = outputs[1:,1]
yaw = outputs[1:,3]

fig = plt.figure()
line = fig.add_subplot(2,1,1)
ang = fig.add_subplot(2,1,2)

def animate(i):
	global file
	outputs = np.genfromtxt(file, delimiter=',')

	# x = [i[0] for i in outputs[1::]]
	# y = [i[1] for i in outputs[1::]]
	# yaw = [i[2] for i in outputs[1::]]
	# refX = [i[3] for i in outputs[1::]]
	# refY = [-1*i[4] for i in outputs[1::]]
	# refYaw = [i[5] for i in outputs[1::]]
	# steps = range(len(yaw))

	x = outputs[1:,0]
	y = outputs[1:,1]
	yaw = outputs[1:,2]
	refX = outputs[1:,3]
	refY = -1 * outputs[1:,4]
	refYaw = outputs[1:,5]
	steps = range(yaw.shape[0])
	# print(yaw.shape)
	# x = [i[0] for i in dataIn[1::]]
	# y = [i[1] for i in dataIn[1::]]
	# yaw = [i[2] for i in dataIn[1::]]
	# yawp = map(float, yaw)
	# yawp = np.asarray(yawp) * r2d

	line.clear()
	line.plot(refY, refX,'g',y,x,'r')
	# line.plot(x, y,'r')
	line.set_title('EKF Position')
	line.set_xlabel('X (m)')
	line.set_ylabel('Y (m)')
	line.axis('equal')
	# line.set_ylim([-5, 5])
	# line.set_xlim([-4, 0])
	# line.autoscale()

	ang.clear()
	ang.plot(steps, refYaw,'g', steps, yaw,'r')
	ang.set_title('EKF Yaw')
	ang.set_xlabel('Steps')
	ang.set_ylabel('Yaw (rad)')
	# ang.axis('equal')
	ang.set_ylim([-np.pi, np.pi])
	ang.autoscale()

	return line, ang,

anim = animation.FuncAnimation(fig, animate, interval=25)
# anim = animation.FuncAnimation(fig2, animate, interval=25)

plt.show()
