import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:args/args.dart';

//import 'package:path/path.dart' as p;

/**
   // 让用户命令行输入路径|可能出错~
   // 命令行：目录输入使用双引号！！！！

**/
ArgResults argResults;


var matchedReg = new RegExp(r'\.(web_vtt|vtt)$');

void main(List<String> arguments){
   
       final ArgParser argParser = new ArgParser()
       ..addOption('dir', abbr: 'D', defaultsTo: '.');

      argResults = argParser.parse(arguments);
      final String dir = argResults['dir'];

  //String dir = r'C:\Users\ChandlerVer5\Desktop\Projectox!\xxx.vtt';
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
           print('文件另存为： $file');
        });
}


vttToSrt(String filePath) {

   readVttFile(filePath);
  
}


/// 转换规则 [rules]

String toSrtRule(filePath, data){
        int id = 0;
        var ss = data.replaceAllMapped(
                    new RegExp(r'(\d+):(\d+)\.(\d+)\s*--?>\s*(\d+):(\d+)\.(\d+)'), (Match m) => '${'00:'+m[1]+':'+m[2]+','+m[3]+' --> ' + '00:'+m[4]+':'+m[5]+','+m[6]}'
                )
                .replaceAllMapped(
                    new RegExp(r'(\d+):(\d+):(\d+)(?:.(\d+))?\s*--?>\s*(\d+):(\d+):(\d+)(?:.(\d+))?', caseSensitive: false),
                (Match m) => m[1]+":"+m[2]+":"+m[3]+","+m[4]+" --> "
                            +m[5]+":"+m[6]+":"+m[7]+","+m[8]
                            )
                 //srt 标准时间前一行需要id数字，所以根据判断，vtt文件没有的话就加上~
                .replaceAllMapped(new RegExp(r'(\d+)?([\n|\r]+)(\d+):(\d+)'),(Match m){
                    return m[1] == null ? '${ m[2] +(++id).toString() +'\n'+m[3]+':'+m[4]}' :'${m[0]}';
                })
                .replaceAll(new RegExp('WEBVTT[\n|\r]+'), '');
                
                
        save (filePath, ss);
}

//
toVttRule(){

}

       


	