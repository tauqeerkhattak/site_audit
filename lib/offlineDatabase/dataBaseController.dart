import 'package:get/get.dart';
import 'package:site_audit/models/DataBaseModel.dart';
import 'package:site_audit/offlineDatabase/database.dart';

class DataBaseController extends GetxController{
  final loading = RxBool(false);
  RxList images = [].obs;
  List<DataBaseItem> dataBaseItem1= [];
  List<DataBaseModel> dataBaseModel1 = [];
  DataBaseModel? dataBaseModel;


  List? getAllForms(){
    loading.value = false;
    DatabaseDb databaseDb = DatabaseDb();
    databaseDb.getForm().then((value) {
      for(int i = 0; i < value.length; i++){
        dataBaseModel1.add(value[i]);
      }
      //loading.value = true;
      }).whenComplete(() => loading.value = true);
    loading.value = false;
  }

}