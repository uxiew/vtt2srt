import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:args/args.dart';

//import 'package:path/path.dart' as p;

/**
   // 让用户命令行输入路径|可能出错~
   // 命令行：目录输入使用双引号！！！！
**/

var matchedReg = new RegExp(r'\.(web_vtt|vtt)$');

void main(List<String> arguments){
  final ArgParser argParser = new ArgParser()
  ..addOption('dir', abbr: 'D', defaultsTo: '.');

  ArgResults argResults = argParser.parse(arguments);
  final String dir = argResults['dir'];
  walktree (dir, vttToSrt);
}


// 读取文件内容
 readVttFile(filePath) {
   var data =  new File(filePath).readAsStringSync()
	// 修改文件内容中的一些错误编码字符等~
	.replaceAll("&gt;&gt;",">>");

	// print(data);

   // 跳转到实际规则操作函数
   toSrtRule(filePath, data);
}

Future walktree(String mainPath, callback) async{
    // 是否为vtt文件？
    try{
        var type = await FileSystemEntity.type(mainPath) ;
        switch(type.toString()){
            case "directory":
                //'walktree'();
                new Directory(mainPath).list(recursive: true, followLinks: false)
                .listen((FileSystemEntity entity) {
                   if (entity.path.contains(matchedReg)) {
                    FileSystemEntity.isFile(entity.path).then((res){
                        if(res){
                          callback(entity.path);
                        }
                    });
                   }

                });
                break;
            case "file":
                callback(mainPath);
                break;
            default:
                print('\n Input Path Not Found！！！check path again!');
                break;
        }
    }
    catch (e){

    }
}

// 保存文件
save(filePath, strContent){
        var file = new File(filePath.replaceAll(matchedReg,".srt"));
        file.writeAsString(strContent)
        .then((File file) {
           print('file saved as ： $file');
        });
}


vttToSrt(String filePath) {
   readVttFile(filePath);
}


/// Rules of transformation [rules]
toSrtRule(String filePath, String data) {
  int id = 0;
  var ss = data
      .replaceAllMapped(
        RegExp(r'(\d+):(\d+)\.(\d+)\s*--?>\s*(\d+):(\d+)\.(\d+)'),
        (match) => '00:${match[1]}:${match[2]},${match[3]} --> 00:${match[4]}:${match[5]},${match[6]}',
      )
      .replaceAllMapped(
        RegExp(r'(\d+):(\d+):(\d+)(?:\.(\d+))?\s*--?>\s*(\d+):(\d+):(\d+)(?:\.(\d+))?'),
        (match) =>
            '${match[1]}:${match[2]}:${match[3]},${match[4]} --> ${match[5]}:${match[6]}:${match[7]},${match[8]}',
      )
      .replaceAllMapped(
        RegExp(r'(\d+)?([\n|\r]+)(\d+):(\d+)'),
        (match) => match[1] == null ? '${match[2]}${++id}\n${match[3]}:${match[4]}' : '${match[0]}',
      )
      .replaceAll(RegExp('WEBVTT[\n|\r]+'), '');

  save(filePath, ss);
}


//
toVttRule(){

}
