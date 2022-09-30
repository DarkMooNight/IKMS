import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:horizontal_center_date_picker/datepicker_controller.dart';
import 'package:horizontal_center_date_picker/horizontal_date_picker.dart';
import 'package:project_cdis/app/data/shedule.dart';
import 'package:project_cdis/app/modules/audiences/view.dart';
import 'package:project_cdis/app/modules/professors/view.dart';
import 'package:project_cdis/app/modules/settings/view.dart';

import '../../services/remote_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime now = DateTime.now();
  DatePickerController datePickerController = DatePickerController();
  DateTime? selectedDay;
  var isLoaded = false;
  String? dateNow;
  final tabIndex = 0.obs;

  Rasp? raspElement;
  List<RaspElement>? raspElements;

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime(now.year, now.month, now.day);

    getData();
  }

  getData() async {
    raspElement = await RomoteServise().getRaspElementData();
    raspElements = await RomoteServise().getRaspsElementData();
    if (raspElement != null) {
      setState(() {
        isLoaded = true;
        getRasp();
      });
    }
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  void getRasp() {
    var value = selectedDay!.toIso8601String().substring(0, 19);
    setState(() {
      raspElements = raspElement?.data.rasp.where((element) {
        var raspTitle = element.date;
        return raspTitle.contains(value);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();
    var theme = Theme.of(context);
    final squareWidth = Get.width;
    return Scaffold(
      body: Obx(
        (() => IndexedStack(
              index: tabIndex.value,
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15.w, bottom: 8.w),
                        child: Text(
                          AppLocalizations.of(context)!.schedule,
                          style: theme.textTheme.headline2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 5.w, horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: HorizontalDatePickerWidget(
                            locale: '$tag',
                            selectedColor: Colors.blue,
                            normalColor: theme.primaryColor,
                            disabledColor: theme.primaryColor,
                            selectedTextColor: theme.dividerColor,
                            normalTextColor: theme.disabledColor,
                            startDate: DateTime(2022, 09, 01),
                            endDate: DateTime(2100, 09, 01),
                            selectedDate: selectedDay!,
                            widgetWidth: MediaQuery.of(context).size.width,
                            datePickerController: datePickerController,
                            onValueSelected: (date) {
                              selectedDay = date;
                              getRasp();
                            },
                          ),
                        ),
                      ),
                      Divider(
                        color: theme.dividerColor,
                        height: 20.w,
                        thickness: 2,
                        indent: 10.w,
                        endIndent: 10.w,
                      ),
                      Expanded(
                        child: Visibility(
                          visible: isLoaded,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ListView.builder(
                            itemCount: raspElements?.length,
                            itemBuilder: (BuildContext context, int index) {
                              final raspElementPage = raspElements?[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 10.w),
                                    child: Text(
                                        '${raspElementPage!.beginning}-${raspElementPage.end}',
                                        style: theme.textTheme.headline6),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 5.w),
                                    child: Container(
                                      height: 120.w,
                                      width: squareWidth,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15)),
                                          color: theme.primaryColor),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(raspElementPage.discipline,
                                                style:
                                                    theme.textTheme.headline6),
                                            Flexible(
                                                child: SizedBox(height: 10.w)),
                                            Text(raspElementPage.teacher,
                                                style: theme.primaryTextTheme
                                                    .subtitle1),
                                            Flexible(
                                                child: SizedBox(height: 10.w)),
                                            Text(raspElementPage.audience,
                                                style: theme.primaryTextTheme
                                                    .subtitle1),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const ProfessorsPage(),
                const AudiencesPage(),
                const SettingsPage(),
              ],
            )),
      ),
      bottomNavigationBar: Obx(
        () => Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            onTap: (int index) => changeTabIndex(index),
            currentIndex: tabIndex.value,
            backgroundColor: theme.primaryColor,
            showUnselectedLabels: false,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey[500],
            items: [
              BottomNavigationBarItem(
                label: AppLocalizations.of(context)!.schedule,
                icon: const Icon(Icons.event_outlined),
              ),
              BottomNavigationBarItem(
                label: AppLocalizations.of(context)!.professors,
                icon: const Icon(Icons.person_outline),
              ),
              BottomNavigationBarItem(
                label: AppLocalizations.of(context)!.audiences,
                icon: const Icon(Icons.door_back_door_outlined),
              ),
              BottomNavigationBarItem(
                label: AppLocalizations.of(context)!.settings,
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
