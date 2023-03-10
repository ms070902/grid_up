import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus/views/components/constants/strings.dart';

import '../../components/constants/app_colors.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.signOut,
            color: AppColors.googleColor,
          ),
          const SizedBox(
            width: 10.0,
          ),
          const Text(
            Strings.logOut,
          ),
        ],
      ),
    );
  }
}
