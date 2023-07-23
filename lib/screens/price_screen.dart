import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bitcoin_ticker/classes/coin_data.dart';
import 'package:bitcoin_ticker/utilities/generative_functions.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io' show Platform;
import '../utilities/constants.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  dynamic crypto = cryptoList.first;
  dynamic currency = currenciesList.first;

  // Initialized to zero for all cryptos using initState
  List<String> rates = [];

  void getExchangeRate({required currency}) async {
    CoinData coinApi = CoinData();
    int indexOfCurrentCrypto = 0;

    for (var crypto in cryptoList) {
      var exchangeRate =
          await coinApi.getJsonResponse(crypto: crypto, currency: currency);
      double rateValue = exchangeRate['rate'];

      setState(() {
        this.currency = currency;
        rates[indexOfCurrentCrypto] = rateValue.toStringAsFixed(2);
      });

      indexOfCurrentCrypto++;
    }
  }

  DropdownButton androidCurrencies() {
    List<DropdownMenuItem<Object>> androidCurrencyList = [];

    for (int i = 0; i < currenciesList.length; i++) {
      androidCurrencyList.add(
        DropdownMenuItem(
          value: currenciesList[i],
          child: Text(currenciesList[i]),
        ),
      );
    }

    // Tap into loaded list and return widget
    return DropdownButton(
      value: currency,
      items: androidCurrencyList,
      onChanged: (value) {
        getExchangeRate(currency: value);
      },
    );
  }

  CupertinoPicker iOSCurrencies() {
    List<Text> iosCurrencyPickerList = [];

    for (String currency in currenciesList) {
      iosCurrencyPickerList.add(Text(currency));
    }

    // Tap into loaded list and return widget
    return CupertinoPicker(
      itemExtent: 35.0,
      onSelectedItemChanged: (selectedCurrencyIndex) {
        getExchangeRate(currency: currenciesList[selectedCurrencyIndex]);
      },
      children: iosCurrencyPickerList,
    );
  }

  // Using dart:io library
  Widget currencyWidget() {
    if (kIsWeb) {
      return iOSCurrencies();
    } else if (Platform.isIOS) {
      return iOSCurrencies();
    } else {
      return androidCurrencies();
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialized to zero for all cryptos
    for (int i = 0; i < cryptoList.length; i++) {
      rates.add('0');
    }
    getExchangeRate(currency: currency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('🤑 Coin Ticker'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: getCryptoCards(rates: rates, currency: currency),
          ),
          const SpinKitWave(
            color: Colors.blue,
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Center(
              child: currencyWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
