import "package:translit/translit.dart";


class AppUtils{
  
  static Object login(var names){
    // принимаем словарь -> возвращаем строку с логином вида Фамилия.ИО
    try{
        // отсутствие фамилии
        if(names["surname"] == ""){
          throw Exception("Ошибка! Нет имени");
        }

        final String loginStr = Translit().toTranslit(
          source: "${names["surname"]}.${names["name"][0] + (names["third_name"] == "" ? "" : names["third_name"][0])}"
          ).toLowerCase().replaceAll("'", "");     
        return loginStr;
    }
    on RangeError{
      throw Exception("Ошибка! Недостаточно данных!");
    } 
    catch (e){
        // другие ошибки
        throw Exception("Ошибка! Некорректные данные!");
    }
  }
}
