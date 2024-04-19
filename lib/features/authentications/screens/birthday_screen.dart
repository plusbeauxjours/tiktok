import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/authentications/widgets/birthday_header.dart';
import 'package:tiktok/features/authentications/widgets/form_button.dart';
import 'package:tiktok/features/onboarding/screens/interests_screen.dart';
import 'package:tiktok/utils/utils.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({Key? key}) : super(key: key);

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
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

  void _setTextFieldDate(DateTime date) {
    _birthdayController.value =
        TextEditingValue(text: DateFormat('yyyy년 MM월 dd일').format(date));
  }

  @override
  Widget build(BuildContext context) {
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
              onTap: () => Utils.navPushAndRemoveUntil(
                  context, const InterestsScreen(), (route) => false),
              child: const FormButton(disabled: false),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 300,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: initDate,
            minimumDate: minDate,
            maximumDate: initDate,
            onDateTimeChanged: _setTextFieldDate,
          ),
        ),
      ),
    );
  }
}