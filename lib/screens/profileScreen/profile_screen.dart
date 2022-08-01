import 'package:book_my_show_clone/main.dart';
import 'package:book_my_show_clone/screens/profileScreen/editProfileScreen/edit_profile_screen.dart';
import 'package:book_my_show_clone/utils/asset_images_strings.dart';
import 'package:book_my_show_clone/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/color_palette.dart';
import '../../utils/custom_styles.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = "profile-screen";
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                      pushNewScreenWithRouteSettings(
                        context,
                        screen: const EditProfileScreen(),
                        settings:
                            const RouteSettings(name: EditProfileScreen.id),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      ).then((value) {
                        setState(() {});
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
      //bottomNavigationBar: edit == false ? const SizedBox() : _bottomSheet()
    );
  }

  Widget _body() {
    return Container(
        height: MediaQuery.of(context).size.height - 80,
        width: MediaQuery.of(context).size.width,
        color: ColorPalette.background,
        padding: const EdgeInsets.only(top: 0),
        child: sliverUpperSection()
        // : Stack(
        //     children: [
        //       Column(
        //         children: [
        //           _myPic(),
        //           const SizedBox(
        //             height: 40,
        //           ),
        //           Column(children: [
        //             _nameEditor(),
        //             _emailEditor(),
        //             _phoneEditor(),
        //           ]),
        //         ],
        //       ),
        //       Positioned(
        //           right: 5,
        //           top: 5,
        //           child: RoundedIconBtn(
        //             icon: Icons.close,
        //             bgColor: const Color(0XFFe8f5fe),
        //             iconSize: 22,
        //             press: () {
        //               setState(() {
        //                 edit = !edit;
        //               });
        //             },
        //           ))
        //     ],
        //   ),
        );
  }

  Widget sliverUpperSection() {
    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(
          height: SizeConfig.heightMultiplier * 18,
        ),
        // Stack(
        //   children: [
        //     Container(
        //       padding: const EdgeInsets.only(
        //           top: 20, bottom: 20, left: 10, right: 5),
        //       decoration: BoxDecoration(
        //         borderRadius: const BorderRadius.only(
        //             topLeft: Radius.circular(30),
        //             topRight: Radius.circular(5),
        //             bottomLeft: Radius.circular(5),
        //             bottomRight: Radius.circular(30)),
        //         color: ColorPalette.secondary.withOpacity(0.5),
        //       ),
        //       width: MediaQuery.of(context).size.width,
        //       child: Row(
        //         children: [
        //           Container(
        //             height: 150 * SizeConfig.heightMultiplier,
        //             width: 150 * SizeConfig.heightMultiplier,
        //             decoration: BoxDecoration(
        //               shape: BoxShape.circle,
        //               border: Border.all(
        //                 width: 1,
        //                 color: Colors.black,
        //               ),
        //               boxShadow: [
        //                 BoxShadow(
        //                     spreadRadius: 0.5,
        //                     blurRadius: 0.5,
        //                     color: Colors.black.withOpacity(0.5),
        //                     offset: const Offset(0.7, 0.7))
        //               ],
        //             ),
        //             child: ClipRRect(
        //               clipBehavior: Clip.antiAliasWithSaveLayer,
        //               borderRadius:
        //                   const BorderRadius.all(Radius.circular(500)),
        //               child: CachedNetworkImage(
        //                 imageUrl: _uploadedProfilePicURL == null
        //                     ? preferences!.getString('_userPhoto')!
        //                     : _uploadedProfilePicURL!,
        //                 width: MediaQuery.of(context).size.width,
        //                 height: 200,
        //                 fit: BoxFit.cover,
        //                 placeholder: (context, url) =>
        //                     const CircularProgressIndicator(),
        //                 errorWidget: (context, url, error) =>
        //                     const Icon(Icons.error),
        //               ),
        //             ),
        //           ),
        //           const SizedBox(width: 20),
        //           Expanded(
        //             child: SizedBox(
        //               height: 120 * SizeConfig.heightMultiplier,
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 mainAxisSize: MainAxisSize.max,
        //                 children: [
        //                   Text(
        //                     nameTextEditingController.text,
        //                     style: Theme.of(context).textTheme.headline6,
        //                     maxLines: 1,
        //                   ),
        //                   Text(
        //                     emailTextEditingController.text,
        //                     style: Theme.of(context).textTheme.bodyText1,
        //                   ),
        //                   Text(
        //                     phoneTextEditingController.text,
        //                     style: Theme.of(context).textTheme.bodyText1,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           )
        //         ],
        //       ),
        //     ),
        //     Positioned(
        //         right: 5,
        //         top: 5,
        //         child: RoundedIconBtn(
        //           icon: Icons.edit_outlined,
        //           bgColor: const Color(0XFFe8f5fe),
        //           iconSize: 22,
        //           press: () {
        //             setState(() {
        //               edit = !edit;
        //             });
        //           },
        //         ))
        //   ],
        // ),
        // const SizedBox(
        //   height: 20,
        // ),

        Container(
          color: ColorPalette.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                tileColor: ColorPalette.primary,
                dense: true,
                onTap: () {},
                leading: const Icon(
                  Icons.shopping_cart_checkout_rounded,
                  color: Colors.black,
                  //  size: SizeConfig.heightMultiplier * 25,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                  size: SizeConfig.heightMultiplier * 25,
                ),
                title: Text('Purchase History',
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: ColorPalette.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 2)),
                subtitle: Text("View all your booking and purchases",
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: ColorPalette.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 1.4)),
              ),
              const Divider(
                thickness: 1,
                height: 0,
              ),
              ListTile(
                tileColor: ColorPalette.primary,
                dense: true,
                onTap: () {},
                leading: const Icon(
                  Icons.video_library_outlined,
                  color: Colors.black,
                  //  size: SizeConfig.heightMultiplier * 25,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                  size: SizeConfig.heightMultiplier * 25,
                ),
                title: Text('Stream Library',
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: ColorPalette.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 2)),
                subtitle: Text("Rented, Purchased and Downloaded movies",
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: ColorPalette.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 1.4)),
              ),
              const Divider(
                thickness: 1,
                height: 0,
              ),
              ListTile(
                tileColor: ColorPalette.primary,
                dense: true,
                onTap: () {},
                leading: const Icon(
                  Icons.messenger_outline,
                  color: Colors.black,
                  //  size: SizeConfig.heightMultiplier * 25,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                  size: SizeConfig.heightMultiplier * 25,
                ),
                title: Text('Help & Support',
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: ColorPalette.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 2)),
                subtitle: Text("View commonly asked questions and Chat",
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: ColorPalette.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 1.5)),
              ),
              const Divider(
                thickness: 1,
                height: 0,
              ),
              ListTile(
                tileColor: ColorPalette.primary,
                dense: true,
                onTap: () {},
                leading: const Icon(
                  Icons.settings_outlined,
                  color: Colors.black,
                  //  size: SizeConfig.heightMultiplier * 25,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                  size: SizeConfig.heightMultiplier * 25,
                ),
                title: Text('Accounts & Settings',
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: ColorPalette.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 2)),
                subtitle: Text("View commonly asked questions and Chat",
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: ColorPalette.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 1.5)),
              ),
              const Divider(
                thickness: 1,
                height: 0,
              ),
            ],
          ),
        ),

        SizedBox(
          height: SizeConfig.heightMultiplier * 18,
        ),
        Container(
          color: ColorPalette.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                tileColor: ColorPalette.primary,
                //  dense: true,
                onTap: () {},
                leading: const Icon(
                  Icons.discount_outlined,
                  color: Colors.black,
                  //  size: SizeConfig.heightMultiplier * 25,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                  size: SizeConfig.heightMultiplier * 25,
                ),
                title: Text('Restaurant Discounts',
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: ColorPalette.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 2)),
              ),
              const Divider(
                thickness: 1,
                height: 0,
              ),
              ListTile(
                tileColor: ColorPalette.primary,
                // dense: true,
                onTap: () {},
                leading: const Icon(
                  CupertinoIcons.tickets,
                  color: Colors.black,
                  //  size: SizeConfig.heightMultiplier * 25,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                  size: SizeConfig.heightMultiplier * 25,
                ),
                title: Text('Discount Store',
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: ColorPalette.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 2)),
              ),
              const Divider(
                thickness: 1,
                height: 0,
              ),
              ListTile(
                tileColor: ColorPalette.primary,
                dense: true,
                onTap: () {},
                leading: const Icon(
                  CupertinoIcons.gift,
                  color: Colors.black,
                  //  size: SizeConfig.heightMultiplier * 25,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                  size: SizeConfig.heightMultiplier * 25,
                ),
                title: Text('Rewards',
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: ColorPalette.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 2)),
                subtitle: Text("View your rewars & unlock new ones",
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: ColorPalette.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 1.5)),
              ),
              const Divider(
                thickness: 1,
                height: 0,
              ),
              ListTile(
                tileColor: ColorPalette.primary,
                //dense: true,
                onTap: () {},
                leading: const Icon(
                  CupertinoIcons.checkmark_seal,
                  color: Colors.black,
                  //  size: SizeConfig.heightMultiplier * 25,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                  size: SizeConfig.heightMultiplier * 25,
                ),
                title: Text('Offers',
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: ColorPalette.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 2)),
              ),
              const Divider(
                thickness: 1,
                height: 0,
              ),
              ListTile(
                tileColor: ColorPalette.primary,
                //dense: true,
                onTap: () {},
                leading: const Icon(
                  CupertinoIcons.gift_alt,
                  color: Colors.black,
                  //  size: SizeConfig.heightMultiplier * 25,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                  size: SizeConfig.heightMultiplier * 25,
                ),
                title: Text('Gift Cards',
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: ColorPalette.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 2)),
              ),
              const Divider(
                thickness: 1,
                height: 0,
              ),
              ListTile(
                tileColor: ColorPalette.primary,
                //dense: true,
                onTap: () {},
                leading: const Icon(
                  Icons.fastfood_outlined,
                  color: Colors.black,
                  //  size: SizeConfig.heightMultiplier * 25,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                  size: SizeConfig.heightMultiplier * 25,
                ),
                title: Text('Food & Beverages',
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: ColorPalette.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 2)),
              ),
              const Divider(
                thickness: 1,
                height: 0,
              ),
              ListTile(
                tileColor: ColorPalette.primary,
                //dense: true,
                onTap: () {},
                leading: const Icon(
                  Icons.broadcast_on_home_rounded,
                  color: Colors.black,
                  //  size: SizeConfig.heightMultiplier * 25,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                  size: SizeConfig.heightMultiplier * 25,
                ),
                title: Text('List Your Show',
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: ColorPalette.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 2)),
              ),
              const Divider(
                thickness: 1,
                height: 0,
              ),
            ],
          ),
        ),

        SizedBox(
          height: SizeConfig.heightMultiplier * 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Share.share(
                          'Check out Book My Show Clone App \n http://www.virtualemployee.co.in',
                        );
                      },
                      child: Text("Share",
                          style: CustomStyleClass.onboardingBodyTextStyle
                              .copyWith(
                                  decoration: TextDecoration.underline,
                                  color: ColorPalette.secondary,
                                  letterSpacing: 0.5,
                                  fontSize: SizeConfig.textMultiplier * 1.5)),
                    ),
                    Container(
                      height: 15,
                      width: 1,
                      color: ColorPalette.secondary,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text("Rate Us",
                          style: CustomStyleClass.onboardingBodyTextStyle
                              .copyWith(
                                  color: ColorPalette.secondary,
                                  decoration: TextDecoration.underline,
                                  letterSpacing: 0.5,
                                  fontSize: SizeConfig.textMultiplier * 1.5)),
                    ),
                    Container(
                      height: 15,
                      width: 1,
                      color: ColorPalette.secondary,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text("Book a Smile",
                          style: CustomStyleClass.onboardingBodyTextStyle
                              .copyWith(
                                  color: ColorPalette.secondary,
                                  letterSpacing: 0.5,
                                  fontSize: SizeConfig.textMultiplier * 1.5)),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 5,
              ),
              Text("App Version: 0.0.1",
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      color: ColorPalette.secondary,
                      fontSize: SizeConfig.textMultiplier * 1.6)),
              SizedBox(
                height: SizeConfig.heightMultiplier * 18,
              ),
            ],
          ),
        )
        // ListTile(
        //   onTap: () {},
        //   leading: Container(
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(8),
        //         color: ColorPalette.secondary.withOpacity(0.5)),
        //     child: const Padding(
        //       padding: EdgeInsets.all(8.0),
        //       child: Icon(Icons.call, color: Colors.white, size: 20),
        //     ),
        //   ),
        //   title: Text('CONTACT US',
        //       style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
        //           color: ColorPalette.secondary,
        //           fontWeight: FontWeight.bold,
        //           fontSize: SizeConfig.textMultiplier * 2)),
        // ),
        // const Divider(),
        // ListTile(
        //   onTap: () {
        //     Share.share(
        //       'Check out Chat App \n http://www.virtualemployee.co.in',
        //     );
        //   },
        //   leading: Container(
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(8),
        //         color: ColorPalette.secondary.withOpacity(0.5)),
        //     child: const Padding(
        //       padding: EdgeInsets.all(8.0),
        //       child: Icon(Icons.share_outlined, color: Colors.white, size: 20),
        //     ),
        //   ),
        //   title: Text("SHARE",
        //       style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
        //           color: ColorPalette.secondary,
        //           fontWeight: FontWeight.bold,
        //           fontSize: SizeConfig.textMultiplier * 2)),
        // ),
        // const Divider(),
        // ListTile(
        //   onTap: () {
        //     showDialog();
        //   },
        //   leading: Container(
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(8),
        //         color: ColorPalette.secondary.withOpacity(0.5)),
        //     child: const Padding(
        //       padding: EdgeInsets.all(8.0),
        //       child: Icon(Icons.logout, color: Colors.white, size: 20),
        //     ),
        //   ),
        //   title: Text("LOGOUT",
        //       style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
        //           color: ColorPalette.secondary,
        //           fontWeight: FontWeight.bold,
        //           fontSize: SizeConfig.textMultiplier * 2)),
        // ),
        // const Divider(),
      ],
    ));
  }
}
