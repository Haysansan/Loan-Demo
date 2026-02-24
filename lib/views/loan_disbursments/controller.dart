import 'dart:io';

import 'package:apploan/core/core.dart';
import 'package:apploan/core/offline/database_helper.dart';
import 'package:apploan/models/models.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanDisbursmentsController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController numberOfPackagesCtl = TextEditingController();
  final TextEditingController phoneNumberCtl = TextEditingController();
  final TextEditingController totalAmountCtl = TextEditingController();
  final TextEditingController destinationCtl = TextEditingController();
  final TextEditingController descriptionCtl = TextEditingController();
  final TextEditingController dateOpenLoanCtl = TextEditingController();
  final TextEditingController dateFirstRepaymentCtl = TextEditingController();
  final TextEditingController instCtl = TextEditingController();
  final TextEditingController principlCtl = TextEditingController();
  final TextEditingController intCtl = TextEditingController();
  final TextEditingController addminFeeCtl = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isLoadings = false.obs;
  final RxBool isLoadings1 = false.obs;
  final RxBool isLoading1 = false.obs;

  List<ClientDisbModel> ClientList = [];

  final Rxn<ProductDetailModel> productList = Rxn<ProductDetailModel>();
  ClientDisbModel? clientSelected;

  List<StaffModel> StaffList = [];
  StaffModel? StaffSelected;

  List<ProductModel> ProductList = [];
  ProductModel? ProductSelected;

  @override
  void onInit() async {
    await fetchUser();
    await fetchProduct();
    DateTime now = DateTime.now();
    dateOpenLoanCtl.text = DateFormat('yyyy-MM-dd').format(now);
    dateFirstRepaymentCtl.text =
        DateFormat('yyyy-MM-dd').format(now.add(Duration(days: 1)));
    super.onInit();
  }

  // show branch_id for login
  Future<int?> getbranchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? branchId = prefs.getInt('branch_id');
    return branchId;
  }

  // show user_id from login
  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? user_id = prefs.getInt('user_id');
    return user_id;
  }

  //get product
  Future<void> fetchProduct() async {
    try {
      isLoading.value = true;
      ProductList = await DatabaseHelper.instance.queryAllRowsProducts();
    } catch (e) {
      if (isClosed) {
        return;
      }
      ExceptionHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  // get product detail
  Future<void> fetchProductDetail(num? id) async {
    final Map<String, dynamic> params = {
      'id': id,
    };

    try {
      isLoadings1.value = true;

      // Make the API call
      final res = await Get.find<ApiService>().get(
        EndPoints.getproduct_detail,
        queryParameters: params,
        isShowLoading: false,
      );

      // Assuming res.data is a Map with a key 'data' that holds a list of product details
      final data = getPropertyFromJson(res.data, 'data');

      // Check if 'data' is indeed a List
      if (data is List<dynamic>) {
        // Parse the list of products
        final products =
            data.map((json) => ProductDetailModel.fromJson(json)).toList();
        // Assuming you need to set specific fields from the first product in the list
        if (products.isNotEmpty) {
          final product = products.first;
          principlCtl.text =
              formatCurrency(product.principal as String) ?? '0.00';
          instCtl.text = (product.loan_term ?? 0).toString();
          intCtl.text = product.interest_rate ?? '0.000';
          addminFeeCtl.text = product.fee ?? '0.000';
        }
      } else {
        print('Expected a list of products but got something else.');
      }
    } catch (e) {
      if (isClosed) {
        return;
      }
      ExceptionHandler.handleException(e);
    } finally {
      isLoadings1.value = false;
    }
  }

  Future<void> fetchUser() async {
    try {
      isLoadings.value = true;
      StaffList = await DatabaseHelper.instance.queryAllRowsStaff();
    } catch (e) {
      if (isClosed) {
        return;
      }
      ExceptionHandler.handleException(e);
    } finally {
      isLoadings.value = false;
    }
  }

  Future<void> fetchClient(num? staffId) async {
    int? branchId = await getbranchId();
    try {
      isLoading1.value = true;
      final Map<String, dynamic> params = {
        'branch_id': branchId,
        'user_id': staffId,
      };
      final res = await Get.find<ApiService>().get(
        EndPoints.getClientDisb,
        queryParameters: params,
      );
      final data = getPropertyFromJson(res.data, 'data');
      ClientList =
          List.from((data as List).map((e) => ClientDisbModel.fromJson(e)));
    } catch (e) {
      if (isClosed) {
        return;
      }
      ExceptionHandler.handleException(e);
    } finally {
      isLoading1.value = false;
    }
  }

  DatePicker getDateFirstPicker() {
    final DatePicker startPicker = DatePicker(
      controller: dateFirstRepaymentCtl,
      initialDate: dateFirstRepaymentCtl.text.isEmpty
          ? DateTime.parse(
              '${DateFormat("yyyy-MM-dd").format(DateTime.now())} 00:00:00')
          : DateTime.parse(dateFirstRepaymentCtl.text),
      minDate: DateTime(DateTime.now().year),
      maxDate: DateTime(DateTime.now().year + 200),
      minYear: DateTime.now().year,
      maxYear: DateTime.now().year + 200,
    );
    return startPicker;
  }

  DatePicker getDatePicker() {
    final DatePicker startPicker = DatePicker(
      controller: dateOpenLoanCtl,
      initialDate: dateOpenLoanCtl.text.isEmpty
          ? DateTime.parse(
              '${DateFormat("yyyy-MM-dd").format(DateTime.now())} 00:00:00')
          : DateTime.parse(dateOpenLoanCtl.text),
      minDate: DateTime(DateTime.now().year),
      maxDate: DateTime(DateTime.now().year + 200),
      minYear: DateTime.now().year,
      maxYear: DateTime.now().year + 200,
    );
    return startPicker;
  }

  String formatCurrency(String amount) {
    // ignore: unnecessary_null_comparison
    return amount != null
        ? '${NumberFormat.currency(locale: 'en_US', symbol: '').format(double.parse(amount))}'
            .replaceAll('.00', '')
        : 'N/A';
  }

  void onClientChanged(ClientDisbModel? selectedClient) {
    clientSelected = selectedClient;
  }

  void onProductChanged(ProductModel? selectedClient) {
    ProductSelected = selectedClient;
  }

// Method to handle staff selection change
  Future<void> onStaffChanged(StaffModel? selectedStaff) async {
    StaffSelected = selectedStaff;
    await fetchClient(
        StaffSelected?.id); // Fetch clients based on selected staff
  }

  Future<void> submitBooking() async {
    try {
      int? branchId = await getbranchId();
      int? userId = await getUserId();
      dio.FormData formData = dio.FormData.fromMap({
        // This static because of feature removed
        'branch_id': branchId,
        'user_id': userId,
        'client_id': clientSelected?.id,
        'loan_officer_id': StaffSelected?.id,
        'loan_product_id': ProductSelected?.id,
        'applied_amount': principlCtl.text,
        'loan_term': instCtl.text,
        'interest_rate': intCtl.text,
        'first_payment_date': dateFirstRepaymentCtl.text,
      });

      await Get.find<ApiService>().post(
        EndPoints.storeDisburment,
        formData,
        isShowLoading: true,
      );

      DialogManager.showDialog(
        title: LocaleKeys.successfully.tr,
        subTitle: LocaleKeys.youHavesuccessfullyCreatedTheBooking.tr,
        onPressed: () => Get.back(),
      );
    } catch (e) {
      if (isClosed) {
        return;
      }
      ExceptionHandler.handleException(e);
    }
  }

  final RxList<File> imageFiles = RxList<File>([File('')]);
  final int totalImage = 5;
  bool isNoMoreUpload() {
    return imageFiles.length == totalImage + 1; // 1 is for placeholder image
  }
}
