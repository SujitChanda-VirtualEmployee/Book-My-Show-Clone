import 'dart:io';

import 'package:book_my_show_clone/main.dart';
import 'package:book_my_show_clone/screens/welcomScreen/welcome_screen.dart';
import 'package:book_my_show_clone/utils/asset_images_strings.dart';
import 'package:book_my_show_clone/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:share_plus/share_plus.dart';
import '../../services/firebaseServices/firebase_services.dart';
import '../../services/sharedService/shared_preference_service.dart';
import '../../utils/color_palette.dart';
import '../../utils/custom_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/rounded_icon_btn.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = "profile-screen";
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? status;
  String? drivingLicenceUrl;
  String? id;
  String? profilePicUrl;
  String? email;
  String? name;
  bool loading = false;
  String? _uploadedProfilePicURL;
  File? profilePic;
  File? cropped;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final picker = ImagePicker();
  bool edit = false;
  int remainingDays = 0;
  FirebaseServices _userServices = new FirebaseServices();

  SharedServices _sharedServices = SharedServices();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();

  @override
  void initState() {
    nameTextEditingController.text = preferences!.getString('_userName')!;
    emailTextEditingController.text = preferences!.getString('_userEmail')!;
    phoneTextEditingController.text = preferences!.getString('_userPhone')!;

    super.initState();
  }

  void updateUser(
      {required String id, required String name, required String emailId}) {
    _userServices.updateUserData({
      'id': id,
      'name': name,
      'email': emailId,
      // ignore: prefer_if_null_operators
      'profile_Pic_URL': _uploadedProfilePicURL == null
          ? preferences!.getString('_userPhoto')
          : _uploadedProfilePicURL,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0), topRight: Radius.circular(0))),
        backgroundColor: Colors.green.shade400,
        content: Text("Profile Update Successful !",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white)),
        duration: const Duration(milliseconds: 3000),
      ));
    });

    SharedServices.addUserDataToSF(
      userName: name,
      userPhone: phoneTextEditingController.text,
      userEmail: emailId,
      userPhoto: _uploadedProfilePicURL == null
          ? preferences!.getString('_userPhoto')!
          : _uploadedProfilePicURL!,
    );
    // Provider.of<AppData>(context, listen: false).setUserName();
    // Provider.of<AppData>(context, listen: false).setProfilePic();
  }

  @override
  void dispose() {
    nameTextEditingController.dispose();
    phoneTextEditingController.dispose();
    emailTextEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorPalette.secondary,
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: SizedBox(
            height: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi ${preferences!.getString("_userName")} !",
                  style: CustomStyleClass.onboardingBodyTextStyle
                      .copyWith(color: Colors.white),
                ),
                Expanded(
                  child: Container(
                    color: ColorPalette.secondary,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          edit = !edit;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Edit Profile ",
                            style: CustomStyleClass.onboardingBodyTextStyle
                                .copyWith(
                                    color: Colors.grey.shade500,
                                    letterSpacing: 0.5,
                                    fontSize: SizeConfig.textMultiplier * 1.5),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey.withOpacity(0.6),
                            size: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 1),
              ],
            ),
          ),
          actions: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 22,
              child: Padding(
                padding: const EdgeInsets.all(0.5),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 21.5,
                  child: ClipRRect(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    borderRadius: const BorderRadius.all(Radius.circular(500)),
                    child: CachedNetworkImage(
                      imageUrl: preferences!.getString('_userPhoto')!,
                      width: MediaQuery.of(context).size.width,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: Image.asset(
                          AssetImageClass.appLogo,
                          color: ColorPalette.dark,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Image.asset(
                          AssetImageClass.appLogo,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        body: _body(),
        bottomNavigationBar: edit == false ? const SizedBox() : _bottomSheet());
  }

  Widget _body() {
    return Container(
      height: MediaQuery.of(context).size.height - 80,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
      child: edit == false
          ? sliverUpperSection()
          : Stack(
              children: [
                Column(
                  children: [
                    _myPic(),
                    const SizedBox(
                      height: 40,
                    ),
                    Column(children: [
                      _nameEditor(),
                      _emailEditor(),
                      _phoneEditor(),
                    ]),
                  ],
                ),
                Positioned(
                    right: 5,
                    top: 5,
                    child: RoundedIconBtn(
                      icon: Icons.close,
                      bgColor: const Color(0XFFe8f5fe),
                      iconSize: 22,
                      press: () {
                        setState(() {
                          edit = !edit;
                        });
                      },
                    ))
              ],
            ),
    );
  }

  Widget sliverUpperSection() {
    return SingleChildScrollView(
        child: Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 20, left: 10, right: 5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(30)),
                color: ColorPalette.secondary.withOpacity(0.5),
              ),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                    height: 150 * SizeConfig.heightMultiplier,
                    width: 150 * SizeConfig.heightMultiplier,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 0.5,
                            blurRadius: 0.5,
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(0.7, 0.7))
                      ],
                    ),
                    child: ClipRRect(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(500)),
                      child: CachedNetworkImage(
                        imageUrl: _uploadedProfilePicURL == null
                            ? preferences!.getString('_userPhoto')!
                            : _uploadedProfilePicURL!,
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: SizedBox(
                      height: 120 * SizeConfig.heightMultiplier,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            nameTextEditingController.text,
                            style: Theme.of(context).textTheme.headline6,
                            maxLines: 1,
                          ),
                          Text(
                            emailTextEditingController.text,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            phoneTextEditingController.text,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
                right: 5,
                top: 5,
                child: RoundedIconBtn(
                  icon: Icons.edit_outlined,
                  bgColor: const Color(0XFFe8f5fe),
                  iconSize: 22,
                  press: () {
                    setState(() {
                      edit = !edit;
                    });
                  },
                ))
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        const Divider(),
        ListTile(
          onTap: () {},
          leading: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorPalette.secondary.withOpacity(0.5)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.business_center_outlined,
                  color: Colors.white, size: 20),
            ),
          ),
          title: Text('OUR WORK',
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 2)),
        ),
        const Divider(),
        ListTile(
          onTap: () {},
          leading: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorPalette.secondary.withOpacity(0.5)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.people, color: Colors.white, size: 20),
            ),
          ),
          title: Text("TEAM",
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 2)),
        ),
        const Divider(),
        ListTile(
          onTap: () {},
          leading: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorPalette.secondary.withOpacity(0.5)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.newspaper, color: Colors.white, size: 20),
            ),
          ),
          title: Text('BUZZ',
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 2)),
        ),
        const Divider(),
        ListTile(
          onTap: () {},
          leading: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorPalette.secondary.withOpacity(0.5)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.call, color: Colors.white, size: 20),
            ),
          ),
          title: Text('CONTACT US',
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 2)),
        ),
        const Divider(),
        ListTile(
          onTap: () {
            Share.share(
              'Check out Chat App \n http://www.virtualemployee.co.in',
            );
          },
          leading: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorPalette.secondary.withOpacity(0.5)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.share_outlined, color: Colors.white, size: 20),
            ),
          ),
          title: Text("SHARE",
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 2)),
        ),
        const Divider(),
        ListTile(
          onTap: () {
            showDialog();
          },
          leading: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorPalette.secondary.withOpacity(0.5)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.logout, color: Colors.white, size: 20),
            ),
          ),
          title: Text("LOGOUT",
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 2)),
        ),
        const Divider(),
      ],
    ));
  }

  _myPic() {
    return Stack(clipBehavior: Clip.none, children: [
      Container(
        height: 220 * SizeConfig.heightMultiplier,
        width: 220 * SizeConfig.heightMultiplier,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 1,
            color: Colors.black,
          ),
          boxShadow: [
            BoxShadow(
                spreadRadius: 0.5,
                blurRadius: 0.5,
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(0.7, 0.7))
          ],
        ),
        child: ClipRRect(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderRadius: const BorderRadius.all(Radius.circular(500)),
          child: Hero(
            tag: _uploadedProfilePicURL == null
                ? "profilePage_${preferences!.getString('_userPhoto')!}"
                : "profilePage_${_uploadedProfilePicURL!}",
            child: CachedNetworkImage(
              imageUrl: _uploadedProfilePicURL == null
                  ? preferences!.getString('_userPhoto')!
                  : _uploadedProfilePicURL!,
              width: MediaQuery.of(context).size.width,
              height: 200,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CupertinoActivityIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
      Positioned(
          bottom: 0,
          right: 0,
          child: ClipOval(
            child: GestureDetector(
              onTap: () {
                getProfileImage();
              },
              child: Card(
                elevation: 2,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(800)),
                    side: BorderSide(width: 0.1, color: Colors.black)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(Icons.edit_outlined,
                          size: 7 * SizeConfig.imageSizeMultiplier,
                          color: Colors.blueGrey),
                    ),
                  ),
                ),
              ),
            ),
          ))
    ]);
  }

  _nameEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: _textEditor(
            prefixIcon: Icons.person_outline_outlined,
            controller: nameTextEditingController,
            readOnly: false,
            hintText: "User Name"));
  }

  _phoneEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: _textEditor(
            prefixIcon: Icons.phone_iphone_outlined,
            controller: phoneTextEditingController,
            readOnly: true,
            hintText: "Phone Number"));
  }

  _emailEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: _textEditor(
            prefixIcon: Icons.email_outlined,
            controller: emailTextEditingController,
            readOnly: false,
            hintText: "Email Id"));
  }

  _textEditor({
    IconData? prefixIcon,
    TextEditingController? controller,
    bool? readOnly,
    String? hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
          color: ColorPalette.secondary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(width: 0.5, color: ColorPalette.primary)),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            const SizedBox(width: 5),
            Icon(prefixIcon, color: ColorPalette.primary, size: 20),
            // SizedBox(width: 10.0),
            Expanded(
              child: TextField(
                readOnly: readOnly!,
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.grey),
                  fillColor: Colors.transparent,
                  filled: true,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                ),
              ),
            ),
            readOnly
                ? Icon(EvaIcons.checkmarkCircle, color: ColorPalette.primary)
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _bottomSheet() {
    return Visibility(
      visible: loading == false,
      child: Container(
          decoration: BoxDecoration(
            image: null,
            color: const Color(0XFFe8f5fe),
            boxShadow: [
              BoxShadow(
                //color: Colors.blue.withOpacity(0.3),
                color: Colors.grey.shade400,
                blurRadius: 0.5,
                spreadRadius: 1,
                offset: const Offset(0.7, 0.7),
              )
            ],
          ),
          height: 70,
          width: MediaQuery.of(context).size.width,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: ColorPalette.secondary.withOpacity(0.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customButton(
                    context: context,
                    onPressed: () {
                      if (nameTextEditingController.text.isNotEmpty &&
                          emailTextEditingController.text.isNotEmpty) {
                        updateUser(
                          id: _firebaseAuth.currentUser!.uid,
                          name: nameTextEditingController.text,
                          emailId: emailTextEditingController.text,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(0))),
                          backgroundColor: Colors.red.shade400,
                          content: Text("Fields Can not be Empty " + "!",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.white)),
                          duration: const Duration(milliseconds: 3000),
                        ));
                      }
                    },
                    title: "UPDATE"),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                //   child: Container(
                //     height: 45,
                //     width: double.infinity,
                //     child: ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //             primary: Theme.of(context).colorScheme.secondary),
                //         onPressed: () {},
                //         child: Text("UPDATE",
                //             style: Theme.of(context)
                //                 .textTheme
                //                 .headline6
                //                 .copyWith(letterSpacing: 4))),
                //   ),
                // ),
              ],
            ),
          )),
    );
  }

  Future getProfileImage() async {
    await EasyLoading.show(status: 'Please wait...', dismissOnTap: false);
    await ImagePicker()
        // ignore: deprecated_member_use
        .getImage(source: ImageSource.gallery, maxHeight: 1024, maxWidth: 1024)
        .then((image) async {
      try {
        if (image != null) {
          var data = await ImageCropper().cropImage(
              sourcePath: image.path,
              aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
              // compressQuality: 100,
              maxWidth: 1024,
              maxHeight: 1024,
              compressFormat: ImageCompressFormat.jpg,
              uiSettings: [
                AndroidUiSettings(
                  toolbarColor: Theme.of(context).colorScheme.secondary,
                  toolbarTitle: "Crop Image",
                  statusBarColor: Theme.of(context).colorScheme.secondary,
                  backgroundColor: Colors.white,
                )
              ]);
          if (data != null) cropped = File(data.path);

          if (cropped != null) {
            setState(() {
              profilePic = cropped;
            });
            EasyLoading.dismiss();
            await uploadProfilePic();
            if (cropped?.path == null) retrieveLostData(profilePic!);
            // print(
            //     "============================================================================");
          }
          EasyLoading.dismiss();
        }
      } catch (e) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0))),
              backgroundColor: Colors.red.shade400,
              content: Text(e.toString() + "!",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.white)),
              duration: const Duration(milliseconds: 5000),
            ))
            .closed
            .then((_) {
          setState(() {});
        });
      }
    });
  }

  Future uploadProfilePic() async {
    await EasyLoading.show(status: 'Uploading...');

    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('${_firebaseAuth.currentUser!.uid}/profilePicture.jpg');
      UploadTask uploadTask = storageReference.putFile(profilePic!);
      uploadTask.whenComplete(() async {
        await storageReference.getDownloadURL().then((fileURL) {
          setState(() {
            _uploadedProfilePicURL = fileURL;
            print(fileURL.toString());
            print(
                'From Storage URL Upload: ${_uploadedProfilePicURL.toString()}');
          });
          print("========================");
        });
      });
    } catch (e) {
      EasyLoading.dismiss();
    }

    EasyLoading.dismiss();
  }

  Future<void> retrieveLostData(File _image) async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = File(response.file!.path);
      });
    } else {
      print(response.file);
    }
  }

  showDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Confirm Logout ?"),
          content: const Text("\nAre you sure you want to logout?\n"),
          actions: [
            CupertinoDialogAction(
                child: Text(
                  "NO",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(false);
                }),
            CupertinoDialogAction(
                child: Text(
                  "YES",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                })
          ],
        );
      },
    ).then((value) async {
      if (value != null && value == true) {
        await FirebaseAuth.instance.signOut().then((val) {
          preferences!.clear();
          // Navigator.of(context).pushAndRemoveUntil(

          //   CupertinoPageRoute(
          //     builder: (BuildContext context) {
          //       return WelcomeScreen();
          //     },
          //   ),
          //   (_) => true,
          // );
         
          pushNewScreenWithRouteSettings(
            context,
            screen: const WelcomeScreen(),
            settings: const RouteSettings(name: WelcomeScreen.id),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        });
      }
    });
  }
}
