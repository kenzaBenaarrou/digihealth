import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'locale_provider.g.dart';
@riverpod
class LocaleProvider extends _$LocaleProvider {
  @override
  String build() {
    return 'en';
  }

  void changeLocale(String locale) {
    state = locale;
  }
}