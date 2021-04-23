class LoginModel{
    String token;
    int user_id;
    String email;
    String name;

    LoginModel(String token, int user_id, String email, String name){
      this.email = email;
      this.name = name;
      this.user_id = user_id;
      this.token = token;
    }
}