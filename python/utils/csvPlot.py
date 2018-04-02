import matplotlib.pyplot as plt
from csv import reader
from dateutil import parser
from matplotlib import animation

with open('/home/hunter/devel/robo-dev/data/fusion/output/ekf_outputs.csv', 'r') as fIn:
    dataIn = list(reader(fIn))

time = [i[0] for i in dataIn[1::]]
x = [i[1] for i in dataIn[1::]]
y = [i[2] for i in dataIn[1::]]
yaw = [i[3] for i in dataIn[1::]]
err = [i[4] for i in dataIn[1::]]

fig = plt.figure()
line = fig.add_subplot(1,1,1)

plt.title('EKF Position')
plt.xlabel('X (m)')
plt.ylabel('Y (m)')
plt.axis('equal')
# plt.plot(x, y,'r')


def init():
    # ax.clear()
    # line.set_data([],[])
    return line,

def animate(i):
    with open('/home/hunter/devel/robo-dev/data/fusion/output/ekf_outputs.csv', 'r') as fIn:
        dataIn = list(reader(fIn))
    time = [i[0] for i in dataIn[1::]]
    x = [i[1] for i in dataIn[1::]]
    y = [i[2] for i in dataIn[1::]]
    yaw = [i[3] for i in dataIn[1::]]
    err = [i[4] for i in dataIn[1::]]

    line.clear()
    line.plot(x, y,'r')
    line.axis('equal')
    # line.autoscale()
    return line,

anim = animation.FuncAnimation(fig, animate, interval=25)

plt.show()
