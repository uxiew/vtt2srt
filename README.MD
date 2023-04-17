# vtt to srt

Convert WebVTT (The Web Video Text Tracks Format, aka html5 video subtitles) into (SubRip file).srt file.，vice versa.【WIP】

遵循了(SubRip file).srt标准转换
只是为了好玩~

# Usage
```
dart vtt2srt.dart -D "path"
```

`"path"`(cuz whitespace problem, preferably double quotes) not provided，srt files are generated in the original directory.
`path` 使用双引号，然后转换该目录及其子文件夹下所有`vtt`文件。默认转换当前目录下文件。

# Update

support [FrontendMasters/fm-transcripts](https://github.com/FrontendMasters/fm-transcripts/)  `.web_vtt` files bug fixed，ie：
```
&gt;&gt; // ==>  >>
```

# TODO
- [] ASS


# Reference
[smplayer's convert](https://chromecast.smplayer.info/convert-srt-to-vtt/)

https://github.com/asticode/go-astisub

https://github.com/jamiees2/ass-to-vtt
