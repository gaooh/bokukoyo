require "jcode"
require "nkf"

class StringUtil
  MOBILE_Z_LIST = 'アイウエオカキクケコガギグゲゴサシスセソザジズゼゾタチツテトダヂヅデドナニヌネノハヒフヘホバビブベボパピプペポマミムメモヤユヨラリルレロワヲンャュョ、。゛゜・ー'
  MOBILE_H_LIST = 'ｱｲｳｴｵｶｷｸｹｺｶｷｸｹｺｻｼｽｾｿｻｼｽｾｿﾀﾁﾂﾃﾄﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾊﾋﾌﾍﾎﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝｬｭｮ､｡ﾞﾟ･ｰ'

  MOBILE_D_LIST = "ガギグゲゴザジズゼゾダヂヅデドバビブベボ"
  MOBILE_HD_LIST = 'パピプペポ'

  MOBILE_NKF_OPTION = "-sWx"  # input:utf-8/output:sjis/全角へのコンバートなし
  
  def self.z2h(str)
    tmp = str.gsub(/[#{MOBILE_D_LIST}]/, '\0゛')
    tmp.gsub!(/[#{MOBILE_HD_LIST}]/, '\0゜')
    tmp = str
    tmp.tr!(MOBILE_Z_LIST, MOBILE_H_LIST)
    tmp = NKF.nkf(MOBILE_NKF_OPTION, tmp)
    return tmp
  end
  
  def self.h2z(str)
    return NKF::nkf('-j',str)
  end
  
  def self.sanitize(value)
    return '' if value == nil
    
    value.gsub!(/&/, "&amp;")
    value.gsub!(/>/, "&gt;")
    value.gsub!(/</, "&lt;")
    value.gsub!(/"/, "&quot;")
    
    return value
  end
  
end
