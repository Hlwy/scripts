#!/usr/bin/env python
import cv2, time
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import NullFormatter
from matplotlib.transforms import Bbox
import pprint

pp = pprint.PrettyPrinter(indent=4)

flag_save = 0
count = 0

img = cv2.imread("test_disparity.png",cv2.IMREAD_GRAYSCALE)
h,w = img.shape
print(img.shape)

# cv2.namedWindow('Disparity', cv2.WINDOW_NORMAL)
# cv2.imshow('Disparity', img)

# cv2.line(histImage, ( bin_w*(i-1), hist_h - int(round(b_hist[i-1])) ),
#             ( bin_w*(i), hist_h - int(round(b_hist[i])) ),
#             ( 255, 0, 0), thickness=2)

# histImage = np.zeros((hist_h, hist_w, 3), dtype=np.uint8)

histRange = (0,256)
dmax = np.max(img)
histSz = dmax+1
print(dmax)

umap = np.zeros((histSz,w,1), dtype=np.uint8)
vmap = np.zeros((h,histSz,1), dtype=np.uint8)

for i in range(0,h):
    # scan = tImg[i,:]
    uscan = img[i,:]
    vscan = img[:,i]
    # print(uscan.shape)
    # print(vscan.shape)
    urow = cv2.calcHist([uscan],[0],None,[histSz],histRange)
    vrow = cv2.calcHist([vscan],[0],None,[histSz],histRange)
    # print(scan.ravel())
    # print(row)
    # print(
    # """
    #
    # ==========================
    #
    # """)
    umap[:,i] = urow
    vmap[i,:] = vrow

tmp = np.reshape(umap,(histSz,w))
tmpw = np.reshape(vmap,(h,histSz))

# print(umap.shape)
# print(tmp.shape)


new_dimg = np.zeros((h,w,1), dtype=np.uint8)
new_dimg2 = np.zeros((h,w,1), dtype=np.uint8)

# asa = cv2.calcBackProject([img],[0],umap[:,0],histRange,1)
for i in range(0,h):
    asa = cv2.calcBackProject([img[i,:]],[0],umap[:,i],histRange,1)
    new_dimg[i,:] = asa

for i in range(0,h):
    asa = cv2.calcBackProject([img[:,i]],[0],vmap[i,:],histRange,1)
    new_dimg2[:,i] = asa

    print(new_dimg2.shape)
# asa2 = cv2.calcBackProject([img],[0],vmap,histRange,1)


cv2.namedWindow('Disparity', cv2.WINDOW_NORMAL)
cv2.namedWindow('Vmap', cv2.WINDOW_NORMAL)
cv2.imshow('Disparity', new_dimg)
cv2.imshow('Vmap', new_dimg2)

while True:
    if cv2.waitKey(1) == ord('q'):
        break

fig, axs = plt.subplots(2, 2)
nullfmt = NullFormatter()

axs[0,0].imshow(img)
axs[0,1].imshow(tmpw)
axs[1,0].imshow(tmp)
axs[1,1].imshow(asa)
for ax in axs.flatten():
    ax.set_xticklabels('')
    ax.set_yticklabels('')
    ax.set_frame_on(0)
    ax.xaxis.set_major_formatter(nullfmt)
    ax.xaxis.set_ticks_position('none')
    ax.yaxis.set_major_formatter(nullfmt)
    ax.yaxis.set_ticks_position('none')
    # pp.pprint(ax.properties())
    # print(
    # """
    #
    # ==========
    #
    # """
    # )
fig.set_constrained_layout_pads(w_pad=0., h_pad=0., hspace=0., wspace=0.)

# print(axs[0,0].get_position(True))
# print(axs[0,1].get_position(True))
# print(axs[1,0].get_position(True))
# print(axs[1,1].get_position(True))

dx2 = abs(0.547727272727 - 0.9)
dy3 = abs(0.11 - 0.46)

bx2 = Bbox([[0.477272727273,0.53],[0.477272727273+dx2,0.88]])
axs[0,1].set_position(bx2, 'active')

# axs[1,0].imshow(tmp)

# 'position': Bbox([[0.125, 0.53], [0.477272727273, 0.88]]),
# 'window_extent': Bbox([[76.5, 250.9], [308.954545455, 425.9]]),

# 'position': Bbox([[0.547727272727, 0.53], [0.9, 0.88]]),
# 'window_extent': Bbox([[347.045454545, 250.9], [579.5, 425.9]]),
# 'window_extent': Bbox([[308.954545455, 250.9], [579.5, 425.9]]),

# 'position': Bbox([[0.125, 0.11], [0.477272727273, 0.46]]),
# 'window_extent': Bbox([[76.5, 49.3], [308.954545455, 224.3]]),

# 'position': Bbox([[0.547727272727, 0.11], [0.9, 0.46]]),
# 'window_extent': Bbox([[347.045454545, 49.3], [579.5, 224.3]]),


# fig.subplots_adjust(hspace=0)

# cv2.imshow('Disparity', umap)
# left, width = 0.1, 0.65
# bottom, height = 0.1, 0.65
# bottom_h = left_h = left + width + 0.02
#
# rectd = [left, bottom, width, height]
# rectv = [left, bottom_h, width, 0.2]
# rectu = [width+ 0.02, bottom, 0.2, height]
#
# nullfmt = NullFormatter()
# fig = plt.figure(1, figsize=(8, 8))
#
# axd = plt.axes(rectd,sharex=True,sharey=True)
# axv = plt.axes(rectv,sharex=True,sharey=True)
# axu = plt.axes(rectu,sharex=True,sharey=True)
# fig.add_axes(axd)
# fig.add_axes(axv)
# fig.add_axes(axu)
#
# axv.xaxis.set_major_formatter(nullfmt)
# axu.yaxis.set_major_formatter(nullfmt)

# fig, axs = plt.subplots(2,2,sharex=True,sharey=True)
# fig.subplots_adjust(hspace=0,wspace=0)

# axd.imshow(img)
# axu.imshow(tmpw)
# axv.imshow(tmp)

# axd.set_aspect('equal')
# axu.set_aspect('equal')
# axv.set_aspect('equal')

# axs[0,0].imshow(img)
# axs[0,1].imshow(tmpw)
# axs[1,0].imshow(tmp)


# plt.subplot(2,2,2)
# plt.subplot(2,2,3)
plt.show()
cv2.imwrite("test_umap_tmp.png",umap)
cv2.imwrite("test_vmap_tmp.png",vmap)

while True:
    if cv2.waitKey(1) == ord('q'):
        break
