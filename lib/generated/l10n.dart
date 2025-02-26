// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Sign up for {nameOfTheApp}`
  String signUpTitle(String nameOfTheApp) {
    return Intl.message(
      'Sign up for $nameOfTheApp',
      name: 'signUpTitle',
      desc: 'The title people see when they open the app for the first time.',
      args: [nameOfTheApp],
    );
  }

  /// `login into your {nameOfTheApp} account`
  String loginTitle(String nameOfTheApp, DateTime when) {
    final DateFormat whenDateFormat =
        DateFormat('💖 LLLL 😱 Hm', Intl.getCurrentLocale());
    final String whenString = whenDateFormat.format(when);

    return Intl.message(
      'login into your $nameOfTheApp account',
      name: 'loginTitle',
      desc: 'The title people see when they open the login screen.',
      args: [nameOfTheApp, whenString],
    );
  }

  /// `Create a profile, follow other accounts, make your own {videoCount, plural, =0{no videos} =1{video} other{videos}}, and more.`
  String signUpSubtitle(num videoCount) {
    return Intl.message(
      'Create a profile, follow other accounts, make your own ${Intl.plural(videoCount, zero: 'no videos', one: 'video', other: 'videos')}, and more.',
      name: 'signUpSubtitle',
      desc: '',
      args: [videoCount],
    );
  }

  /// `Use email & password`
  String get emailPasswordButton {
    return Intl.message(
      'Use email & password',
      name: 'emailPasswordButton',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Facebook`
  String get facebookButton {
    return Intl.message(
      'Continue with Facebook',
      name: 'facebookButton',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Apple`
  String get appleButton {
    return Intl.message(
      'Continue with Apple',
      name: 'appleButton',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Google`
  String get googleButton {
    return Intl.message(
      'Continue with Google',
      name: 'googleButton',
      desc: '',
      args: [],
    );
  }

  /// `Continue with {nameOfTheApp}`
  String accountLoginButton(Object nameOfTheApp) {
    return Intl.message(
      'Continue with $nameOfTheApp',
      name: 'accountLoginButton',
      desc: '',
      args: [nameOfTheApp],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Log in {gender, select, male{sir} female{madam} other{human}}`
  String logIn(String gender) {
    return Intl.message(
      'Log in ${Intl.gender(gender, male: 'sir', female: 'madam', other: 'human')}',
      name: 'logIn',
      desc: '',
      args: [gender],
    );
  }

  /// `{count}`
  String likeCount(int count) {
    final NumberFormat countNumberFormat = NumberFormat.compact(
      locale: Intl.getCurrentLocale(),
    );
    final String countString = countNumberFormat.format(count);

    return Intl.message(
      '$countString',
      name: 'likeCount',
      desc: 'Anything you want',
      args: [countString],
    );
  }

  /// `{count}`
  String commentCount(int count) {
    final NumberFormat countNumberFormat = NumberFormat.compact(
      locale: Intl.getCurrentLocale(),
    );
    final String countString = countNumberFormat.format(count);

    return Intl.message(
      '$countString',
      name: 'commentCount',
      desc: 'Anything you want',
      args: [countString],
    );
  }

  /// `{count} {count2, plural, =0{comment} =1{comment} other{comments}}`
  String commentTitle(int count, num count2) {
    final NumberFormat countNumberFormat = NumberFormat.compact(
      locale: Intl.getCurrentLocale(),
    );
    final String countString = countNumberFormat.format(count);

    return Intl.message(
      '$countString ${Intl.plural(count2, zero: 'comment', one: 'comment', other: 'comments')}',
      name: 'commentTitle',
      desc: 'Anything you want',
      args: [countString, count2],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ko'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
