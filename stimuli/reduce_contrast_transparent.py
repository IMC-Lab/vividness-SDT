### reduce contrast of images with a transparent background ###

# intall relevant packages
from __future__ import print_function
import os, sys, os.path
import numpy as np
from PIL import Image, ImageDraw, ImageFilter
from scipy import ndimage as ndi


# define directories
input_dir = 'stimuli/full_alpha/'
out_dir = 'stimuli/reduced_alpha/'

for infile in os.listdir(input_dir):
    if infile != '.DS_Store':
        with Image.open(input_dir + infile) as image:
            pixeldata = list(image.getdata())
            for i, pixel in enumerate(pixeldata):
                if pixel[3] != 0:
                    pixeldata[i] = list(pixeldata[i])
                    pixeldata[i][3] = 51
                    pixeldata[i] = tuple(pixeldata[i])                
            image.putdata(pixeldata)
            print(out_dir + infile[:(len(infile) - 4)] + '.png')
            image.save(out_dir + infile[:(len(infile) - 4)] + '.png')


