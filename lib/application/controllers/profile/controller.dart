import 'package:album/application/controller.dart';
import 'package:album/application/controllers/profile/widgets/avatar.dart';
import 'package:album/application/controllers/profile/widgets/menu.dart';
import 'package:album/application/stores/user.dart';
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
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16.0,
                    ),
                    of<App>().require<UserStore>().subscribe(
                          onNext: (data) => Column(
                            children: [
                              const SizedBox(height: 24.0),
                              ProfileAvatar(
                                imageUri: data.avatar,
                              ),
                              const SizedBox(height: 12.0),
                              Text(
                                data.name,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              if (data.email != null) ...[
                                const SizedBox(height: 4.0),
                                Text(
                                  data.email!,
                                  style: const TextStyle(
                                    color: CupertinoColors.inactiveGray,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                              CupertinoFormSection(
                                header: const Text("계정"),
                                children: [
                                  ProfileMenu(
                                    onTap: () {},
                                    prefix: const Text("이름, 이메일, 프로필 사진"),
                                    child: const Icon(
                                      CupertinoIcons.chevron_forward,
                                      size: 20.0,
                                      color: CupertinoColors.systemGrey3,
                                    ),
                                  ),
                                  ProfileMenu(
                                    onTap: () => to<Profile>()
                                        .dispatch(const Pushed("/signin")),
                                    prefix: const Text(
                                      "구매 내역",
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.chevron_forward,
                                      size: 20.0,
                                      color: CupertinoColors.systemGrey3,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          onLoad: () => CupertinoFormSection(
                            header: const Text("계정"),
                            children: [
                              ProfileMenu(
                                onTap: () => to<Profile>()
                                    .dispatch(const Pushed("/signin")),
                                prefix: const Text(
                                  "로그인",
                                  style: TextStyle(
                                      color: CupertinoColors.activeBlue),
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
                      header: const Text("기타"),
                      children: [
                        ProfileMenu(
                          onTap: () {},
                          prefix: const Text(
                            "로그아웃",
                            style: TextStyle(
                              color: CupertinoColors.destructiveRed,
                            ),
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
