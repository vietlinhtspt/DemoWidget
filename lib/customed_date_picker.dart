import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/src/intl/date_format.dart';

import 'time_keeping_by_month_response.dart';

class CustomedDatePickerWidget extends StatefulWidget {
  final Function(DateTime newDatetime)? onChange;
  final String? hintText;
  final Color? primaryColor;
  final Widget? actionIcon;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;
  final double? width;
  final double height;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;
  final DateTime? pickedDatetime;
  final DateFormat? dateFormat;
  final bool isAllowedToSelectDayInPast;
  final AlignmentGeometry textAlignment;

  const CustomedDatePickerWidget({
    Key? key,
    this.onChange,
    this.hintText,
    this.primaryColor,
    this.actionIcon,
    this.textStyle,
    this.hintTextStyle,
    this.width = 156,
    this.height = 50,
    this.padding,
    this.decoration,
    this.pickedDatetime,
    this.dateFormat,
    this.isAllowedToSelectDayInPast = false,
    this.textAlignment = Alignment.centerLeft,
  }) : super(key: key);

  @override
  State<CustomedDatePickerWidget> createState() =>
      _CustomedDatePickerWidgetState();
}

class _CustomedDatePickerWidgetState extends State<CustomedDatePickerWidget> {
  final primaryColor = const Color(0xffF5484C);

  final listMonths = [
    for (var i = 1; i <= 12; i++) MonthItem(code: i, name: 'Tháng $i')
  ];

  final listYears = [for (var i = 1970; i <= 2100; i++) i];

  late MonthItem selectedMonth;
  late int selectedYear;
  late int selectedDay;
  late List<int?> daysInMonth;
  String? displayTimeString;
  DateTime? displayTime;

  @override
  void initState() {
    if (widget.pickedDatetime != null) {
      selectedYear = widget.pickedDatetime!.year;
      selectedMonth = listMonths[listMonths.indexWhere(
        (element) => element.code == widget.pickedDatetime!.month,
      )];
      selectedDay = widget.pickedDatetime!.day;
      displayTime = widget.pickedDatetime;
      daysInMonth = _getListDays();
      displayTimeString = widget.dateFormat?.format(widget.pickedDatetime!) ??
          '${selectedYear.toString()}/${selectedMonth.code.toString().padLeft(2, '0')}/${selectedDay.toString().padLeft(2, '0')}';
    } else {
      selectedMonth = listMonths[listMonths.indexWhere(
        (element) => element.code == DateTime.now().month,
      )];
      selectedYear = DateTime.now().year;
      selectedDay = DateTime.now().day;
      displayTime = DateTime.now();
      daysInMonth = _getListDays();
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomedDatePickerWidget oldWidget) {
    if (widget.pickedDatetime != null) {
      selectedYear = widget.pickedDatetime!.year;
      selectedMonth = listMonths[listMonths.indexWhere(
        (element) => element.code == widget.pickedDatetime!.month,
      )];
      selectedDay = widget.pickedDatetime!.day;
      displayTime = widget.pickedDatetime;
      daysInMonth = _getListDays();
      displayTimeString = displayTimeString = widget.dateFormat
              ?.format(widget.pickedDatetime!) ??
          '${selectedYear.toString()}/${selectedMonth.code.toString().padLeft(2, '0')}/${selectedDay.toString().padLeft(2, '0')}';
    }
    if (mounted) setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  void _setNewSelectedDay(int newDay, DayDetail? dayDetail) {
    setState(
      () {
        selectedDay = newDay;
        displayTimeString = displayTimeString = widget.dateFormat
                ?.format(widget.pickedDatetime!) ??
            '${selectedYear.toString()}/${selectedMonth.code.toString().padLeft(2, '0')}/${selectedDay.toString().padLeft(2, '0')}';
        displayTime = DateTime(
          selectedYear,
          selectedMonth.code,
          selectedDay,
        );
      },
    );
    Navigator.pop(context);
    _callOnChange(displayTime!);
  }

  void _setNewSelectedMonth(MonthItem newMonth) {
    setState(() {
      selectedMonth = newMonth;
    });
  }

  void _setNewSelectedYear(int newYear) {
    setState(() {
      selectedYear = newYear;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => customDatePickerDialog(context),
      ),
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: widget.padding ??
            const EdgeInsets.symmetric(
              horizontal: 10,
            ),
        decoration: widget.decoration ??
            BoxDecoration(
              border: Border.all(
                color: const Color(0xffEAEAEA),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
        child: Row(children: [
          Expanded(
            child: Align(
              alignment: widget.textAlignment,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 3),
                child: displayTimeString != null
                    ? Text(
                        displayTimeString!,
                        style: widget.textStyle,
                      )
                    : Text(
                        widget.hintText ?? '',
                        style: widget.hintTextStyle,
                      ),
              ),
            ),
          ),
          widget.actionIcon != null
              ? widget.actionIcon!
              : Container(
                  margin: EdgeInsets.only(right: 8),
                  width: 16,
                  height: 16,
                  child:
                      SvgPicture.asset('assets/icons/ic_expand_up_light.svg')),
        ]),
      ),
    );
  }

  Widget customDatePickerDialog(BuildContext context) {
    const dialogWidth = 350.0;
    const bodyHeight = 320.0;
    return StatefulBuilder(builder: (context, setState) {
      return GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: const Color(0xff666666).withOpacity(0.1),
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () => null,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 70 + bodyHeight,
                    maxHeight: MediaQuery.of(context).size.height,
                  ),
                  child: SizedBox(
                    width: dialogWidth,
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          DatePickerHeaderWidget(
                            primaryColor: widget.primaryColor ?? primaryColor,
                            listMonths: listMonths,
                            listYears: listYears,
                            daysInMonth: daysInMonth,
                            selectedMonth: selectedMonth,
                            selectedYear: selectedYear,
                            onChangeMonth: (newMonth) {
                              selectedMonth = newMonth;
                              daysInMonth = _getListDays();
                              _setNewSelectedMonth(newMonth);
                              setState(() {});
                              _getDaysInMonth();
                            },
                            onChangeYear: (newYear) {
                              selectedYear = newYear;
                              _setNewSelectedYear(newYear);
                              daysInMonth = _getListDays();
                              setState(() {});
                            },
                            onChangeMonthAndYear: (newMonth, newYear) {
                              selectedMonth = newMonth;
                              selectedYear = newYear;
                              _setNewSelectedMonth(newMonth);
                              _setNewSelectedYear(newYear);
                              daysInMonth = _getListDays();
                              setState(() {});
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DatePickerBodyWidget(
                            displayTime: displayTime,
                            dialogWidth: dialogWidth,
                            daysInMonth: daysInMonth,
                            selectedDay: selectedDay,
                            selectedMonth: selectedMonth,
                            selectedYear: selectedYear,
                            primaryColor: widget.primaryColor ?? primaryColor,
                            bodyHeight: bodyHeight,
                            isAllowedToSelectDayInPast:
                                widget.isAllowedToSelectDayInPast,
                            onSelectDay: (newDay, dayDetail) {
                              _setNewSelectedDay(newDay, dayDetail);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  List<int?> _getListDays() {
    final numDays = _getDaysInMonth();
    final weekDayCodeOfFirstDay =
        DateTime(selectedYear, selectedMonth.code, 1).weekday;
    final listDays = <int?>[];
    if (weekDayCodeOfFirstDay != 7)
      listDays.addAll([for (int i = 0; i < weekDayCodeOfFirstDay; i++) null]);
    listDays.addAll([for (int i = 1; i <= numDays; i++) i]);
    return listDays;
  }

  int _getDaysInMonth() {
    final firstDayThisMonth = DateTime(
      selectedYear,
      selectedMonth.code,
      1,
    );
    final firstDayNextMonth = DateTime(
      firstDayThisMonth.year,
      firstDayThisMonth.month + 1,
      1,
    );
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  void _callOnChange(DateTime displayTime) {
    if (widget.onChange != null && selectedDay != -1) {
      widget.onChange!(displayTime);
    }
  }
}

class DatePickerBodyWidget extends StatelessWidget {
  const DatePickerBodyWidget({
    Key? key,
    required this.dialogWidth,
    required this.daysInMonth,
    required this.selectedDay,
    required this.primaryColor,
    required this.onSelectDay,
    required this.bodyHeight,
    this.displayTime,
    required this.selectedMonth,
    required this.selectedYear,
    required this.isAllowedToSelectDayInPast,
    this.data,
  }) : super(key: key);

  final double dialogWidth;
  final List<int?> daysInMonth;
  final int selectedDay;
  final Color primaryColor;
  final Function(int, DayDetail?) onSelectDay;
  final double bodyHeight;
  final DateTime? displayTime;
  final MonthItem selectedMonth;
  final int selectedYear;
  final bool isAllowedToSelectDayInPast;
  final TimeKeepingByMonthResponse? data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: bodyHeight,
      child: CustomScrollView(
        slivers: [
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: dialogWidth / 7,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 0,
              childAspectRatio: 1,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final dayIndex = _getDayIndexFromGridViewIndex(index);
                return Center(
                  child: Text(
                    dayIndex == 1 ? 'CN' : 'T$dayIndex',
                    style: TextStyle(
                      color: Color(0xff444444),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
              childCount: 7,
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: dialogWidth,
              childAspectRatio: dialogWidth,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  height: 1,
                  color: Color(0xffEAEAEA),
                );
              },
              childCount: 1,
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: dialogWidth / 7,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              childAspectRatio: 1,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final isAllowToSelect = _checkIsAllowedToSelectDayInPast(
                  selectedMonth: selectedMonth.code,
                  selectedDay: (daysInMonth[index] ?? -1),
                  selectedYear: selectedYear,
                );

                final dayDetailIndex = data?.data?.list?.indexWhere(
                  (element) =>
                      DateTime.tryParse(element.date ?? '')?.day ==
                      (daysInMonth[index] ?? -1),
                );

                final dayDetail = dayDetailIndex != -1 && dayDetailIndex != null
                    ? data?.data?.list![dayDetailIndex]
                    : null;

                final bool isSelectedDay = selectedDay == daysInMonth[index] &&
                    selectedMonth.code == displayTime?.month &&
                    selectedYear == displayTime?.year;
                final bool isNowDay =
                    DateTime.now().day == daysInMonth[index] &&
                        DateTime.now().month == displayTime?.month &&
                        DateTime.now().year == displayTime?.year;
                ;

                return GestureDetector(
                  onTap: () {
                    if (daysInMonth[index] != null && isAllowToSelect) {
                      onSelectDay(daysInMonth[index]!, dayDetail);
                    }
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    decoration: isNowDay
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              100,
                            ),
                            color: primaryColor.withOpacity(0.8),
                          )
                        : isSelectedDay
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xffEAF0FF),
                                border: Border.all(color: Color(0xff718CFB)))
                            : null,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          daysInMonth[index]?.toString() ?? '',
                          style: TextStyle(
                            color: isAllowToSelect &&
                                    ((index % 7) != 0 && (index % 7) != 6)
                                ? Color(0xff444444)
                                : Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isAllowToSelect && daysInMonth[index] != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: dayDetail?.morningTimekeeping == 0
                                      ? Colors.red
                                      : dayDetail?.morningTimekeeping == 0.5
                                          ? Colors.yellow
                                          : dayDetail?.morningTimekeeping == 1
                                              ? Colors.green
                                              : null,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: dayDetail?.afternoonTimekeeping == 0
                                      ? Colors.red
                                      : dayDetail?.afternoonTimekeeping == 0.5
                                          ? Colors.yellow
                                          : dayDetail?.afternoonTimekeeping == 1
                                              ? Colors.green
                                              : null,
                                ),
                              )
                            ],
                          ),
                      ],
                    )),
                  ),
                );
              },
              childCount: daysInMonth.length,
            ),
          ),
        ],
      ),
    );
  }

  int _getDayIndexFromGridViewIndex(int index) {
    return index + 1;
  }

  bool _checkIsAllowedToSelectDayInPast({
    required int selectedDay,
    required int selectedMonth,
    required int selectedYear,
  }) {
    var isAllowed = true;
    if (!isAllowedToSelectDayInPast) {
      final selectedDateTime =
          DateTime(selectedYear, selectedMonth, selectedDay);
      isAllowed = DateTime.now()
          .add(
            const Duration(days: -1),
          )
          .isBefore(selectedDateTime);
    }
    return isAllowed;
  }
}

class DatePickerHeaderWidget extends StatelessWidget {
  const DatePickerHeaderWidget({
    Key? key,
    required this.primaryColor,
    required this.listMonths,
    required this.listYears,
    required this.onChangeMonth,
    required this.onChangeYear,
    required this.selectedMonth,
    required this.selectedYear,
    required this.onChangeMonthAndYear,
    required this.daysInMonth,
  }) : super(key: key);
  final Null Function(MonthItem) onChangeMonth;
  final Null Function(int) onChangeYear;
  final Color primaryColor;
  final List<MonthItem> listMonths;
  final List<int> listYears;
  final List<int?> daysInMonth;
  final MonthItem selectedMonth;
  final int selectedYear;
  final Null Function(MonthItem newMonth, int newYear) onChangeMonthAndYear;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // GestureDetector(
          //   onTap: _changetoLastMonth,
          //   child: RotatedBox(
          //     quarterTurns: 135,
          //     child: SvgPicture.asset(
          //       'assets/icons/ic_expand_up_light.svg',
          //       height: 40,
          //       color: primaryColor,
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   width: 120,
          //   child: CustomedDropdownButton(
          //     chosenValue: selectedMonth.name,
          //     onChanged: (newMonthName) {
          //       if (newMonthName != null) {
          //         final newMonth = listMonths
          //             .where((element) => element.name == newMonthName)
          //             .first;
          //         onChangeMonth(newMonth);
          //       }
          //     },
          //     hintText: '',
          //     items: listMonths.map((e) => e.name).toList(),
          //     primaryColor: primaryColor,
          //   ),
          // ),
          // const SizedBox(
          //   width: 20,
          // ),
          // SizedBox(
          //   width: 100,
          //   child: CustomedDropdownButton(
          //     chosenValue: selectedYear.toString(),
          //     onChanged: (newYear) {
          //       if (newYear != null) {
          //         onChangeYear(int.parse(newYear));
          //       }
          //     },
          //     hintText: '',
          //     items: listYears
          //         .map(
          //           (e) => e.toString(),
          //         )
          //         .toList(),
          //     primaryColor: primaryColor,
          //   ),
          // ),
          // GestureDetector(
          //   onTap: _changetoNextMonth,
          //   child: RotatedBox(
          //     quarterTurns: 90,
          //     child: SvgPicture.asset(
          //       'assets/icons/ic_arrow_next.svg',
          //       height: 40,
          //       color: primaryColor,
          //     ),
          //   ),
          // ),

          Row(
            children: [
              SizedBox(
                width: 16,
              ),
              Text(
                'Hôm nay: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                DateFormat('dd/MM/yyyy').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff718CFB),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 200,
                  color: Colors.amber,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text('Modal BottomSheet'),
                        ElevatedButton(
                          child: const Text('Close BottomSheet'),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            child: Container(
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Color(0xffEAF0FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: RotatedBox(
                quarterTurns: 90,
                child: SvgPicture.asset(
                  'assets/icons/ic_expand_up_light.svg',
                  height: 32,
                  width: 32,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _changetoNextMonth() {
    int? newYear;
    if (selectedMonth.code == 12) {
      newYear = selectedYear + 1;
    }
    final nextMonthIndex =
        selectedMonth.code == 12 ? 1 : selectedMonth.code + 1;
    final nextMonth = listMonths[
        listMonths.indexWhere((element) => element.code == nextMonthIndex)];
    if (newYear != null) {
      onChangeMonthAndYear(nextMonth, newYear);
    } else {
      onChangeMonth(nextMonth);
    }
  }

  void _changetoLastMonth() {
    int? newYear;
    if (selectedMonth.code == 1) {
      newYear = selectedYear - 1;
    }
    final newMonthCode = selectedMonth.code == 1 ? 12 : selectedMonth.code - 1;
    final nextMonth = listMonths[
        listMonths.indexWhere((element) => element.code == newMonthCode)];
    if (newYear != null) {
      onChangeMonthAndYear(nextMonth, newYear);
    } else {
      onChangeMonth(nextMonth);
    }
  }
}

class CustomedDropdownButton extends StatelessWidget {
  const CustomedDropdownButton({
    Key? key,
    required String? chosenValue,
    required this.onChanged,
    required this.hintText,
    required this.items,
    this.isReadOnly = false,
    required this.primaryColor,
  })  : _chosenValue = chosenValue,
        super(key: key);

  final String? _chosenValue;
  final Function(String?) onChanged;
  final String hintText;
  final List<String> items;
  final bool isReadOnly;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffEAEAEA)),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.only(left: 7),
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: _chosenValue,
        isExpanded: true,
        //elevation: 5,
        style: TextStyle(color: Colors.white),
        iconEnabledColor: Colors.black,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
        underline: const SizedBox.shrink(),
        borderRadius: BorderRadius.circular(10),
        hint: Text(
          hintText,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: RotatedBox(
          quarterTurns: 90,
          child: SvgPicture.asset(
            'assets/icons/ic_expand_up_light.svg',
            height: 25,
            color: primaryColor,
          ),
        ),
        onChanged: isReadOnly ? null : onChanged,
        alignment: AlignmentDirectional.centerStart,
      ),
    );
  }
}

class CustomedCalendar extends StatefulWidget {
  const CustomedCalendar({
    Key? key,
    this.primaryColor,
    this.dateFormat,
    this.pickedDatetime,
    this.onChange,
    this.isEnable = false,
    this.data,
  }) : super(key: key);

  final Color? primaryColor;
  final DateTime? pickedDatetime;
  final DateFormat? dateFormat;
  final Function(
    DateTime newDatetime,
    DayDetail? dayDetail,
  )? onChange;
  final TimeKeepingByMonthResponse? data;
  final bool isEnable;

  @override
  State<CustomedCalendar> createState() => _CustomedCalendarState();
}

class _CustomedCalendarState extends State<CustomedCalendar> {
  final primaryColor = const Color(0xffF5484C);

  final listMonths = [
    for (var i = 1; i <= 12; i++) MonthItem(code: i, name: 'Tháng $i')
  ];

  final listYears = [for (var i = 1970; i <= 2100; i++) i];

  late MonthItem selectedMonth;
  late int selectedYear;
  late int selectedDay;
  late List<int?> daysInMonth;
  String? displayTimeString;
  DateTime? displayTime;
  TimeKeepingByMonthResponse? data;

  @override
  void initState() {
    if (widget.pickedDatetime != null) {
      selectedYear = widget.pickedDatetime!.year;
      selectedMonth = listMonths[listMonths.indexWhere(
        (element) => element.code == widget.pickedDatetime!.month,
      )];
      selectedDay = widget.pickedDatetime!.day;
      displayTime = widget.pickedDatetime;
      daysInMonth = _getListDays();
      displayTimeString = widget.dateFormat?.format(widget.pickedDatetime!) ??
          '${selectedYear.toString()}/${selectedMonth.code.toString().padLeft(2, '0')}/${selectedDay.toString().padLeft(2, '0')}';
    } else {
      selectedMonth = listMonths[listMonths.indexWhere(
        (element) => element.code == DateTime.now().month,
      )];
      selectedYear = DateTime.now().year;
      selectedDay = DateTime.now().day;
      displayTime = DateTime.now();
      daysInMonth = _getListDays();
    }

    data = widget.data;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomedCalendar oldWidget) {
    if (widget.pickedDatetime != null) {
      selectedYear = widget.pickedDatetime!.year;
      selectedMonth = listMonths[listMonths.indexWhere(
        (element) => element.code == widget.pickedDatetime!.month,
      )];
      selectedDay = widget.pickedDatetime!.day;
      displayTime = widget.pickedDatetime;
      daysInMonth = _getListDays();
      displayTimeString = displayTimeString = widget.dateFormat
              ?.format(widget.pickedDatetime!) ??
          '${selectedYear.toString()}/${selectedMonth.code.toString().padLeft(2, '0')}/${selectedDay.toString().padLeft(2, '0')}';
    }
    data = widget.data;
    if (mounted) setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    const bodyHeight = 370.0;
    return LayoutBuilder(builder: (context, constrants) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 70 + bodyHeight,
          maxHeight: MediaQuery.of(context).size.height,
        ),
        child: SizedBox(
          width: constrants.maxWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              DatePickerHeaderWidget(
                primaryColor: widget.primaryColor ?? primaryColor,
                listMonths: listMonths,
                listYears: listYears,
                daysInMonth: daysInMonth,
                selectedMonth: selectedMonth,
                selectedYear: selectedYear,
                onChangeMonth: (newMonth) {
                  selectedMonth = newMonth;
                  daysInMonth = _getListDays();
                  _setNewSelectedMonth(newMonth);
                  setState(() {});
                  _getDaysInMonth();
                },
                onChangeYear: (newYear) {
                  selectedYear = newYear;
                  _setNewSelectedYear(newYear);
                  daysInMonth = _getListDays();
                  setState(() {});
                },
                onChangeMonthAndYear: (newMonth, newYear) {
                  selectedMonth = newMonth;
                  selectedYear = newYear;
                  _setNewSelectedMonth(newMonth);
                  _setNewSelectedYear(newYear);
                  daysInMonth = _getListDays();
                  setState(() {});
                },
              ),
              SizedBox(
                height: 10,
              ),
              DatePickerBodyWidget(
                displayTime: displayTime,
                dialogWidth: constrants.maxWidth,
                daysInMonth: daysInMonth,
                selectedDay: selectedDay,
                selectedMonth: selectedMonth,
                selectedYear: selectedYear,
                primaryColor: widget.primaryColor ?? primaryColor,
                bodyHeight: bodyHeight,
                isAllowedToSelectDayInPast: true,
                onSelectDay: (newDay, dayDetail) {
                  _setNewSelectedDay(newDay, dayDetail);
                },
                data: data,
              ),
            ],
          ),
        ),
      );
    });
  }

  List<int?> _getListDays() {
    final numDays = _getDaysInMonth();
    final weekDayCodeOfFirstDay =
        DateTime(selectedYear, selectedMonth.code, 1).weekday;
    final listDays = <int?>[];
    if (weekDayCodeOfFirstDay != 7)
      listDays.addAll([for (int i = 0; i < weekDayCodeOfFirstDay; i++) null]);
    listDays.addAll([for (int i = 1; i <= numDays; i++) i]);
    return listDays;
  }

  int _getDaysInMonth() {
    final firstDayThisMonth = DateTime(
      selectedYear,
      selectedMonth.code,
      1,
    );
    final firstDayNextMonth = DateTime(
      firstDayThisMonth.year,
      firstDayThisMonth.month + 1,
      1,
    );
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  void _setNewSelectedMonth(MonthItem newMonth) {
    setState(() {
      selectedMonth = newMonth;
    });
  }

  void _setNewSelectedYear(int newYear) {
    setState(() {
      selectedYear = newYear;
    });
  }

  void _setNewSelectedDay(int newDay, DayDetail? dayDetail) {
    setState(
      () {
        if (widget.isEnable) {
          selectedDay = newDay;
          displayTimeString = displayTimeString = widget.dateFormat
                  ?.format(widget.pickedDatetime!) ??
              '${selectedYear.toString()}/${selectedMonth.code.toString().padLeft(2, '0')}/${selectedDay.toString().padLeft(2, '0')}';
          displayTime = DateTime(
            selectedYear,
            selectedMonth.code,
            newDay,
          );
          _callOnChange(displayTime!, dayDetail);
        } else {
          displayTime = DateTime(
            selectedYear,
            selectedMonth.code,
            newDay,
          );
          _callOnChange(displayTime!, dayDetail);
        }
      },
    );
  }

  void _callOnChange(DateTime displayTime, DayDetail? dayDetail) {
    if (widget.onChange != null && selectedDay != -1) {
      widget.onChange!(displayTime, dayDetail);
    }
  }
}

class MonthItem {
  final int code;
  final String name;

  const MonthItem({
    required this.code,
    required this.name,
  });
}
