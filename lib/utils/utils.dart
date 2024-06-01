import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

// 모든 화면은 스택(Stack) 구조이며, 밑에서부터 위로 겹쳐 쌓는 형태로 렌더링 -> Flutter Outline 확인

// 1) 웹앱 호환 공통 페이지 이동 Navigator2 방식 유틸 - 최신 방식(추천)

// 화면 이동 -> 스택 위에 또 다른 스택을 쌓는다.
void goRoutePush(BuildContext context, String location, {Object? extra}) =>
    context.push(location, extra: extra);

// 화면 이동 -> goRoutePush()와 같지만, url 로 라우트명이 아닌 name 속성값을 참조해 명령을 실행한다.
void goRoutePushNamed(BuildContext context, String location, {Object? extra}) =>
    context.pushNamed(location, extra: extra);

// 화면 이동 => 기존 스택과의 관계를 끊고 원하는 화면 위치로 이동시킨다.
//  앱이라면 이동한 화면 앱바의 뒤로가기 버튼이 사라지고 context.pop() 사용 불가, 웹 뒤로가기는 사용 가능
void goRouteGo(BuildContext context, String location) => context.go(location);

// goRouteGo()와 같지만, url 로 라우트명이 아닌 name 속성값을 참조해 명령을 실행한다.
void goRouteGoNamed(BuildContext context, String location) =>
    context.goNamed(location);

// 뒤로 가기 => goRoutePush()로 이동한 화면(페이지)에서만 사용 가능
void goRoutePop(BuildContext context) => context.pop();

// 2) 앱 전용 페이지 이동 Navigator1 방식 유틸

// 화면에 넘긴 파라미터 가져오기 => routePath()에 두번째 인자 args 를 입력한 경우
//  입력된 args 파라미터 정보를 가져오기 위해 사용
Object? getParams(BuildContext context) =>
    ModalRoute.of(context)!.settings.arguments;

// 화면 이동(특정된 이름이 붙은 화면으로 라우트하는 방식)
void routePush(
  BuildContext context,
  String routeName, {
  Object? args,
}) async {
  final result =
      await Navigator.of(context).pushNamed(routeName, arguments: args);
  if (kDebugMode) print(result);
}

// 화면 이동(실제로는 화면 추가)
void navPush(
  BuildContext context,
  Widget widget, [
  bool? isFullScreenDialog,
]) async {
  // 화면(PageRoute 대상)을 추가하면, 추가된 화면이 바로 위에 쌓여 마치 스크린을 이동한 것처럼 보이게 됨.
  final result = await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => widget,
      fullscreenDialog: isFullScreenDialog ?? false, // 꽉찬 다이얼로그로 표시 여부 설정
    ),
  );
  if (kDebugMode) {
    print(result);
  }
}

// 화면 이동(PageRouteBuilder 방식) => 애니메이션 커스더마이징 가능
void navPagePush(
  BuildContext context,
  Widget widget, [
  bool? isFullScreenDialog,
]) async {
  // 화면(PageRoute 대상)을 추가하면, 추가된 화면이 바로 위에 쌓여 마치 스크린을 이동한 것처럼 보이게 됨.
  final result = await Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration:
          const Duration(milliseconds: 500), // 뒤로가기 작동 애니메이션 시간
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // 위치 이동 애니메이션
        final offsetAnimation = Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation);
        // 투명도 애니메이션
        final opacityAnimation = Tween(
          begin: 0.5,
          end: 1.0,
        ).animate(animation);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: opacityAnimation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      fullscreenDialog: isFullScreenDialog ?? false, // 꽉찬 다이얼로그로 표시 여부 설정
    ),
  );
  if (kDebugMode) {
    print(result);
  }
}

// 조건부 화면 이동 -> 세 번째 인자(조건 콜백)을 생략하면 navPush 메서드와 같다.
void navPushAndRemoveUntil(
  BuildContext context,
  Widget widget, [
  // 콜백이 false 반환 시 네비게이터 아래 쌓인 라우트 스택 모두 제거(초기화) -> 뒤로가기 할 화면 제거됨
  bool Function(Route<dynamic>)? predicate,
]) async {
  await Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => widget),
    // 기본: predicate 생략 시 네비게이터 라우트 스텍 유지 -> 뒤로가기 할 화면 유지
    predicate ?? (route) => true,
  );
}

// 뒤로 가기(실제로는 맨 위에 놓인 화면 제거)
void navPop(BuildContext context, [dynamic result]) {
  Navigator.of(context).pop(result);
}
