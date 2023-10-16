

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  late TextEditingController _amountController;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    print("payment success");
  }

  void handlerErrorFailure() {
    print("payment failed");
  }

  void handlerExternalWallet() {
    print("External Wallet");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment App"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 350,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          const Text(
                            "Do Payment Here",
                            style: TextStyle(fontSize: 21),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: _amountController,
                              decoration: const InputDecoration(
                                  hintText: "Enter amount"),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return "Please Enter Amount";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // ignore: deprecated_member_use
                          ElevatedButton(
                            onPressed: () {
                              if (!_formkey.currentState!.validate()) {
                                return;
                              }
                              _formkey.currentState!.save();
                              var options = {
                                "key": "rzp_test_GYND61YfVU2oDJ",
                                "amount":
                                    num.parse(_amountController.text) * 100,
                                "name": "Startup Projects",
                                "description": "payment for our work",
                                "prefill": {
                                  "contact": "9342573263",
                                  "email": "dravi7350@gmail.com"
                                },
                                "external": {
                                  "wallets": ["paytm"]
                                },
                              };
                              try {
                                _razorpay.open(options);
                              } catch (e) {
                                print(e.toString());
                              }
                            },
                            child: const Text("Pay Now"),
                          )
                        ],
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}