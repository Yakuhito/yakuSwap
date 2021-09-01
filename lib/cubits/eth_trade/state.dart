part of 'cubit.dart';

class EthTradeState extends Equatable {
  final EthTradeForm form;
  final bool forceReload;
  final String? warning;

  bool get canSubmit => form.status == FormzStatus.valid;

  const EthTradeState({
    required this.form,
    this.forceReload = false,
    this.warning = "",
  });

  EthTradeState copyWith({
    EthTradeForm? form,
    bool? forceReload,
    String? warning,
  }) => EthTradeState(
    form: form ?? this.form,
    forceReload: forceReload ?? this.forceReload,
    warning: warning ?? this.warning
  );

  @override
  List<Object?> get props => [form, forceReload, warning];
}