import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';

class LabelOverrides extends DefaultLocalizations {
  const LabelOverrides();

  @override
  String get isNotAValidEmailErrorText =>
      "学校のメール（＠ed.ritsumei.ac.jp)を入力してください。";

  @override
  String get emailIsRequiredErrorText => "メールアドレスを入力してください。";

  @override
  String get deleteAccount => "アカウント削除";

  @override
  String get signInActionText => "ログイン";

  @override
  String get signInText => "ログイン";

  @override
  String get signInHintText => "既にアカウントをお持ちの方";

  @override
  String get signOutButtonText => "ログアウト";

  @override
  String get registerActionText => "作成する";

  @override
  String get registerText => "作成する";

  @override
  String get registerHintText => "アカウントをお持ちでない方";

  @override
  String get forgotPasswordButtonLabel => "パスワードを忘れた場合はこちら";

  @override
  String get confirmPasswordInputLabel => "パスワードの確認";

  @override
  String get confirmPasswordIsRequiredErrorText => "パスワードが正しくありません。";

  @override
  String get passwordIsRequiredErrorText => "パスワードが正しくありません。";

  @override
  String get resetPasswordButtonLabel => "パスワードのリセット";

  @override
  String get goBackButtonLabel => "戻る";

  @override
  String get forgotPasswordViewTitle => "パスワードの再設定";

  @override
  String get forgotPasswordHintText =>
      "ご登録済みのメールアドレスをご入力ください。パスワードの再設定を行うためのメールをお送りいたします。";
}
