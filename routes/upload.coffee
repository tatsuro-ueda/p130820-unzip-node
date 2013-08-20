###
var fs = require('fs');
exports.post = function(req, res){
  // 一時ファイルのパス
  var tmp_path = req.files.thumbnail.path;
  // public以下に置くパス
  var target_path = './public/img/' + req.files.thumbnail.name;
  // public以下に移動
  fs.rename(tmp_path, target_path, function(err) {
    if (err) throw err;
    // 一時ファイルを削除
    fs.unlink(tmp_path, function() {
      if (err) throw err;
      res.send('File uploaded to: ' + target_path + ' - ' + req.files.thumbnail.size + ' bytes');
    });
  });
};

fs.createReadStream('path/to/archive.zip')
  .pipe(unzip.Parse())
  .on('entry', function (entry) {
    var fileName = entry.path;
    var type = entry.type; // 'Directory' or 'File'
    var size = entry.size;
    if (fileName === "this IS the file I'm looking for") {
      entry.pipe(fs.createWriteStream('output/path'));
    } else {
      entry.autodrain();
    }
  });

  fs.createReadStream('path/to/archive.zip').pipe(unzip.Extract({ path: 'output/path' }));
###

fs = require 'fs'
unzip = require 'unzip'
pattern = /(.?)\.zip/

exports.post = (req, res) ->
  tmp_path = req.files.thumbnail.path
  # ファイル名から.zipをとったものをフォルダ名にする
  directory_name = req.files.thumbnail.name.replace pattern, "$1"
  fs.mkdir './uploads/' + directory_name, ->
    fs.createReadStream(tmp_path)
    .pipe(
      unzip.Extract
        path: 'uploads/' + directory_name
    )
    # 一時ファイルを削除
    fs.unlink tmp_path, ->
      res.render 'upload',
        title: 'File uploaded and unziped'
        name : directory_name
        size : req.files.thumbnail.size