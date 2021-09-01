import 'package:formz/formz.dart';
import 'package:yakuswap/models/currency.dart';
import 'package:yakuswap/models/inputs/address_prefix.dart';
import 'package:yakuswap/models/inputs/directory.dart';
import 'package:yakuswap/models/inputs/host.dart';
import 'package:yakuswap/models/inputs/max_block_height.dart';
import 'package:yakuswap/models/inputs/min_confirmation_height.dart';
import 'package:yakuswap/models/inputs/port.dart';
import 'package:yakuswap/models/inputs/fee.dart';
import 'package:yakuswap/models/inputs/name.dart';
import 'package:yakuswap/models/inputs/photo_url.dart';
import 'package:yakuswap/models/inputs/units_per_coin.dart';

class CurrencyForm with FormzMixin {
  final AddressPrefixInput addressPrefix;
  final NameInput name;
  final PhotoURLInput photoURL;
  final UnitsPerCoinInput unitsPerCoin;
  final FeeInput minFee;
  final MaxBlockHeightInput defaultMaxBlockHeight;
  final MinConfirmationHeightInput defaultMinConfirmationHeight;
  final HostInput host;
  final PortInput port;
  final DirectoryInput sslDirectory;

  const CurrencyForm({
    this.addressPrefix = const AddressPrefixInput.pure(),
    this.name = const NameInput.pure(),
    this.photoURL = const PhotoURLInput.pure(),
    this.unitsPerCoin = const UnitsPerCoinInput.pure(),
    this.minFee = const FeeInput.pure(),
    this.defaultMaxBlockHeight = const MaxBlockHeightInput.pure(),
    this.defaultMinConfirmationHeight = const MinConfirmationHeightInput.pure(),
    this.host = const HostInput.pure(),
    this.port = const PortInput.pure(),
    this.sslDirectory = const DirectoryInput.pure(),
  });
  
  CurrencyForm.fromCurrency({required Currency currency}) :
    addressPrefix = AddressPrefixInput.dirty(value: currency.addressPrefix),
    name = NameInput.dirty(value: currency.name),
    photoURL = PhotoURLInput.dirty(value: currency.photoUrl),
    unitsPerCoin = UnitsPerCoinInput.dirty(value: "${currency.unitsPerCoin}"),
    minFee = FeeInput.dirty(value: "${currency.minFee}"),
    defaultMaxBlockHeight = MaxBlockHeightInput.dirty(value: "${currency.defaultMaxBlockHeight}"),
    defaultMinConfirmationHeight = MinConfirmationHeightInput.dirty(value: "${currency.defaultMinConfirmationHeight}"),
    host = HostInput.dirty(value: currency.host),
    port = PortInput.dirty(value: "${currency.port}"),
    sslDirectory = DirectoryInput.dirty(value: currency.sslDirectory);

  CurrencyForm copyWith({
    AddressPrefixInput? addressPrefix,
    NameInput? name,
    PhotoURLInput? photoURL,
    UnitsPerCoinInput? unitsPerCoin,
    FeeInput? minFee,
    MaxBlockHeightInput? defaultMaxBlockHeight,
    MinConfirmationHeightInput? defaultMinConfirmationHeight,
    HostInput? host,
    PortInput? port,
    DirectoryInput? sslDirectory,
  }) => CurrencyForm(
    addressPrefix: addressPrefix ?? this.addressPrefix,
    name: name ?? this.name,
    photoURL: photoURL ?? this.photoURL,
    unitsPerCoin: unitsPerCoin ?? this.unitsPerCoin,
    minFee: minFee ?? this.minFee,
    defaultMaxBlockHeight: defaultMaxBlockHeight ?? this.defaultMaxBlockHeight,
    defaultMinConfirmationHeight: defaultMinConfirmationHeight ?? this.defaultMinConfirmationHeight,
    host: host ?? this.host,
    port: port ?? this.port,
    sslDirectory: sslDirectory ?? this.sslDirectory
  );

  Currency? toCurrency() => status == FormzStatus.valid ? Currency(
    addressPrefix: addressPrefix.value,
    name: name.value,
    photoUrl: photoURL.value,
    unitsPerCoin: int.parse(unitsPerCoin.value),
    minFee: int.parse(minFee.value),
    defaultMaxBlockHeight: int.parse(defaultMaxBlockHeight.value),
    defaultMinConfirmationHeight: int.parse(defaultMinConfirmationHeight.value),
    host: host.value,
    port: int.parse(port.value),
    sslDirectory: sslDirectory.value,
  ) : null;

  @override
  List<FormzInput> get inputs => [addressPrefix, name, photoURL, unitsPerCoin, minFee, defaultMaxBlockHeight, defaultMinConfirmationHeight, host, port, sslDirectory];
}
