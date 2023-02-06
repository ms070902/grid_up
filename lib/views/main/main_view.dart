import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/state/auth/providers/auth_state_provider.dart';
import 'package:nexus/state/image_upload/helpers/image_picker_helper.dart';
import 'package:nexus/state/image_upload/models/file_type.dart';
import 'package:nexus/state/post_settings/providers/post_settings_provider.dart';
import 'package:nexus/views/components/dialogs/alert_dialog_model.dart';
import 'package:nexus/views/constants/strings.dart';
import 'package:nexus/views/create_new_post/create_new_post_view.dart';
import 'package:nexus/views/tabs/home_view.dart';
import 'package:nexus/views/tabs/search/search_view.dart';
import 'package:nexus/views/tabs/user_posts/user_posts_view.dart';

import '../components/dialogs/logout_dialog.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  int _selectedIndex = 0;
  static const List<ConsumerWidget> _widgetViews = <ConsumerWidget>[
    HomeView(),
    SearchView(),
    UserPostsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.appName,
          style: TextStyle(
            color: Colors.blueGrey,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              ///pick a video
              final videoFile = await ImagePickerHelper.pickVideoFromGallery();
              if (videoFile == null) {
                return;
              }
              ref.refresh(postSettingsProvider);

              ///go to the screen to create new post
              if (!mounted) {
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateNewPostView(
                    fileToPost: videoFile,
                    fileType: FileType.video,
                  ),
                ),
              );
            },
            icon: const FaIcon(
              FontAwesomeIcons.film,
            ),
            color: Colors.blueGrey,
          ),
          IconButton(
            onPressed: () async {
              ///pick an image
              final imageFile = await ImagePickerHelper.pickImageFromGallery();
              if (imageFile == null) {
                return;
              }
              ref.refresh(postSettingsProvider);

              ///go to the screen to create new post
              if (!mounted) {
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateNewPostView(
                    fileToPost: imageFile,
                    fileType: FileType.image,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.add_photo_alternate_outlined,
            ),
            color: Colors.blueGrey,
          ),
          IconButton(
            onPressed: () async {
              final shouldLogOut =
                  await const LogoutDialog().present(context).then(
                        (value) => value ?? false,
                      );
              if (shouldLogOut) {
                await ref.read(authStateProvider.notifier).logOut();
              }
            },
            icon: const Icon(
              Icons.logout,
            ),
            color: Colors.blueGrey,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.search,
            ),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        animationDuration: const Duration(milliseconds: 1000),
      ),
      body: _widgetViews.elementAt(_selectedIndex),
    );
  }
}
