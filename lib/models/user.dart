
class User {
  String fullName = "";
  String email = "";
  String profileImg = "";
  int invitationCode = 0;

  User(String fullName,String email,String profileImg,int invitationCode){
    this.fullName = fullName;
    this.email = email;
    this.profileImg = profileImg;
    this.invitationCode = invitationCode;
  }
}
