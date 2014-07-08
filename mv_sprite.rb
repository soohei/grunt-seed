########################################################################
# @2x がついた画像ファイルを _2x にrenameして、_2x付きのディレクトリへ移動する
########################################################################

# ディレクトリを再帰的に抽出する
require 'pp'
require 'FileUtils'

root = File.expand_path(File.dirname(__FILE__))
root = ARGV[0] if ARGV[0]

# フォルダの一覧を取得
dir_entries = Dir.glob(root + "/" + "**/*")
# pp dir_entries

for filePath in dir_entries do
  # pp file
  ext = File::extname(filePath) # 拡張子取得

  # 画像のみに処理
  if( ext == '.jpg' || ext == '.png' || ext == '.gif' )
    dir = File::dirname(filePath) # ディレクトリ
    base = File::basename(filePath,ext) # 拡張子除去
    twox_index = base.index('@2x')

    # @2xを含む
    if( twox_index && twox_index >= 0 )
      p "#{dir}/#{base}#{ext}"
      parent_dir = File::dirname(dir) # e.g. path_to_htdocs/common/img
      my_dir = File::basename(dir) # e.g. sprite
      twox_my_dir = "#{my_dir}_2x" # e.g. sprite_2x
      twox_dir =  "#{parent_dir}/#{twox_my_dir}" # e.g. path_to_htdocs/common/img/sprite_2x
      twox_base_ext = "#{base.sub('@2x', '_2x')}#{ext}" # e.g. hoge_2x.png

      # ディレクトリがなければ作る
      FileUtils.mkdir_p(twox_dir) unless FileTest.exist?(twox_dir)

      # ファイルを移動する
      File.rename filePath, "#{twox_dir}/#{twox_base_ext}"

      p "#{twox_dir}/#{twox_base_ext}"
      p '--'
    end

  end

end