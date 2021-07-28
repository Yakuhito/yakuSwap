part of 'cubit.dart';

class CurrencyState extends Equatable {
  final CurrencyForm form;
  final bool forceReload;

  bool get canSubmit => form.status == FormzStatus.valid;

  const CurrencyState({
    required this.form,
    this.forceReload = false,
  });

  CurrencyState copyWith({
    CurrencyForm? form,
    bool forceReload = false,
  }) => CurrencyState(form: form ?? this.form, forceReload: forceReload);

  @override
  List<Object?> get props => [form, forceReload];

  
}