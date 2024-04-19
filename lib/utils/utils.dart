import 'package:flutter/material.dart';

class Utils {
  // 모든 네비게이터는 스택(Stack) 구조이며, 밑에서부터 위로 겹쳐 쌓는 형태로 렌더링 -> Flutter Outline 확인

  // 화면 이동(실제로는 화면 추가)
  static void navPush(
    BuildContext context,
    Widget widget, [
    bool? isFullScreenDialog,
  ]) {
    // 화면(PageRoute 대상)을 추가하면, 추가된 화면이 바로 위에 쌓여 마치 스크린을 이동한 것처럼 보이게 됨.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => widget,
        fullscreenDialog: isFullScreenDialog ?? false, // 꽉찬 다이얼로그로 표시 여부 설정
      ),
    );
  }

  // 조건부 화면 이동 -> 세 번째 인자(조건 콜백)을 생략하면 navPush 메서드와 같다.
  static void navPushAndRemoveUntil(
    BuildContext context,
    Widget widget, [
    // 콜백이 false 반환 시 네비게이터 아래 쌓인 라우트 스택 모두 제거(초기화) -> 뒤로가기 할 화면 제거됨
    bool Function(Route<dynamic>)? predicate,
  ]) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => widget),
      // 기본: predicate 생략 시 네비게이터 라우트 스텍 유지 -> 뒤로가기 할 화면 유지
      predicate ?? (route) => true,
    );
  }

  // 뒤로 가기(실제로는 맨 위에 놓인 화면 제거)
  static void navPop(BuildContext context) {
    Navigator.of(context).pop();
  }

  // 포커스 아웃 -> 자식 위젯의 GestureDetector 영역(여기서는 TextField)을 제외한 부모 위젯에서만 발동
  static void focusout(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
