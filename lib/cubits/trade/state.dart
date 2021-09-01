part of 'cubit.dart';

class TradeState extends Equatable {
  final TradeForm form;
  final bool forceReload;
  final String? warning;

  bool get canSubmit => form.status == FormzStatus.valid;

  const TradeState({
    required this.form,
    this.forceReload = false,
    this.warning,
  });

  TradeState copyWith({
    TradeForm? form,
    bool forceReload = false,
    String? warning,
  }) => TradeState(form: form ?? this.form, forceReload: forceReload, warning: warning ?? this.warning);

  @override
  List<Object?> get props => [form, forceReload, warning];

  
}