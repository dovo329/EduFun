convert mtnHouseSource.png -transparent 'rgb(128,0,0)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape1.png

convert mtnHouseSource.png -transparent 'rgb(255,0,0)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape2.png

convert mtnHouseSource.png -transparent 'rgb(0,128,0)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape3.png

convert mtnHouseSource.png -transparent 'rgb(0,255,0)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape4.png

convert mtnHouseSource.png -transparent 'rgb(0,0,128)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape5.png

convert mtnHouseSource.png -transparent 'rgb(0,0,255)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape6.png

convert mtnHouseSource.png -transparent 'rgb(128,128,0)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape7.png

convert mtnHouseSource.png -transparent 'rgb(255,255,0)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape8.png

convert mtnHouseSource.png -transparent 'rgb(0,128,128)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape9.png

convert mtnHouseSource.png -transparent 'rgb(0,255,255)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape10.png

convert mtnHouseSource.png -transparent 'rgb(128,0,128)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape11.png

convert mtnHouseSource.png -transparent 'rgb(255,0,255)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape12.png

convert mtnHouseSource.png -transparent 'rgb(128,64,0)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape13.png

convert mtnHouseSource.png -transparent 'rgb(255,128,0)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape14.png

convert mtnHouseSource.png -transparent 'rgb(64,128,0)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape15.png

convert mtnHouseSource.png -transparent 'rgb(128,255,0)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape16.png

convert mtnHouseSource.png -transparent 'rgb(128,0,64)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape17.png

convert mtnHouseSource.png -transparent 'rgb(255,0,128)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape18.png

convert mtnHouseSource.png -transparent 'rgb(64,0,128)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape19.png

convert mtnHouseSource.png -transparent 'rgb(128,0,255)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape20.png

convert mtnHouseSource.png -transparent 'rgb(0,128,64)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape21.png

convert mtnHouseSource.png -transparent 'rgb(0,255,128)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape22.png

convert mtnHouseSource.png -transparent 'rgb(0,64,128)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape23.png

convert mtnHouseSource.png -transparent 'rgb(0,128,255)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape24.png

convert mtnHouseSource.png -transparent 'rgb(0,0,0)' matteInput.png
convert mtnHouseSource.png -matte matteInput.png -compose DstOut -composite mtnShape25.png

rm matteInput.png
