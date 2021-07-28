part of 'cubit.dart';

class TradeState extends Equatable {
  final TradeForm form;
  final bool forceReload;

  bool get canSubmit => form.status == FormzStatus.valid;

  const TradeState({
    required this.form,
    this.forceReload = false,
  });

  TradeState copyWith({
    TradeForm? form,
    bool forceReload = false,
  }) => TradeState(form: form ?? this.form, forceReload: forceReload);

  @override
  List<Object?> get props => [form];

  
}