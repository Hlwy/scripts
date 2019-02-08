import cv2, time
import numpy as np
import matplotlib.pyplot as plt

flag_save = 0
count = 0

img = cv2.imread("test_disparity.png",cv2.IMREAD_GRAYSCALE)
h,w = img.shape
print(img.shape)

cv2.namedWindow('Disparity', cv2.WINDOW_NORMAL)
# cv2.imshow('Disparity', img)
cv2.imshow('Disparity', img)
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

# cv2.imshow('Disparity', umap)

plt.imshow(tmp); plt.show()
plt.imshow(tmpw); plt.show()
cv2.imwrite("test_umap_2.png",umap)
cv2.imwrite("test_vmap_2.png",vmap)
while True:
    if cv2.waitKey(1) == ord('q'):
        break
