import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileLogoutButton extends StatelessWidget {
  final void Function() onTap;

  const ProfileLogoutButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
          child: const Center(
            child: Text(
              "로그아웃",
              style: TextStyle(
                color: CupertinoColors.systemRed,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
