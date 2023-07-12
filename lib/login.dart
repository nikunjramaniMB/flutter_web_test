
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/adaptive.dart';
import 'package:flutter_web/gallery_options.dart';
import 'package:flutter_web/home.dart';

const _horizontalPadding = 24.0;
double _textScaleFactor(BuildContext context) {
  return GalleryOptions.of(context).textScaleFactor(context);
}
double reducedTextScale(BuildContext context) {
  final textScaleFactor = _textScaleFactor(context);
  return textScaleFactor >= 1 ? (1 + textScaleFactor) / 2 : 1;
}
double desktopLoginScreenMainAreaWidth({required BuildContext context}) {
  return min(
    360 * reducedTextScale(context),
    MediaQuery.of(context).size.width - 2 * _horizontalPadding,
  );
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);

    return ApplyTextOptions(
      child: isDesktop
          ? LayoutBuilder(
        builder: (context, constraints) => Scaffold(
          body: SafeArea(
            child: Center(
              child: SizedBox(
                width: desktopLoginScreenMainAreaWidth(context: context),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ShrineLogo(),
                    SizedBox(height: 40),
                    _UsernameTextField(),
                    SizedBox(height: 16),
                    _PasswordTextField(),
                    SizedBox(height: 24),
                    _CancelAndNextButtons(),
                    SizedBox(height: 62),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
          : Scaffold(
        body: SafeArea(
          child: ListView(
            restorationId: 'login_list_view',
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: _horizontalPadding,
            ),
            children: const [
              SizedBox(height: 80),
              _ShrineLogo(),
              SizedBox(height: 120),
              _UsernameTextField(),
              SizedBox(height: 12),
              _PasswordTextField(),
              _CancelAndNextButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShrineLogo extends StatelessWidget {
  const _ShrineLogo();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Column(
        children: [
          const FadeInImagePlaceholder(
            image: AssetImage('assets/images/illustration-2.png'),
            placeholder: SizedBox(
              width: 34,
              height: 34,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Login',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}

class _UsernameTextField extends StatelessWidget {
  const _UsernameTextField();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      textInputAction: TextInputAction.next,
      restorationId: 'username_text_field',
      cursorColor: colorScheme.onSurface,
      decoration: InputDecoration(
        labelText: "email",
        labelStyle: TextStyle(
        ),
      ),
    );
  }
}
double letterSpacingOrNone(double letterSpacing) =>
    kIsWeb ? 0.0 : letterSpacing;

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      restorationId: 'password_text_field',
      cursorColor: colorScheme.onSurface,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "password",
        labelStyle: TextStyle(
        ),
      ),
    );
  }
}

class _CancelAndNextButtons extends StatelessWidget {
  const _CancelAndNextButtons();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final isDesktop = isDisplayDesktop(context);

    final buttonTextPadding = isDesktop
        ? const EdgeInsets.symmetric(horizontal: 24, vertical: 16)
        : EdgeInsets.zero;

    return Padding(
      padding: isDesktop ? EdgeInsets.zero : const EdgeInsets.all(8),
      child: OverflowBar(
        spacing: isDesktop ? 0 : 8,
        alignment: MainAxisAlignment.end,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
            ),
            onPressed: () {
              // The login screen is immediately displayed on top of
              // the Shrine home screen using onGenerateRoute and so
              // rootNavigator must be set to true in order to get out
              // of Shrine completely.
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Padding(
              padding: buttonTextPadding,
              child: Text(
                "Cancel",
                style: TextStyle(color: colorScheme.onSurface),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 8,
              shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: Padding(
              padding: buttonTextPadding,
              child: Text(
               "Next",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FadeInImagePlaceholder extends StatelessWidget {
  const FadeInImagePlaceholder({
    super.key,
    required this.image,
    required this.placeholder,
    this.child,
    this.duration = const Duration(milliseconds: 500),
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.fit,
  });

  /// The target image that we are loading into memory.
  final ImageProvider image;

  /// Widget displayed while the target [image] is loading.
  final Widget placeholder;

  /// What widget you want to display instead of [placeholder] after [image] is
  /// loaded.
  ///
  /// Defaults to display the [image].
  final Widget? child;

  /// The duration for how long the fade out of the placeholder and
  /// fade in of [child] should take.
  final Duration duration;

  /// See [Image.excludeFromSemantics].
  final bool excludeFromSemantics;

  /// See [Image.width].
  final double? width;

  /// See [Image.height].
  final double? height;

  /// See [Image.fit].
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: image,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return this.child ?? child;
        } else {
          return AnimatedSwitcher(
            duration: duration,
            child: frame != null ? this.child ?? child : placeholder,
          );
        }
      },
    );
  }
}