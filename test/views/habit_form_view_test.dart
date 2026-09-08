import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:tracking_your_habits/l10n/app_localizations.dart';
import 'package:tracking_your_habits/src/viewmodels/habit_viewmodel.dart';
import 'package:tracking_your_habits/src/views/habits/habits_form_view.dart';

import '../viewmodels/habit_viewmodel_test.mocks.dart';

void main() {
  late MockHabitRepository repository;

  setUp(() {
    repository = MockHabitRepository();
  });

  Widget createTestWidget() {
    return ChangeNotifierProvider<HabitViewModel>(
      create: (_) => HabitViewModel(repository),
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('pt', 'BR'),
          Locale('en'),
        ],
        locale: Locale('pt', 'BR'),
        home: HabitFormView(),
      ),
    );
  }

  Future<void> setLargeTestScreen(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(
      const Size(800, 1400),
    );
    await tester.pump();
  }

  group('HabitFormView', () {
    testWidgets('should display the habit form', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await setLargeTestScreen(tester);

      expect(find.text('Novo hábito'), findsOneWidget);
      expect(find.text('Nome'), findsOneWidget);
      expect(find.text('Descrição'), findsOneWidget);
      expect(find.text('Frequência'), findsOneWidget);
      expect(find.text('Salvar hábito'), findsOneWidget);
    });

    testWidgets(
      'should show validation error when name is empty',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await setLargeTestScreen(tester);

        final saveButton = find.widgetWithText(
          ElevatedButton,
          'Salvar hábito',
        );

        expect(saveButton, findsOneWidget);

        await tester.tap(saveButton);
        await tester.pump();

        expect(
          find.text('Informe o nome do hábito.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should show weekly days when frequency is changed to weekly',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await setLargeTestScreen(tester);

        await tester.tap(find.text('Diário'));
        await tester.pump();

        await tester.tap(find.text('Semanal'));
        await tester.pump();

        expect(find.text('Dia da semana'), findsOneWidget);
        expect(find.text('Segunda'), findsOneWidget);
        expect(find.text('Terça'), findsOneWidget);
        expect(find.text('Quarta'), findsOneWidget);
        expect(find.text('Quinta'), findsOneWidget);
        expect(find.text('Sexta'), findsOneWidget);
        expect(find.text('Sábado'), findsOneWidget);
        expect(find.text('Domingo'), findsOneWidget);
      },
    );

    testWidgets(
      'should show error when weekly frequency has no selected day',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await setLargeTestScreen(tester);

        await tester.tap(find.text('Diário'));
        await tester.pump();

        await tester.tap(find.text('Semanal'));
        await tester.pump();

        await tester.enterText(
          find.byType(TextFormField).first,
          'Estudar',
        );

        final saveButton = find.widgetWithText(
          ElevatedButton,
          'Salvar hábito',
        );

        expect(saveButton, findsOneWidget);

        await tester.tap(saveButton);
        await tester.pump();

        expect(
          find.text('Selecione um dia da semana.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should select a weekday when weekly frequency is selected',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await setLargeTestScreen(tester);

        await tester.tap(find.text('Diário'));
        await tester.pump();

        await tester.tap(find.text('Semanal'));
        await tester.pump();

        final mondayRadio = find.ancestor(
          of: find.text('Segunda'),
          matching: find.byType(RadioListTile<int>),
        );

        expect(mondayRadio, findsOneWidget);

        await tester.tap(mondayRadio);
        await tester.pump();

        final radio = tester.widget<RadioListTile<int>>(
          mondayRadio,
        );

        expect(radio.value, 1);
        expect(radio.groupValue, 1);
      },
    );

    testWidgets(
      'should show custom days when frequency is changed to custom',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await setLargeTestScreen(tester);

        await tester.tap(find.text('Diário'));
        await tester.pump();

        await tester.tap(find.text('Personalizado'));
        await tester.pump();

        expect(find.text('Dias da semana'), findsOneWidget);
        expect(
          find.byType(CheckboxListTile),
          findsNWidgets(7),
        );
      },
    );

    testWidgets(
      'should allow selecting multiple custom days',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await setLargeTestScreen(tester);

        await tester.tap(find.text('Diário'));
        await tester.pump();

        await tester.tap(find.text('Personalizado'));
        await tester.pump();

        final mondayCheckbox = find.ancestor(
          of: find.text('Segunda'),
          matching: find.byType(CheckboxListTile),
        );

        final wednesdayCheckbox = find.ancestor(
          of: find.text('Quarta'),
          matching: find.byType(CheckboxListTile),
        );

        expect(mondayCheckbox, findsOneWidget);
        expect(wednesdayCheckbox, findsOneWidget);

        await tester.tap(mondayCheckbox);
        await tester.pump();

        await tester.tap(wednesdayCheckbox);
        await tester.pump();

        final checkboxes = tester
            .widgetList<CheckboxListTile>(
          find.byType(CheckboxListTile),
        )
            .toList();

        expect(checkboxes[0].value, true);
        expect(checkboxes[2].value, true);
      },
    );
  });
}