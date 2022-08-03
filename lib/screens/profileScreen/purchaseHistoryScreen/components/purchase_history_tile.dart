import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../models/purchase_history_model.dart';
import '../../../../utils/asset_images_strings.dart';
import '../../../../utils/color_palette.dart';
import '../../../../utils/custom_styles.dart';
import '../../../../utils/size_config.dart';
import 'history_details_screen.dart';

class PurchaseHistoryTile extends StatefulWidget {
  final PurchaseHistoryModel model;

  const PurchaseHistoryTile({Key? key, required this.model}) : super(key: key);

  @override
  State<PurchaseHistoryTile> createState() => _PurchaseHistoryTileState();
}

class _PurchaseHistoryTileState extends State<PurchaseHistoryTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.0),
      onTap: () {
        Navigator.pushNamed(context, HistoryDetailsScreen.id,
            arguments: widget.model);
      },
      child: Container(
        height: SizeConfig.heightMultiplier * 121,
        width: SizeConfig.fullWidth,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: ColorPalette.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  // color: ColorPalette.primary.withOpacity(0.2),
                  border: Border.all(color: ColorPalette.dark, width: 0.5)),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    height: SizeConfig.heightMultiplier * 120,
                    width: SizeConfig.heightMultiplier * 100,
                    child: CachedNetworkImage(
                      imageUrl: widget.model.moviePoster!,
                      width: MediaQuery.of(context).size.width,
                      height: double.infinity,
                      fit: BoxFit.fill,
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
                  SizedBox(
                    width: SizeConfig.widthMultiplier * 60,
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.model.moviveName!,
                          maxLines: 1,
                          style: CustomStyleClass.onboardingBodyTextStyle
                              .copyWith(
                                  color: ColorPalette.secondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.textMultiplier * 1.6),
                        ),
                        const Expanded(
                          child: SizedBox(
                            height: 1,
                          ),
                        ),
                        Text(
                          widget.model.movieTheaterName!,
                          maxLines: 1,
                          style: CustomStyleClass.onboardingBodyTextStyle
                              .copyWith(
                                  color: ColorPalette.secondary,
                                  fontSize: SizeConfig.textMultiplier * 1.4),
                        ),
                        const Expanded(
                          child: SizedBox(
                            height: 1,
                          ),
                        ),
                        Text(
                          "${widget.model.movieDate} | ${widget.model.movieTime}",
                          maxLines: 1,
                          style: CustomStyleClass.onboardingBodyTextStyle
                              .copyWith(
                                  color: ColorPalette.secondary,
                                  fontSize: SizeConfig.textMultiplier * 1.4),
                        ),
                        const Expanded(
                          child: SizedBox(
                            height: 1,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                    color:
                                        ColorPalette.primary.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Text(
                                  widget.model.bookingId!,
                                  maxLines: 1,
                                  style: CustomStyleClass
                                      .onboardingBodyTextStyle
                                      .copyWith(
                                          color: ColorPalette.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              SizeConfig.textMultiplier * 1.5),
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    "${widget.model.numberOfTickets} ",
                                    maxLines: 1,
                                    style: CustomStyleClass
                                        .onboardingBodyTextStyle
                                        .copyWith(
                                            color: ColorPalette.secondary,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    1.5),
                                  ),
                                  const Icon(
                                    CupertinoIcons.tickets_fill,
                                    size: 12,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(
                    width: 5,
                  ),
                  RotatedBox(
                    quarterTurns: -1,
                    child: Text("\nM-Ticket",
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.textMultiplier * 1.5)),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: SizeConfig.heightMultiplier * 100,
              child: halfCircleDivider(),
            )
          ],
        ),
      ),
    );
  }

  Widget halfCircleDivider() {
    return SizedBox(
      // height: SizeConfig.heightMultiplier * 120,
      width: SizeConfig.widthMultiplier * 60,
      child: Stack(
        children: [
          const Center(
              child: VerticalDivider(
            indent: 8,
            endIndent: 8,
            color: ColorPalette.background,
            thickness: 0.8,
          )),
          Positioned(
              left: 0,
              top: -(SizeConfig.widthMultiplier * 45),
              right: 0,
              child: CircleAvatar(
                backgroundColor: ColorPalette.dark,
                radius: SizeConfig.widthMultiplier * 30,
                child: CircleAvatar(
                  backgroundColor: ColorPalette.background,
                  radius: SizeConfig.widthMultiplier * 28.5,
                ),
              )),
          Positioned(
              right: 0,
              left: 0,
              bottom: -(SizeConfig.widthMultiplier * 45),
              child: CircleAvatar(
                backgroundColor: ColorPalette.dark,
                radius: SizeConfig.widthMultiplier * 30,
                child: CircleAvatar(
                  backgroundColor: ColorPalette.background,
                  radius: SizeConfig.widthMultiplier * 28.5,
                ),
              ))
        ],
      ),
    );
  }
}
