import 'package:flutter/material.dart';
import 'config/constants.dart';
import 'shell/tv_shell.dart';
import 'theme/tv_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KUETTvApp());
}

class KUETTvApp extends StatelessWidget {
  const KUETTvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: TVTheme.darkTheme,
      home: const TVShell(),
    );
  }
}
