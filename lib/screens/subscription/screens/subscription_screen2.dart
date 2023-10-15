import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubscriptionScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Student Assistsant Subscription",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StudentAssistantSubscription(),
    );
  }
}

class StudentAssistantSubscription extends StatefulWidget {
  @override
  _StudentAssistantSubscription createState() =>
      _StudentAssistantSubscription();
}

class _StudentAssistantSubscription
    extends State<StudentAssistantSubscription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: Icon(
          CupertinoIcons.back,
          color: Colors.black,
        ),
        title: Text(
          "Subscriptions",
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _netflixLogo(context),
            _netflix(context),
            _currentPlan(context),
            _infoBox(context),
            _cancelSubscription(context),
            Expanded(child: _otherPlanLayout(context))
          ],
        ),
      ),
    );
  }

  Widget _otherPlanLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * 0.1,
          left: MediaQuery.of(context).size.width * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _otherPlansLabel(context),
          _planRow(context),
        ],
      ),
    );
  }
}

Widget _planRow(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.8,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _standardPlanBox(context),
        SizedBox(width: MediaQuery.of(context).size.width * 0.03),
        _premiumPlanBox(context)
      ],
    ),
  );
}

Widget _standardPlanBox(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.04),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.redAccent[100],
        highlightColor: Colors.white,
        onTap: () => {print('Tapped')},
        child: Container(
          height: MediaQuery.of(context).size.width * 0.35,
          width: MediaQuery.of(context).size.width * 0.35,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.only(left: 5, top: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildPlansLabel('Standard'),
              _buildPlanPrice('\$12.99/mo'),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child:
                    _buildFeatureLabel('Simultaneous viewing\n up to 2 people'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _premiumPlanBox(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.04),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.redAccent,
        highlightColor: Colors.white,
        onTap: () => {print('Tapped')},
        child: Container(
          height: MediaQuery.of(context).size.width * 0.35,
          width: MediaQuery.of(context).size.width * 0.35,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.only(left: 5, top: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildPlansLabel('Premium'),
              _buildPlanPrice('\$18.99/mo'),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: _buildFeatureLabel('-4k Video Support'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: _buildFeatureLabel(
                    '-Simultaneous viewiing\n up to 4 people'),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildPlanPrice(String price) {
  return Text(
    price,
    style: TextStyle(
        color: Colors.black, fontWeight: FontWeight.w900, fontSize: 14),
    textAlign: TextAlign.center,
  );
}

Widget _buildFeatureLabel(String label) {
  return Text(
    label,
    style: TextStyle(
        letterSpacing: 0.2,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
        fontSize: 10),
  );
}

Widget _buildPlansLabel(String label) {
  return Text(
    label,
    style: TextStyle(
        letterSpacing: 0.1,
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 12),
    textAlign: TextAlign.center,
  );
}

Widget _otherPlansLabel(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.06),
    child: Text(
      'Other Plans',
      style: TextStyle(
          letterSpacing: 0.5,
          color: Colors.grey,
          fontWeight: FontWeight.w800,
          fontSize: 12),
      textAlign: TextAlign.center,
    ),
  );
}

Widget _cancelSubscription(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "CANCEL SUBSCRIPTION",
          style: TextStyle(
              letterSpacing: 0.5,
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 14),
          textAlign: TextAlign.center,
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        Icon(
          CupertinoIcons.forward,
          color: Colors.black,
        ),
      ],
    ),
  );
}

Widget _infoBox(BuildContext context) {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.08),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          'Your current subscription will end today. \nAnd will be renewed automatically.',
          style: TextStyle(
              letterSpacing: 1,
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

Widget _netflix(BuildContext context) {
  return Center(
    child: Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
      child: Text(
        'Netflix',
        style: TextStyle(
          fontSize: 34,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget _currentPlan(BuildContext context) {
  return Center(
    child: Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "\$9/Month",
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
          Text(
            "Basic Plan",
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

Widget _netflixLogo(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12),
    width: MediaQuery.of(context).size.width * 0.2,
    height: MediaQuery.of(context).size.width * 0.2,
    decoration:
        BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [
      BoxShadow(
          color: Colors.black54.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 1))
    ]),
    child: Center(
      child: Text(
        'N',
        style: TextStyle(
          fontSize: 34,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
