import 'package:bitcoin_ticker/classes/crypto_card.dart';
import 'constants.dart';

List<CryptoCard> getCryptoCards(
    {required List<String> rates, required String currency}) {
  List<CryptoCard> cryptoCards = [];
  int indexOfCurrentCrypto = 0;

  for (String crypto in cryptoList) {
    cryptoCards.add(CryptoCard(
      rate: rates[indexOfCurrentCrypto],
      currency: currency,
      crypto: crypto,
    ));
    indexOfCurrentCrypto++;
  }
  return cryptoCards;
}
