import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main()
{
  runApp(MaterialApp(
    home: pay(),
  ));
}
class pay extends StatefulWidget {
  const pay({Key? key}) : super(key: key);

  @override
  State<pay> createState() => _payState();
}

class _payState extends State<pay> {
  List name=["tomato","potato","brinjal"];
  List desc=["buy 1kg tomato","buy 2kg potato","buy 3 kg brinjal"];
  List rupy_value=[1,2,3];
  List rupy=[100,200,300];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Payment app"),),
        body: ListView.builder(itemCount: name.length,itemBuilder: (context, index) {
          return ListTile(
            title: Text("${name[index]}"),
            subtitle: Text("${rupy_value[index]}"),
            trailing: ElevatedButton(onPressed: (){
              Razorpay razorpay = Razorpay();
              var options = {
                'key': 'rzp_test_hd4iFPwKZV9fER',
                'amount': rupy[index],
                'name': '${name[index]}',
                'description': '${desc[index]}',
                'retry': {'enabled': true, 'max_count': 1},
                'send_sms_hash': true,
                'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
                'external': {
                  'wallets': ['paytm']
                }
              };
              razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
              razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
              razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
              razorpay.open(options);
            },
                child: const Text("Pay Now")),
          );

        },),

    );
  }
  void handlePaymentErrorResponse(PaymentFailureResponse response){
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

