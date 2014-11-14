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
    # ディレクトリ
    dir = File::dirname(filePath) # ディレクトリ
    my_dir = File::basename(dir) # e.g. sprite
    parent_dir = File::dirname(dir) # e.g. path_to_htdocs/common/images
    parent_parent_dir = File::dirname(parent_dir) # e.g. path_to_htdocs/common
    base = File::basename(filePath,ext) # 拡張子除去 e.g. hoge

    twox_index = base.index('@2x')

    # @2xの処理
    if( twox_index && twox_index >= 0 )
      twox_my_dir = "#{my_dir}_2x" # e.g. sprite_2x
      twox_dir =  "#{parent_parent_dir}/sprites/#{twox_my_dir}" # e.g. path_to_htdocs/common/sprites/sprite_2x
      twox_base_ext = "#{base.sub('@2x', '_2x')}#{ext}" # e.g. hoge_2x.png

      # ファイルを移動する
      p "#{twox_dir}/#{twox_base_ext}"
      FileUtils.mkdir_p(twox_dir) unless FileTest.exist?(twox_dir) # ディレクトリがなければ作る
      File.rename filePath, "#{twox_dir}/#{twox_base_ext}"

    else
      # @1xの処理
      onex_dir = "#{parent_parent_dir}/sprites/#{my_dir}" # e.g. path_to_htdocs/common/sprites/sprite
      onex_base_ext = "#{base}#{ext}" # e.g. hoge.png

      # ファイルを移動する
      p '--'
      p "#{onex_dir}/#{onex_base_ext}"
      FileUtils.mkdir_p(onex_dir) unless FileTest.exist?(onex_dir) # ディレクトリがなければ作る
      File.rename filePath, "#{onex_dir}/#{onex_base_ext}"
    end

  end

end