import 'package:flutter/material.dart';
import 'package:tiktok/features/main_navigation/screens/stf_screen.dart';

/*
동일한 위젯을 배열 요소로 하나 이상 선택하면, 플러터에서 같은 화면으로 보아 각 요소를 서로 다르게 랜더하지 못한다.

final screens = [
  const StfScreen(),
  const StfScreen(),
  Container(),
  const StfScreen(),
  const StfScreen(),
];

이 때는 위젯 슈퍼필드 'key' 속성을 설정해 각기 서로 다른 요소임을 플러터에게 알려준다. -> key: GlobalKey()
그리고 모두 별개임을 알 수 있도록 위젯 앞에 달린 const 예약어도 지워야 한다.
*/
final screens = [
  StfScreen(key: GlobalKey()),
  StfScreen(key: GlobalKey()),
  Container(),
  StfScreen(key: GlobalKey()),
  StfScreen(key: GlobalKey()),
];
