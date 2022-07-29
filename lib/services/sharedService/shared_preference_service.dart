
import 'package:book_my_show_clone/main.dart';

class SharedServices {
  static addUserDataToSF({
    required String userName,
    required String userPhone,
    required String userEmail,
    required String userPhoto,

  }) {
    preferences!.setString('_userName', userName);
    preferences!.setString('_userPhoto', userPhoto);
    preferences!.setString('_userEmail', userEmail);
    preferences!.setString('_userPhone', userPhone);

    
    print("User Data Added to SharedPreferences");
  }
}
