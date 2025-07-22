import 'package:am_user/controller/user_provider/get_user_provider.dart';
import 'package:am_user/modals/userModal.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../responsive/reponsive_layout.dart';
import '../widgets/component/banner_image.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 0;
  late final List<Widget> slider;

  @override
  void initState() {
    super.initState();
    slider = List.generate(6, (index) => const BannerImageWidget());
  }

  PreferredSizeWidget buildAppBar(bool isMobile, bool isDesktop) {
    return AppBar(
      backgroundColor: isMobile ? Colors.blue : Colors.transparent,
      elevation: 0,
      title: const Text(
        "Profile",
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: !isDesktop,
      // leading: IconButton(
      //   icon: const Icon(Icons.arrow_back, color: Colors.white),
      //   onPressed: () => Navigator.pop(context),
      // ),
      leading: null,
    );
  }

  final userController = Get.find<GetUserController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTab(context);
    final isMobile = !isDesktop && !isTablet;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.pop();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        extendBodyBehindAppBar: !isMobile,
        appBar: buildAppBar(isMobile, isDesktop),
        body:userController.myUser == null
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header Sliver
            SliverToBoxAdapter(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Background Cover Image
                  Container(
                    height: isDesktop ? 400 : isTablet ? 300 : 200,
                    width: size.width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/images/bcfeb299090d3fec14a41657b98537e0.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Profile Content
                  Positioned(
                    top: isDesktop ? 300 : isTablet ? 200 : 150,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white, width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: isDesktop
                                ? 80
                                : isTablet
                                ? 60
                                : 50,
                            backgroundImage:
                            userController.myUser!.image != null ?NetworkImage(userController.myUser!.image!): AssetImage("assets/images/d37b020e87945ad7f245e48df752ed03.jpg")
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userController.myUser!.name!,
                          style: TextStyle(
                            color: customTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: isDesktop ? 24 : 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          userController.myUser!.email!,
                          style: TextStyle(
                            color: customTextColor,
                            fontSize: isDesktop ? 16 : 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userController.myUser!.contact!,
                          style: TextStyle(
                            color: customTextColor,
                            fontSize: isDesktop ? 16 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),


            // Spacer between header and content
            SliverToBoxAdapter(
              child: SizedBox(
                  height: isDesktop ? 80 : isTablet ? 100 : 170),
            ),

            // Main Content Sliver
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 80 : isTablet ? 40 : 16,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Carousel Section
                  Column(
                    children: [
                      CarouselSlider(
                        items: slider,
                        options: CarouselOptions(
                          height: isDesktop
                              ? 400
                              : isTablet
                              ? 250
                              : 180,
                          viewportFraction: isDesktop ? 0.8 : 0.9,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          autoPlayInterval:
                          const Duration(seconds: 3),
                          autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                          onPageChanged: (index, _) {
                            setState(() => _currentIndex = index);
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: slider.asMap().entries.map((entry) {
                          return Container(
                            width: _currentIndex == entry.key ? 12 : 8,
                            height: _currentIndex == entry.key ? 12 : 8,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == entry.key
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
