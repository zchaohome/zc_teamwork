public class ReplaceChar {

  /** 半角アルファベットを全角アルファベットに変換するメソッド */
    public static String repleceAlphabetHalfToFull(String str) {

        List<Integer> codePointList = new List<Integer>();

        for (integer i = 0; i < str.length(); i++) {
            // 文字のコードポイント取得
            Integer codePoint = str.codePointAt(i);

            if (65 <= codePoint && codePoint <= 90) {
            // 半角アルファベット大文字は全角大文字に変換してリストに追加
                codePoint += 65248;
                codePointList.add(codePoint);
            } else if (97 <= codePoint && codePoint <= 122) {
            // 半角アルファベット小文字は全角小文字に変換してリストに追加
                codePoint += 65248;
                codePointList.add(codePoint);
            } else {
            // 半角アルファベット以外はそのままリストに追加
                codePointList.add(codePoint);
            }
        }

        return String.fromCharArray(codePointList);
    }
    
     /** 全角アルファベットを半角アルファベットに変換するメソッド */
    public static String repleceAlphabetFullToHalf(String str) {

        List<Integer> codePointList = new List<Integer>();

        for (integer i = 0; i < str.length(); i++) {
            // 文字のコードポイント取得
            Integer codePoint = str.codePointAt(i);

            if (65 <= codePoint && codePoint <= 90) {
            // 半角アルファベット大文字は全角大文字に変換してリストに追加
                codePoint -= 65248;
                codePointList.add(codePoint);
            } else if (97 <= codePoint && codePoint <= 122) {
            // 半角アルファベット小文字は全角小文字に変換してリストに追加
                codePoint -= 65248;
                codePointList.add(codePoint);
            } else {
            // 半角アルファベット以外はそのままリストに追加
                codePointList.add(codePoint);
            }
        }

        return String.fromCharArray(codePointList);
    }
    
    /**
     * 全角→半角変換
     *
     * @param value 変換元文字列
     * @return 半角文字列
     */
    public static String convertFullToHalf(String value) {
        String result;
        // 変換内容がない場合
        if(String.isEmpty(value)) {
            result = '';
        }else{
            // 半角文字のみなら以降スキップ
            if (Pattern.matches('[ -~]+', value)) {
                result = value;
            }else{
                // 濁音、半濁音は2文字で1文字に変換されるため先に実施
                Map<String, String> fulltoHalfMap1 = new Map<String, String>();
                fulltoHalfMap1.put('ガ' , 'ｶﾞ');
                fulltoHalfMap1.put('ギ' , 'ｷﾞ');
                fulltoHalfMap1.put('グ' , 'ｸﾞ');
                fulltoHalfMap1.put('ゲ' , 'ｹﾞ');
                fulltoHalfMap1.put('ゴ' , 'ｺﾞ');
                fulltoHalfMap1.put('ザ' , 'ｻﾞ');
                fulltoHalfMap1.put('ジ' , 'ｼﾞ');
                fulltoHalfMap1.put('ズ' , 'ｽﾞ');
                fulltoHalfMap1.put('ゼ' , 'ｾﾞ');
                fulltoHalfMap1.put('ゾ' , 'ｿﾞ');
                fulltoHalfMap1.put('ダ' , 'ﾀﾞ');
                fulltoHalfMap1.put('ヂ' , 'ﾁﾞ');
                fulltoHalfMap1.put('ヅ' , 'ﾂﾞ');
                fulltoHalfMap1.put('デ' , 'ﾃﾞ');
                fulltoHalfMap1.put('ド' , 'ﾄﾞ');
                fulltoHalfMap1.put('バ' , 'ﾊﾞ');
                fulltoHalfMap1.put('ビ' , 'ﾋﾞ');
                fulltoHalfMap1.put('ブ' , 'ﾌﾞ');
                fulltoHalfMap1.put('ベ' , 'ﾍﾞ');
                fulltoHalfMap1.put('ボ' , 'ﾎﾞ');
                fulltoHalfMap1.put('パ' , 'ﾊﾟ');
                fulltoHalfMap1.put('ピ' , 'ﾋﾟ');
                fulltoHalfMap1.put('プ' , 'ﾌﾟ');
                fulltoHalfMap1.put('ペ' , 'ﾍﾟ');
                fulltoHalfMap1.put('ポ' , 'ﾎﾟ');
                fulltoHalfMap1.put('ヴ' , 'ｳﾞ');

                Map<String, String> fulltoHalfMap2 = new Map<String, String>();
                fulltoHalfMap2.put( '！',  '!' );
                fulltoHalfMap2.put( '”',  '"' );
                fulltoHalfMap2.put( '＃',  '#' );
                fulltoHalfMap2.put( '＄',  '$' );
                fulltoHalfMap2.put( '％',  '%' );
                fulltoHalfMap2.put( '＆',  '&' );
                fulltoHalfMap2.put(  '’',  '\'');
                fulltoHalfMap2.put( '（',  '(' );
                fulltoHalfMap2.put( '）',  ')' );
                fulltoHalfMap2.put( '＊',  '*' );
                fulltoHalfMap2.put( '＋',  '+' );
                fulltoHalfMap2.put( '，',   '' );
                fulltoHalfMap2.put( '−',  '-' );
                fulltoHalfMap2.put( '．',  '.' );
                fulltoHalfMap2.put( '／',  '/' );
                fulltoHalfMap2.put( '０',  '0' );
                fulltoHalfMap2.put( '１',  '1' );
                fulltoHalfMap2.put( '２',  '2' );
                fulltoHalfMap2.put( '３',  '3' );
                fulltoHalfMap2.put( '４',  '4' );
                fulltoHalfMap2.put( '５',  '5' );
                fulltoHalfMap2.put( '６',  '6' );
                fulltoHalfMap2.put( '７',  '7' );
                fulltoHalfMap2.put( '８',  '8' );
                fulltoHalfMap2.put( '９',  '9' );
                fulltoHalfMap2.put( '：',  ':' );
                fulltoHalfMap2.put( '；',  ';' );
                fulltoHalfMap2.put( '＜',  '<' );
                fulltoHalfMap2.put( '＝',  '=' );
                fulltoHalfMap2.put( '＞',  '>' );
                fulltoHalfMap2.put( '？',  '?' );
                fulltoHalfMap2.put( '＠',  '@' );
                fulltoHalfMap2.put( 'Ａ',  'A' );
                fulltoHalfMap2.put( 'Ｂ',  'B' );
                fulltoHalfMap2.put( 'Ｃ',  'C' );
                fulltoHalfMap2.put( 'Ｄ',  'D' );
                fulltoHalfMap2.put( 'Ｅ',  'E' );
                fulltoHalfMap2.put( 'Ｆ',  'F' );
                fulltoHalfMap2.put( 'Ｇ',  'G' );
                fulltoHalfMap2.put( 'Ｈ',  'H' );
                fulltoHalfMap2.put( 'Ｉ',  'I' );
                fulltoHalfMap2.put( 'Ｊ',  'J' );
                fulltoHalfMap2.put( 'Ｋ',  'K' );
                fulltoHalfMap2.put( 'Ｌ',  'L' );
                fulltoHalfMap2.put( 'Ｍ',  'M' );
                fulltoHalfMap2.put( 'Ｎ',  'N' );
                fulltoHalfMap2.put( 'Ｏ',  'O' );
                fulltoHalfMap2.put( 'Ｐ',  'P' );
                fulltoHalfMap2.put( 'Ｑ',  'Q' );
                fulltoHalfMap2.put( 'Ｒ',  'R' );
                fulltoHalfMap2.put( 'Ｓ',  'S' );
                fulltoHalfMap2.put( 'Ｔ',  'T' );
                fulltoHalfMap2.put( 'Ｕ',  'U' );
                fulltoHalfMap2.put( 'Ｖ',  'V' );
                fulltoHalfMap2.put( 'Ｗ',  'W' );
                fulltoHalfMap2.put( 'Ｘ',  'X' );
                fulltoHalfMap2.put( 'Ｙ',  'Y' );
                fulltoHalfMap2.put( 'Ｚ',  'Z' );
                fulltoHalfMap2.put( '［',  '[' );
                fulltoHalfMap2.put(  '￥',  '\\');
                fulltoHalfMap2.put( '］',  ']' );
                fulltoHalfMap2.put( '＾',  '^' );
                fulltoHalfMap2.put( '＿',  '_' );
                fulltoHalfMap2.put( '‘',  '`' );
                fulltoHalfMap2.put( 'ａ',  'a' );
                fulltoHalfMap2.put( 'ｂ',  'b' );
                fulltoHalfMap2.put( 'ｃ',  'c' );
                fulltoHalfMap2.put( 'ｄ',  'd' );
                fulltoHalfMap2.put( 'ｅ',  'e' );
                fulltoHalfMap2.put( 'ｆ',  'f' );
                fulltoHalfMap2.put( 'ｇ',  'g' );
                fulltoHalfMap2.put( 'ｈ',  'h' );
                fulltoHalfMap2.put( 'ｉ',  'i' );
                fulltoHalfMap2.put( 'ｊ',  'j' );
                fulltoHalfMap2.put( 'ｋ',  'k' );
                fulltoHalfMap2.put( 'ｌ',  'l' );
                fulltoHalfMap2.put( 'ｍ',  'm' );
                fulltoHalfMap2.put( 'ｎ',  'n' );
                fulltoHalfMap2.put( 'ｏ',  'o' );
                fulltoHalfMap2.put( 'ｐ',  'p' );
                fulltoHalfMap2.put( 'ｑ',  'q' );
                fulltoHalfMap2.put( 'ｒ',  'r' );
                fulltoHalfMap2.put( 'ｓ',  's' );
                fulltoHalfMap2.put( 'ｔ',  't' );
                fulltoHalfMap2.put( 'ｕ',  'u' );
                fulltoHalfMap2.put( 'ｖ',  'v' );
                fulltoHalfMap2.put( 'ｗ',  'w' );
                fulltoHalfMap2.put( 'ｘ',  'x' );
                fulltoHalfMap2.put( 'ｙ',  'y' );
                fulltoHalfMap2.put( 'ｚ',  'z' );
                fulltoHalfMap2.put( '｛',  '{' );
                fulltoHalfMap2.put( '｜',  '|' );
                fulltoHalfMap2.put( '｝',  '}' );
                fulltoHalfMap2.put( '〜',  '~' );
                fulltoHalfMap2.put( '　',  ' ' );
                fulltoHalfMap2.put( '。',  '｡' );
                fulltoHalfMap2.put( '「',  '｢' );
                fulltoHalfMap2.put( '」',  '｣' );
                fulltoHalfMap2.put( '、',  '､' );
                fulltoHalfMap2.put( '・',  '･' );
                fulltoHalfMap2.put( 'ヲ',  'ｦ' );
                fulltoHalfMap2.put( 'ァ',  'ｧ' );
                fulltoHalfMap2.put( 'ィ',  'ｨ' );
                fulltoHalfMap2.put( 'ゥ',  'ｩ' );
                fulltoHalfMap2.put( 'ェ',  'ｪ' );
                fulltoHalfMap2.put( 'ォ',  'ｫ' );
                fulltoHalfMap2.put( 'ャ',  'ｬ' );
                fulltoHalfMap2.put( 'ュ',  'ｭ' );
                fulltoHalfMap2.put( 'ョ',  'ｮ' );
                fulltoHalfMap2.put( 'ッ',  'ｯ' );
                fulltoHalfMap2.put( 'ー',  'ｰ' );
                fulltoHalfMap2.put( 'ア',  'ｱ' );
                fulltoHalfMap2.put( 'イ',  'ｲ' );
                fulltoHalfMap2.put( 'ウ',  'ｳ' );
                fulltoHalfMap2.put( 'エ',  'ｴ' );
                fulltoHalfMap2.put( 'オ',  'ｵ' );
                fulltoHalfMap2.put( 'カ',  'ｶ' );
                fulltoHalfMap2.put( 'キ',  'ｷ' );
                fulltoHalfMap2.put( 'ク',  'ｸ' );
                fulltoHalfMap2.put( 'ケ',  'ｹ' );
                fulltoHalfMap2.put( 'コ',  'ｺ' );
                fulltoHalfMap2.put( 'サ',  'ｻ' );
                fulltoHalfMap2.put( 'シ',  'ｼ' );
                fulltoHalfMap2.put( 'ス',  'ｽ' );
                fulltoHalfMap2.put( 'セ',  'ｾ' );
                fulltoHalfMap2.put( 'ソ',  'ｿ' );
                fulltoHalfMap2.put( 'タ',  'ﾀ' );
                fulltoHalfMap2.put( 'チ',  'ﾁ' );
                fulltoHalfMap2.put( 'ツ',  'ﾂ' );
                fulltoHalfMap2.put( 'テ',  'ﾃ' );
                fulltoHalfMap2.put( 'ト',  'ﾄ' );
                fulltoHalfMap2.put( 'ナ',  'ﾅ' );
                fulltoHalfMap2.put( 'ニ',  'ﾆ' );
                fulltoHalfMap2.put( 'ヌ',  'ﾇ' );
                fulltoHalfMap2.put( 'ネ',  'ﾈ' );
                fulltoHalfMap2.put( 'ノ',  'ﾉ' );
                fulltoHalfMap2.put( 'ハ',  'ﾊ' );
                fulltoHalfMap2.put( 'ヒ',  'ﾋ' );
                fulltoHalfMap2.put( 'フ',  'ﾌ' );
                fulltoHalfMap2.put( 'ヘ',  'ﾍ' );
                fulltoHalfMap2.put( 'ホ',  'ﾎ' );
                fulltoHalfMap2.put( 'マ',  'ﾏ' );
                fulltoHalfMap2.put( 'ミ',  'ﾐ' );
                fulltoHalfMap2.put( 'ム',  'ﾑ' );
                fulltoHalfMap2.put( 'メ',  'ﾒ' );
                fulltoHalfMap2.put( 'モ',  'ﾓ' );
                fulltoHalfMap2.put( 'ヤ',  'ﾔ' );
                fulltoHalfMap2.put( 'ユ',  'ﾕ' );
                fulltoHalfMap2.put( 'ヨ',  'ﾖ' );
                fulltoHalfMap2.put( 'ラ',  'ﾗ' );
                fulltoHalfMap2.put( 'リ',  'ﾘ' );
                fulltoHalfMap2.put( 'ル',  'ﾙ' );
                fulltoHalfMap2.put( 'レ',  'ﾚ' );
                fulltoHalfMap2.put( 'ロ',  'ﾛ' );
                fulltoHalfMap2.put( 'ワ',  'ﾜ' );
                fulltoHalfMap2.put( 'ン',  'ﾝ' );
                fulltoHalfMap2.put( '゛',  'ﾞ' );
                fulltoHalfMap2.put( '゜',  'ﾟ' );
                // エスケープ必要文字
                Set<String> escapeChars = new Set<String>();
                escapeChars.add('\\');
                escapeChars.add('*');
                escapeChars.add('+');
                escapeChars.add('.');
                escapeChars.add('?');
                escapeChars.add('{');
                escapeChars.add('}');
                escapeChars.add('(');
                escapeChars.add(')');
                escapeChars.add('[');
                escapeChars.add(']');
                escapeChars.add('^');
                escapeChars.add('$');
                escapeChars.add('|');
                escapeChars.add('/');

                for (String key : fulltoHalfMap1.keySet()) {
                    if (value.contains(key)) {
                        value = value.replaceAll(key, fulltoHalfMap1.get(key));
                    }
                }

                for (String key : fulltoHalfMap2.keySet()) {
                    if (value.contains(key)) {
                        String tempKey = key;
                        if (escapeChars.contains(tempKey)) {
                            tempKey = '\\' + tempKey;
                        }
                        value = value.replaceAll(tempKey, fulltoHalfMap2.get(key));
                    }
                }
                String comma = '，';
                if(value.contains(comma)){
                    value = value.replaceAll(comma, '');
                }
                result = value;
            }
        }
        return result;
    }
 /**
     * 半角→全角変換
     *
     * @param value 変換元文字列
     * @return 全角文字列
     */
    public static String convertHalfToFull(String value) {
        String result;
        // 変換内容がない場合
        if(String.isEmpty(value)) {
            result = '';
        }else{
            // 全角文字のみなら以降スキップ
            if (Pattern.matches('[^ -~｡-ﾟ]+', value)) {
                result = value;
            }else{
                // 濁音、半濁音は2文字で1文字に変換されるため先に実施
                Map<String, String> halftoFullMap1 = new Map<String, String>();
                halftoFullMap1.put('ｶﾞ' , 'ガ');
                halftoFullMap1.put('ｷﾞ' , 'ギ');
                halftoFullMap1.put('ｸﾞ' , 'グ');
                halftoFullMap1.put('ｹﾞ' , 'ゲ');
                halftoFullMap1.put('ｺﾞ' , 'ゴ');
                halftoFullMap1.put('ｻﾞ' , 'ザ');
                halftoFullMap1.put('ｼﾞ' , 'ジ');
                halftoFullMap1.put('ｽﾞ' , 'ズ');
                halftoFullMap1.put('ｾﾞ' , 'ゼ');
                halftoFullMap1.put('ｿﾞ' , 'ゾ');
                halftoFullMap1.put('ﾀﾞ' , 'ダ');
                halftoFullMap1.put('ﾁﾞ' , 'ヂ');
                halftoFullMap1.put('ﾂﾞ' , 'ヅ');
                halftoFullMap1.put('ﾃﾞ' , 'デ');
                halftoFullMap1.put('ﾄﾞ' , 'ド');
                halftoFullMap1.put('ﾊﾞ' , 'バ');
                halftoFullMap1.put('ﾋﾞ' , 'ビ');
                halftoFullMap1.put('ﾌﾞ' , 'ブ');
                halftoFullMap1.put('ﾍﾞ' , 'ベ');
                halftoFullMap1.put('ﾎﾞ' , 'ボ');
                halftoFullMap1.put('ﾊﾟ' , 'パ');
                halftoFullMap1.put('ﾋﾟ' , 'ピ');
                halftoFullMap1.put('ﾌﾟ' , 'プ');
                halftoFullMap1.put('ﾍﾟ' , 'ペ');
                halftoFullMap1.put('ﾎﾟ' , 'ポ');
                halftoFullMap1.put('ｳﾞ' , 'ヴ');

                Map<String, String> fulltoHalfMap2 = new Map<String, String>();
                fulltoHalfMap2.put('!' , '！');
                fulltoHalfMap2.put('"' , '”');
                fulltoHalfMap2.put('#' , '＃');
                fulltoHalfMap2.put('$' , '＄');
                fulltoHalfMap2.put('%' , '％');
                fulltoHalfMap2.put('&' , '＆');
                fulltoHalfMap2.put('\'' , '’');
                fulltoHalfMap2.put('(' , '（');
                fulltoHalfMap2.put(')' , '）');
                fulltoHalfMap2.put('*' , '＊');
                fulltoHalfMap2.put('+' , '＋');
                fulltoHalfMap2.put('' , '，');
                fulltoHalfMap2.put('-' , '−');
                fulltoHalfMap2.put('.' , '．');
                fulltoHalfMap2.put('/' , '／');
                fulltoHalfMap2.put('0' , '０');
                fulltoHalfMap2.put('1' , '１');
                fulltoHalfMap2.put('2' , '２');
                fulltoHalfMap2.put('3' , '３');
                fulltoHalfMap2.put('4' , '４');
                fulltoHalfMap2.put('5' , '５');
                fulltoHalfMap2.put('6' , '６');
                fulltoHalfMap2.put('7' , '７');
                fulltoHalfMap2.put('8' , '８');
                fulltoHalfMap2.put('9' , '９');
                fulltoHalfMap2.put(':' , '：');
                fulltoHalfMap2.put(';' , '；');
                fulltoHalfMap2.put('<' , '＜');
                fulltoHalfMap2.put('=' , '＝');
                fulltoHalfMap2.put('>' , '＞');
                fulltoHalfMap2.put('?' , '？');
                fulltoHalfMap2.put('@' , '＠');
                fulltoHalfMap2.put('A' , 'Ａ');
                fulltoHalfMap2.put('B' , 'Ｂ');
                fulltoHalfMap2.put('C' , 'Ｃ');
                fulltoHalfMap2.put('D' , 'Ｄ');
                fulltoHalfMap2.put('E' , 'Ｅ');
                fulltoHalfMap2.put('F' , 'Ｆ');
                fulltoHalfMap2.put('G' , 'Ｇ');
                fulltoHalfMap2.put('H' , 'Ｈ');
                fulltoHalfMap2.put('I' , 'Ｉ');
                fulltoHalfMap2.put('J' , 'Ｊ');
                fulltoHalfMap2.put('K' , 'Ｋ');
                fulltoHalfMap2.put('L' , 'Ｌ');
                fulltoHalfMap2.put('M' , 'Ｍ');
                fulltoHalfMap2.put('N' , 'Ｎ');
                fulltoHalfMap2.put('O' , 'Ｏ');
                fulltoHalfMap2.put('P' , 'Ｐ');
                fulltoHalfMap2.put('Q' , 'Ｑ');
                fulltoHalfMap2.put('R' , 'Ｒ');
                fulltoHalfMap2.put('S' , 'Ｓ');
                fulltoHalfMap2.put('T' , 'Ｔ');
                fulltoHalfMap2.put('U' , 'Ｕ');
                fulltoHalfMap2.put('V' , 'Ｖ');
                fulltoHalfMap2.put('W' , 'Ｗ');
                fulltoHalfMap2.put('X' , 'Ｘ');
                fulltoHalfMap2.put('Y' , 'Ｙ');
                fulltoHalfMap2.put('Z' , 'Ｚ');
                fulltoHalfMap2.put('[' , '［');
                fulltoHalfMap2.put('\\' , '￥');
                fulltoHalfMap2.put(']' , '］');
                fulltoHalfMap2.put('^' , '＾');
                fulltoHalfMap2.put('_' , '＿');
                fulltoHalfMap2.put('`' , '‘');
                fulltoHalfMap2.put('a' , 'ａ');
                fulltoHalfMap2.put('b' , 'ｂ');
                fulltoHalfMap2.put('c' , 'ｃ');
                fulltoHalfMap2.put('d' , 'ｄ');
                fulltoHalfMap2.put('e' , 'ｅ');
                fulltoHalfMap2.put('f' , 'ｆ');
                fulltoHalfMap2.put('g' , 'ｇ');
                fulltoHalfMap2.put('h' , 'ｈ');
                fulltoHalfMap2.put('i' , 'ｉ');
                fulltoHalfMap2.put('j' , 'ｊ');
                fulltoHalfMap2.put('k' , 'ｋ');
                fulltoHalfMap2.put('l' , 'ｌ');
                fulltoHalfMap2.put('m' , 'ｍ');
                fulltoHalfMap2.put('n' , 'ｎ');
                fulltoHalfMap2.put('o' , 'ｏ');
                fulltoHalfMap2.put('p' , 'ｐ');
                fulltoHalfMap2.put('q' , 'ｑ');
                fulltoHalfMap2.put('r' , 'ｒ');
                fulltoHalfMap2.put('s' , 'ｓ');
                fulltoHalfMap2.put('t' , 'ｔ');
                fulltoHalfMap2.put('u' , 'ｕ');
                fulltoHalfMap2.put('v' , 'ｖ');
                fulltoHalfMap2.put('w' , 'ｗ');
                fulltoHalfMap2.put('x' , 'ｘ');
                fulltoHalfMap2.put('y' , 'ｙ');
                fulltoHalfMap2.put('z' , 'ｚ');
                fulltoHalfMap2.put('{' , '｛');
                fulltoHalfMap2.put('|' , '｜');
                fulltoHalfMap2.put('}' , '｝');
                fulltoHalfMap2.put('~' , '〜');
                fulltoHalfMap2.put(' ' , '　');
                fulltoHalfMap2.put('｡' , '。');
                fulltoHalfMap2.put('｢' , '「');
                fulltoHalfMap2.put('｣' , '」');
                fulltoHalfMap2.put('､' , '、');
                fulltoHalfMap2.put('･' , '・');
                fulltoHalfMap2.put('ｦ' , 'ヲ');
                fulltoHalfMap2.put('ｧ' , 'ァ');
                fulltoHalfMap2.put('ｨ' , 'ィ');
                fulltoHalfMap2.put('ｩ' , 'ゥ');
                fulltoHalfMap2.put('ｪ' , 'ェ');
                fulltoHalfMap2.put('ｫ' , 'ォ');
                fulltoHalfMap2.put('ｬ' , 'ャ');
                fulltoHalfMap2.put('ｭ' , 'ュ');
                fulltoHalfMap2.put('ｮ' , 'ョ');
                fulltoHalfMap2.put('ｯ' , 'ッ');
                fulltoHalfMap2.put('ｰ' , 'ー');
                fulltoHalfMap2.put('ｱ' , 'ア');
                fulltoHalfMap2.put('ｲ' , 'イ');
                fulltoHalfMap2.put('ｳ' , 'ウ');
                fulltoHalfMap2.put('ｴ' , 'エ');
                fulltoHalfMap2.put('ｵ' , 'オ');
                fulltoHalfMap2.put('ｶ' , 'カ');
                fulltoHalfMap2.put('ｷ' , 'キ');
                fulltoHalfMap2.put('ｸ' , 'ク');
                fulltoHalfMap2.put('ｹ' , 'ケ');
                fulltoHalfMap2.put('ｺ' , 'コ');
                fulltoHalfMap2.put('ｻ' , 'サ');
                fulltoHalfMap2.put('ｼ' , 'シ');
                fulltoHalfMap2.put('ｽ' , 'ス');
                fulltoHalfMap2.put('ｾ' , 'セ');
                fulltoHalfMap2.put('ｿ' , 'ソ');
                fulltoHalfMap2.put('ﾀ' , 'タ');
                fulltoHalfMap2.put('ﾁ' , 'チ');
                fulltoHalfMap2.put('ﾂ' , 'ツ');
                fulltoHalfMap2.put('ﾃ' , 'テ');
                fulltoHalfMap2.put('ﾄ' , 'ト');
                fulltoHalfMap2.put('ﾅ' , 'ナ');
                fulltoHalfMap2.put('ﾆ' , 'ニ');
                fulltoHalfMap2.put('ﾇ' , 'ヌ');
                fulltoHalfMap2.put('ﾈ' , 'ネ');
                fulltoHalfMap2.put('ﾉ' , 'ノ');
                fulltoHalfMap2.put('ﾊ' , 'ハ');
                fulltoHalfMap2.put('ﾋ' , 'ヒ');
                fulltoHalfMap2.put('ﾌ' , 'フ');
                fulltoHalfMap2.put('ﾍ' , 'ヘ');
                fulltoHalfMap2.put('ﾎ' , 'ホ');
                fulltoHalfMap2.put('ﾏ' , 'マ');
                fulltoHalfMap2.put('ﾐ' , 'ミ');
                fulltoHalfMap2.put('ﾑ' , 'ム');
                fulltoHalfMap2.put('ﾒ' , 'メ');
                fulltoHalfMap2.put('ﾓ' , 'モ');
                fulltoHalfMap2.put('ﾔ' , 'ヤ');
                fulltoHalfMap2.put('ﾕ' , 'ユ');
                fulltoHalfMap2.put('ﾖ' , 'ヨ');
                fulltoHalfMap2.put('ﾗ' , 'ラ');
                fulltoHalfMap2.put('ﾘ' , 'リ');
                fulltoHalfMap2.put('ﾙ' , 'ル');
                fulltoHalfMap2.put('ﾚ' , 'レ');
                fulltoHalfMap2.put('ﾛ' , 'ロ');
                fulltoHalfMap2.put('ﾜ' , 'ワ');
                fulltoHalfMap2.put('ﾝ' , 'ン');
                fulltoHalfMap2.put('ﾞ' , '゛');
                fulltoHalfMap2.put('ﾟ' , '゜');
                // エスケープ必要文字
                Set<String> escapeChars = new Set<String>();
                escapeChars.add('\\');
                escapeChars.add('*');
                escapeChars.add('+');
                escapeChars.add('.');
                escapeChars.add('?');
                escapeChars.add('{');
                escapeChars.add('}');
                escapeChars.add('(');
                escapeChars.add(')');
                escapeChars.add('[');
                escapeChars.add(']');
                escapeChars.add('^');
                escapeChars.add('$');
                escapeChars.add('|');
                escapeChars.add('/');

                for (String key : halftoFullMap1.keySet()) {
                    if (value.contains(key)) {
                        value = value.replaceAll(key, halftoFullMap1.get(key));
                    }
                }

                for (String key : fulltoHalfMap2.keySet()) {
                    if (value.contains(key)) {
                        String tempKey = key;
                        if (escapeChars.contains(tempKey)) {
                            tempKey = '\\' + tempKey;
                        }
                        value = value.replaceAll(tempKey, fulltoHalfMap2.get(key));
                    }
                }
                String comma = '，';
                if(value.contains(comma)){
                    value = value.replaceAll(comma, '');
                }
                result = value;
            }
        }
        return result;
    }
}