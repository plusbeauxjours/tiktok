import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tiktok/constants/breakpoints.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/authentications/widgets/birthday_date_picker.dart';
import 'package:tiktok/features/authentications/widgets/birthday_header.dart';
import 'package:tiktok/features/authentications/widgets/form_button.dart';
import 'package:tiktok/features/authentications/view_models/signup_view_model.dart';

class BirthdayScreen extends ConsumerStatefulWidget {
  const BirthdayScreen({Key? key}) : super(key: key);

  @override
  BirthdayScreenState createState() => BirthdayScreenState();
}

class BirthdayScreenState extends ConsumerState<BirthdayScreen> {
  final TextEditingController _birthdayController = TextEditingController();

  DateTime initDate = DateTime.now();
  late DateTime minDate = DateTime(
    initDate.year - 12,
    initDate.month,
    initDate.day,
  );

  @override
  void initState() {
    super.initState();
    _setTextFieldDate(initDate);
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose();
  }

  void _onNextTap() {
    final state = ref.read(signUpForm.notifier).state;
    ref.read(signUpForm.notifier).state = {
      ...state,
      "birthday": _birthdayController.value.text,
    };
    ref.read(signUpProvider.notifier).signUp(context);
    // context.goNamed(InterestsScreen.routeName);
  }

  void _setTextFieldDate(DateTime date) {
    _birthdayController.value =
        TextEditingValue(text: DateFormat('yyyy. MM. dd').format(date));
  }

  @override
  Widget build(BuildContext context) {
    final isWebScreen = MediaQuery.of(context).size.width > Breakpoints.lg;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Sign up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.size36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v40,
            const BirthdayHeader(),
            Gaps.v28,
            TextField(
              enabled: false,
              controller: _birthdayController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ),
              cursorColor: Theme.of(context).primaryColor,
            ),
            Gaps.v28,
            GestureDetector(
              onTap: _onNextTap,
              child: FormButton(
                disabled: ref.watch(signUpProvider).isLoading,
              ),
            ),
            Gaps.v96,
            if (isWebScreen)
              BirthdayDatePicker(
                initialDateTime: initDate,
                minimumDate: minDate,
                maximumDate: initDate,
                onDateTimeChanged: _setTextFieldDate,
              ),
          ],
        ),
      ),
      bottomNavigationBar: !isWebScreen
          ? BottomAppBar(
              height: MediaQuery.of(context).size.height * 0.3,
              child: BirthdayDatePicker(
                initialDateTime: initDate,
                minimumDate: minDate,
                maximumDate: initDate,
                onDateTimeChanged: _setTextFieldDate,
              ),
            )
          : null,
    );
  }
}
