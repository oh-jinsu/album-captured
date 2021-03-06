import 'package:album/application/controller.dart';
import 'package:album/application/controllers/profile/events/sign_out_button_tapped.dart';
import 'package:album/application/controllers/profile/usecases/sign_out.dart';
import 'package:album/application/controllers/profile/widgets/avatar.dart';
import 'package:album/application/controllers/profile/widgets/menu.dart';
import 'package:album/application/stores/user.dart';
import 'package:album/core/controller/arguments.dart';
import 'package:album/core/controller/controller.dart';
import 'package:album/infrastructure/providers/navigation.dart';
import 'package:flutter/cupertino.dart';

class Profile extends Controller {
  Profile({Key? key})
      : super(
          const Arguments(),
          key: key,
          usecases: [
            SignOutUsecase(),
          ],
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
                child: of<App>().require<UserStore>().subscribe(
                      onNext: (data) => Column(
                        children: [
                          const SizedBox(
                            height: 16.0,
                          ),
                          if (data != null) ...[
                            const SizedBox(height: 24.0),
                            ProfileAvatar(
                              imageUri: data.avatarImageUri,
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
                              header: const Text("??????"),
                              children: [
                                ProfileMenu(
                                  onTap: () {},
                                  prefix: const Text("??????, ?????????, ????????? ??????"),
                                  child: const Icon(
                                    CupertinoIcons.chevron_forward,
                                    size: 20.0,
                                    color: CupertinoColors.systemGrey3,
                                  ),
                                ),
                                ProfileMenu(
                                  onTap: () {},
                                  prefix: const Text(
                                    "?????? ??????",
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.chevron_forward,
                                    size: 20.0,
                                    color: CupertinoColors.systemGrey3,
                                  ),
                                ),
                              ],
                            ),
                          ] else
                            CupertinoFormSection(
                              header: const Text("??????"),
                              children: [
                                ProfileMenu(
                                  onTap: () =>
                                      use<Coordinator>().push("/signin"),
                                  prefix: const Text(
                                    "?????????",
                                    style: TextStyle(
                                        color: CupertinoColors.activeBlue),
                                  ),
                                ),
                              ],
                            ),
                          CupertinoFormSection(
                            header: const Text("??????"),
                            children: [
                              ProfileMenu(
                                onTap: () {},
                                prefix: const Text("?????????????????????"),
                                child: const Icon(
                                  CupertinoIcons.chevron_forward,
                                  size: 20.0,
                                  color: CupertinoColors.systemGrey3,
                                ),
                              ),
                              ProfileMenu(
                                onTap: () {},
                                prefix: const Text("????????????????????????"),
                                child: const Icon(
                                  CupertinoIcons.chevron_forward,
                                  size: 20.0,
                                  color: CupertinoColors.systemGrey3,
                                ),
                              ),
                              ProfileMenu(
                                onTap: () {},
                                prefix: const Text("????????? ??? ??????"),
                                child: const Icon(
                                  CupertinoIcons.chevron_forward,
                                  size: 20.0,
                                  color: CupertinoColors.systemGrey3,
                                ),
                              )
                            ],
                          ),
                          if (data != null)
                            CupertinoFormSection(
                              header: const Text("??????"),
                              children: [
                                ProfileMenu(
                                  onTap: () => to<Profile>().dispatch(
                                    const SignOutButtonTapped(),
                                  ),
                                  prefix: const Text(
                                    "????????????",
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
          ),
          CupertinoTabBar(
            currentIndex: 1,
            onTap: (index) {
              if (index == 0) {
                use<Coordinator>().replace("/home");
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
