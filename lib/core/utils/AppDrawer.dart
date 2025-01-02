import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:letaskono_flutter/core/utils/CustomDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final _prefs = GetIt.instance<SharedPreferences>();
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Container(
              height: 200.h,
              width: double.infinity,
              color: Theme.of(context).colorScheme.primary,
              child: Image.asset('assets/images/logo2.png', scale: 1.2),
            ),
            SizedBox(height: 20.h),
            ListTile(
              title: Text(
                'بيانات الحساب',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              leading: const Icon(Icons.person_outline_outlined),
              onTap: () {
                Navigator.popAndPushNamed(context, "/edit_info");
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
              },
              title: Text(
                'الإعدادت',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              leading: Icon(Icons.settings),
            ),
            ListTile(
              title: Text(
                'الدعم والمساعدة',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              leading: const Icon(Icons.help_outline_outlined),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'معلومات عن المبادرة',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              leading: const Icon(Icons.info_outline),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'قائمة الحظر',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              leading: Icon(Icons.block_outlined),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'تسجيل الخروج',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              leading: Icon(Icons.exit_to_app_outlined),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(
                      title: 'هل تريد تسجيل الخروج؟',
                      content:
                          const Text('هل أنت متأكد من رغبتك في تسجيل الخروج ؟'),
                      actions: [
                        ElevatedButton(
                          onPressed: () => {
                            _prefs.remove("auth_token"),
                            Navigator.pop(context, 'OK'),
                            Navigator.pushReplacementNamed(context, "/"),
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4B164C),
                            // Darkest color
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('نعم'),
                        ),
                        TextButton(
                          onPressed: () => {
                            Navigator.pop(context, 'Cancel'),
                          },
                          child: Text(
                            'إلغاء',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.7)), // Accent color
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
