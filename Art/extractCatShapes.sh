convert CatColored.png -transparent 'rgb(128,0,0)' matteInput.png
convert CatColored.png -matte matteInput.png -compose DstOut -composite catShape1.png

convert CatColored.png -transparent 'rgb(255,0,0)' matteInput.png
convert CatColored.png -matte matteInput.png -compose DstOut -composite catShape2.png

convert CatColored.png -transparent 'rgb(0,128,0)' matteInput.png
convert CatColored.png -matte matteInput.png -compose DstOut -composite catShape3.png

convert CatColored.png -transparent 'rgb(0,255,0)' matteInput.png
convert CatColored.png -matte matteInput.png -compose DstOut -composite catShape4.png

convert CatColored.png -transparent 'rgb(0,0,128)' matteInput.png
convert CatColored.png -matte matteInput.png -compose DstOut -composite catShape5.png

convert CatColored.png -transparent 'rgb(0,0,255)' matteInput.png
convert CatColored.png -matte matteInput.png -compose DstOut -composite catShape6.png

convert CatColored.png -transparent 'rgb(128,128,0)' matteInput.png
convert CatColored.png -matte matteInput.png -compose DstOut -composite catShape7.png

convert CatColored.png -transparent 'rgb(255,255,0)' matteInput.png
convert CatColored.png -matte matteInput.png -compose DstOut -composite catShape8.png

convert CatColored.png -transparent 'rgb(0,128,128)' matteInput.png
convert CatColored.png -matte matteInput.png -compose DstOut -composite catShape9.png

convert CatColored.png -transparent 'rgb(0,255,255)' matteInput.png
convert CatColored.png -matte matteInput.png -compose DstOut -composite catShape10.png

convert CatColored.png -transparent 'rgb(128,0,128)' matteInput.png
convert CatColored.png -matte matteInput.png -compose DstOut -composite catShape11.png
convert CatColored.png -transparent 'rgb(255,0,255)' matteInput.png
convert CatColored.png -matte matteInput.png -compose DstOut -composite catShape12.png

convert CatColored.png -transparent 'rgb(0,0,0)' matteInput.png
convert CatColored.png -matte matteInput.png -compose DstOut -composite catShape13.png
