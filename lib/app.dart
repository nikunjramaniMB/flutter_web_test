// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_web/constants.dart';
import 'package:flutter_web/gallery_options.dart';
import 'package:flutter_web/home.dart';
import 'package:flutter_web/login.dart';

const _primaryColor = Color(0xFF6200EE);

class StarterApp extends StatelessWidget {
  const StarterApp({super.key});


  @override
  Widget build(BuildContext context) {
    return ModelBinding(
      initialModel: GalleryOptions(
        themeMode: ThemeMode.system,
        textScaleFactor: systemTextScaleFactorOption,
        customTextDirection: CustomTextDirection.localeBased,
        locale: null,
        timeDilation: timeDilation,
        platform: defaultTargetPlatform,
        isTestMode: true,
      ),
      child: Builder(
        builder: (context) {
          final options = GalleryOptions.of(context);
          return MaterialApp(
            restorationScopeId: 'rootGallery',
            title: 'Flutter Gallery',
            debugShowCheckedModeBanner: false,
            themeMode: options.themeMode,
            locale: options.locale,
            localeListResolutionCallback: (locales, supportedLocales) {
              deviceLocale = locales?.first;
              return basicLocaleListResolution(locales, supportedLocales);
            },
            home: Home(),
          );
        },
      ),
    );
  }

}

class Home extends StatelessWidget {
  const Home();

  @override
  Widget build(BuildContext context) {
    return const ApplyTextOptions(
      child: LoginPage(),
    );
  }
}
