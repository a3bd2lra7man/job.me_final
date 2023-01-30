import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/date_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';

class DatePicker extends StatefulWidget {
  final String title;
  final DateTime initialDate;
  final DateTime lastDate;
  final DateTime startDate;
  final Function(DateTime) onDateSelected;

  const DatePicker(
      {Key? key,
      required this.onDateSelected,
      required this.title,
      required this.initialDate,
      required this.lastDate,
      required this.startDate})
      : super(key: key);

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              selectedDate == null ? widget.title : selectedDate!.toRawString(),
              style: AppTextStyles.hint.copyWith(color: AppColors.darkGrey),
            ),
            const Spacer(),
            IconButton(
              onPressed: () async {
                var date = await showDatePicker(
                  context: context,
                  initialDate: widget.initialDate,
                  firstDate: widget.startDate,
                  lastDate: widget.lastDate,
                );
                if (date != null) {
                  widget.onDateSelected(date);
                  selectedDate = date;
                  setState(() {});
                }
              },
              icon: Icon(
                Icons.calendar_today_outlined,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
        Divider(
          color: AppColors.grey,
          thickness: 1,
        ),
      ],
    );
  }
}
