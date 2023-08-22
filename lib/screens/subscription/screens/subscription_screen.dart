import 'package:flutter/material.dart';
import 'package:giphy_get/l10n.dart';
import 'package:in_app_purchases_paywall_ui/in_app_purchases_paywall_ui.dart';

class SubscriptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Demo Supscription",
      theme: ThemeData(
          primarySwatch: Colors.blue,
          iconTheme: IconThemeData(color: Colors.lightBlue[100]),
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(46, 101, 185, 1),
              brightness: Brightness.light),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
          )),
      supportedLocales: [
        const Locale("en"),
        const Locale("vi"),
      ],
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return PaywallScaffold(
      appBarTitle: "YourApp Premium",
      child: MoritzPaywall(
        title: "Go Premium",
        subTitle:
            "Enjoy all the advantages of YourApp with the Premium subscription.",
        continueText: "Continue",
        bulletPoints: [
          IconAndText(Icons.stop_screen_share_outlined, "No Ads"),
          IconAndText(Icons.hd, "Premium HD"),
          IconAndText(Icons.sort, "Access to All Premium Articles")
        ],
        subscriptionListData: [
          SubscriptionData(
              durationTitle: "Yearly",
              durationShort: "12 months",
              price: "100000VND",
              highlightText: "Most Popular",
              dealPercentage: 59,
              productDetails: "Test1",
              currencySymbol: "VND",
              rawPrice: 10.00,
              monthText: "m",
              duration: "P1Y",
              index: 3),
          SubscriptionData(
              durationTitle: "Monthly",
              durationShort: "6 months",
              price: "30000",
              dealPercentage: 40,
              productDetails: "Test2",
              currencySymbol: "VND",
              rawPrice: 3.00,
              monthText: "m",
              duration: "P6M",
              index: 2),
          SubscriptionData(
              durationTitle: "Monthly",
              durationShort: "1 month",
              price: "30000",
              dealPercentage: 0,
              productDetails: "Test3",
              currencySymbol: "VND",
              rawPrice: 2.99,
              monthText: "m",
              duration: "P1M",
              index: 1)
        ],
        successTitle: "Sucess!!",
        successSubTitle: "Thanks for choosing Premium!",
        successWidget: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  print("test1");
                },
                child: Text("Let's go!"),
              ),
            ],
          ),
        ),
        isSubscriptionLoading: false,
        isPurchaseInProgress: false,
        purchaseState: PurchaseState.NOT_PURCHASED,
      ),
    );
  }
}
