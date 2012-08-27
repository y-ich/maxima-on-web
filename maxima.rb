# -*- coding: utf-8 -*-
#
# Maximaインターフェイス
#
# Authors:: 市川雄二
# Version:: 0.1
# Copyright:: Copyright (C) 2011 ICHIKAWA, Yuji. All rights reserved.


# マルチクライアント対応Maximaクラスライブラリ
class Maxima
  BUFFER_SIZE = 1024
  MAXIMA_PATH = '/Applications/Maxima.app/Contents/Resources/maxima.sh'
  IMAGE_PATH = '/Users/yuji/Projects/maxima-on-web/public/images/'
  SETTINGS = ["set_plot_option([plot_format, gnuplot])",
              "set_plot_option([gnuplot_term,\"png size 480, 360\"])"]
  @@sessions = {}

  # セッション識別子に対応するインスタンスを返します。
  def Maxima.get_instance(id)
    return @@sessions[id]
  end

  # セッションをすべてcloseします。
  def Maxima.cleanup
    @@sessions.dup.each_value {|e| e.close }
  end

  # セッション識別子を作成し、Maximaを起動、パイプで接続します。
  def initialize
    @id = time_stamp
    @io = IO.popen(MAXIMA_PATH, 'r+')
    @@sessions[@id] = self
    geto # オープニング出力を破棄
    SETTINGS.each {|e| exec(e)}
    exec("set_plot_option([gnuplot_out_file, \"#{graph_file}\"])")
  end

  # セッション終了のための後処理です。
  def close
    @io.close
    @@sessions.delete(@id)
    `rm #{graph_file}` 
  end

  attr_reader :id

  def graph_file
    return IMAGE_PATH + id + '.png'
  end

  def time_stamp
    t = Time.now
    return t.strftime("%Y%m%d%H%M%S") + t.usec.to_s
  end

  # Maximaの出力を返します。入力プロンプトは含ません。
  def geto 
    output = ''
    while /^\(%i[0-9]+\) $/ !~ (line = @io.readpartial(BUFFER_SIZE))
      output += line
    end
    return output
  end

  # Maximaにcmdを入力します。行末が終端文字(;か$)でなければ;を補完します。
  def puti(cmd)
    cmd = cmd + ';' if /[;$]$/ !~ cmd
    @io.puts(cmd)
  end

  # Maximaにcmdを入力し、結果を返します。
  def exec(cmd)
    puti(cmd)
    return geto
  end

  # Maximaにcmdを入力し、結果をMathjax導入HTML(tex数式か画像リンク)で返します。
  def response(cmd)
    `rm #{graph_file}` if File.exist?(graph_file)
    result = exec(cmd)
    result = exec('tex(%)$') if result != ''
    
    if File.exist?(graph_file) then
      result += '<div align="center">' + "\n" +
        '<img src="/images/' + File.basename(graph_file) + '?' + time_stamp + '" />' +
        "</div>\n"
    end
    return result
  end
end
