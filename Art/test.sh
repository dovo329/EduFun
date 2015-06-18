#convert all black colors to white
#convert TestColorCatShape.png -fill 'rgb(255,255,255)' -opaque 'rgb(0,0,0)' out.png
#convert white to clear
#convert out.png -fill clear -opaque white out2.png

convert Cat.png -transparent 'rgb(128,0,0)' matteInput.png
convert Cat.png -matte matteInput.png -compose DstOut -composite catShape1.png

convert Cat.png -transparent 'rgb(255,0,0)' matteInput.png
convert Cat.png -matte matteInput.png -compose DstOut -composite catShape2.png

convert Cat.png -transparent 'rgb(0,128,0)' matteInput.png
convert Cat.png -matte matteInput.png -compose DstOut -composite catShape3.png

convert Cat.png -transparent 'rgb(0,255,0)' matteInput.png
convert Cat.png -matte matteInput.png -compose DstOut -composite catShape4.png

convert Cat.png -transparent 'rgb(0,0,128)' matteInput.png
convert Cat.png -matte matteInput.png -compose DstOut -composite catShape5.png

convert Cat.png -transparent 'rgb(0,0,255)' matteInput.png
convert Cat.png -matte matteInput.png -compose DstOut -composite catShape6.png

convert Cat.png -transparent 'rgb(128,128,0)' matteInput.png
convert Cat.png -matte matteInput.png -compose DstOut -composite catShape7.png

convert Cat.png -transparent 'rgb(255,255,0)' matteInput.png
convert Cat.png -matte matteInput.png -compose DstOut -composite catShape8.png

convert Cat.png -transparent 'rgb(0,128,128)' matteInput.png
convert Cat.png -matte matteInput.png -compose DstOut -composite catShape9.png

convert Cat.png -transparent 'rgb(0,255,255)' matteInput.png
convert Cat.png -matte matteInput.png -compose DstOut -composite catShape10.png
