#convert all black colors to white
#convert TestColorCatShape.png -fill 'rgb(255,255,255)' -opaque 'rgb(0,0,0)' out.png
#convert white to clear
#convert out.png -fill clear -opaque white out2.png

convert ColoringBookPictureScanBW.png -threshold 50% BWonly.png
