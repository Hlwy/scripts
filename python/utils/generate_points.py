# Created by: Hunter Young
# Date: 11/19/17
#
# Script Description:
# 	Script is designed to take various commandline arguments making a very simple
# 	and user-friendly method to generate an array of (X,Y) coordinates to be used
#   as the centers of corn stalks for loading into ROS Gazebo. (Optional: additionally
#   include a randomized yaw angle or pitch angle to simulate lodging and model irregularity).
#
# Current Recommended Usage: (in terminal)
# 	python generate_points.py -o name_of_output_data_file

import random
import numpy as np
import matplotlib.pyplot as plt
import math
import argparse

# ========================================================
#                 Supplementary Functions
# ========================================================


def generate_random_coordinate(radius):

    # Return container
    output = []

    # Range of the choose-able angles
    range_angle = (0, 360)

    # Generate a random radius and angle sample
    r = random.random()*radius
    theta = random.randrange(*range_angle)

    # Calculate X-Y coordinates from the randomized radius and angle
    x = r * math.cos(math.radians(theta))
    y = r * math.sin(math.radians(theta))

    # Store Variable for output
    output.append(x)
    output.append(y)

    return output


def generate_random_coordinates(radius, num_samples):

    # Storage containers
    xs = []
    ys = []

    # Counter Index
    i = 0

    while i < num_samples:

        # Generate a random X-Y coordinate
        center = generate_random_coordinate(radius)

        # Store the X-Y coordinates
        xs.append(center[0])
        ys.append(center[1])

        # Increase counting index
        i += 1

    samples = np.array([xs, ys])
    return samples

def generate_mean_centers(rows, cols, dRow, dCol, origin):

    # Define Constants
    origin_x = origin[0]
    origin_y = origin[1]
    index = 0
    num_elements = rows * cols

    # Storage containers
    centers = np.zeros((2,num_elements))


    # For each row determine each stalks information
    for row in range(0,rows):

        # For each stalk determine respective X-Y coordinates
        for stalk in range(0,cols):
            # Calculate and store stalk data for output
            centers[0, index] = origin_x + dRow * row
            centers[1, index] = origin_y + dCol * stalk

            # Update counter index
            index += 1

    # Output centers
    return centers

def randomize_mean_centers(centers, radius):

    # Define Constants
    numStalks = centers.shape[1]

    # For each stalk
    for stalk in range(0,numStalks):

        # Generate a randomized offset
        offset = generate_random_coordinate(radius)

        # Apply offset to current stalk's mean center coordinates
        centers[0,stalk] = centers[0,stalk] + offset[0]
        centers[1,stalk] = centers[1,stalk] + offset[1]

    return centers

def main():
    # Setup commandline argument(s) structures
    ap = argparse.ArgumentParser(description='Extract images from a video file.')
    ap.add_argument("--radius", "-r",           type=float, default='1', help="Radius of the bounding circle with which to pull random samples from")
    ap.add_argument("--rows", "-n",             type=int,   default='4', help="Number of rows of crops to simulate")
    ap.add_argument("--stalks", "-m",           type=int,   default='5', help="Number of stalks of crops within a row")
    ap.add_argument('--row-spacing', "-s",      type=float, default='1.5', help="Spacing between each row")
    ap.add_argument('--stalk-spacing', "-S",    type=float, default='2', help="Spacing between each stalk within a row")
    ap.add_argument('--origin', "-O", nargs='+',type=float, default=[0,0], help="Spacing between each stalk within a row")
    ap.add_argument("--output", "-o",           type=str,   default='randomized_stalk_centers', help="Name of output file containing randomized stalk centers")
    # Store parsed arguments into array of variables
    args = vars(ap.parse_args())

    # Extract stored arguments array into individual variables for later usage in script
    radius = args["radius"]
    numRows = args["rows"]
    numStalks = args["stalks"]
    dRow = args["row_spacing"]
    dStalk = args["stalk_spacing"]
    origin = args["origin"]
    outFile = args["output"]

    # Define Hard-coded variables
    num_samples = 100

    # centers = generate_random_coordinates(radius,num_samples)
    mean_centers = generate_mean_centers(numRows,numStalks,dRow,dStalk,origin)
    centers = randomize_mean_centers(mean_centers, radius)

    # Load Points into plot for visualization
    plt.plot(centers[0,:],centers[1,:],'ro')
    # Define dynamic axis limits for showing whole crop plot
    xLowerLimit = origin[0] - 1
    yLowerLimit = origin[1] - 1
    xUpperLimit = (numRows * dRow) + 1
    yUpperLimit = (numStalks * dStalk) + 1
    # Update plot axes
    plt.axis([xLowerLimit, xUpperLimit,yLowerLimit,yUpperLimit])
    # Show plot
    plt.show()




main()
