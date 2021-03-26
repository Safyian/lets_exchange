import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class Services {
  // ******** Post Image to Storage and getting it's url *******
  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref().child('products').child(fileName);
    UploadTask uploadTask =
        reference.putData((await imageFile.getByteData()).buffer.asUint8List());
    TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {
      print('image uploaded');
    });
    print(storageTaskSnapshot.ref.getDownloadURL());
    return storageTaskSnapshot.ref.getDownloadURL();
  }

  // ******** Money Formattor *********
  formateMoney(double amount) {
    FlutterMoneyFormatter fmf = new FlutterMoneyFormatter(
      amount: amount,
      settings: MoneyFormatterSettings(
        symbol: 'Rs.',
        fractionDigits: 0,
      ),
    );
    return fmf.output.symbolOnLeft;
  }
}
