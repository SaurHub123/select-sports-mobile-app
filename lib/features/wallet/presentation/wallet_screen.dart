import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:iconsax/iconsax.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:select_sports/core/constants/theme_constants.dart';
import 'package:select_sports/core/models/wallet_model.dart';
import 'package:select_sports/features/wallet/presentation/wallet_controller.dart';

import '../../../providers/theme_provider.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  late ScrollController _scrollController;
  late Future<WalletResponse?> _walletFuture;
  bool _isScrolled = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScrollChange);

    super.initState();
    final walletController = ref.read(walletControllerProvider);
    _walletFuture = walletController.getWalletDetails();
  }

  void _listenToScrollChange() {
    if (_scrollController.offset >= 100.0) {
      setState(() {
        _isScrolled = true;
      });
    } else {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    // final authController = ref.read(authControllerProvider);
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
    final walletState = ref.watch(walletControllerProvider);

    return Scaffold(
      body: FutureBuilder(
          future: _walletFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error fetching slots"));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Text(
                  "No slots available for now",
                  style: TextStyle(
                    color:
                        isDarkMode ? AppColors.lightText : AppColors.darkText,
                  ),
                ),
              );
            }

            var walletDetail = snapshot.data!.wallet;
            var transactionDetail = snapshot.data!.transactions;

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: 250.0,
                  elevation: 0,
                  pinned: true,
                  stretch: true,
                  toolbarHeight: 80,
                  backgroundColor:
                      isDarkMode ? AppColors.darkGreyColor : Colors.white,
                  leading: IconButton(
                    color:
                        isDarkMode ? AppColors.lightestGreyColor : Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: ValueListenableBuilder<AdvancedDrawerValue>(
                      valueListenable: _advancedDrawerController,
                      builder: (_, value, __) {
                        return AnimatedSwitcher(
                          duration: Duration(milliseconds: 250),
                          child: Icon(
                            Icons.arrow_back_sharp,
                          ),
                        );
                      },
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  centerTitle: true,
                  title: AnimatedOpacity(
                    opacity: _isScrolled ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Column(
                      children: [
                        Text(
                          '₹ ${walletDetail.balance.toString()}',
                          style: TextStyle(
                            color:
                                isDarkMode ? AppColors.lightText : Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 30,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppColors.lightestGreyColor
                                : Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    titlePadding: const EdgeInsets.only(left: 20, right: 20),
                    title: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: _isScrolled ? 0.0 : 1.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FadeIn(
                            duration: const Duration(milliseconds: 500),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '₹',
                                  style: TextStyle(
                                      color: isDarkMode
                                          ? AppColors.lightestGreyColor
                                          : Colors.grey.shade800,
                                      fontSize: 22),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  walletDetail.balance.toString(),
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? AppColors.lightText
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // FadeIn(
                          //   duration: const Duration(milliseconds: 500),
                          //   child: MaterialButton(
                          //     height: 30,
                          //     padding:
                          //         EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          //     onPressed: () {
                          //       Navigator.pushNamed(context, '/addMoney');
                          //     },
                          //     color: Colors.transparent,
                          //     elevation: 0,
                          //     shape: RoundedRectangleBorder(
                          //       side:
                          //           BorderSide(color: Colors.grey.shade300, width: 1),
                          //       borderRadius: BorderRadius.circular(30),
                          //     ),
                          //     child: Text(
                          //       'Add Money',
                          //       style: TextStyle(
                          //           color: isDarkMode
                          //               ? AppColors.lightText
                          //               : Colors.black,
                          //           fontSize: 10),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 30,
                            height: 3,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppColors.lightestGreyColor
                                  : Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Column(
                      children: [
                        FadeInDown(
                          duration: Duration(milliseconds: 500),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Transactions',
                                style: TextStyle(
                                    color: isDarkMode
                                        ? AppColors.lightestGreyColor
                                        : Colors.grey.shade800,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              // Text(
                              //   '₹ ${walletDetail.balance}',
                              //   style: TextStyle(
                              //     color: isDarkMode
                              //         ? AppColors.lightText
                              //         : Colors.black,
                              //     fontSize: 16,
                              //     fontWeight: FontWeight.w700,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.only(top: 20),
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: transactionDetail.length,
                            itemBuilder: (context, index) {
                              return FadeInDown(
                                duration: Duration(milliseconds: 500),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? AppColors.darkLightBackground
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            transactionDetail[index].method ==
                                                    "RAZORPAY"
                                                ? "assets/images/razorpay.png"
                                                : "assets/images/wallet.jpg",
                                            width: 50,
                                            height: 50,
                                          ),
                                          SizedBox(width: 15),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                transactionDetail[index].method,
                                                style: TextStyle(
                                                  color: isDarkMode
                                                      ? AppColors
                                                          .lightestGreyColor
                                                      : Colors.grey.shade900,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                transactionDetail[index]
                                                    .updatedAt,
                                                style:
                                                    AppTextStyles.body.copyWith(
                                                  color: isDarkMode
                                                      ? AppColors.darkBlue
                                                      : Colors.grey.shade500,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text(
                                        (transactionDetail[index].method !=
                                                        "WALLET" ||
                                                    (transactionDetail[index]
                                                                .method ==
                                                            "WALLET" &&
                                                        transactionDetail[index]
                                                                .walletTxn!
                                                                .transactionType !=
                                                            "CREDIT")
                                                ? "-"
                                                : "+") +
                                            transactionDetail[index]
                                                .amount
                                                .toString(),
                                        style: AppTextStyles.body.copyWith(
                                          color: transactionDetail[index]
                                                          .method !=
                                                      "WALLET" ||
                                                  (transactionDetail[index]
                                                              .method ==
                                                          "WALLET" &&
                                                      transactionDetail[index]
                                                              .walletTxn!
                                                              .transactionType !=
                                                          "CREDIT")
                                              ? AppColors.redColor
                                              : AppColors.darkGreenColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}
