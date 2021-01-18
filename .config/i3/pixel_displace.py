import random
from sys import argv
from PIL import Image

img = Image.open(argv[1])
pixels = img.load()

chosen_i = 0
chosen_j = 0

for i in range(img.size[0]):
    if random.choice([True,False,False]):
        chosen_i = i
    for j in range(img.size[1]):
        if random.choice([True,False,False]):
            chosen_j = j
        pixels[i,j] = pixels[chosen_i,chosen_j]

img.save(argv[1])
    
