#convert all black colors to white
#convert TestColorShape.png -fill 'rgb(255,255,255)' -opaque 'rgb(0,0,0)' out.png
#convert white to clear
#convert out.png -fill clear -opaque white out2.png

#convert TestColorShape.png -matte +clone -transparent black -compose DstOut -composite output.png


convert TestColorShape.png -transparent 'rgb(255,0,0)' matteInput.png
convert TestColorShape.png -matte matteInput.png -compose DstOut -composite redOnly.png

convert TestColorShape.png -transparent 'rgb(0,0,255)' matteInput.png
convert TestColorShape.png -matte matteInput.png -compose DstOut -composite blueOnly.png

convert TestColorShape.png -transparent 'rgb(255,255,255)' matteInput.png
convert TestColorShape.png -matte matteInput.png -compose DstOut -composite whiteOnly.png

convert TestColorShape.png -transparent 'rgb(0,0,0)' matteInput.png
convert TestColorShape.png -matte matteInput.png -compose DstOut -composite blackOnly.png

#convert TestColorShape.png -transparent 'rgb(255,0,0)' alpha.png
#convert TestColorShape.png -matte alpha.png -compose DstOut -composite output.png

#convert input.png -transparent 'rgb(255,0,0)' matteInput.png
#convert input.png -matte matteInput.png -compose DstOut -composite output.png

