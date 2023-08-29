import 'package:flutter/material.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

import '../../test_screen/screens/main_test_screen.dart';
import '../../test_screen/screens/profile_test_screen.dart';

late String savedName;
late String savedSurname;
late String savedSecondName;
late String savedBirthDate;
late String savedCity;
late String savedCheckbox;
late String savedAbout;

abstract class ProfileStepDefinitions {
  static StepDefinitionGeneric nextButton = when<FlutterWidgetTesterWorld>(
    RegExp(r'Я перехожу далее$'),
    (context) async {
      final tester = context.world.rawAppDriver;
      await tester.tap(ProfileTestScreen.nextButton);
      await tester.pumpAndSettle();
    },
  );

  static Iterable<StepDefinitionGeneric> get steps => [
        when1<String, FlutterWidgetTesterWorld>(
          RegExp(r'Я указываю фамилию {string}$'),
          (surname, context) async {
            savedSurname = surname;
            final tester = context.world.rawAppDriver;
            await tester.pumpAndSettle();
            await tester.enterText(ProfileTestScreen.surnameField, surname);
            await tester.pump();
          },
        ),
        when1<String, FlutterWidgetTesterWorld>(
          RegExp(r'Я указываю имя {string}$'),
          (name, context) async {
            savedName = name;
            final tester = context.world.rawAppDriver;
            await tester.pumpAndSettle();
            await tester.enterText(ProfileTestScreen.nameField, name);
            await tester.pump();
          },
        ),
        when1<String, FlutterWidgetTesterWorld>(
          RegExp(r'Я указываю отчество {string}$'),
          (secondName, context) async {
            savedSecondName = secondName;
            final tester = context.world.rawAppDriver;
            await tester.pumpAndSettle();
            await tester.enterText(
              ProfileTestScreen.secondNameField,
              secondName,
            );
            await tester.pump();
          },
        ),
        when1<String, FlutterWidgetTesterWorld>(
          RegExp(r'Я указываю дату рождения {string}$'),
          (birthdate, context) async {
            savedBirthDate = birthdate;
            final tester = context.world.rawAppDriver;
            await tester.pumpAndSettle();
            tester
                .widget<TextField>(ProfileTestScreen.birthdayField)
                .controller
                ?.text = birthdate;
            await tester.pump();
          },
        ),
        nextButton,
        when1<String, FlutterWidgetTesterWorld>(
          RegExp(r'Я выбираю город {string}$'),
          (city, context) async {
            savedCity = city;
            final tester = context.world.rawAppDriver;
            await tester.pumpAndSettle();
            tester
                .widget<TextField>(ProfileTestScreen.cityField)
                .controller
                ?.text = city;
            await tester.pump();
          },
        ),
        nextButton,
        when1<String, FlutterWidgetTesterWorld>(
          RegExp(r'Я выбираю {string} из интересов$'),
          (selectedCheckbox, context) async {
            savedCheckbox = selectedCheckbox;
            final tester = context.world.rawAppDriver;
            await tester.pumpAndSettle();
            await tester.scrollUntilVisible(
              ProfileTestScreen.checkbox(selectedCheckbox),
              100,
            );
            await tester.tap(ProfileTestScreen.checkbox(selectedCheckbox));
            await tester.pump();
          },
        ),
        nextButton,
        when1<String, FlutterWidgetTesterWorld>(
          RegExp(r'Я заполняю заметку о себе {string}$'),
          (note, context) async {
            savedAbout = note;
            final tester = context.world.rawAppDriver;
            await tester.pumpAndSettle();
            await tester.enterText(
              ProfileTestScreen.noteField,
              note,
            );
            await tester.pump();
          },
        ),
        when<FlutterWidgetTesterWorld>(
          RegExp(r'Я сохраняю данные$'),
          (context) async {
            final tester = context.world.rawAppDriver;
            await tester.tap(ProfileTestScreen.saveButton);
            await tester.pumpAndSettle();
          },
        ),
        when<FlutterWidgetTesterWorld>(
          RegExp(r'Я перехожу к редактированию профиля$'),
          (context) async {
            final tester = context.world.rawAppDriver;
            await tester.tap(MainTestScreen.editProfileBtn);
          },
        ),
        then<FlutterWidgetTesterWorld>(
          RegExp(r'Я вижу заполненные поля ФИО$'),
          (context) async {
            final tester = context.world.rawAppDriver;
            await tester.pumpAndSettle();
            final fields = tester.widgetList<TextField>(find.byType(TextField));
            expect(fields.length, equals(4));

            expect(fields.any((e) => e.controller?.text == savedName), isTrue);
            expect(
              fields.any((e) => e.controller?.text == savedSurname),
              isTrue,
            );
            expect(
              fields.any((e) => e.controller?.text == savedSecondName),
              isTrue,
            );
          },
        ),
        then<FlutterWidgetTesterWorld>(
          RegExp(r'Я вижу заполненное поле даты рождения$'),
          (context) async {
            final tester = context.world.rawAppDriver;
            final fields = tester.widgetList<TextField>(find.byType(TextField));
            expect(
              fields.any((e) => e.controller?.text == savedBirthDate),
              isTrue,
            );
          },
        ),
        nextButton,
        then<FlutterWidgetTesterWorld>(
          RegExp(r'Я вижу заполненное поле города$'),
          (context) async {
            final tester = context.world.rawAppDriver;
            await tester.pump();
            expect(
              tester.widget<TextField>(find.byType(TextField)).controller?.text,
              equals(savedCity),
            );
          },
        ),
        nextButton,
        then<FlutterWidgetTesterWorld>(
          RegExp(r'Я вижу выбранные интересы$'),
          (context) async {
            final tester = context.world.rawAppDriver;
            await tester.pump();
            await tester.scrollUntilVisible(
              ProfileTestScreen.checkbox(savedCheckbox),
              100,
            );
            expect(ProfileTestScreen.checkbox(savedCheckbox), findsOneWidget);
          },
        ),
        nextButton,
        then<FlutterWidgetTesterWorld>(
          RegExp(r'Я вижу заполненное поле заметки о себе$'),
          (context) async {
            final tester = context.world.rawAppDriver;
            await tester.pump();
            expect(
              tester.widget<TextField>(find.byType(TextField)).controller?.text,
              equals(savedAbout),
            );
          },
        ),
      ];
}
