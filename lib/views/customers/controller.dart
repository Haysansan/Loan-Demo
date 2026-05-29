import 'package:apploan/models/customer/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/core/offline/database_helper.dart';
import 'package:apploan/flavor/flavor.dart';
import 'package:apploan/models/models.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:apploan/views/views.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomersController extends GetxController {
  final RxInt selectedStatusValue = 0.obs;
  final TextEditingController startBillCreateDateCtl = TextEditingController();
  final TextEditingController endBillCreateDateCtl = TextEditingController();
  final TextEditingController startBillFinishDateCtl = TextEditingController();
  final TextEditingController endBillFinishDateCtl = TextEditingController();
  final TextEditingController searchCtl = TextEditingController();

  final RxList<ClientModel> customerModel = <ClientModel>[].obs;
  final RxBool isLoading = false.obs;
  final PaginationModel pagination = PaginationModel(limit: 15);
  final RefreshController refreshCtl = RefreshController(initialRefresh: false);
  final RxBool isToggleOpen = false.obs;
  num total = 0;

  final StartController startCtl = Get.find<StartController>();

  @override
  void onInit() {
    fetchClient();
    super.onInit();
  }

  @override
  void onClose() {
    startBillCreateDateCtl.dispose();
    endBillCreateDateCtl.dispose();
    startBillFinishDateCtl.dispose();
    endBillCreateDateCtl.dispose();
    searchCtl.dispose();
    refreshCtl.dispose();
    super.onClose();
  }

  // show branch_id for login
  Future<int?> getbranchId() async {
    int? branchId = await SharedPreferencesManager.getIntValue('branch_id');
    return branchId;
  }

  // show user_id from login
  Future<int?> getUserId() async {
    int? user_id = await SharedPreferencesManager.getIntValue('user_id');
    return user_id;
  }

  Future<void> fetchClientSearch({
    bool isRefresh = false,
    bool isLoadMore = false,
    bool isFilter = false,
  }) async {
    if (isFilter == true) {
      String searchText = searchCtl.text.toLowerCase();
      customerModel.value = List<ClientModel>.from(
        customerModel.value.where(
          (item) =>
              item.name.toLowerCase().contains(searchText) ||
              item.client_code.toLowerCase().contains(searchText),
        ),
      );
    } else {
      onRefresh();
    }
  }

  Future<void> fetchClient({
    bool isRefresh = false,
    bool isLoadMore = false,
    bool isFilter = false,
  }) async {
    int? branchId = await getbranchId();
    int? user_id = await getUserId();
    try {
      if (isRefresh) {
        if (!isFilter) {
          clearFitler();
        }
        pagination.refresh();
      }

      if (pagination.isEndOfPage) {
        return;
      }

      // Show loading only when first time and filter
      if ((!isRefresh && !isLoadMore) || isFilter) {
        isLoading.value = true;
      }

      final Map<String, dynamic> params = {
        'branch_id': branchId,
        'user_id': user_id,
      };

      String endPoint = EndPoints.getClientList;
      if (UserRepository.shared.isCO) {
        endPoint = EndPoints.repayment;
      }

      final res = await Get.find<ApiService>().get(
        endPoint,
        queryParameters: params,
        isShowLoading: false,
      );

      // Take care of load more error when while load more user switch the tap
      if (startCtl.selectedIndex.value != 3 && isLoadMore) {
        return;
      }

      // final data = getPropertyFromJson(DatabaseHelper.instance.queryAllRowsRepayments(1),"data");
      // print(data);
      // final data = getPropertyFromJson(res.data, 'data');
      final dataWrapper = getPropertyFromJson(res.data, 'data');
      final data = getPropertyFromJson(dataWrapper, 'data');

      // total = getPropertyFromJson(res.data['totalAmount'], 'total') ?? 0;
      // pagination.checkLoadMore((data['data'] as List).length);

      if (isRefresh) {
        customerModel.value = List<ClientModel>.from(
          (data as List).map((e) => ClientModel.fromJson(e)).toList(),
        );
      } else {
        customerModel.addAll(
          List<ClientModel>.from(
            (data as List).map((e) => ClientModel.fromJson(e)).toList(),
          ),
        );
      }
    } catch (e) {
      if (isClosed) {
        return;
      }
      ExceptionHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onRefresh({bool isFilter = false}) async {
    await fetchClient(isRefresh: true, isFilter: isFilter);
    refreshCtl.refreshCompleted();
  }

  Future<void> onLoading() async {
    await fetchClient(isLoadMore: true);
    refreshCtl.loadComplete();
  }

  DatePicker getStartBillCreatePicker(
    TextEditingController startDateCtl,
    TextEditingController endDateCtl,
  ) {
    final DatePicker startPicker = DatePicker(
      controller: startDateCtl,
      initialDate:
          startDateCtl.text.isEmpty
              ? DateTime.parse(
                '${DateFormat("yyyy-MM-dd").format(DateTime.now())} 00:00:00',
              )
              : DateTime.parse(startDateCtl.text),
      minDate: DateTime(DateTime.now().year - 200),
      maxDate:
          endDateCtl.text.isEmpty
              ? DateTime(DateTime.now().year + 200)
              : DateTime.parse(
                endDateCtl.text,
              ).subtract(const Duration(days: 1)),
      minYear: DateTime.now().year - 200,
      maxYear: DateTime.now().year + 200,
    );
    return startPicker;
  }

  DatePicker getEndBillCreatePicker(
    TextEditingController startDateCtl,
    TextEditingController endDateCtl,
  ) {
    final DatePicker startPicker = DatePicker(
      controller: endDateCtl,
      initialDate:
          endDateCtl.text.isNotEmpty
              ? DateTime.parse(endDateCtl.text)
              : startDateCtl.text.isNotEmpty
              ? DateTime.parse(startDateCtl.text)
              : DateTime.parse(
                '${DateFormat("yyyy-MM-dd").format(DateTime.now())} 00:00:00',
              ),
      minDate:
          startDateCtl.text.isNotEmpty
              ? DateTime.parse(startDateCtl.text)
              : endDateCtl.text.isNotEmpty
              ? DateTime.parse(endDateCtl.text)
              : DateTime(DateTime.now().year - 200),
      maxDate: DateTime(DateTime.now().year + 200),
      minYear:
          startDateCtl.text.isEmpty
              ? DateTime.now().year - 200
              : DateTime.parse(startDateCtl.text).year,
      maxYear: DateTime.now().year + 200,
    );
    return startPicker;
  }

  List<IdNameModel> getStatus() {
    final List<IdNameModel> status = [
      IdNameModel(id: 0, name: '--- ${LocaleKeys.chooseDeliveyStatus.tr} ---'),
      IdNameModel(id: 1, name: LocaleKeys.inStock.tr),
      IdNameModel(id: 2, name: LocaleKeys.inprogress.tr),
      IdNameModel(id: 3, name: LocaleKeys.complete.tr),
      IdNameModel(id: 4, name: LocaleKeys.returned.tr),
    ];
    return status;
  }

  void setSearchValue() {
    startBillCreateDateCtl.clear();
    endBillCreateDateCtl.clear();
    startBillFinishDateCtl.clear();
    endBillCreateDateCtl.clear();
    selectedStatusValue.value = 0;
  }

  void setFilterValue({num value = 0}) {
    searchCtl.text = '';
  }

  void clearFitler({int status = 0}) {
    searchCtl.text = '';
    selectedStatusValue.value = status;
    startBillCreateDateCtl.clear();
    endBillCreateDateCtl.clear();
    startBillFinishDateCtl.clear();
    endBillCreateDateCtl.clear();
  }
}
