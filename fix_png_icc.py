from PIL import Image

input_path = 'resources/icon.png'
output_path = 'resources/icon_fixed.png'

img = Image.open(input_path)
if "icc_profile" in img.info:
    del img.info['icc_profile']
img.save(output_path, format='PNG')