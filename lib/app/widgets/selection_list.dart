import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_cdis/app/data/schema.dart';

class SelectionList<T extends SelectionData> extends StatefulWidget {
  final String headerText;
  final String hintText;
  final Function(String)? onTextChanged;
  final bool isLoaded;
  final List<T>? filteredData;
  final Function(T) onEntrySelected;
  final Function()? onBackPressed;
  final TextStyle? selectionTextStyle;

  const SelectionList({
    super.key,
    required this.headerText,
    required this.hintText,
    required this.isLoaded,
    required this.onEntrySelected,
    required this.selectionTextStyle,
    required this.filteredData,
    this.onTextChanged,
    this.onBackPressed,
  });

  @override
  State<SelectionList<T>> createState() => _SelectionListState<T>();
}

class _SelectionListState<T extends SelectionData>
    extends State<SelectionList<T>> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          widget.onBackPressed == null
              ? Padding(
                  padding: EdgeInsets.only(top: 15.w),
                  child: Text(
                    widget.headerText,
                    style: context.theme.textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(top: 15.w, left: 10.w),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: widget.onBackPressed,
                        icon: const Icon(Icons.arrow_back),
                        iconSize: context.theme.iconTheme.size,
                        color: context.theme.iconTheme.color,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Expanded(
                        child: Text(
                          widget.headerText,
                          style: context.theme.textTheme.headline2,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
            child: TextField(
              onChanged: widget.onTextChanged,
              style: context.theme.textTheme.headline6,
              decoration: InputDecoration(
                fillColor: context.theme.primaryColor,
                filled: true,
                prefixIcon: const Icon(
                  Icons.search_outlined,
                  color: Colors.grey,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                    color: context.theme.primaryColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                    color: context.theme.primaryColor,
                  ),
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15.sp,
                ),
              ),
              autofocus: false,
            ),
          ),
          Divider(
            color: context.theme.dividerColor,
            height: 20.w,
            thickness: 2,
            indent: 10.w,
            endIndent: 10.w,
          ),
          Expanded(
            child: Visibility(
              visible: widget.isLoaded,
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              child: ListView.builder(
                itemCount: widget.filteredData?.length,
                itemBuilder: (BuildContext context, int index) {
                  final T data = widget.filteredData![index];
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
                    child: Container(
                      height: 45.w,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          color: context.theme.primaryColor),
                      child: TextButton(
                        onPressed: () => widget.onEntrySelected(data),
                        child: Center(
                          child: Text(
                            data.name,
                            style: widget.selectionTextStyle,
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
    );
  }
}
