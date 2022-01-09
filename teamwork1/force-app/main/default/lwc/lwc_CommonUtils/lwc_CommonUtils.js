/*
   *  Chage  date  value  to  string  format.
   *  Date型を文字列に変換する
   *    戻り値の日付フォーマット  (yyyy/MM/dd  hh:mm:ss)
   *    dt  日付
   */
 const toStringFromDate  =(dt)  =>  {
         let  timeString  =  dt.toLocaleTimeString('en-US',  {'hour12':false})  //24フォーマット
         return  [
                 dt.getFullYear(),
                 dt.getMonth()  +  1,
                 dt.getDate()
                 ].join(  '/'  )  +  '  '
                 +  timeString;
 };

 export  {  toStringFromDate  };