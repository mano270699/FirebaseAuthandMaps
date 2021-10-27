import 'package:authphone/busniss_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:authphone/constant/my_colors.dart';
import 'package:authphone/constant/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({Key? key}) : super(key: key);
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();
  Widget buildDrawerHeader() => Column(
        children: [
          Container(
            padding: EdgeInsetsDirectional.fromSTEB(70, 10, 70, 10),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.blue[100],
            ),
            child: Image.asset(
              'assets/images/mano.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Text(
            'Ahmed mAnO',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            '01069103550',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );
  Widget buildDrawerListItem(
          {required IconData loadingIcon,
          required String title,
          Function()? onTap,
          Widget? traling,
          Color? color}) =>
      ListTile(
        leading: Icon(
          loadingIcon,
          color: color ?? MyColors.blue,
        ),
        title: Text(title),
        onTap: onTap,
        trailing: traling ??= Icon(
          Icons.arrow_right,
          color: MyColors.blue,
        ),
      );
  Widget buildDrawerListItemDivider() => Divider(
        indent: 18,
        height: 0,
        endIndent: 24,
        thickness: 1,
      );
  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
  Widget buildSocialIcon(IconData icon, String url) => InkWell(
        child: Icon(
          icon,
          color: MyColors.blue,
          size: 35,
        ),
        onTap: () {
          _launchURL(url);
        },
      );
  Widget builRowSoialmediaIcons() => Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            buildSocialIcon(
                FontAwesomeIcons.facebook, 'https://www.facebook.com/Ahmano99'),
            const SizedBox(
              width: 5,
            ),
            buildSocialIcon(
                FontAwesomeIcons.github, 'https://github.com/mano270699'),
            const SizedBox(
              width: 5,
            ),
            buildSocialIcon(
                FontAwesomeIcons.instagram, 'https://instagram.com/a.mano99'),
          ],
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 280,
            child: DrawerHeader(
              child: buildDrawerHeader(),
              decoration: BoxDecoration(color: Colors.blue[100]),
            ),
          ),
          buildDrawerListItem(loadingIcon: Icons.person, title: 'Profile'),
          buildDrawerListItemDivider(),
          buildDrawerListItem(
              loadingIcon: Icons.history, title: 'Places History'),
          buildDrawerListItemDivider(),
          buildDrawerListItem(loadingIcon: Icons.settings, title: 'Settings'),
          buildDrawerListItemDivider(),
          buildDrawerListItem(loadingIcon: Icons.help, title: 'Help'),
          BlocProvider<PhoneAuthCubit>(
            create: (context) => phoneAuthCubit,
            child: buildDrawerListItem(
              loadingIcon: Icons.logout,
              title: 'Logout',
              onTap: () async {
                await phoneAuthCubit.logOut();
                Navigator.of(context).pushReplacementNamed(loginScreen);
              },
              color: Colors.red,
              traling: SizedBox(),
            ),
          ),
          SizedBox(
            height: 80,
          ),
          ListTile(
            leading: Text(
              'About us',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          builRowSoialmediaIcons(),
        ],
      ),
    );
  }
}
