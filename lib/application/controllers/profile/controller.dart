import 'package:album/application/controller.dart';
import 'package:album/application/controllers/profile/widgets/login_button.dart';
import 'package:album/application/controllers/profile/widgets/menu.dart';
import 'package:album/application/stores/user.dart';
import 'package:album/application/widgets/button.dart';
import 'package:album/application/widgets/menu_container.dart';
import 'package:album/core/controller/arguments.dart';
import 'package:album/core/controller/controller.dart';
import 'package:album/core/event/event.dart';
import 'package:flutter/cupertino.dart';

class Profile extends Controller {
  Profile({Key? key})
      : super(
          const Arguments(),
          key: key,
        );

  @override
  Widget render(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    of<App>().require<UserStore>().subscribe(
                          onNext: (data) => Container(),
                          onLoad: () => CupertinoFormSection(
                            header: const Text("계정"),
                            children: [
                              ProfileMenu(
                                onTap: () {},
                                prefix: const Text(
                                  "로그인",
                                  style: TextStyle(
                                      color: CupertinoColors.activeBlue),
                                ),
                                child: const Icon(
                                  CupertinoIcons.chevron_forward,
                                  size: 20.0,
                                  color: CupertinoColors.systemGrey3,
                                ),
                              ),
                            ],
                          ),
                        ),
                    CupertinoFormSection(
                      header: const Text("일반"),
                      children: [
                        ProfileMenu(
                          onTap: () {},
                          prefix: const Text("서비스이용약관"),
                          child: const Icon(
                            CupertinoIcons.chevron_forward,
                            size: 20.0,
                            color: CupertinoColors.systemGrey3,
                          ),
                        ),
                        ProfileMenu(
                          onTap: () {},
                          prefix: const Text("개인정보처리방침"),
                          child: const Icon(
                            CupertinoIcons.chevron_forward,
                            size: 20.0,
                            color: CupertinoColors.systemGrey3,
                          ),
                        ),
                        ProfileMenu(
                          onTap: () {},
                          prefix: const Text("도움말 및 문의"),
                          child: const Icon(
                            CupertinoIcons.chevron_forward,
                            size: 20.0,
                            color: CupertinoColors.systemGrey3,
                          ),
                        ),
                      ],
                    ),
                    CupertinoFormSection(
                      header: const Text("애플리케이션"),
                      children: [
                        ProfileMenu(
                          onTap: () {},
                          prefix: const Text("버전 0.1.0"),
                        ),
                        ProfileMenu(
                          onTap: () {},
                          prefix: const Text("codersproduct"),
                          child: const Icon(
                            CupertinoIcons.chevron_forward,
                            size: 20.0,
                            color: CupertinoColors.systemGrey3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          CupertinoTabBar(
            currentIndex: 1,
            onTap: (index) {
              if (index == 0) {
                to<Profile>().dispatch(const Replaced("/home"));
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(CupertinoIcons.photo)),
              BottomNavigationBarItem(icon: Icon(CupertinoIcons.person)),
            ],
          )
        ],
      ),
    );
  }
}
