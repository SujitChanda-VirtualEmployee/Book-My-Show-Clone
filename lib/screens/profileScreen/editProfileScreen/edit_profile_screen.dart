import 'dart:io';

import 'package:book_my_show_clone/main.dart';
import 'package:book_my_show_clone/services/providerService/location_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../services/firebaseServices/firebase_services.dart';
import '../../../services/sharedService/shared_preference_service.dart';
import '../../../utils/asset_images_strings.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/custom_styles.dart';
import '../../../utils/size_config.dart';
import '../../welcomScreen/welcome_screen.dart';
import 'components/dob_picker_sheet_content.dart';

class EditProfileScreen extends StatefulWidget {
  static const String id = 'EditProfileScreen';
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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
  bool? identity, married;
  FirebaseServices userServices = FirebaseServices();
  LocationProvider locationProvider = LocationProvider();

  String? userDoB;

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();

  TextEditingController pinCodeTextEditingController = TextEditingController();
  TextEditingController addressLineTextEditingController =
      TextEditingController();
  TextEditingController localityTextEditingController = TextEditingController();
  TextEditingController cityTextEditingController = TextEditingController();
  TextEditingController stateTextEditingController = TextEditingController();

  @override
  void initState() {
    nameTextEditingController.text = preferences!.getString('_userName')!;
    emailTextEditingController.text = preferences!.getString('_userEmail')!;
    phoneTextEditingController.text = preferences!.getString('_userPhone')!;
    if (preferences!.containsKey('_userDOB')) {
      userDoB = preferences!.getString('_userDOB')!;
    } else {
      userDoB = "Select Date of Birth";
    }

    if (preferences!.containsKey('_userIdentity')) {
      identity = preferences!.getBool('_userIdentity')!;
    }

    if (preferences!.containsKey('_userMarriageStatus')) {
      married = preferences!.getBool('_userMarriageStatus')!;
    }
    locationProvider = Provider.of<LocationProvider>(context, listen: false);
    pinCodeTextEditingController.text =
        locationProvider.pickUpLocation.postalCode.toString();
    addressLineTextEditingController.text =
        locationProvider.pickUpLocation.placeFormattedAddress.toString();
    localityTextEditingController.text =
        locationProvider.pickUpLocation.locality.toString();
    cityTextEditingController.text =
        locationProvider.pickUpLocation.city.toString();
    stateTextEditingController.text =
        locationProvider.pickUpLocation.stateOrProvince.toString();

    super.initState();
  }

  void updateUser(
      {required String id, required String name, required String emailId}) {
    userServices.updateUserData({
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
      userDob: userDoB,
      userIdentity: identity,
      userMarriageStatus: married,
    );
    // Provider.of<AppData>(context, listen: false).setUserName();
    // Provider.of<AppData>(context, listen: false).setProfilePic();
  }

  void _showDatePicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) {
          return const DobPickerSheetContent();
        }).then((value) {
      if (value != null) {
        setState(() {
          userDoB = DateFormat.yMMMMd('en_US').format(value);
        });
      }
    });
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
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ColorPalette.white,
            )),
        centerTitle: false,
        title: Text(
          "Edit Profile",
          style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
              color: ColorPalette.white,
              fontSize: SizeConfig.textMultiplier * 2),
        ),
      ),
      body: body(),
      bottomNavigationBar: _bottomSheet(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _myPic(),
          const SizedBox(
            height: 20,
          ),
          Column(children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text("Mobile Number",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: ColorPalette.secondary,
                          fontSize: SizeConfig.textMultiplier * 2,
                          fontWeight: FontWeight.bold)),
                )),
            _phoneEditor(),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 10),
                  child: Text("Email Address",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: ColorPalette.secondary,
                          fontSize: SizeConfig.textMultiplier * 2,
                          fontWeight: FontWeight.bold)),
                )),
            _emailEditor(),
            Container(
              height: SizeConfig.heightMultiplier * 15,
              color: ColorPalette.background,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 10),
                  child: Text("Personal Details",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: ColorPalette.secondary,
                          fontSize: SizeConfig.textMultiplier * 2,
                          fontWeight: FontWeight.bold)),
                )),
            _nameEditor(),
            _dobEditor(),
            _identitySelector(
                firstButtonTitle: "Woman",
                secondButtonTitle: 'Man',
                selectorTypeTitle: 'Identity (Optional)'),
            const SizedBox(
              height: 5,
            ),
            _marriageSelector(
                firstButtonTitle: "Yes",
                secondButtonTitle: 'No',
                selectorTypeTitle: 'Married? (Optional)'),
            Container(
              height: SizeConfig.heightMultiplier * 15,
              width: SizeConfig.fullWidth,
              color: ColorPalette.background,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 10),
                  child: Text("Address (Optional)",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: ColorPalette.secondary,
                          fontSize: SizeConfig.textMultiplier * 2,
                          fontWeight: FontWeight.bold)),
                )),
            _pinCodeEditor(),
            _addressLineEditor(),
            _localityEditor(),
            _cityEditor(),
            _stateEditor(),
            SizedBox(height: 20 * SizeConfig.heightMultiplier),
            Container(
              height: SizeConfig.heightMultiplier * 50,
              color: ColorPalette.background,
              width: SizeConfig.fullWidth,
              child: Center(
                child: Text.rich(
                  TextSpan(
                      text: 'I agree to  ',
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: ColorPalette.secondary,
                          fontSize: SizeConfig.textMultiplier * 1.5),
                      children: <InlineSpan>[
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: CustomStyleClass.onboardingBodyTextStyle
                              .copyWith(
                                  decoration: TextDecoration.underline,
                                  color: ColorPalette.secondary,
                                  fontSize: SizeConfig.textMultiplier * 1.5),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Container(),
                        ),
                        TextSpan(
                          text: ' and ',
                          style: CustomStyleClass.onboardingBodyTextStyle
                              .copyWith(
                                  color: ColorPalette.secondary,
                                  fontSize: SizeConfig.textMultiplier * 1.5),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Container(),
                        ),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: CustomStyleClass.onboardingBodyTextStyle
                              .copyWith(
                                  decoration: TextDecoration.underline,
                                  color: ColorPalette.secondary,
                                  fontSize: SizeConfig.textMultiplier * 1.5),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Container(),
                        )
                      ]),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  _myPic() {
    return Container(
      height: 200 * SizeConfig.heightMultiplier,
      color: ColorPalette.secondary,
      child: Center(
        child: Stack(clipBehavior: Clip.none, children: [
          Container(
            height: 180 * SizeConfig.heightMultiplier,
            width: 180 * SizeConfig.heightMultiplier,
            margin: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 15),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderRadius: const BorderRadius.all(Radius.circular(500)),
              child: CachedNetworkImage(
                imageUrl: _uploadedProfilePicURL == null
                    ? preferences!.getString('_userPhoto')!
                    : _uploadedProfilePicURL!,
                height: 180 * SizeConfig.heightMultiplier,
                width: 180 * SizeConfig.heightMultiplier,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: Image.asset(
                    AssetImageClass.appLogo,
                    color: ColorPalette.dark,
                    width: 100 * SizeConfig.heightMultiplier,
                    height: 100 * SizeConfig.heightMultiplier,
                  ),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Image.asset(
                    AssetImageClass.appLogo,
                    width: 100 * SizeConfig.heightMultiplier,
                    height: 100 * SizeConfig.heightMultiplier,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              bottom: SizeConfig.heightMultiplier * 15,
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
                              size: 5 * SizeConfig.imageSizeMultiplier,
                              color: ColorPalette.secondary),
                        ),
                      ),
                    ),
                  ),
                ),
              ))
        ]),
      ),
    );
  }

  _nameEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Full Name",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: SizeConfig.textMultiplier * 1.5,
                )),
            SizedBox(
              height: SizeConfig.heightMultiplier * 5,
            ),
            _textEditor(
                verified: false,
                prefixIcon: Icons.person_outline_outlined,
                controller: nameTextEditingController,
                readOnly: false,
                hintText: "User Name")
          ],
        ));
  }

  _dobEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Birthday (Optional)",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: SizeConfig.textMultiplier * 1.5,
                )),
            SizedBox(
              height: SizeConfig.heightMultiplier * 5,
            ),
            InkWell(
              onTap: () => _showDatePicker(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                decoration: BoxDecoration(
                    color: ColorPalette.white,
                    borderRadius: BorderRadius.circular(5.0),
                    border:
                        Border.all(width: 0.5, color: ColorPalette.secondary)),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      const SizedBox(width: 5),
                      const Icon(Icons.cake_outlined,
                          color: ColorPalette.secondary, size: 20),
                      // SizedBox(width: 10.0),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          userDoB != null ? userDoB! : 'No date time picked!',
                          style:
                              CustomStyleClass.onboardingBodyTextStyle.copyWith(
                            color: ColorPalette.secondary,
                            fontSize: SizeConfig.textMultiplier * 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  _phoneEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: _textEditor(
            verified: true,
            prefixIcon: Icons.phone_iphone_outlined,
            controller: phoneTextEditingController,
            readOnly: true,
            hintText: "Phone Number"));
  }

  _emailEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: _textEditor(
            verified: false,
            prefixIcon: Icons.email_outlined,
            controller: emailTextEditingController,
            readOnly: false,
            hintText: "Email Id"));
  }

  _pinCodeEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Area Pincode",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: SizeConfig.textMultiplier * 1.5,
                )),
            SizedBox(
              height: SizeConfig.heightMultiplier * 5,
            ),
            _textEditor(
                verified: false,
                prefixIcon: Icons.pin_drop_outlined,
                controller: pinCodeTextEditingController,
                readOnly: false,
                hintText: "Area Pincode")
          ],
        ));
  }

  _addressLineEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Address Line",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: SizeConfig.textMultiplier * 1.5,
                )),
            SizedBox(
              height: SizeConfig.heightMultiplier * 5,
            ),
            _textEditor(
                verified: false,
                prefixIcon: Icons.home_outlined,
                controller: addressLineTextEditingController,
                readOnly: false,
                hintText: "Address Line")
          ],
        ));
  }

  _localityEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Locality",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: SizeConfig.textMultiplier * 1.5,
                )),
            SizedBox(
              height: SizeConfig.heightMultiplier * 5,
            ),
            _textEditor(
                verified: false,
                prefixIcon: Icons.pin_drop_outlined,
                controller: localityTextEditingController,
                readOnly: false,
                hintText: "Locality")
          ],
        ));
  }

  _cityEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Town / City",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: SizeConfig.textMultiplier * 1.5,
                )),
            SizedBox(
              height: SizeConfig.heightMultiplier * 5,
            ),
            _textEditor(
                verified: false,
                prefixIcon: Icons.pin_drop_outlined,
                controller: cityTextEditingController,
                readOnly: false,
                hintText: "Town / City")
          ],
        ));
  }

  _stateEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("State",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: SizeConfig.textMultiplier * 1.5,
                )),
            SizedBox(
              height: SizeConfig.heightMultiplier * 5,
            ),
            _textEditor(
                verified: false,
                prefixIcon: Icons.pin_drop_outlined,
                controller: stateTextEditingController,
                readOnly: false,
                hintText: "State")
          ],
        ));
  }

  _identitySelector({
    required String selectorTypeTitle,
    required String firstButtonTitle,
    required String secondButtonTitle,
  }) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(selectorTypeTitle,
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: SizeConfig.textMultiplier * 1.5,
                )),
            SizedBox(
              height: SizeConfig.heightMultiplier * 5,
            ),
            _identitySelctorButtons(
              firstButtonTitle: firstButtonTitle,
              secondButtonTitle: secondButtonTitle,
            )
          ],
        ));
  }

  _marriageSelector({
    required String selectorTypeTitle,
    required String firstButtonTitle,
    required String secondButtonTitle,
  }) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(selectorTypeTitle,
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: SizeConfig.textMultiplier * 1.5,
                )),
            SizedBox(
              height: SizeConfig.heightMultiplier * 5,
            ),
            _marriageSelctorButtons(
              firstButtonTitle: firstButtonTitle,
              secondButtonTitle: secondButtonTitle,
            )
          ],
        ));
  }

  _textEditor({
    IconData? prefixIcon,
    TextEditingController? controller,
    bool? readOnly,
    bool verified = false,
    String? hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
          color: ColorPalette.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(width: 0.5, color: ColorPalette.secondary)),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            const SizedBox(width: 5),
            Icon(prefixIcon, color: ColorPalette.secondary, size: 20),
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
            verified
                ? Icon(CupertinoIcons.checkmark_alt_circle,
                    color: Colors.green.shade700)
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _bottomSheet() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              offset: const Offset(0, -2),
              color: ColorPalette.secondary.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 0),
        ]),
        height: 60,
        width: SizeConfig.fullWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: ColorPalette.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
                    content: Text("Fields Can not be Empty !",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white)),
                    duration: const Duration(milliseconds: 3000),
                  ));
                }
              },
              child: Text(
                "Save Changes",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 2,
                ),
              )),
        ),
      ),
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
              content: Text("$e!",
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
            if (kDebugMode) {
              print(fileURL.toString());
            }
            if (kDebugMode) {
              print(
                  'From Storage URL Upload: ${_uploadedProfilePicURL.toString()}');
            }
          });
          if (kDebugMode) {
            print("========================");
          }
        });
      });
    } catch (e) {
      EasyLoading.dismiss();
    }

    EasyLoading.dismiss();
  }

  Future<void> retrieveLostData(File image) async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        image = File(response.file!.path);
      });
    } else {
      if (kDebugMode) {
        print(response.file);
      }
    }
  }

  _identitySelctorButtons({
    required String firstButtonTitle,
    required String secondButtonTitle,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        InkWell(
          onTap: () {
            setState(() {
              identity = true;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: (identity == null
                      ? ColorPalette.dark
                      : identity == true
                          ? ColorPalette.primary
                          : identity == false
                              ? ColorPalette.dark
                              : ColorPalette.white)),
              color: (identity == null
                  ? ColorPalette.white
                  : identity == true
                      ? ColorPalette.primary
                      : identity == false
                          ? ColorPalette.white
                          : ColorPalette.white),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 15.0),
              child: Text(firstButtonTitle,
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      color: (identity == null
                          ? ColorPalette.dark
                          : identity == true
                              ? ColorPalette.white
                              : identity == false
                                  ? ColorPalette.dark
                                  : ColorPalette.white),
                      fontSize: SizeConfig.textMultiplier * 1.5,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        SizedBox(
          width: SizeConfig.widthMultiplier * 30,
        ),
        InkWell(
          onTap: () {
            setState(() {
              identity = false;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: (identity == null
                      ? ColorPalette.dark
                      : identity == false
                          ? ColorPalette.primary
                          : identity == true
                              ? ColorPalette.dark
                              : ColorPalette.white)),
              color: (identity == null
                  ? ColorPalette.white
                  : identity == false
                      ? ColorPalette.primary
                      : identity == true
                          ? ColorPalette.white
                          : ColorPalette.white),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 15.0),
              child: Text(secondButtonTitle,
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      color: (identity == null
                          ? ColorPalette.dark
                          : identity == false
                              ? ColorPalette.white
                              : identity == true
                                  ? ColorPalette.dark
                                  : ColorPalette.white),
                      fontSize: SizeConfig.textMultiplier * 1.5,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        )
      ]),
    );
  }

  _marriageSelctorButtons({
    required String firstButtonTitle,
    required String secondButtonTitle,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        InkWell(
          onTap: () {
            setState(() {
              married = true;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: (married == null
                      ? ColorPalette.dark
                      : married == true
                          ? ColorPalette.primary
                          : married == false
                              ? ColorPalette.dark
                              : ColorPalette.white)),
              color: (married == null
                  ? ColorPalette.white
                  : married == true
                      ? ColorPalette.primary
                      : married == false
                          ? ColorPalette.white
                          : ColorPalette.white),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 15.0),
              child: Text(firstButtonTitle,
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      color: (married == null
                          ? ColorPalette.dark
                          : married == true
                              ? ColorPalette.white
                              : married == false
                                  ? ColorPalette.dark
                                  : ColorPalette.white),
                      fontSize: SizeConfig.textMultiplier * 1.5,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        SizedBox(
          width: SizeConfig.widthMultiplier * 30,
        ),
        InkWell(
          onTap: () {
            setState(() {
              married = false;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: (married == null
                      ? ColorPalette.dark
                      : married == false
                          ? ColorPalette.primary
                          : married == true
                              ? ColorPalette.dark
                              : ColorPalette.white)),
              color: (married == null
                  ? ColorPalette.white
                  : married == false
                      ? ColorPalette.primary
                      : married == true
                          ? ColorPalette.white
                          : ColorPalette.white),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 15.0),
              child: Text(secondButtonTitle,
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      color: (married == null
                          ? ColorPalette.dark
                          : married == false
                              ? ColorPalette.white
                              : married == true
                                  ? ColorPalette.dark
                                  : ColorPalette.white),
                      fontSize: SizeConfig.textMultiplier * 1.5,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        )
      ]),
    );
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
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (BuildContext context) {
                return const WelcomeScreen();
              },
            ),
            (_) => true,
          );

          // pushNewScreenWithRouteSettings(
          //   context,
          //   screen: const WelcomeScreen(),
          //   settings: const RouteSettings(name: WelcomeScreen.id),
          //   withNavBar: false,
          //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
          // );
        });
      }
    });
  }
}
