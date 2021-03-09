class ValidationMixin{

  String validateInput(String value){
    if(value.length<2){
      return "Bu alanı boş geçemezsiniz";
    }
  }

  String validateEmail(String value){
    if(value.contains("@")!=true){
      return "E-mail formatı uygun değildir.";
    }
  }

  String validatePassword(String value){
    if(value.length<2){
      return "Şifre alanını boş geçemezsiniz";
    }
  }
}