import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 포커스 아웃 -> 자식 위젯의 GestureDetector 영역(여기서는 TextField)을 제외한 부모 위젯에서만 발동
void focusout(BuildContext context) {
  FocusScope.of(context).unfocus();
}

// 스크린 너비값 가져오기
double getWinWidth(BuildContext context) => MediaQuery.of(context).size.width;

// 스크린 높이값 가져오기
double getWinHeight(BuildContext context) => MediaQuery.of(context).size.height;

// 웹화면인가?
bool isWebScreen(BuildContext context) => kIsWeb;

// 다크모드인가?
bool isDarkMode(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;

// 한국어인가?
bool isKorean(BuildContext context) =>
    Localizations.localeOf(context).toString() == 'ko';
