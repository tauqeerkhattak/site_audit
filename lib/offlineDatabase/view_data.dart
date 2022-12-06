import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:site_audit/domain/controllers/form_controller.dart';
import 'package:site_audit/offlineDatabase/dataBaseController.dart';

class ViewData extends StatefulWidget {
  const ViewData({Key? key}) : super(key: key);

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  final controller = Get.put(DataBaseController());
  @override
  void initState() {
    // TODO: implement initState
    controller.getAllForms();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Center(
        child: controller.loading.value == true ? Padding (
          padding: const EdgeInsets.all(8.0),
          child: controller.images.value.isNotEmpty?ListView.builder(
              itemCount: controller.dataBaseModel1.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    child: Column(
                      children: [
                        Text("Form number ${index + 1}",style: const TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            Container(
                              child: Row(
                                children: [
                                  const Text("Sub Module Id: ",style: TextStyle(color: Colors.black,fontSize: 16),),
                                  Text("${controller.dataBaseModel1[index].sub_module_id}",style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  const Text("Sub Module Name: ",style: TextStyle(color: Colors.black,fontSize: 16),),
                                  Text("${controller.dataBaseModel1[index].sub_module_name}",style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  const Text("Module Name: ",style: TextStyle(color: Colors.black,fontSize: 16),),
                                  Text("${controller.dataBaseModel1[index].module_name}",style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: Row(
                            children: [
                              const Text("Project Id: ",style: TextStyle(color: Colors.black,fontSize: 16),),
                              Text("${controller.dataBaseModel1[index].project_id}",style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                        const Text("Form Items",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                        Expanded(
                          child: ListView.builder(
                              itemCount: controller.dataBaseModel1[index].items!.length,
                              itemBuilder: (BuildContext context, int i) {
                                return Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          const Text("Item Id: ",style: TextStyle(color: Colors.black,fontSize: 16),),
                                          Text("${controller.dataBaseModel1[index].items![i].id}",style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          const Text("Input Description: ",style: TextStyle(color: Colors.black,fontSize: 16),),
                                          Text("${controller.dataBaseModel1[index].items![i].inputDescription}",style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          const Text("Answer: ",style: TextStyle(color: Colors.black,fontSize: 16),),
                                          Text("${controller.dataBaseModel1[index].items![i].answer}",style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          const Text("Input Type: ",style: TextStyle(color: Colors.black,fontSize: 16),),
                                          Text("${controller.dataBaseModel1[index].items![i].inputType}",style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          const Text("Input Parameter: ",style: TextStyle(color: Colors.black,fontSize: 16),),
                                          Text("${controller.dataBaseModel1[index].items![i].inputParameter}",style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          const Text("Input Length: ",style: TextStyle(color: Colors.black,fontSize: 16),),
                                          Text("${controller.dataBaseModel1[index].items![i].inputLength}",style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          const Text("Input Hint: ",style: TextStyle(color: Colors.black,fontSize: 16),),
                                          Text("${controller.dataBaseModel1[index].items![i].inputHint}",style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          const Text("Parent Input Id: ",style: TextStyle(color: Colors.black,fontSize: 16),),
                                          Text("${controller.dataBaseModel1[index].items![i].parentInputId}",style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          const Text("Input Label: ",style: TextStyle(color: Colors.black,fontSize: 16),),
                                          Text("${controller.dataBaseModel1[index].items![i].parentInputId}",style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          const Text("File Name: ",style: TextStyle(color: Colors.black,fontSize: 16),),
                                          Text("${controller.dataBaseModel1[index].items![i].filename}",style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                        ],
                                      ),

                                    ),
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),

                  ),
                );
              }):const Text("No Data Found",style:  TextStyle(color: Colors.black,fontSize: 16),),
        ):CircularProgressIndicator(color: Theme.of(context).primaryColor,),
      )),
    );
  }
}
