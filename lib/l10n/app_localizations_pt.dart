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
}
