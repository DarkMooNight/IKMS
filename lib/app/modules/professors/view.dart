import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_cdis/app/data/professors.dart';
import 'package:project_cdis/app/modules/raspProfessors/view.dart';

import '../../services/remote_services.dart';

class ProfessorsPage extends StatefulWidget {
  const ProfessorsPage({super.key});

  @override
  State<ProfessorsPage> createState() => _ProfessorsPageState();
}

class _ProfessorsPageState extends State<ProfessorsPage> {
  List<Professors>? professors;
  List<Professors>? professor;
  final box = GetStorage();
  var isLoaded = false;
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    professor = professors;
    getData();
  }

  getData() async {
    professor = await RomoteServise().getProfessorsData();
    professors = await RomoteServise().getProfessorsData();
    if (professor != null) {
      setState(
        () {
          isLoaded = true;
          getProfessors();
        },
      );
    }
  }

  getProfessors() {
    setState(
      () {
        professor =
            professors?.where((element) => element.name.isNotEmpty).toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15.w),
              child: Text(
                AppLocalizations.of(context)!.professors,
                style: theme.textTheme.headline2,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
              child: TextField(
                controller: textEditingController,
                onChanged: (value) {
                  value = value.toLowerCase();
                  setState(
                    () {
                      professor = professors?.where(
                        (element) {
                          var professorsTitle = element.name.toLowerCase();
                          return professorsTitle.contains(value);
                        },
                      ).toList();
                      if (textEditingController.text.isEmpty) {
                        getProfessors();
                      }
                    },
                  );
                },
                style: theme.textTheme.headline6,
                decoration: InputDecoration(
                  fillColor: theme.primaryColor,
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.search_outlined,
                    color: Colors.grey,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: theme.primaryColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: theme.primaryColor,
                    ),
                  ),
                  hintText: AppLocalizations.of(context)!.fio,
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15.sp,
                  ),
                ),
                autofocus: false,
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
                  itemCount: professor?.length,
                  itemBuilder: (BuildContext context, int index) {
                    final professorPage = professor![index];
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
                      child: Container(
                        height: 40.w,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            color: theme.primaryColor),
                        child: TextButton(
                          onPressed: () {
                            box.write(
                                'isProfessor', professorPage.id.toString());
                            box.write('isProfessorName', professorPage.name);
                            Get.to(() => const RaspProfessorsPage(),
                                transition: Transition.downToUp);
                          },
                          child: Center(
                            child: Text(
                              professorPage.name,
                              style: theme.primaryTextTheme.headline4,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
