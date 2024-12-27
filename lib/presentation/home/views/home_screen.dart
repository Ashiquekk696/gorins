import 'package:app_ui/app_ui.dart'; 
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gorins/di/di.dart';
import 'package:gorins/presentation/auth/providers/auth_provider.dart'; 
import 'package:gorins/presentation/home/providers/home_provider.dart';
import 'package:provider/provider.dart';
 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 20),
        child: CustomButton(text: "Logout", onPressed: () {
          getItInstance<AuthProvider>().signout(context: context);
        }),
      ),
      appBar: AppBar(
        leadingWidth: 0,
        leading: const SizedBox(
          width: 0,
        ),
        title: const Text(
          "Users",
          style: AppTextStyle.bodyXLCap,
        ),
        backgroundColor: AppColors.lightGrey,
        elevation: 4.0, // Shadow effect for the AppBar
      ),
      body: Consumer<HomeProvider>(builder: (context, homeProvider, child) {
        return homeProvider.usersList.isEmpty
            ? const Center(
                // ignore: prefer_const_constructors
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: homeProvider.usersList.length,
                itemBuilder: (context, index) {
                  final user = homeProvider.usersList[index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: user.profilePic ?? "",
                                placeholder: (context, url) => const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            16.0.w,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.username,
                                    style: AppTextStyle.bodyXL600
                                        .copyWith(color: AppColors.black)),
                                2.0.h,
                                Text(user.email,
                                    style: AppTextStyle.heading
                                        .copyWith(color: AppColors.black)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                },
              );
      }),
    );
  }
}
