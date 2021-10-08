import 'dart:async';
import 'dart:io';

import 'package:bookmemo/ui/splashInteractor.dart';
import 'package:bookmemo/helper/widgetHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:lottie/lottie.dart';

import 'home/home.dart';
import 'modifyBook/modifyBook.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  StreamSubscription? subscription;
  final interactor = SplashInteractor();

  @override
  initState() {
    WidgetsFlutterBinding.ensureInitialized();
    interactor.migrateOldDatabase(context);
    interactor.initializeFlutterFire();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (Platform.isAndroid) {
        HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
        subscription = HomeWidget.widgetClicked.listen(_launchedFromWidget);
      } else {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  void _launchedFromWidget(var uri) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      WidgetHelper().launchedFromWidget(uri).then((value) => {
            if (value != null)
              {
                Navigator.pushReplacementNamed(
                    context, ModifyBookPage.routeName,
                    arguments: ModifyBookArguments(book: value))
              }
            else
              {Navigator.pushReplacementNamed(context, HomePage.routeName)}
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Lottie.asset('assets/lotties/waiting_book.json',
              animate: true, repeat: true),
        ),
      ),
    );
  }
}
