clean:
	rm -f videos/*

server:
	iex -S mix

stream:
	ffmpeg -y \
	-i tcp://localhost:5000 \
	-codec copy \
	-bsf h264_mp4toannexb \
	-map 0 \
	-f segment \
	-segment_time 5 \
	-segment_format mpegts \
	-segment_list "videos/playlist.m3u8" \
	-segment_list_size 0 \
	-segment_list_type m3u8 \
	"videos/file%d.ts"
