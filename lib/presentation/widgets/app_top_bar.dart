import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_routes.dart';

/// Shared top bar: a **back** arrow (when there's somewhere to go back to), a
/// **home** action that returns to the root shell, the title, and an overflow
/// menu for Settings / Profile / Log out. Use on the shell and on pushed pages
/// so navigation affordances are consistent everywhere.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    required this.title,
    super.key,
    this.actionsBefore = const <Widget>[],
    this.onTitleTap,
  });

  final String title;

  /// Extra page-specific actions shown before the home/menu actions.
  final List<Widget> actionsBefore;

  /// Optional title tap handler (the shell uses it for the hidden mock-mode
  /// triple-tap). Null leaves the title inert.
  final VoidCallback? onTitleTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final bool canPop = Navigator.of(context).canPop();
    final Widget titleWidget = Text(title);
    return AppBar(
      leading: canPop
          ? IconButton(
              tooltip: 'Back',
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : null,
      title: onTitleTap == null
          ? titleWidget
          : GestureDetector(onTap: onTitleTap, child: titleWidget),
      actions: <Widget>[
        ...actionsBefore,
        if (canPop)
          IconButton(
            tooltip: 'Home',
            icon: const Icon(Icons.home_outlined),
            onPressed: () =>
                Navigator.of(context).popUntil((Route<dynamic> r) => r.isFirst),
          ),
        PopupMenuButton<_TopBarAction>(
          tooltip: 'Menu',
          icon: const Icon(Icons.more_vert),
          onSelected: (_TopBarAction a) => _onSelected(context, a),
          itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<_TopBarAction>>[
            const PopupMenuItem<_TopBarAction>(
              value: _TopBarAction.settings,
              child: ListTile(
                leading: Icon(Icons.settings_outlined),
                title: Text('Settings'),
              ),
            ),
            const PopupMenuItem<_TopBarAction>(
              value: _TopBarAction.profile,
              child: ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('Profile'),
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<_TopBarAction>(
              value: _TopBarAction.logout,
              child: ListTile(
                leading: Icon(Icons.logout, color: AppColors.error),
                title: Text('Log out'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onSelected(BuildContext context, _TopBarAction action) {
    switch (action) {
      case _TopBarAction.settings:
        Navigator.of(context).pushNamed(AppRoutes.settings);
      case _TopBarAction.profile:
        Navigator.of(context).pushNamed(AppRoutes.profile);
      case _TopBarAction.logout:
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
    }
  }
}

enum _TopBarAction { settings, profile, logout }
