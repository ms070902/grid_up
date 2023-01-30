import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/state/auth/providers/auth_state_provider.dart';
import 'package:nexus/state/image_upload/helpers/image_picker_helper.dart';
import 'package:nexus/state/image_upload/models/file_type.dart';
import 'package:nexus/state/post_settings/providers/post_settings_provider.dart';
import 'package:nexus/views/constants/strings.dart';
import 'package:nexus/views/create_new_post/create_new_post_view.dart';
import 'package:nexus/views/tabs/user_posts/user_posts_view.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  int _selectedIndex = 0;
  static const List<ConsumerWidget> _widgetViews = <ConsumerWidget>[
    UserPostsView(),
    UserPostsView(),
    UserPostsView(),
  ];

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.appName,
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
          ),
          IconButton(
            onPressed: ref.read(authStateProvider.notifier).logOut,
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTapped,
      ),
      body: _widgetViews.elementAt(_selectedIndex),
    );
  }
}
