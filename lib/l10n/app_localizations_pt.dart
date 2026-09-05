// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Senha';

  @override
  String get login => 'Entrar';

  @override
  String get enterEmail => 'Informe o e-mail.';

  @override
  String get enterPassword => 'Informe a senha.';

  @override
  String get invalidEmail => 'O e-mail informado é inválido.';

  @override
  String get userNotFound => 'Usuário não encontrado.';

  @override
  String get wrongPassword => 'Senha incorreta.';

  @override
  String get invalidCredential => 'E-mail ou senha incorretos.';

  @override
  String get emailAlreadyInUse => 'Este e-mail já está cadastrado.';

  @override
  String get weakPassword => 'A senha é muito fraca.';

  @override
  String get networkRequestFailed => 'Verifique sua conexão com a internet.';

  @override
  String get tooManyRequests => 'Muitas tentativas. Tente novamente mais tarde.';

  @override
  String get authenticationError => 'Ocorreu um erro durante a autenticação.';

  @override
  String get appTitle => 'Tracking Your Habits';

  @override
  String get loginSuccess => 'Login realizado com sucesso!';

  @override
  String get habits => 'Hábitos';

  @override
  String get noHabits => 'Nenhum hábito cadastrado.';

  @override
  String get newHabit => 'Novo hábito';

  @override
  String get editHabit => 'Editar hábito';

  @override
  String get name => 'Nome';

  @override
  String get description => 'Descrição';

  @override
  String get frequency => 'Frequência';

  @override
  String get daily => 'Diário';

  @override
  String get weekly => 'Semanal';

  @override
  String get custom => 'Personalizado';

  @override
  String get customDays => 'Dias da semana';

  @override
  String get monday => 'Segunda';

  @override
  String get tuesday => 'Terça';

  @override
  String get wednesday => 'Quarta';

  @override
  String get thursday => 'Quinta';

  @override
  String get friday => 'Sexta';

  @override
  String get saturday => 'Sábado';

  @override
  String get sunday => 'Domingo';

  @override
  String get saveHabit => 'Salvar hábito';

  @override
  String get saveChanges => 'Salvar alterações';

  @override
  String get enterHabitName => 'Informe o nome do hábito.';

  @override
  String get selectCustomDay => 'Selecione pelo menos um dia da semana.';

  @override
  String get deleteHabit => 'Excluir hábito';

  @override
  String deleteHabitConfirmation(String habitName) {
    return 'Deseja excluir o hábito \"$habitName\"?';
  }

  @override
  String get cancel => 'Cancelar';
}
